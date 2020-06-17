function [X, Y, ndist, means, sigmas] = gaussian(N, ndist, means, sigmas)
%Sample a dataset from a mixture of gaussians
%   [X, Y, ndist, means, sigmas] = gaussian(N, ndist, means, sigmas)
%    INPUT 
%	N      1x2 vector that fix the numberof samples from each class
%	ndist  number of gaussian for each class. Default is 3.    
%	means  vector of size(2*ndist X 2) with the means of each gaussian. 
%	       Default is random.
%	sigmas A sequence of covariance matrices of size (2*ndist, 2). 
%	       Default is random.
%    OUTPUT
%	X data matrix with a sample for each row 
%   	Y vector with the labels
%
%   EXAMPLE:
%       [X, Y] = gaussian([10, 10]);

if (nargin  < 2)
    ndist = 3;
end
if (nargin < 4)
	sigmas =[];
	for i=1:ndist*2
	    sigma =rand(2, 2) + eye(2) * 2;
	    sigma(1, 2) = sigma(2, 1);
	    sigmas = [sigmas; sigma];
	end
end
if (nargin < 3)
	means = rand(ndist * 2, 2) * 20 - 10;
end


X = [];
for i=1:N(1)
    dd = floor(rand(1) * ndist);
    X = [X; randn(1,2) * sigmas(dd*2+1:dd*2+2, :) + means(dd + 1, :)];
end

for i=1:N(2)
    dd = floor(rand(1) * ndist + ndist);
    X = [X; randn(1,2) * sigmas(dd*2+1:dd*2+2, :) + means(dd+1, :)];
end

Y = ones(sum(N), 1);
Y(1:N(1))  = -1;