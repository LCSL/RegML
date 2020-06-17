function [alpha]=tsvd(K, t_range, y)
%TSVD Calculates the coefficient vector using TSVD method.
%   [ALPHA] = TSVD(K, T_RANGE, Y) calculates the truncated singular values
%   solution of the problem 'K*ALPHA = Y' given a kernel matrix 'K[n,n]' a 
%   range of regularization parameters 'T_RANGE' and a label/output 
%   vector 'Y'.
%
%   The function works even if 'T_RANGE' is a single value
%
%   Example:
%       K = kernel('lin', [], X, X);
%       alpha = tsvd(K, logspace(-3, 3, 7), y);
%       alpha = tsvd(K, 0.1, y);
%
% See also RLS, NU, LAND, CUTOFF

if (sum(t_range > 1) + sum(t_range<0))
    msgbox('T-SVD: The range of t must be (0,s] in case of "Linear Space"; Otherwise for "Log Space" must be (-inf,log s], with s the biggest eigenvalue of the kernel matrix','Tips and tricks');
    return
end

n = length(y);

[U,S,V] = svd(K);
ds = diag(S);

alpha = cell(size(t_range));

for i=1:length(t_range)
    t = t_range(i);
    
    mask = ( ds >= t*n );
    
    inv_ds = (1./ds) .* mask;
    TinvS = diag(inv_ds);
    TK = V * TinvS * U';
    
    alpha{i} = TK * y;
end
