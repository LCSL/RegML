function [X,Y] = create_training_set(n,p,s,err_y)

% creates a training set with linear input-output relation.
%
% [X,Y] = CREATE_TRAINING_SET(N,P,S,ERR_Y) creates a training
% set [X,Y] for regression. 
% X is the input data, a NxP matrix ~N(0,1).
% Y is the labels, a vector Nx1.

X = randn(n,p);                 % Normally distributed pseudorandom matrix
fx = [rand(s,1); zeros(p-s,1)]; % the feature vector generating the data
Y = X*fx;
Y = Y + err_y.*randn(n,1);      % The labels are corrupted by White noise.
