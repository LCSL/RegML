% ___ MODIFY HERE ___
%
%
%CHOOSE THE L2 REGULARIZATION PARAMETER
%--- l2_par is the value of the l2 regularization parameter
l2_par = 1e-5;
%-------------------------------------------------------------------------------------------------------------------
%
% DO YOU WANT TO USE CROSS VALIDATION FOR THE L1 REGULARIZATION?
%--- use_kcv values are true or false;
use_kcv = true;

%-------------------------------------------------------------------------------------------------------------------
% IF YOU ARE NOT USING CROSS VALIDATION
%--- l1_par_fixed_value is the regularization parameter value
l1_par_fixed_value = 1e-3;
%
%-------------------------------------------------------------------------------------------------------------------
% IF YOU ARE USING CROSS VALIDATION
%
%CHOOSE IF YOU WANT TO USE A DEFAULT RANGE OF L1 PARAMETER VALUES OR YOU WANT TO SPECIFY THEM
%--- default_or_choose values can be 'default' or 'choose'
%--- If you pick 'default', the code will choose for you a range of parameters to explore
default_or_choose = 'choose';
%
%IF YOU CHOSE TO SPECIFY THE RANGE OF L1 PARAMETERS
%--- l1_par_min is the smallest l1 parameter
l1_par_min = 1e-3;
%--- l1_par_max is the biggest l1 parameter
l1_par_max = 1e-1;
%--- n_l1_par is the number of parameters to test
n_l1_par = 100;

% ADVANCED CROSS VALIDATION SETTINGS
%--- split_type options are 'seq', 'rand'
split_type = 'seq';
%--- n_splits is the number of splits performed
n_splits = 5;

%-------------------------------------------------------------------------------------------------------------------
%
% ___ END MODIFY ___
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% FROM HERE DO NOT MODIFY THE DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



addpath(genpath('./'));

if strcmp(split_type,'rand')
    rand_split = true;
else
    rand_split = false;

end

task = 'regr';

if(use_kcv)
    if(strcmp(default_or_choose,'default'))
        [cv_output,model, tau_values] = l1l2_kcv(X,Y,'err_type', task, 'rand_split', rand_split, 'K', n_splits, 'protocol', 'one_step', ...
     'smooth_par', l2_par);
    else
     [cv_output,model, tau_values] = l1l2_kcv(X,Y,'err_type', task, 'rand_split', rand_split, 'K', n_splits, 'protocol', 'one_step', ...
     'smooth_par', l2_par, 'L1_n_par', n_l1_par, 'L1_max_par', l1_par_max, 'L1_min_par', l1_par_min);
    end

    l1_par = cv_output.tau_opt_1step;
    idx = find(tau_values==l1_par);
    % axes(handles.error);
    mm = [cv_output.err_KCV_1step(:); cv_output.err_train_1step(:)];
    % axis([min(tau_values) max(tau_values) min(mm) max(mm)]);
    figure;
    plot(tau_values, cv_output.err_KCV_1step);
    hold on
    plot(tau_values, cv_output.err_train_1step, 'r');
    plot(l1_par, cv_output.err_KCV_1step(tau_values == l1_par),'g*');
    xlabel('l1 par');
    ylabel('error');
    legend('KCV error', 'training error', 'KCV minimum', 'location', 'SouthEast');
    hold off
    %xlabel('l1 par'); ylabel('error');
    % axes(handles.selection);
    %axis([min(tau_values) max(tau_values) 0 1]);
    figure;
    plot(tau_values, cv_output.sparsity);
    xlabel('l1 par');
    ylabel('# of selected features');

    %xlabel('l1 par'); ylabel('# of selected features');
else
    l1_par = l1_par_fixed_value;
    [beta_m, offset_par, n_iter] = l1l2_learn(X, Y, l1_par, 'smooth_par', l2_par);
    model.beta_1step = beta_m;
    model.offset_1step = offset_par;
end
[pred] = l1l2_pred(model,Xt,Yt,task);
temp = model.beta_1step(model.beta_1step~=0.0);
l1_par_print =  sprintf('L1 par = %3.3e', l1_par)
l2_par_print =  sprintf('L2 par = %3.3e', l2_par)
test_error_print =  sprintf('Test error = %f', pred.err_1step)
n_selected_var_print =  sprintf('# of selected variables = %i', numel(temp))
