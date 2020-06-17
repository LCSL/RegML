% -------------------------------------------------------------------------
% Sparsity based methods for feature selection
% l1/l2 regularization
%
% Chiara Olivieri - olivieri@disi.unige.it
%
% Simple demo. 
% -------------------------------------------------------------------------
% Modifications by Guillaume Garrigos
% -------------------------------------------------------------------------

clear; close all;

% -------------------------------------------------------------------------
% Training/Test set generation
% -------------------------------------------------------------------------

N = 1000;        % Number of points
P = 100;       % Number of variables (dimension)
S = 15;         % Number of relevant variables
err_y = 0.3;    % Error on the Y

[Xtr,Ytr]=create_training_set(N,P,S,err_y);
[Xtest,Ytest] = create_training_set(N, P, S, err_y);

% -------------------------------------------------------------------------
% Learning phase
% -------------------------------------------------------------------------
l2_par = 0;
l1_par = 0.1;

[beta_m, offset_par] = l1l2_learn(Xtr, Ytr, l1_par, 'smooth_par', l2_par);

model.beta_1step = beta_m;
model.offset_1step = offset_par;

% If we want to do cross validation, use instead:
%[cv_output, model, tau_values] = l1l2_kcv(Xtr, Ytr,'L1_min_par', 1e-4, 'L1_max_par', 1e1, ...
%              'L1_n_par', 100, 'smooth_par', l2_par, 'K', 5, protocol', 'one_step', 'plot', true); 

% -------------------------------------------------------------------------
% Measuring errors
% -------------------------------------------------------------------------
pred = l1l2_pred(model, Xtr, Ytr);
training_error = pred.err_1step;
pred = l1l2_pred(model, Xtest, Ytest);
test_error = pred.err_1step;
nb_features = numel(beta_m(beta_m ~=0));

fprintf('Number of features selected: %f\n', nb_features);
fprintf('Training error: %f\n', training_error);
fprintf('Test error: %f\n', test_error);

