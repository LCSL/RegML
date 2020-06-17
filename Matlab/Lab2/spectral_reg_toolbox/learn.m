function [alpha, err] = learn(knl, kpar, filt, t_range, X, y, task)
%LEARN Learns an estimator. 
%   ALPHA = LEARN(KNL, KPAR, FILT, T_RANGE, X, Y) calculates a set of 
%   estimators given a kernel type 'KNL' and (if needed) a kernel parameter 
%   'KPAR', a filter type 'FILT', a range of regularization parameters 
%   'T_RANGE' and a training set composed by the input matrix 'X[n,d]' and
%   the output vector 'Y[n,1]'.
%
%   The allowed values for 'KNL' and 'KPAR' are described in the
%   documentation given with the 'KERNEL' function. Moreover, it is possible to
%   give a custom kernel with 'KNL='cust'' and 'KPAR[n,n]' matrix.
%
%   The allowed values for 'FILT' are:
%       'rls'   - regularized least squares
%       'land'  - iterative Landweber
%       'tsvd'  - truncated SVD
%       'nu'    - nu-method
%       'cutoff'- spectral cut-off
%
%   The parameter 'T_RANGE' may be a range of values or a single value.
%   In case of 'FILT' equal 'land' or 'nu', 'T_RANGE' *MUST BE* a single
%   integer value, because its value is interpreted as 'T_MAX' (see also 
%   LAND and NU documentation). Note that in case of 'land' the algorithm
%   step size 'tau' will be automatically calculated (and printed).
%
%   [ALPHA, ERR] = LEARN(KNL, FILT, T_RANGE, X, Y, TASK) also returns
%   either classification or regression errors (on the training data)
%   according to the parameter 'TASK':
%       'class' - classification
%       'regr'  - regression
%
%   Example:
%       alpha = learn('lin', [], 'rls', logspace (-3, 3, 7), X, y);
%       alpha = learn('gauss', 2.0, 'land', 100, X, y);
%       [alpha, err] = learn('lin', [] , 'tsvd', logspace(-3, 3, 7), X, y, 'regr');
%
%   See also KCV, KERNEL, LEARN_ERROR

%% Check inputs
if nargin == 6
    task = false;
end

if (strcmpi(filt,'nu') || strcmpi(filt,'land')) && length(t_range) ~= 1
    msgbox('The dimension of the t_range array MUST be 1','Tips and tricks');
    return
end            

if ~(strcmpi(task, 'class') || strcmpi(task, 'regr'))
    msgbox('Unknown learning task!','DEBUG: YOU ARE FAILING AT FAIL!!');
    return 
end

%% Compute kernel K
if strcmpi(knl,'cust')
    n = size(X, 1);
    if ~all(size( kpar ) == [n, n])
        msgbox('Not valid custom kernel','Tips and tricks');
        return 
    end
else
    K = kernel(knl, kpar, X, X);
end

%% Algorithm execution
switch lower(filt)
    case 'land'
        if strcmp(knl,'gauss')
            tau = 2;
        else
            opts.disp = 0;
            opts.issym = 1;
            s = eigs(K,1, 'LM', opts);
            tau = 2/s;
        end
        fprintf('Calculated step size tau: %f\n', tau);        
        alpha = land(K, t_range, y, tau, true);

    case 'nu'
        alpha = nu(K, t_range, y, true);
        
    case 'rls'
        alpha = rls(K, t_range, y);
        
    case 'tsvd'
        alpha = tsvd(K, t_range, y);
        
    case 'cutoff'
        alpha = cutoff(K, t_range, y);
        
    otherwise
        msgbox('Unknown filter. Please specify one in: nu, rls, tsvd, land, cutoff','Tips and tricks');
        return 
end


%% Training Error requested
if task
    err = cell(1, length(alpha));
    for i=1:length(alpha)
        y_lrnt = K * alpha{i};
        err{i} = learn_error( y_lrnt, y, task );
    end
end

end
