function [] = demo_multiclass()
    % this part will load the dataset
    load('challenge_datasets/three_tr.mat');
    load('challenge_datasets/eight_tr.mat');
    load('challenge_datasets/zero_tr.mat');
    
    %% They will be used for all the training stuffs    
    X = double([three_tr;eight_tr;zero_tr])/255.0;
    
    %% Trivial part
    YOURNAME = '...'; % example: 'john_smith' and pay attention to the underscore
    
    
    
    %% Now, see 'help kcv' for the parameters choice
    FILT = '...' ; % example: 'tsvd'; see 'help kcv'
    N_SPLIT =  '...' ; % example: 5; see 'help kcv'
    SPLIT_TYPE =  '...' ; % example: 'seq' ; see 'help kcv'
    T_RANGE = '...' ; % example: logspace(-3, 3, 7); see 'help kcv'
    
    %% Now, see 'help kernel' for the kernel choice
    KERNEL = '...' ; % see 'help kernel'
    KERNEL_PARAMETER = '...' ; %fix it manually or by using 'autosigma.m' for example with autosigma(TRAIN,5). see 'help kernel' 'help kcv' and 'help autosigma'
    
    %% perform the 1 vs. all procedure
    for i = 1:3
        MASK = -ones(3,1);
        MASK(i) = 1;
        Y = [MASK(1)*ones(300,1); MASK(2)*ones(300,1); MASK(3)*ones(300,1)];
        %% Perform the k-fold cross validation
        [t_kcv_idx, avg_err_kcv] = kcv(KERNEL, KERNEL_PARAMETER, FILT, T_RANGE, X, Y, N_SPLIT, 'class', SPLIT_TYPE);
        
        t(i) = T_RANGE(t_kcv_idx);
        errval(i) = avg_err_kcv(t_kcv_idx);
    end


    
    %% now saving all your parameters
    save_challenge_2(YOURNAME, t, KERNEL, KERNEL_PARAMETER, errval,FILT);
end