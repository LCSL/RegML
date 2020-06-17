function lrn_error = learn_error(y_learnt, y_test, learn_task)
%LEARN_ERROR Compute the learning error.
%   LRN_ERROR = LEARN_ERROR(Y_LEARNT, Y_TEST, LEARN_TASK) computes the 
%   classification or regression error given two vectors 'Y_LEARNT' and 
%   'T_TEST', which contain respectively the learnt and the the test 
%   labels/values of the output set.
%   The parameter 'LEARN_TASK' specify the kind of error:
%       'regr' - regression error
%       'class' - classification error
%
%   Example:
%       y_learnt = Kernel * alpha;
%       lrn_error = learn_error(y_learnt, y_test, 'class');
%       lrn_error = learn_error(y_learnt, y_test, 'regr');
%
% See also LEARN

if strcmpi(learn_task, 'class')    
    lrn_error = (sum(y_learnt .* y_test <= 0)) / length(y_test);
elseif strcmpi(learn_task, 'regr')
    lrn_error = norm(y_learnt - y_test)^2 / length(y_test);
else
    msgbox('Unknown learning task!','DEBUG: YOU ARE FAILING AT FAIL!!');
    return 
end