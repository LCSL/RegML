function [X,Y] = create_training_set_new(n,fx,sigma_noise,type)
% creates a training set with linear input-output relation.
% checked and commented by Savero Salzo
% 29/06/2016
% salzo.uni@gmail.com
%
% [X,Y] = CREATE_TRAINING_SET(n,fx,sigma_noise) creates a training 
% set [X,Y] for regression. 
%
% INPUT:
% fx...................the feature vector of dimension 
%
% OUTPUT:
% X....................a nxd matrix, collecting n samples of dimension
%                      d (= length(fx)) randomly generated according to the
%                      uniform distribution on [-1,1].
% Y....................a nx1 vector of labels. It is generated as
%                      Y = X*fx + N(0,sigma_noise) in the regression case 
%                      and as Y = sign(X*fx + N(0,sigma_noise)) in the 
%                      classification case.

% [X,Y] = CREATE_TRAINING_SET(n,fx,sigma_noise,type) if type='CLASS'
% (default) create a training set for classification; if type='REGR'
% creates a training set for regression Y = X*fx + delta, 
% delta~N(0,sigma_noise).

if nargin<3, error('too few input arguments'); end
if nargin<4, type ='class'; end
if nargin>4, error('too many input arguments'); end

xdim=length(fx);
X = rand(n,xdim)*2-1;            % Uniformly distributed pseudorandom matrix
                                 % with value in [-1,1]
Y = X*fx;                        % the feature vector generating the data
Y = Y + sigma_noise.*randn(n,1); % the labels are corrupted by white noise
if isequal(type,'class'),  Y = sign(Y); end