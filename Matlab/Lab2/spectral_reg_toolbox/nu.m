function [alpha]=nu(K, t_max, y, all_path)
%NU Calculates the coefficient vector using NU method.
%   [ALPHA] = NU(K, T_MAX, Y) calculates the solution of the problem 
%   'K*ALPHA = Y' using NU method given a kernel matrix 
%   'K[n,n]', the maximum number of the iterations 'T_MAX' and a 
%   label/output vector 'Y'.
%
%   [ALPHA] = NU(K, T_MAX, Y, ALL_PATH) returns only the last 
%   solution calculated using 'T_MAX' as regularization parameter if
%   'ALL_PATH' is false(DEFAULT). Otherwise return all the regularization 
%   path.
%
%   Example:
%       K = kernel('lin', [], X, X);
%       alpha = nu(K, 10, y);
%       alpha = nu(K, 10, y, true);
%
% See also TSVD, CUTOFF, RLS, LAND

if nargin == 3
    all_path = false; 
end


% if ~all(size(t_max) == [1, 1])
%     msgbox('t_max must be an int greater than 0','Tips and tricks');
%     return
% end
t_max = floor(t_max);
if (t_max < 3)
    msgbox('t_max must be an int greater than 2','Tips and tricks');
    return
end

n=length(y);
alpha = cell([1, t_max]);

alpha{1} = zeros(n,1);
alpha{2} = zeros(n,1);
nu = 1;

for i=3:t_max
    u = ((i-1) * (2*i-3) * (2*i+2*nu-1)) / ((i+2*nu-1) * (2*i+4*nu-1) * (2*i+2*nu-3));
    w = 4 * ( ((2*i+2*nu-1)*(i+nu-1)) / ((i+2*nu-1)*(2*i+4*nu-1)) );
    alpha{i} = alpha{i-1} + u*(alpha{i-1} - alpha{i-2}) + (w/n)*(y - K*alpha{i-1});
end

if ~all_path
    alpha = {alpha{t_max}};
end

end
