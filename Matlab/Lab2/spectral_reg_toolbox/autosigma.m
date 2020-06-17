function s = autosigma(X, K)
%AUTOSIGMA Compute the average K nearest neighbor distance of n p-dimensional points.
%   S = AUTOSIGMA(X, K) calculate the average K nearest neighbor
%   distance of n p-dimensional given a data matrix 'X[n,p]' and a number 
%   'K' of nearest neighbors returned by the K-NN
%   
%   Example:
%        s = autosigma(X, 5);
%
% See also KERNEL

E = EuclideanDistance(X,X,1);
E = sort(E);
s = mean(E(K+1,:));

% n = size(X, 1);
% s = 0;
% for i =1:n;
%     D = zeros(n,1);
%     for j =1:n;
%         D(j) = norm(X(i,:)-X(j,:));
%     end
%     D = sort(D);
%     s = s + mean(D(2:K+1));
% end
% s = s/n;

end
