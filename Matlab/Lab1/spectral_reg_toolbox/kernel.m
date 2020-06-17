function k = kernel(knl, kpar, X1, X2)
%KERNEL Calculates a kernel matrix.
%   K = KERNEL(KNL, KPAR, X1, X2) calculates the nxN kernel matrix given
%   two matrix X1[n,d], X2[N,d] with kernel type specified by 'knl':
%       'lin'   - linear kernel, 'kpar' is not considered
%       'pol'   - polinomial kernel, where 'kpar' is the polinomial degree
%       'gauss' - gaussian kernel, where 'kpar' is the gaussian sigma
%
%   Example:
%       X1 = randn(n, d);
%       X2 = randn(N, d);
%       K = kernel('lin', [], X1, X2);
%       K = kernel('gauss', 2.0, X1, X2);
%
% See also LEARN

N = size(X1, 1);
n = size(X2, 1);

switch lower(knl)
   
    case 'lin'
        k = X1 * X2';
        
    case 'pol'
        deg = kpar;
        if (int64(deg) ~= deg) || deg < 1
            msgbox('Polynomial kernel degree should be an integer greater or equal than 1','Tips and tricks');
            return
        end
        k = (X1 * X2'+1) .^ deg;
        
%     case 'gauss'
%         sigma = kpar;
%         if (sigma <= 0)
%             msgbox('Gaussian kernel sigma should be greater than 0','Tips and tricks');
%             return
%         end
%         [a b] = meshgrid(1:n, 1:N);
%         a = a(:);
%         b = b(:);
%         var = (2 * (sigma*sigma));
%         out = exp( -sum((X1(b,:)-X2(a,:)).^2, 2) / var);
%         k = reshape(out,N,n);
    
    case 'gauss'
        sigma = kpar;
        if (sigma <= 0)            
            msgbox('Gaussian kernel sigma should be greater than 0','Tips and tricks');
            return
        end

        %k = zeros(N, n);
        var = (2 * (sigma*sigma));
        sqx = sum(X1.*X1, 2);
        sqy = sum(X2.*X2, 2);
        k = sqx*ones(1, n) + ones(N, 1) * sqy' - 2 * X1*X2';

        k=exp(-(k./var));

        
    otherwise
        msgbox('Unknown kernel! Choose the appropriate one!','Tips and tricks');
        return
end
