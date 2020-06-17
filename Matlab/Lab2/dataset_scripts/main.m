%SET INPUT PARAMETERS
kPar = [];
range = [];
NTrainPoints = input('Number of training samples  ') ;
noise = input('Noise. It must be >= 0 && < 0.5  ');
kernelType = input('Kernelt type: it must be one from lin pol gauss  ');

if not(strcmp(kernelType, 'lin'))
    kPar = input('kernel parameter  ');
end
algo = input('Filter: it must be one from rls tsvd cutoff nu land  ');

if or(strcmp(algo, 'land'), strcmp(algo, 'nu')) 
    range = input('Regularization parameter  ');
else
    range = input('Range in log scale: [first,end,nsample]  The parameters will be a vector of nsample logarithmically spaced points between decades 10^first and 10^end ');
    range = logspace (range(1), range(2), range(3));
end

dataset = input('Dataset tyep: it must be one of MOONS LINEAR GAUSSIANS SINUSOIDAL SPIRAL    ');

%the dataset is generated
[XTrain, YTrain] = create_dataset(NTrainPoints, dataset, noise, 'PRESET');
[XTest, YTest] = create_dataset(1000, dataset, noise, 'PRESET');

%the dataset is centered w.r.t. the center of mass of the training set
center = mean(XTrain);
XTrain = XTrain - repmat(center, size(XTrain, 1), 1);
XTest = XTest - repmat(center, size(XTest, 1), 1);

%all the classifiers with wit the parameters in the rage are generated
disp('Training all classifiers in the range');
tic
[alpha trainErr]= learn(kernelType, kPar, algo, range, XTrain, YTrain, 'class');
toc
%all the classifiers with with the parameters in the rage are used with the
%test set and their errors are stored
[tmp testError] = classify(alpha, kernelType, kPar,XTrain, XTest, YTest);

%KCV is used to select the best parameter in the range
disp('Starting 5 folds KCV');
tic
[idx, kcverr] = kcv(kernelType, kPar, algo, range, XTrain, YTrain, 5, 'class', 'seq');
toc

disp('Selected regularization parameter:')
if or(strcmp(algo, 'land'), strcmp(algo, 'nu')) 
    idx
else
    range(idx)    
end

%the classifier selected by the KCV is shown
hold on
plot(cell2mat( trainErr), 'b-')
plot(testError, 'r-')
plot(kcverr, 'g-')
legend('Train Error', 'Test Error', 'KCVErr')
hold off
figure, 
plot_estimator(alpha{idx}, XTrain, YTrain, XTest, YTest, kernelType, kPar);