clear all
close all
addpath(genpath('../GLOPriDu_TOOLBOX'))


% fixing the seed of the random generators
seed=1;
randn('state',seed);
rand('state',seed);

ng = 5; %number of relevant groups
dg = 5;%group size for relevant groups
n = 100; %number of training points
d = 1000; %total number of variables
beta_true = [rand(ng*dg,1); zeros(d-ng*dg,1)]; %true coefficient vector
X = rand(n,d)*2-1;
Y = X*beta_true; %linear regression
Y = awgn(Y,20); %add noise to labels

% build test set
ntest = 500;
Xtest = rand(ntest,d)*2-1;
Ytest = Xtest*beta_true; %linear regression
Ytest = awgn(Ytest,20); %add noise to labels
%%
% L1L2 REGULARIZATION
fprintf('\n===================================================')
fprintf('\n\t\tL1L2 REGULARIZATION')
fprintf('\n===================================================\n')

[output_l1l2,model_l1l2] =l1l2_kcv(X,Y,'plot',true,'K',5,'smooth_par',0.1,'1step',true);

% evaluates selection errorselection_l1l2.FalseNeg_1step = 1-sum(model_l1l2.selected_1step(beta_true~=0))/(dg*ng);
selection_l1l2.FalseNeg_1step = sum(model_l1l2.selected_1step(beta_true==0))/(d-dg*ng);
selection_l1l2.FalseNeg_2steps = 1-sum(model_l1l2.selected_2steps(beta_true~=0))/(dg*ng);
selection_l1l2.FalseNeg_2steps = sum(model_l1l2.selected_2steps(beta_true==0))/(d-dg*ng);

% testing
prediction_l1l2 = l1l2_pred(model_l1l2,Xtest,Ytest,'regr');
disp(selection_l1l2)
disp(prediction_l1l2)

%%
% GLOPRIDU
fprintf('\n===================================================')
fprintf('\n\t\tGLOPRIDU')
fprintf('\n===================================================\n')
% build blocks of 10 variables with 5 overlapping variables (1:10, 6:15, etc.)
blocks = mat2cell([reshape(1:d,10,d/10), reshape(6:(d-5),10,d/10 -1)],10,ones(d/10 +d/10 -1,1));

[output_glo,model_glo] =glopridu_kcv(X,Y,'blocks',blocks,'plot',true,'K',5,'1step',true);

% evaluates selection error
selection_glo.FalseNeg_1step = 1-sum(model_glo.selected_1step(beta_true~=0))/(dg*ng);
selection_glo.FalseNeg_1step = sum(model_glo.selected_1step(beta_true==0))/(d-dg*ng);
selection_glo.FalseNeg_2steps = 1-sum(model_glo.selected_2steps(beta_true~=0))/(dg*ng);
selection_glo.FalseNeg_2steps = sum(model_glo.selected_2steps(beta_true==0))/(d-dg*ng);

% testing
prediction_glo = glopridu_pred(model_glo,Xtest,Ytest,'regr');

disp(selection_glo)
disp(prediction_glo)
