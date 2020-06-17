function tau_max = l1l2_tau_max(X,Y)
%L1L2_TAU_MAX estimates maximum value for l1 parameter. Values marger than
%tau_max yield null solutions.
% 
% [TAU_MAX] = L1L2_TAU_MAX(X,Y) estimates maximum value for sparsity parameter 
%   for training set (X,Y). X is the NxD input matrix, and Y is the Nx1 
%   outputs vector

tau_max = norm(X'*Y)/length(Y);
