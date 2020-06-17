function [] = demo_lab3()
    %% Import the libraries
    addpath('./spectral_reg_toolbox/');
    
    %% This part will load the datasets
    load('challenge_datasets/three_train.mat');
    load('challenge_datasets/eight_train.mat');
    load('challenge_datasets/zero_train.mat');
    
    %% They will be used for all the training stuffs    
    X = double([three_train;eight_train;zero_train]);
    
    %% Trivial part
    YOURNAME = 'GG'; % example: 'john_smith' and pay attention to the underscore
    
    %% Now, see 'help kcv' for the parameters choice
    FILT = 'land' ; % example: 'tsvd'; see 'help kcv'
    N_SPLIT =  5 ; % example: 5; see 'help kcv'
    SPLIT_TYPE =  'seq' ; % example: 'seq' ; see 'help kcv'
    T_RANGE = 100; %linspace(0, 1, 3) ; % example: logspace(-3, 0, 7); see 'help kcv'

    %% Now, see 'help kernel' for the kernel choice
    KERNEL = 'gauss' ; % see 'help kernel'
    KERNEL_PARAMETER = 0.1 ; %fix it manually or by using 'autosigma.m' for example with autosigma(X,5). see 'help kernel' 'help kcv' and 'help autosigma'
    
    %% perform the 1 vs. all procedure
    for i = 1:3
        MASK = -ones(3,1);
        MASK(i) = 1;
        Y = [MASK(1)*ones(300,1); MASK(2)*ones(300,1); MASK(3)*ones(300,1)];
        %% Perform the k-fold cross validation
        [t_kcv_idx, avg_err_kcv] = kcv(KERNEL, KERNEL_PARAMETER, FILT, T_RANGE, X, Y, N_SPLIT, 'class', SPLIT_TYPE);
        
        if (strcmp(FILT,'nu') + strcmp(FILT,'land'))
            t(i) = t_kcv_idx;
        else
            if isscalar(T_RANGE)
                t(i) = t_kcv_idx;
            else
                t(i) = T_RANGE(t_kcv_idx);
            end
        end
        errval(i) = avg_err_kcv(t_kcv_idx);
    end
    
    %% now saving all your parameters
    save_challenge_lab2(YOURNAME, t, KERNEL, KERNEL_PARAMETER, errval,FILT);
end
