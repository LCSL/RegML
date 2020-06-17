function [X,Y] = create_corr_tr_set(n,err_y,type,d1,d2,d3,d4)
% creates a training set with linear input-output relation.
%
% [X,Y] = CREATE_CORR_TR_SET(N,ERR_Y) creates a training 
% set [X,Y] for classification. The input data is Nx3 matrix ~N(0,1). 
% Y is the labels vector Nx1, Y = sign(X*(1,1,1)^T) with
% probability 1-ERR_Y.
% 
% [X,Y] = CREATE_CORR_TR_SET(N,ERR_Y,TYPE) if TYPE='CLASS'
% (default) create a training set for classification; if TYPE='REGR'
% creates a training set for regression Y = X*F0 + delta, delta~N(0,ERR_Y).
% 
% [X,Y] = CREATE_CORR_TR_SET(N,ERR_Y,TYPE,D1,D2,D3,D4) the first D1 
% features are noisy replicates of a first latent relevant feature, the 
% second D2 features are noisy replicates of a second latent relevant 
% feature, and the third D3 features are noisy replicates of a third 
% latent relevant feature. The last D4 features are noisy
% 
    if nargin<3, error('too few input arguments'); end
    if nargin<4, type ='class'; end
    if nargin<5, d1 =1; d2=1; d3=1; d4=0; end
    if nargin>8, error('too many input arguments'); end
    
    fx = ones(3,1);
    X = rand(n,3)*2-1;
    Y = X*fx;
    Y = Y + err_y.*randn(n,1);
    if isequal(type,'class'),  Y = sign(Y); end 
    X = add_correlation(X,d1,d2,d3);
    X = [X rand(n,d4)*2-1];
end

function [Xtot] = add_correlation(X,d1,d2,d3) 
    n = size(X,1);
    Xtot = zeros(n,d1+d2+d3);
    for i = 1:d1; Xtot(:,i) = X(:,1)+randn(n,1).*0.01; end
    for i = 1:d2; Xtot(:,d1+i) = X(:,2)+randn(n,1).*0.01; end
    for i = 1:d3; Xtot(:,d1+d2+i) = X(:,3)+randn(n,1).*0.01; end
end