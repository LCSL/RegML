% -------------------------------------------------------------------------
% Sparsity based methods for feature selection
% l1/l2 regularization
%
% Chiara Olivieri - olivieri@disi.unige.it
%
% Introduction:
%
% Suppose we have N training examples, each one composed of P variables 
% (P>>N): our objective is to find a subset of these variables that allow 
% us to train a good predictor.
% Intuitively, if we keep all the variables it is likely that we overfit. 
% On the other hand, if we limit too much the number of variables we can
% oversmooth. Since P can be quite large, it is reasonable to search for a 
% subset of relevant variables, as we discard variables we make the 
% model simple and we avoid overfitting. The result is a compressed version 
% of our training set. The new training set will be made 
% with only the variables that have enough discriminative power.
% In the following we provide a demo for the solution of the
% feature selection problem with l1/l2 regularization.
% The l1/l2 regularization algorithm is an embedded method: the selection 
% procedure is  embedded in the training phase.
% Suppose the output is a linear combination of the variables:
%   X*beta = Y
% In our training phase we have access to X and Y: in order to estimate the
% beta we have to solve an inverse problem. Even if we know that a solution
% exists (P>N), the solution is not unique. In addition we have to deal
% with the fact the the data can be noisy. The problem is thus ill-posed.
% The solution presented in the demo has two main points:
%   1) find a regularized solution using l1/l2 regularization;
%   2) use a thresholding step to select the relevant variables.
% In this demo we will explain these two points in detail, we will train a
% predictor and finally we will test the performance of the predictor on a
% test set.
%
% -------------------------------------------------------------------------

clear
path(path, './Utilities');
path(path, '../PROXIMAL_TOOLBOXES/L1L2_TOOLBOX');
path(path, '../PROXIMAL_TOOLBOXES/utilities');

fprintf('--- Sparsity based methods for feature selection - l1/l2 regularization ---\n\n');

% -------------------------------------------------------------------------
% Training set generation
% -------------------------------------------------------------------------

% Training set with LINEAR input-output relation.
% We want to generate a training set of N elements in P dimensions with S
% relevant features.
% We get in output X, that is a NxP matrix ~N(0,1), and Y that is the
% labels vector Nx1.
% With this training set we want to simulate the situation where we have
% few examples (e.g. few patients) and a lot of different measurements
% (e.g. informations on the patients, biomarkers, ...). In the set of all the
% measurements, it is possible that only few are actually relevant (e.g. to
% distinguish between different diseases). Some of the measurements might
% be provide useful information for the problem at hand, other might
% provide redundant information.

N = 100;    % Number of samples
P = 1000;   % Number  of features
S = 10;     % Number of relevant features
% We add a normal distributed error with standard deviation err_y to the
% label vector Y.
err_y = 0.01;

% Regularization parameter for the L2 penalization term
lambda = 1e-5;

% Modify in order to select the type of training set we want to use:
%   - 'Sf' : S relevant features in random position.
%   - '3f' : 3 subsets of correlated features.

train_set_type = 'Sf';

if strcmp(train_set_type, 'Sf')
    fprintf('-> Training set generation (%d elements, %d dimensions, %d features)\n', N, P, S);
    fx = create_regression_coefficients(P, S);
    [X,Y] = create_training_set_new(N, fx, err_y, 'regr');
else
% Alternatively we can create our training set with the following function.
% Training set with 3 correlated subsets based on 3 latent relevant features.

    d1 = 200; d2 = 100; d3 = 300; d4 = 400;
    fprintf('-> Training set generation (%d elements, %d dimensions, 3 features)\n', N, d1+d2+d3+d4);

% The first d1 features are noisy replicates of a first latent relevant 
% feature, the second d2 features are noisy replicates of a second latent 
% relevant feature, and the third d3 features are noisy replicates of a 
% third latent relevant feature. The last d4 features are noisy.
% X will be a matrix Nx(d1+d2+d3+d4), while Y will be Nx1.

    [X,Y] = create_corr_tr_set(N, err_y, 'regr', d1, d2, d3, d4);
end

% -------------------------------------------------------------------------
% Training phase
% -------------------------------------------------------------------------

fprintf('-> Training phase\n');

% We want to train the l1l2 regularization on the generated training set.
% We have to solve:

% min(||Y - beta*X||^2 + tau*||beta||_1) on beta in R^P

% where ||x||_1 is the 1-norm of vector x.
% The 2-norm account for the smoothness of the solution, while the 1-norm
% promotes the sparsity of the solution. tau is the regularization
% parameter and controls the degree of sparsity of the solution.

% We show two possible solutions for the accounted problem: 
%   1) thresholded Landweber iterative algorithm [2] [4]
%   2) FISTA (Fast Iterative Shrinkage-Thresholding Algorithm) [3] [5]
% The former is a simple gradient descent style algorithm, while the latter
% is an extension of the first. Since FISTA achieves much better time
% complexity than the thresholded Landweber, it will be used for the remaining
% parts of the demo.

% 1) Thresholded Landweber

% We compute the solution with the damped and thresholded Landweber
% iterative algorithm:

%   beta(t,tau) = S_tau[ beta(t-1,tau) + c*X'*(Y - X*beta(t-1,tau)) ]

% where t is the current iteration, S_tau is the soft-threshold
% function, c is a constant such as c*||X||<=1.
% We iterate until convergence or until we reach a maximum number of 
% iterations.

% The parameters of the function are:
% [BETA,K] = L1L2_REG(X,Y,TAU,lambda,STOP,KMAX)
%   - If the input data X is a NxD matrix, and the labels Y are a Nx1 vector, 
% BETA is a Dx1 vector.
%   - lambda contribute to the damping factor, that is defined as 
% 1/(1+lambda*TAU).
%   - If STOP=1(default) the algorithm stops when each element of BETA reached 
% convergence (the tolerance or when the number of iterations reached 
% KMAX=1e4.
%   - If STOP=0 the algorithm stops after KMAX iterations.
%   - K is the actual number of iterations done if STOP=1.

tau = l1l2_tau_max(X,Y)*0.1;

% Alternatively we can define lambda as:
% [u,sig,v] = svd(X'*X);
% lambda = min(diag(sig));

% Uncomment to see the behavior of the soft-threshold function:
% xst = (-tau*2:(tau*4)/100:tau*2);
% yst = xst;
% yst = thresholding(yst,tau);
% figure, plot(xst,yst), title('Soft threshold function')

fprintf('(Thresholded Landweber) Estimating the l1/l2 regularizer...\n');
start = clock;
[beta,k] = l1l2_reg(X, Y, tau, lambda);
time = etime(clock,start); 

% The iterative thresholded Landweber is quite time consuming. The
% complexity of the algorithm is O(t*P^2) for each value of the 
% regularization parameter, while the global rate of convergence is in the
% worst case O(1/t). There are several strategies that improve the rate of
% converge: we will see one example in FISTA.
fprintf('(Thresholded Landweber) Training phase: execution time %.2f [s] (%d iterations)\n', time, k);

% Let's test the predictor we just estimated. In order to do this we have
% to create a new set that will be our test set and calculate the training
% error for our beta.

if strcmp(train_set_type, 'Sf')
    [Xtest,Ytest] = create_training_set_new(N, fx, err_y, 'regr');
else
    [Xtest,Ytest] = create_corr_tr_set(N, err_y, 'regr', d1, d2, d3, d4);
end

[train_err] = l1l2_test(Xtest, Ytest, beta);
fprintf('(Thresholded Landweber) Test error: %f (tau = %f)\n', train_err, tau);

% 2) FISTA

% The main difference between the first algorithm and FISTA is that the
% current iterate is not calculated on the previous estimate of
% beta(t-1,tau), but rather at a new point beta_f(t,tau) that is a linear 
% combination of the previous two estimates:

% beta_f(t,tau) = beta(t-1,tau) + (s(t-1) - 1)/(s(t))*( beta(t-1,tau) - beta(t-2,tau) );

% where s(t) = ( 1 + sqrt(1 + 4*s(t-1)^2) )/2.
% The main computational effort in both the algorithm remains the same. The 
% requested additional computations for FISTA (for beta_f(t,tau) and s(t))
% are marginal. The global rate of convergence of FISTA is O(1/t^2).

fprintf('(FISTA) Estimating the l1/l2 regularizer...\n');
start = clock;
[beta,offset_par,k] = l1l2_learn(X, Y, tau, 'smooth_par', lambda);
time = etime(clock,start); 
fprintf('(FISTA) Training phase: execution time %.2f [s] (%d iterations)\n', time, k);

% Let's test the predictor also for FISTA.

if strcmp(train_set_type, 'Sf')
    [Xtest,Ytest] = create_training_set_new(N, fx, err_y, 'regr');
else
    [Xtest,Ytest] = create_corr_tr_set(N, err_y, 'regr', d1, d2, d3, d4);
end

model.beta = beta;
model.offset = offset_par;
pred = l1l2_pred(model, Xtest, Ytest);
fprintf('(FISTA) Test error: %f (tau = %f)\n', pred.err, tau);

% -------------------------------------------------------------------------
% K-fold cross-validation training
% -------------------------------------------------------------------------

% The regularization parameter tau has to be tuned to find the final 
% solution. We want to find a value of tau that has good generalization 
% properties.
% We use the K-fold cross-validation method for estimating tau [1].
% We split the training set in K groups. For a fixed value of tau, we
% train on all K-1 groups and we test on the group left out. This procedure
% is repeated for different values of tau in a specified range and we
% choose the one minimizing the cross validation error. In order to
% decrease variance we can repeat the whole procedure for different splits
% and average the results.

fprintf('-> K-fold cross-validation for estimating the regularization parameter\n')

%  The parameters to be set for the K-fold cross-validation are: the 
% search range for the optimized tau value; the smoothing parameter
% lambda and the number of folds of the cross-validation.

L1_n_par = 50;
L1_max_par = l1l2_tau_max(X,Y);
L1_min_par = 1e-8;

% We start from tau=0: that is the same result we obtain if we use the
% ordinary least square solution.

% If N is too small we use the leave-one-out (LOO) strategy.
min4kcv = 100;
if N < min4kcv
    K = 0;
else
    % Should be set to a reasonable number of subsets depending on the
    % size of N. We can choose K in [5, 15].
    K = 5; 
end

fprintf('l1l2 regularization\n');

[cv_output1, model1, tau_values1] = l1l2_kcv(X, Y, ...
    'protocol', 'one_step', ...
    'L1_n_par', L1_n_par, ...
    'L1_max_par', L1_max_par, ...
    'L1_min_par', L1_min_par, ...
    'smooth_par', lambda, ...
    'K', K, ...
    'plot', true);

% Uncomment to use default parameters
% [cv_output1, model1, tau_values1] = l1l2_kcv(X, Y, ...
%     'protocol', 'one_step', ...
%     'plot', true);

% In output we obtain the following informations:
%   - cv_output.sparsity = number of selected features for each value of the
% sparsity parameter tau.
%   - cv_output.selected_all = indices of the selected features for each 
% value of the sparsity parameter.
%   - cv_output.tau_opt_1step: sparsity parameter minimizing the K-fold
% cross-validation error.
%   - model.beta_1step: coefficient vector for the optimal parameters  for
% the 1-step framework.

fprintf('l1l2 regularization - cross-validation error on validation set %f\n', min(cv_output1.err_KCV_1step));
fprintf('                    - # of selected features %d\n', sum(model1.selected_1step));

% Since learning algorithms based on sparsity usually suffer from an 
% excessive shrinkage effect of the coefficients, it is in practice used an
% heuristic method that combines l1l2 regularization and regularized least
% squares.
% We thus have a two step procedure:
% 	- l1l2 is used for selection of the variables
%   - the regression coefficients are evaluated on the selected variables
%   via RLS.

fprintf('l1l2 regularization + RLS\n');

[cv_output2, model2, tau_values2] = l1l2_kcv(X, Y, ...
    'protocol', 'two_steps', ...
    'L1_n_par', L1_n_par, ...
    'L1_max_par', L1_max_par, ...
    'L1_min_par', L1_min_par, ...
    'smooth_par', lambda, ...
    'K', K, ...
    'plot', true);

% Uncomment to use default parameters
% [cv_output2, model2, tau_values2] = l1l2_kcv(X, Y, ...
%     'protocol', 'two_steps',
%     'plot', true);

fprintf('l1l2 regularization + RLS - cross-validation error on validation set %f\n', min(cv_output2.err_KCV_2steps(:)));
fprintf('                          - # of selected features %d\n', sum(model2.selected_2steps));

% -------------------------------------------------------------------------
% Test phase
% -------------------------------------------------------------------------

fprintf('-> Test phase\n');

if strcmp(train_set_type, 'Sf')
    [Xtest,Ytest] = create_training_set_new(N, fx, err_y, 'regr');
else
    [Xtest,Ytest] = create_corr_tr_set(N, err_y, 'regr', d1, d2, d3, d4);
end

pred = l1l2_pred(model1, Xtest, Ytest);
fprintf('(One step) Test error: %f (tau = %f)\n', pred.err_1step, cv_output1.tau_opt_1step);

pred = l1l2_pred(model2, Xtest, Ytest);
fprintf('(Two steps) Test error: %f (tau = %f)\n', pred.err_2steps, cv_output2.tau_opt_2steps);

% -------------------------------------------------------------------------
% References
%
% [1] F. Odone, L. Rosasco. Regularization Parameter Choice. (Regularization
% Methods for High Dimensional Learning - Course notes).

% [2] f: Odone, L. Rosasco. Variable Selection and Sparsity-based Learning.
% (Regularization Methods for High Dimensional Learning - Course notes).

% [3] S. Mosci, L. Rosasco, M. Santoro, A. Verri and S. Villa. Solving 
% Structured Sparsity Regularization with Proximal Methods.

% [4] I. Daubechies, M. Defrise, and C. De Mol. An iterative thresholding 
% algorithm for linear inverse problems with a sparsity constraint.

% [5] A. Beck, M. Teboulle. A Fast Iterative Shrinkage-Thresholding 
% Algorithm for Linear Inverse Problems.
% -------------------------------------------------------------------------
