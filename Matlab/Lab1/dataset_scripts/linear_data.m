function [X, Y, m, b, s] = linear_data(N, m, b, s)
%Sample a dataset from a linear separable dataset
%   [X, Y, m, b, s] = linear(N, m, b)
%    INPUT 
%	N      1x2 vector that fix the numberof samples from each class
%	m      slope of the separating line. Default is random.    
%	b      bias of the line. Default is random.
% 	s      standard deviation of the gaussian noise. Default is 0.1
%    OUTPUT
%	X data matrix with a sample for each row 
%   	Y vector with the labels
%
%   EXAMPLE:
%       [X, Y] = linearData([10, 10]);
if (nargin < 4)
	s = 0.1;
end
if (nargin < 3)
	b = rand()*0.5;
end
if (nargin < 2)
	m = rand() * 2 +0.01;
end

X = [];
while(size(X,1) < N(1))
    xx = rand(1);
    yy = rand(1);
    fy = xx*m + b;
    if(yy <= fy)
        X = [X;xx + randn(1)*s, yy + randn(1)*s];
    end
end

while(size(X,1) < sum(N))
    xx = rand(1);
    yy = rand(1);
    fy = xx*m + b;
    if(yy > fy)
        X = [X;xx + randn(1)*s,yy + randn(1)*s];
    end
end

Y = ones(sum(N), 1);
Y(1:N(1))  = -1;
