clc,clear,close all;

%% Import the libraries
    addpath('./spectral_reg_toolbox/');
    addpath('./dataset_scripts/');

% help create_dataset
% help learn
% help patt_rec
% help kcv


%%  1.D:


% Data generation (training and test)

%TODO
[Xtr, Ytr] = create_dataset(...);
[Xts, Yts] = create_dataset(...);


% Plot dataset
figure(1)
scatter(Xtr(:,1),Xtr(:,2),30,Ytr,'filled')


% Leaning 
% TODO: use learn function (see help learn) to train the model 
[alpha, err] = learn(...);
% 
% Test 
%TODO: use patt_rec (see help patt_rec) for testing
[Ypred, test_err] = patt_rec(...);

% Plot of test error
figure(2)
semilogy(test_err,'linewidth',2)


%% 1.E:
%choose kernel and kernel parameter
kernel='gauss';
kpar=0.01;

% List of (regularization) parameters 
%TODO: create a list of parameters (use linspace or logspace)
t_range=logspace(...);


% Leaning 
% TODO: select filter among 'rls', 'nu' etc...
filter=...
[alpha, err] = learn(kernel,kpar , filter, t_range, Xtr, Ytr, 'class');

test_err=zeros(1,length(t_range));
for i=1:length(t_range)
    % Test 
    [Ypred, test_err(i)] = patt_rec(kernel, kpar, alpha(i),Xtr, Xts, Yts,'class');
end


% Plot of test error
figure(2)
semilogy(t_range,test_err,'linewidth',2)



%% Cross Validation 

% Cross validation
%TODO: use kcv (see help kcv)
[t_kcv_idx, avg_err_kcv] = kcv(...);


% Plot of test error (cross validation)
figure(3)
semilogy(avg_err_kcv,'linewidth',2)


%% TODO: 1F
