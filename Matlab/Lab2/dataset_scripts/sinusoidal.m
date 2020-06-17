function [X, Y, s] = sinusoidal(N, s)
%Sample a dataset from a dataset separated by a sinusoidal line
%   [X, Y, s] = sinusoidal(N, m, b)
%    INPUT 
%	N      1x2 vector that fix the numberof samples from each class
% 	s      standard deviation of the gaussian noise. Default is 0.1
%    OUTPUT
%	X data matrix with a sample for each row 
%   	Y vector with the labels
%
%   EXAMPLE:
%       [X, Y] = sinusoidal([10, 10])
if (nargin < 2)
	s = 0.1;
end
X = [];
while(size(X,1) < N(1))
    xx = rand(1);
    yy = rand(1);
    fy = 0.7* .5 *(sin(2*pi*xx))+.5;
    if(yy <= fy)
        X = [X;xx + randn(1)*s, yy + randn(1)*s];
    end
end

while(size(X,1) < sum(N))
    xx = rand(1);
    yy = rand(1);
    fy = 0.7* .5 *(sin(2*pi*xx))+.5;
    if(yy > fy)
        X = [X;xx + randn(1)*s, yy + randn(1)*s];
    end
end

Y = ones(sum(N), 1);
Y(1:N(1))  = -1;

