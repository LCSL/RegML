    function [beta] = thresholding(beta0,tau)
    ind = logical(abs(beta0)<tau/2);
    beta = beta0-sign(beta0).*tau/2;
    beta(ind) = 0;