function [Xcentered,Ycentered,meanX,meanY] = centering(X,Y,center)
%Normalization of a data set
%   [XCENTERED,YCENTERED] = CENTERING(X,Y,) normalizes a data
%       set X,Y where X is a matrix NxD and Y an array Nx1 amd returns the 
%       normalized matrix XNORM, and array Ynorm. Matrix X is normalized 
%       column by column by subtracting the mean (only if CENTER=1) and
%       by setting the norm to 1 (only if NORM_COL=1). Y is normalized by
%       subtracting its mean. NORMALIZATION(X,Y,0,0) = [X,Y].
%
%   [XNORM,YNORM,XTS_NORM,YTS_NORM] = NORMALIZATION(X,Y,NORM_MEAN,NORM_COL,Xts,Yts)
%       normalizes matrices XNORM,XTS_NORM, and arrays Ynorm,YTS_NORM. 
%       Test data is normalized with respect to the mean and
%       standard deviation estimated from the training data.
%   [XNORM,YNORM,XTS_NORM,YTS_NORM,MEANY] = NORMALIZATION(...) also returns
%   the mean for Y.

if nargin<3; error('too few inputs!'); end
if nargin>3; error('too many inputs!'); end
    
[n,xdim] = size(X);
if center;
    meanX = mean(X); 
    meanY = mean(Y);
else
    meanX = zeros(1,xdim);
    meanY= 0;
end
Xcentered = zeros(n,xdim);
for i = 1:n;
    Xcentered(i,:) = (X(i,:)-meanX);   
end
Ycentered = Y-meanY;
