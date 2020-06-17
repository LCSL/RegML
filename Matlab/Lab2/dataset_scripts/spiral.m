function [X, Y, s, wrappings, m] = spiral(N, s, wrappings, m)
%Sample a dataset from a dataset separated by a sinusoidal line
%   [X, Y, s, wrappings, m] = spiral(N, s, wrappings, m)
%    INPUT 
%	N         1x2 vector that fix the numberof samples from each class
%	s         standard deviation of the gaussian noise. Default is 0.5.
%	wrappings number of wrappings of each spiral. Default is random.
%	m 	  multiplier m of x * sin(m * x) for the second spiral. Default is random.
%    OUTPUT
%	X data matrix with a sample for each row 
%   	Y vector with the labels
%
%   EXAMPLE:
%       [X, Y] = spiral([10, 10])

if (nargin <= 3)
    m = 1 + rand() ;
end

if (nargin <= 2)
    wrappings = 1 + rand() * 8;
end

if (nargin == 1)
    s = 0.5;
end

X = [];
oneDSampling = rand(N(1), 1)*wrappings*pi;
X = [X; [oneDSampling.*cos(oneDSampling), oneDSampling.*sin(oneDSampling)] + randn(N(1),2)*s];

oneDSampling = rand(N(2), 1)*wrappings*pi;
X = [X; [oneDSampling.*cos(m*oneDSampling), oneDSampling.*sin(m*oneDSampling)] + randn(N(2),2)*s];

Y = ones(sum(N), 1);
Y(1:N(1))  = -1;

