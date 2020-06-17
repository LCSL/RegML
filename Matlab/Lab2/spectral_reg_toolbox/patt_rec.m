function [y_lrnt, test_err] = patt_rec(knl, kpar, alpha, x_train, x_test, y_test, learn_task)
%PATT_REC Calculates a test error given a training and a test dataset and an estimator
%   [Y_LRNT, TEST_ERR] = PATT_REC(KNL, KPAR, ALPHA, X_TRAIN, X_TEST, Y_TEST)
%   calculates the output vector Y_LRNT and the test error (regression or
%   classification) TEST_ERR given
%
%      - kernel type specified by 'knl':
%        'lin'   - linear kernel, 'kpar' is not considered
%        'pol'   - polinomial kernel, where 'kpar' is the polinomial degree
%        'gauss' - gaussian kernel, where 'kpar' is the gaussian sigma
%
%      - kernel parameter 'kpar':
%        'deg'  - for polynomial kernel 'pol'
%        'sigma' - for gaussian kernel 'gauss'
%
%      - an estimator 'alpha'
%        training set 'x_train'
%        test set 'x_test'
%        known output labels/test data 'y_test'
%
%      - a learn_task 'learn_task'
%        'class' - for classification
%        'regr' - for regression
%    
%   Example:
%    [y_lrnt, test_err] = patt_rec('gauss', .4, alpha,x, x_test, y_test)
%
% See also LEARN, KERNEL, LEARN_ERROR
    if iscell(alpha), alpha=cell2mat(alpha); end
    K_test = kernel(knl,kpar,x_test,x_train);   % Compute test kernel
    y_lrnt = K_test*alpha;  % Computre predicted output vector

    test_err = learn_error(y_lrnt, y_test, learn_task); % Evaluate error

end