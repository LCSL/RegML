% build a toy data set with 3 groups of relevant variables. The variables
% in each group are noisy replicates of each other. Then apply 5-fold
% cross-validation with the algorithms:
% -l1 regularization (lasso)
% -l1l2 regularization (naive elastic net)
% -grouped l1 regularization (group lasso)
% -multi-task learning (joint fatures selection)

clear all
close all
addpath(genpath('../PROXIMAL_TOOLBOXES'))


% fixing the seed of the random generators
seed=1;
randn('state',seed);
rand('state',seed);

ng = 3; %number of relevant groups
dg = 5;%group size for relevant groups
n = 50; %number of training points
d = 500; %total number of variables
fx = reshape(repmat(rand(ng,1)./ng,1,dg)',dg*ng,1); %true coefficient vector
% build ng relevant groups by generating dg noisy  replicates of each of the ng relevant variables
X = zeros(n,ng*dg);
for g = 1:ng;
    Xtmp = rand(n,1)*2-1;
    for i = ((g-1)*dg+1):(g*dg); 
        X(:,i) = awgn(Xtmp,10);
    end
end
Y = X*fx; %linear regression
Y = awgn(Y,10); %add noise to labels
% add irrelevant variables to reach d dimensions
X = [X rand(n,d-dg*ng)*2-1];


protocol = 'both'; % if false performs  sparsity regularization followed by the rls de-biasing, if true performs also sparsity regularization alone


%% L1 REGULARIZATION
fprintf('\n===================================================')
fprintf('\n\t\tL1 REGULARIZATION')
fprintf('\n===================================================')
[output_l1,model_l1] =l1l2_kcv(X,Y,'plot',true,'K',5,'smooth_par',0,'protocol',protocol);

%% L1L2 REGULARIZATION
fprintf('\n===================================================')
fprintf('\n\t\tL1L2 REGULARIZATION')
fprintf('\n===================================================')
[output_l1l2,model_l1l2] =l1l2_kcv(X,Y,'plot',true,'K',5,'smooth_par',0.1,'protocol',protocol);

%% GRL REGULARIZATION
fprintf('\n===================================================')
fprintf('\n\t\tGRL REGULARIZATION')
fprintf('\n===================================================')
% build blocks of 5 variables (1:,5, 6:10, etc.)
blocks = mat2cell(reshape(1:d,5,d/5),5,ones(d/5,1));
[output_grl,model_grl] =grl_kcv(X,Y,'blocks',blocks,'plot',true,'K',5,'smooth_par',0.01,'protocol',protocol);

%% MULTI-TASK LEARNING
fprintf('\n===================================================')
fprintf('\n\t\tMULTI-TASK LEARNING')
fprintf('\n===================================================')
% build "fake" second task
X2 = X;
Y2 =2.*Y;
[output_mtl,model_mtl] =mtl_kcv({X,X2},{Y,Y2},'plot',true,'K',5,'smooth_par',0.01,'protocol',protocol);

%% PLOT SELECTION
if strcmp(protocol,'two_steps')
    figure('name','SELECTION')
    imagesc([[ones(dg*ng,1); zeros(d-dg*ng,1)], model_l1.selected_1step, model_l1.selected_2steps, ...
        model_l1l2.selected_1step,model_l1l2.selected_2steps, ...
        model_grl.selected_1step, model_grl.selected_2steps,...
        model_mtl.selected_1step, model_mtl.selected_2steps])
    hold on
    ylabel('Relevant variables')
    set(gca,'Xtick',[1,2,3,4,5,6,7,8,9],'XtickLabel',{'relevant variables';'l1 (1-step)';'l1 (2-steps)';'l1l2 (1-step)';'l1l2 (2-steps)';...
        'grl (1-step)';'grl (2-steps)';'mtl (1-step)';'mtl (2-steps)'})
    for g = 1:ng;
        plot([.5 9.5],[dg*g-.5 dg*g-.5],'k')
    end
    for i = 1:8;
        plot(ones(2,1).*(i+.5),[1 d],'k')
    end

elseif strcmp(protocol,'both')
    figure('name','SELECTION')
    imagesc([[ones(dg*ng,1); zeros(d-dg*ng,1)], model_l1.selected_2steps, ...
        model_l1l2.selected_2steps, ...
        model_grl.selected_2steps,...
        model_mtl.selected_2steps])
    hold on
    ylabel('Relevant variables')
    set(gca,'Xtick',[1,2,3,4,5,6,7,8,9],'XtickLabel',{'relevant variables';'l1';'l1l2';'grl';'mtl'})
    for g = 1:ng;
        plot([.5 4.5],[dg*g-.5 dg*g-.5],'k')
    end
    for i = 1:4;
        plot(ones(2,1).*(i+.5),[1 d],'k')
    end
end