function [X, Y, varargout] = create_dataset(N, type, noise, varargin)
%Sample a dataset from different distributions
%   [X, Y, varargout] = create_dataset(N, type, noise, varargin)
%
%   INPUT 
%       N     Number of samples
%       type  Type of distribution used. It must be one from 
%            'MOONS' 'GAUSSIANS' 'LINEAR' 'SINUSOIDAL' 'SPIRAL'
%       noise probability to have a wrong label in the dataset
%	
%       The meaning of the optional parameters depend on the type of the
%       dataset, if is set to 'PRESET'a fixed set of parameters is used:
%       'MOONS' parameters:
%           1- s: standard deviation of the gaussian noise. Default is 0.1
%           2- d: 1X2 translation vector between the two classes. With d = 0
%                 the classes are placed on a circle. Default is random.
%           3- angle: rotation angle of the moons in (radians). Default is random.
%
%       'GAUSSIANS' parameters:
%           1- ndist: number of gaussians for each class. Default is 3.    
%           2- means: vector of size(2*ndist X 2) with the means of each gaussian. 
%              Default is random.
%           3- sigmas: A sequence of covariance matrices of size (2*ndist, 2). 
%              Default is random.
%
%       'LINEAR' parameters:
%           1- m: slope of the separating line. Default is random.    
%           2- b: bias of the line. Default is random.
%           3- s: standard deviation of the gaussian noise. Default is 0.1
%
%       'SINUSOIDAL' parameters:
%           1- s: standard deviation of the gaussian noise. Default is 0.1
%
%       'SPIRAL' parameters:
%           1- s: standard deviation of the gaussian noise. Default is 0.5.
%           2- wrappings: wrappings number of wrappings of each spiral. Default is random.
%           3- m: multiplier m of x * sin(m * x) for the second spiral. Default is
%                 random.
%
%  OUTPUT
%   X data matrix with a sample for each row 
%   Y vector with the labels
%   varargout parameters used to sample data
%   EXAMPLE:
%       [X, Y] = create_dataset(100, 'SPIRAL', 0.01);
%       [X, Y] = create_dataset(100, 'SPIRAL', 0.01, 'PRESET');
%       [X, Y] = create_dataset(100, 'SPIRAL', 0, 0.1, 2, 2);
%	[X, Y] = gaussian(NN, 2, [-5, -7; 2, -9; 10, 5; 12,-6], repmat(eye(2)* 3, 4, 1));
NN = [floor(N / 2.0), ceil(N / 2.0)];

X = [];
Y = [];

usepreset = 0;
if(size(varargin,2) == 1 && strcmp(varargin{1},  'PRESET'))
   usepreset = 1; 
end

if(strcmp(type,  'MOONS'))
    optargin = size(varargin,2);
    s = []; d = []; angle = [];
    if (usepreset == 1)        
        [X, Y, s, d, angle] = moons(NN, 0.1, [-0.5, -0.5], 0);
    elseif(optargin == 0)
        [X, Y, s, d, angle] = moons(NN);
    elseif(optargin == 1)
        [X, Y, s, d, angle] = moons(NN, varargin{1});
    elseif(optargin == 2)
        [X, Y, s, d, angle] = moons(NN, varargin{1}, varargin{2});
    elseif(optargin == 3)
        [X, Y, s, d, angle] = moons(NN, varargin{1}, varargin{2}, varargin{3});
    end
    varargout{1} = s;
    varargout{2} = d;
    varargout{3} = angle;
elseif(strcmp(type, 'GAUSSIANS'))
    optargin = size(varargin,2);
    ndist = []; means = []; sigmas = [];
    if (usepreset == 1)        
        [X, Y, ndist, means, sigmas] = gaussian(NN, 2, [-5, -7; 2, -9; 10, 5; 12,-6], repmat(eye(2)* 3, 4, 1));
    elseif(optargin == 0)
        [X, Y, ndist, means, sigmas] = gaussian(NN);
    elseif(optargin == 1)
        [X, Y, ndist, means, sigmas] = gaussian(NN, varargin{1});
    elseif(optargin == 2)
        [X, Y, ndist, means, sigmas] = gaussian(NN, varargin{1}, varargin{2});
    elseif(optargin == 3)
        [X, Y, ndist, means, sigmas] = gaussian(NN, varargin{1}, varargin{2}, varargin{3});
    end
    varargout{1} = ndist;
    varargout{2} = means;
    varargout{3} = sigmas;
elseif(strcmp(type, 'LINEAR'))
    optargin = size(varargin,2);
    m = []; b = []; s = [];
    if (usepreset == 1)        
        [X, Y, m, b, s] = linear_data(NN, 1, 0, 0.1);
    elseif(optargin == 0)
        [X, Y, m, b, s] = linear_data(NN);
    elseif(optargin == 1)
        [X, Y, m, b, s] = linear_data(NN, varargin{1});
    elseif(optargin == 2)
        [X, Y, m, b, s] = linear_data(NN, varargin{1}, varargin{2});
    elseif(optargin == 3)
        [X, Y, m, b, s] = linear_data(NN, varargin{1}, varargin{2}, varargin{3});
    end
    varargout{1} = m;
    varargout{2} = b;
    varargout{3} = s;
elseif(strcmp(type, 'SINUSOIDAL'))
    optargin = size(varargin,2);
    if (usepreset == 1)        
        [X, Y, s] = sinusoidal(NN, 0.01);
    elseif(optargin == 0)
        [X, Y, s] = sinusoidal(NN);
    elseif(optargin == 1)
        [X, Y, s] = sinusoidal(NN, varargin{1});
    end
    varargout{1} = s;
elseif(strcmp(type, 'SPIRAL'))
    optargin = size(varargin,2);
    s = []; wrappings = []; m = [];
    if (usepreset == 1)        
        [X, Y, s, wrappings, m] = spiral(NN, 0.5, 2, 2);
    elseif(optargin == 0)
        [X, Y, s, wrappings, m] = spiral(NN);
    elseif(optargin == 1)
        [X, Y, s, wrappings, m] = spiral(NN, varargin{1});
    elseif(optargin == 2)
        [X, Y, s, wrappings, m] = spiral(NN, varargin{1}, varargin{2});
    elseif(optargin == 3)
        [X, Y, s, wrappings, m] = spiral(NN, varargin{1}, varargin{2}, varargin{3});
    end
    varargout{1} = s;
    varargout{2} = wrappings;
    varargout{3} = m;
else
    disp('Specified dataset type is not correct. It must be one of MOONS, GAUSSIANS, LINEAR, SINUSOIDAL, SPIRAL');
end

swap = rand(size(Y)) <= noise;
Y(swap) = Y(swap) * - 1;

