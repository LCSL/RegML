function [t_kcv_idx, avg_err_kcv] = kcv(knl, kpar, filt, t_range, X, y, k, task, split_type)
%KCV Perform K-Fold Cross Validation.
%   [T_KCV_IDX, ERR_KCV] = KCV(KNL, KPAR, FILT, T_RANGE, X, Y, K, TASK, SPLIT_TYPE)
%   performs k-fold cross validation to calculate the index of the
%   regularization parameter 'T_KCV_IDX' within a range 'T_RANGE'
%   which minimizes the average cross validation error 'AVG_ERR_KCV' given
%   a kernel type 'KNL' and (if needed) a kernel parameter 'KPAR', a filter
%   type 'FILT' and a dataset composed by the input matrix 'X[n,d]' and the output vector
%   'Y[n,1]'.
%
%   The allowed values for 'KNL' and 'KPAR' are described in the
%   documentation given with the 'KERNEL' function. Moreover, it is possible to
%   specify a custom kernel with 'KNL='cust'' and 'KPAR[n,n]' matrix.
%
%   The allowed values for 'FILT' are:
%       'rls'   - regularized least squares
%       'land'  - iterative Landweber
%       'tsvd'  - truncated SVD
%       'nu'    - nu-method
%       'cutoff'- spectral cut-off
%
%   The parameter 'T_RANGE' may be a range of values or a single value.
%   In case 'FILT' equals 'land' or 'nu', 'T_RANGE' *MUST BE* a single
%   integer value, because its value is interpreted as 'T_MAX' (see also
%   LAND and NU documentation). Note that in case of 'land' the algorithm
%   step size 'tau' will be automatically calculated (and printed).
%
%   According to the parameter 'TASK':
%       'class' - classification
%       'regr'  - regression
%   the function minimizes the classification or regression error.
%
%   The last parameter 'SLIT_TYPE' must be:
%       'seq' - sequential split (as default)
%       'rand' - random split
%   as indicated in the 'SPLITTING' function.
%
%   Example:
%       [t_kcv_idx, avg_err_kcv] = kcv('lin', [], 'rls', logspace(-3, 3, 7), X, y, 5, 'class', 'seq')
%       [t_kcv_idx, avg_err_kcv] = kcv('gauss', 2.0, 'land', 100, X, y, 5, 'regr', 'rand')
%
% See also LEARN, KERNEL, SPLITTING, LEARN_ERROR
k=ceil(k);
if (k <= 1)
    msgbox('The number of splits in KCV must be at least 2','Tips and tricks');
    return
end

%% Split of training set:
sets = splitting(y, k, split_type);

%% Starting Cross Validation
err_kcv = cell(k, 1); % one series of errors for each split
for split = 1:k;
    %fprintf('\n split number %d \n', split);

    test_idxs = sets{split};
    train_idxs = setdiff(1:length(y), test_idxs);

    X_train = X(train_idxs, :);
    y_train = y(train_idxs);

    X_test = X(test_idxs, :);
    y_test = y(test_idxs);

    %% Learning
    alpha =  learn(knl, kpar, filt, t_range, X_train, y_train, task);

    %% Test error estimation
    % Error estimation over the test set, using the parameters given by the
    % pprevious task
    K_test = kernel(knl, kpar, X_test, X_train);

    % On each split we estimate the error with each t value in the range
    err_kcv{split} = zeros(1, length(alpha));
    for t=1:length(alpha)
        y_learnt = K_test * alpha{t};
        err_kcv{split}(t) = learn_error(y_learnt, y_test, task);
    end
end

%% Average the error over different splits
avg_err_kcv = median(cell2mat(err_kcv));

%% Calculate minimum error w.r.t. the regularization parameter

min_err = inf;
t_kcv_idx = -1;
for i=1:numel(avg_err_kcv)
    if avg_err_kcv(i) <= min_err
        min_err = avg_err_kcv(i);
        t_kcv_idx = i;
    end
end

size(alpha{t_kcv_idx});
alpha{t_kcv_idx};
end
