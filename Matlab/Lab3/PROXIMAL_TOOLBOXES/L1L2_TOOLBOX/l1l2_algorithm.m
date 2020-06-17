function [beta,n_iter] = l1l2_algorithm(X,Y,tau,smooth_par,beta0,L0,max_iter,tol)

% L1L2_ALGORITHM Returns the minimizer of the empirical error penalized
% with l1l2 penalties by using FISTA.
% (checked and revised by) Saverio Salzo
% 29/06/2016
% salzo.uni@gmail.com
% 
% It solves the following minimization problem
%
%   min (1/(2*n))*||X*beta - Y||_2^2 
%                + (A*smooth_par/(2*n))*||beta||_2^2 + tau*||beta||_1
% 
% where A = ||X||^2, by using the FISTA algorithm.
% Note that the gradient of the smooth part, say f, is
%   
%   nabla f(beta) = (1/n)*X^t(X*beta -Y) + (A*smooth_par/n)*beta
%
% which has Lipschitz constant equal to L = (A/n) + (A*smooth_par)/n
%
% INPUT:
% X....................a nxd matrix, collecting n samples of dimension d 
% Y....................a nx1 vector of labels
% tau..................the weight of the l1 term
% smooth_par...........parameter controlling the weight of the l2 term, 
%                      which is ||X||^2*smooth_par/(2n) 
% beta0................initialization vector for FISTA (defalut = 0)
% L0...................parameter that changes the step size (default = A/n)
% max_iter.............maximum number of iteration (default = 1e5)
% toll.................relative tolerance for stopping (default = 1e-6)
%
% OUTPUT:
% beta.................a dx1 vector of featurs. 
%                      The nonzero components gives the relevant features.
% n_iter...............number of iterations executed by the algorithm
%
% INTERNAL VARIABLES:
% A = ||X||^2.....................the largest eigenvalue of X'*X
% L = (A/n)*(1+smooth_par)........the Lipschitz constant of the smooth part
%                                 the step size in FISTA is 1/L
%
%   [beta] = L1L2_ALGORITHM(X,Y,tau) 
%   It returns the solution of the l1 regularization algorithm with sparsity 
%   parameter tau (smoothness parameter 0)
% 
%   [beta] = L1L2_ALGORITHM(X,Y,tau,smooth_par) 
%   It returns the solution of the l1l2 regularization with sparsity 
%   parameter TAU and smoothness parameter (A/n)*SMOOTH_PAR. 
%
%   [beta,n_iter] = L1L2_ALGORITHM(X,Y,tau,smooth_par) 
%   It returns also the number of iterations.
%
%   [...] = L1L2_ALGORITHM(X,Y,tau,smooth_par,beta0) uses beta0 as
%   initialization of the iterative algorithm. If beta0=[], sets beta0=0
%
%   [...] = L1L2_ALGORITHM(X,Y,tau,smooth_par,beta0,L0) 
%   It sets the smoothness parameter to L0*SMOOTH_PAR and the step 
%   size to 1/(L0*(1+smooth_par)). 
%   To ensure convergence it has to be L0>=A/n.
%
%   [...] = L1L2_ALGORITHM(X,Y,tau,smooth_par,beta0,L0,max_iter) 
%   The algorithm stops after max_iter iterations 
%   or when regularized empirical error reaches convergence 
%   (default tolerance is 1e-6). 
%
%   [...] = L1L2_ALGORITHM(X,Y,tau,smooth_par,beta0,L0,max_iter,tol) 
%   uses TOL as tolerance for stopping. 
%
%%%%% Comment from Guillaume Garrigos: FISTA never stops when the dimension n=1
%
    if nargin<3; error('too few inputs!'); end
    if nargin<4; smooth_par = 0; end
    if nargin<5; beta0 = []; end
    if nargin<6; L0=[]; end
    if nargin<7; max_iter = 1e5; end
    if nargin<8; tol = 1e-6; end
    if nargin>8; error('too many inputs!'); end
    
    [n,d] =size(X);
    % if sigma is not specified in input, set  it to as A/n
    if isempty(L0);
        L0 = normest(X)^2/n; % the Lipschitz constant of 
                             % the gradient of datafit term
    end

    mu = smooth_par*L0; % smoothness parameter
    
    L = L0+mu; % the Lipschitz constant of 
               % smooth part of the objective function
               % the full step size is 1/L

    % useful normalization that avoids computing the same computations for
    % each iteration
    mu_s = mu/L;
    tau_s = tau/L;
    XT = X'./(n*L);
    
    
    % initialization 
    if isempty(beta0);
        beta0 = zeros(d,1); 
    end
    n_iter = 0;   % the number of iterations
    stop=0;       % logical variable for stopping the iterations
    beta = beta0; % initialization for iterate n_iter-1
    h = beta0;    % initialization for combination of the previous 2 iterates (iteratations n_iter_1 and n_iter-2)
    t = 1;        % initialization for the adaptive parameter used to combine the previous 2 iterates when building h
    % precomputes X*beta and X*h to avoid computing them twice
    Xb = X*beta;
    Xh = Xb;
    
    % initialization for the values of the regularized empirical error (their
    % mean will be compared with the value of the regularized empirical
    % error at each iteration to establish if convergence is reached)
    E_prevs = Inf*ones(10,1);
    
    % FISTA iterations for l1l2 regression
    
    while and(n_iter<max_iter,~stop)
        
        n_iter = n_iter+1; % update the number of iterations
        beta_prev = beta;  % update of the current iterate            
        Xb_prev = Xb;

        % computes the gradient step
        beta_noproj = h.*(1-mu_s) + XT*(Y-Xh);
        
        % apply soft-thresholding operator
        beta = beta_noproj.*max(0,1-tau_s./abs(beta_noproj));

        Xb = X*beta;
        
        t_new = .5*(1+sqrt(1+4*t^2)); %adaptive parameter used to combine the previous 2 iterates when building h
        h = beta + (t-1)/(t_new)*(beta-beta_prev); % combination of the 2 previous iterates
        Xh = Xb.*(1+ (t-1)/(t_new)) +(1-t)/(t_new).*Xb_prev;
        t = t_new;
        
        % evaluate the regularized empirical error on the current iterate
        E = norm(Xb-Y)^2/n + 2*tau*sum(abs(beta));  
        if smooth_par>0;
            E = E + mu*norm(beta)^2;
        end
        % compares the value of the regularized empirical error on the current iterate
        % with the mean of that of the previous 10 iterates times tol
        E_prevs(mod(n_iter,10)+1) = E;
        if abs(mean(E_prevs)-E)<abs(mean(E_prevs)*tol); stop =1; end
    end
    if ~stop
        fprintf('l1l2_algorithm: FISTA reaches the maximum number of iteration.\n');
    end
