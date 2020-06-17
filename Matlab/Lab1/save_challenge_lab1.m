function save_challenge_1(YOURNAME, T, KERNEL, KERNEL_PARAMETER, errval)
%save_challenge_1(YOURNAME, T, KERNEL, KERNEL_PARAMETER, errval)
%where YOURNAME is a string of the form 'name_surname'
%T is the regularization pamareter you chose
%KERNEL is a string and can be 'lin', 'pol', 'gauss'
%KERNEL_PARAMETER is the parameter of the kernel
%errval the mean average error aon the training set
    model = {};
    model{1} =  YOURNAME;
    model{2} = T;
    model{3} = KERNEL;
    model{4} = KERNEL_PARAMETER;
    model{5} = errval;
    save(YOURNAME, 'model');
    
    s = sprintf('%s you learned with success!\n\nyour learned model uses %s kernel, kernel parameter %f and regularization parameter %f. \n\nIts average kcv classification error is %2.2f%% \n\nAND REMEMBER: if you like it submit your solution!!', YOURNAME, KERNEL, KERNEL_PARAMETER,T,errval*100); 
    msgbox(s,  'Now you have learned!');
end
