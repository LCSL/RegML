function [beta,k] = l1l2_reg(X,Y,lambda,epsilon,stop,kmax,beta0)
% L1L2_REG Argmin of the least squares error with l1 and l2 penalizations. 
%   [BETA] = L1L2_REG(X,Y,LAMBDA,EPSILON) returns the solution of the l1l2
%   regularization with l1 parameter LAMBDA and l2 parameter EPSILON*LAMBDA. 
%   If the input data X is a NxD matrix, and the labels Y are a Nx1 vector, 
%   BETA is the Dx1 vector. The solution BETA is computed with the damped 
%   and thresholded landweber iterative algorithm  with damping factor 
%   1/(1+EPSILON*LAMBDA), thresholding factor LAMBDA, null initialization 
%   vector and step 2/(eig_max(X*X')*1.1). The algorithm stops when each 
%   element of BETA reached convergence.
%
%   [BETA,K] = L1L2_REG(X,Y,LAMBDA,EPSILON) also returns the number of
%   iterations.
%
%   [...] = L1L2_REG(X,Y,LAMBDA,EPSILON,STOP) if STOP=1(default) the algorithm
%   stops when each element of BETA reached convergence (the tolerance 
%   increases with the number of itearations) or when the number of 
%   iterations reached KMAX=1e4; if STOP=0 the algorithm stops after 
%   KMAX=1e4 iterations.
%
%   [...] = L1L2_REG(X,Y,LAMBDA,EPSILON,STOP,KMAX) the algorithm stops after
%   KMAX iterations or, if STOP=1, when each element of BETA reached convergence.
%
%   L1L2_REG(X,Y,LAMBDA,EPSILON) = L1L2_REG(X,Y,LAMBDA,EPSILONA,1).
%   L1L2_REG(X,Y,LAMBDA,EPSILON,STOP) = L1L2_REG(X,Y,LAMBDA,EPSILON,STOP,1e4).
%
%   See also THRESHOLDING
%
    if nargin<4; error('too few inputs'); end
    if nargin<5; stop = 1; end
    if nargin<6; kmax = 1e4; end
    if nargin<7; beta0 = zeros(size(X,2),1); end
    if nargin>7; error('too many inputs'); end
    tol = 0.01;
    kmin = 100;
    sigma_max = normest(X*X');
    step = 2/(sigma_max*1.1);
    XT = X'.*step;
    tau=lambda*length(Y)*step;  % 1-norm parameter (twice the threshold)
    mu = tau*epsilon;           % 2-norm parameter

    k = 0;
    beta = thresholding(beta0+XT*(Y-X*beta0),tau)/(1+mu); % first iteration
    log=1;
    while or(and(k<kmax,log),k<kmin)
        if stop
            % the stopping threshold depends on the iteration
            if all(abs(beta-beta0)<=(abs(beta0)*tol/(k+1))), log=0; end
        end
        beta0 = beta;
        beta = thresholding(beta0+XT*(Y-X*beta0),tau)/(1+mu);
        k = k+1;
    end

