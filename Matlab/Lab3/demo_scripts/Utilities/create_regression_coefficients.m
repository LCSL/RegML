function fx = create_regression_coefficients(p, s)
% Create p regression coefficients with s relevant features.

if s>p, error('More relevant features than overall features'); end

fxdense = rand(p,1);
index = randperm(p);
fx = zeros(p,1);
fx(index(1:s)) = fxdense(index(1:s));

end