function demo_lab1()
    addpath('./spectral_reg_toolbox')

    % this part will load the dataset
    load('../../data/one_train.mat'); %load the matrix one_tr
    load('../../data/seven_train.mat'); %load the matrix seven_tr

    TRAIN = double([one_train; seven_train]);
    LABEL = [ones(300,1); -ones(300,1)];


    %Trivial Part
    YOURNAME = ... ; % eg. 'john_smith' pay attention to the underscore

    %Challenging Part
    N_SPLIT = ...    ; % eg. 5     see 'help kcv'
    SPLIT_TYPE =  ... ; % eg. 'seq' see 'help kcv'
    KERNEL = ...     ; % eg. 'lin' see 'help kernel'
    KERNEL_PARAMETER = ... ; %fix it manually or by autosigma for example with autosigma(TRAIN,5). see 'help kernel' 'help kcv' and 'help autosigma'
    TRANGE =  ....   ; % eg. logspace(-3, 3, 7);


    [t_kcv_idx, avg_err_kcv] = kcv(KERNEL, KERNEL_PARAMETER, 'rls', TRANGE, TRAIN, LABEL, N_SPLIT, 'class', SPLIT_TYPE);
    save_challenge_lab2(YOURNAME, TRANGE(t_kcv_idx), KERNEL, KERNEL_PARAMETER, avg_err_kcv(t_kcv_idx));
end
