function save_challenge_2(YOURNAME, T, KERNEL, KERNEL_PARAMETER, errval,FILT)
    model = {};
    model{1} =  YOURNAME;
    model{2} = T;
    model{3} = KERNEL;
    model{4} = KERNEL_PARAMETER;
    model{5} = errval;
    model{6} = FILT;
    save(YOURNAME, 'model');
    s = '';
    for i=1:3,
        s = [s sprintf('%s you learned with success!\n\nyour learned model uses %s filter, %s kernel, kernel parameter %f and regularization parameters %f. \n\n Its average kcv classification error is %2.2f%% \n\n AND REMEMBER: if you like it submit your solution!!\n\n', YOURNAME, FILT, KERNEL, KERNEL_PARAMETER,T(i),errval(i)*100)]; 
    end
    msgbox(s,  'Now you have done!')
end