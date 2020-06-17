% ___ MODIFY HERE ___
%
%
% FILTER SETTINGS
%   The allowed values for filter are:
%       'rls'   - regularized least squares
%       'land'  - iterative Landweber
%       'tsvd'  - truncated SVD
%       'nu'    - nu-method
%       'cutoff'- spectral cut-off
filter = 'nu';
%
%--- knl is the kernel, it can be:
%       'lin'   - linear kernel, 'kpar' is not considered
%       'pol'   - polinomial kernel, where 'kpar' is the polinomial degree
%       'gauss' - gaussian kernel, where 'kpar' is the gaussian sigma
knl = 'gauss';
%
%--- kpar is the parameter sigma of the gaussian kernel, or the maximal degree of the polynomial kernel
kpar = 5;
%
%--- automatic_sigma, if you are using the gaussian kernel you can choose to automatically evaluate a reasonable sigma parameter ('kpar') setting 'true' this variable
automatic_sigma = true;
%
%-------------------------------------------------------------------------------------------------------------------
% DO YOU WANT TO USE CROSS VALIDATION?
%--- use_kcv is a boolean;
use_kcv = true;
%
%-------------------------------------------------------------------------------------------------------------------
% IF YOU ARE USING CROSS VALIDATION
%CHOOSE AN APPROPRIATE RANGE OF REGULARIZATION PARAMETER t ([t_min:step:t_max])
%--- t_min is the smallest t
t_min = 1E-4;
%
%--- t_max is the biggest t (for 'iterative lanwaber' and 'nu-method' this is the max number of iterations)
t_max = 1E-1;
%
%--- n_t is the number of parameters to test
t_min = 3;
t_max = 97;
n_t = 95;
linspace(t_min, t_max, n_t)
%
%--- Do you prefer a linear or a logaritmic sequence of values between t_min and t_max? 
%--- linear_or_log can be either 'Linear' or 'Logarithmic'
linear_or_log = 'Linear';
%
% CROSS VALIDATION ADVANCED SETTINGS
%--- n_splits is the number of splits performed on the dataset
n_splits = 5;
%
%--- split_type options are 'seq', 'rand'. It controls whether the dataset is splitted sequentially or randomly.
split_type = 'seq';
%
%
%
%-------------------------------------------------------------------------------------------------------------------
% IF YOU ARE NOT USING CROSS VALIDATION
% THEN CHOOSE YOURSELF THE REGULARIZATION PARAMETER
%--- t_fixed_value is the regularization parameter value (for 'iterative lanwaber' and 'nu-method' this is the max number of iterations)
t_fixed_value = 0.001;
%
%-------------------------------------------------------------------------------------------------------------------
% ___ END MODIFY ___
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% FROM HERE DO NOT MODIFY THE DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('./');
addpath('./challenge_datasets');
addpath('./dataGeneration');
addpath('./dataset_scripts');
addpath('./example_datasets');
addpath('./spectral_reg_toolbox');

task = 'class';

if(automatic_sigma)
    kpar = autosigma(X,5);
end

if use_kcv
    if (isnan(t_min) || isnan(t_max) || isnan(n_t))
        error('You must enter a numeric value for T_MIN, T_MAX and N_T');
    end

    if t_min > t_max
        error('Minimum value for the Log Space is larger than the specified maximum value');
    end

    switch linear_or_log
        case 'Linear'
            trange = linspace(t_min,t_max,n_t);
        case 'Logarithmic'
            if t_min < eps
                error('With a Logarithmic sequence of parameters, the smallest parameter #t_min# has to be grater than 0');
            end
            trange = logspace(log10(t_min),log10(t_max),n_t);
    end
    
    [t_kcv_idx, avg_err_kcv] = kcv(knl, kpar, filter, trange(1,:), X, Y, n_splits, task, split_type);

    tval = 0;

    if (strcmpi(filter,'land') || strcmpi(filter,'nu'))
        tval = t_kcv_idx;
        vmin = 0;
        vmax = max(trange);
    else
        tval = trange(t_kcv_idx);
        vmin = min(trange);
        vmax = max(trange);
    end
    [alpha, err] = learn(knl, kpar, filter, tval, X, Y, task);

    trained = 1;

    errMat = cell2mat(err);
    [z,index] = min(errMat);
    K = kernel(knl, kpar, Xt, X);
    y_learnt = K * alpha{index(end)};
    lrn_error = learn_error(y_learnt, Yt, task);

    test_error =  sprintf('The test error is %f', lrn_error)
    training_error =  sprintf('The training error is %f', errMat( index(end) ))
    selected_t = sprintf('The selected t is %f', tval)


    if (strcmpi(task,'class'))

       ax = min(min(min(Xt(:,1)),X(:,1))) : 0.1 : max(max(max(Xt(:,1)),X(:,1)));
        ax = [ax max(max(max(Xt(:,1)),X(:,1)))];

        az = min(min(min(Xt(:,2)),X(:,2))) : 0.1 : max(max(max(Xt(:,2)),X(:,2)));
        az = [az max(max(max(Xt(:,2)),X(:,2)))];

        [a b] = meshgrid(ax, az);
        c = [a(:),b(:)];
        K = kernel(knl, kpar, c, X);
        y_learnt = K * alpha{index(end)};

        y_learnt_cf = y_learnt;

        % PLOT TRAIN AND TEST SET
        figure
        title('Training set');
        hold on
        contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
        plot(X(Y > 0, 1), X(Y > 0, 2), 'r*')
        plot(X(Y < 0, 1), X(Y < 0, 2), 'b*')
        hold off
        colormap winter
        figure
        title('Test set');
        hold on
        contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
        plot(Xt(Yt > 0, 1), Xt(Yt > 0, 2), 'r*')
        plot(Xt(Yt < 0, 1), Xt(Yt < 0, 2), 'b*')
        colormap winter

    end

    if (length(trange) > 1)
        figure
        axis([vmin-0.01 vmax+0.01 min(avg_err_kcv)-0.01 max(avg_err_kcv)+0.01])
        plot(trange, avg_err_kcv,'-.b'), title('KCV - Error Plot'), xlabel( ['reg.par. range: '  num2str(vmin)  ' - ' num2str(vmax) ] ), ylabel('Error');
        grid on
        hold on
        plot(trange(t_kcv_idx), avg_err_kcv(t_kcv_idx), 'r*');

    else
        figure
        axis([vmin-0.01 vmax+0.01 min(avg_err_kcv)-0.01 max(avg_err_kcv)+0.01])
        plot(1:length(avg_err_kcv), avg_err_kcv,'-.b'), title('KCV - Error Plot'),xlabel(['t range: ' num2str(vmin) ' - '  num2str(vmax)] ), ylabel('Error');
        grid on
        hold on
        plot(t_kcv_idx, avg_err_kcv(t_kcv_idx), 'r*');
    end

else %% no kcv

if (isnan(t_fixed_value))
    error('You must enter a numeric value for t_max','Bad Input','modal')
else
    trange = t_fixed_value;
end

[alpha, err] = learn(knl, kpar, filter, trange, X, Y, task);


errMat = cell2mat(err);
[z,index] = min(errMat);

K = kernel(knl, kpar, Xt, X);
y_learnt = K * alpha{index(end)};
lrn_error = learn_error(y_learnt, Yt, task);

handles.trained = 1;

test_error =  sprintf('The test error is %f', lrn_error)
training_error =  sprintf('The training error is %f', errMat( index(end) ))
selected_t = sprintf('The selected t is %f', trange)


if (strcmpi(task,'class') )
    ax = min(min(min(Xt(:,1)),X(:,1))) : 0.1 : max(max(max(Xt(:,1)),X(:,1)));
    ax = [ax max(max(max(Xt(:,1)),X(:,1)))];

    az = min(min(min(Xt(:,2)),X(:,2))) : 0.1 : max(max(max(Xt(:,2)),X(:,2)));
    az = [az max(max(max(Xt(:,2)),X(:,2)))];

    [a b] = meshgrid(ax, az);
    c = [a(:),b(:)];


    K = kernel(knl, kpar, c, X);
    y_learnt = K * alpha{index(end)};

    y_learnt_cf = y_learnt;

    % PLOT TRAIN AND TEST SET
    figure
    title('Training set');
    hold on
    contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
    plot(X(Y > 0, 1), X(Y > 0, 2), 'r*')
    plot(X(Y < 0, 1), X(Y < 0, 2), 'b*')
    hold off
    colormap winter
    figure
    title('Test set');
    hold on
    contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
    plot(Xt(Yt > 0, 1), Xt(Yt > 0, 2), 'r*')
    plot(Xt(Yt < 0, 1), Xt(Yt < 0, 2), 'b*')
    colormap winter
end


end
