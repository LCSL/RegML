function [alpha]=rls(K, t_range, y)
%   RLS Calculates the coefficient vector using Tikhonov method.
%   [ALPHA] = RLS(K, lambdas, Y) calculates the least squares solution
%   of the problem 'K*ALPHA = Y' given a kernel matrix 'K[n,n]' a 
%   range of regularization parameters 'lambdas' and a label/output 
%   vector 'Y'.
%
%   The function works even if 'T_RANGE' is a single value
%
%   Example:
%       K = kernel('lin', [], X, X);
%       alpha = rls(K, logspace(-3, 3, 7), y);
%       alpha = rls(K, 0.1, y);
%
% See also NU, TSVD, LAND, CUTOFF

n = length(y);
alpha = cell(size(t_range));

[U,S,V] = svd(K);
ds=diag(S);

for i=1:length(t_range)
    lambda = t_range(i);
    
    TikS = diag(1 ./ (ds + lambda*n));
    TikK = V * TikS * U';
    
    alpha{i} = TikK * y;
end

end
