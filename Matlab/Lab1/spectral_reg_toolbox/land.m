function [alpha]=land(K, t_max, y, tau, all_path)
%LAND Calculates the coefficient vector using Landweber method.
%   [ALPHA] = LAND(K, T_MAX, Y, TAU) calculates the regularized least 
%   squares  solution of the problem 'K*ALPHA = Y' given a kernel matrix 
%   'K[n,n]' a maximum regularization parameter 'T_MAX', a
%   label/output vector 'Y' and a step size 'TAU'.
%
%   [ALPHA] = LAND(K, T_MAX, Y, TAU, ALL_PATH) returns only the last 
%   solution calculated using 'T_MAX' as regularization parameter if
%   'ALL_PATH' is false. Otherwise return all the regularization path.
%
%   Example:
%       K = kernel('lin', [], X, X);
%       alpha = land(K, 10, y, 2);
%       alpha = land(K, 10, y, 2, true);
%
% See also NU, TSVD, CUTOFF, RLS

if nargin == 4
    all_path = false; 
end

if ~all(size(t_max) == [1, 1])
    msgbox('t_max must be an int greater than 0','Tips and tricks');
    return
end
t_max = floor(t_max);
if (t_max < 2)
    msgbox('t_max must be an int greater equal than 2','Tips and tricks');
    return
end

n = length(y);
alpha = cell([1, t_max]);

alpha{1} = zeros(n,1);
for i=2:t_max        
    alpha{i}= alpha{i-1} + (tau/n) * (y - K*alpha{i-1});
end

if ~all_path
    alpha = {alpha{t_max}};
end

end
