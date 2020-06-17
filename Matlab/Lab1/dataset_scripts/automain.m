%kernel type
kernelType = 'gauss';
%list of parameters of the kernel
kParList = [0.01, 0.5, 1, 2];
%range of regularization parameters. higher parameters lead to higher
%regularization
range = logspace(-7, 7, 30);
%number of training points
NTrainPoints = 50;
%noise on the labels
noise = 0.1;
%algorithm used
algo = 'rls';
%type of dataset
dataset = 'SINUSOIDAL';

%the dataset is created and centered
[XTrain, YTrain] = create_dataset(NTrainPoints, dataset, noise, 0.2);
[XTest, YTest] = create_dataset(1000, dataset, noise, 0.2);
center = mean(XTrain);
XTrain = XTrain - repmat(center, size(XTrain, 1), 1);
XTest = XTest - repmat(center, size(XTest, 1), 1);

%for each kernel parameters we train a classifier for all possible
%regularizations parameter and we compute and plot the error on the
%training set, test set and the error estimated by a 10 fold KCV
%The classifier with the smallest kcv error is plotted.
for kPar=kParList
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
    [idx, kcverr] = kcv(kernelType, kPar, algo, range, XTrain, YTrain, 10, 'class', 'seq');
    toc

    disp('Selected regularization parameter:')
    idx
    figtitle = strcat('Kernel parameter', num2str(kPar));
    figure,
    %the classifier selected by the KCV is shown
    hold on
    plot(cell2mat( trainErr), 'b-')
    plot(testError, 'r-')
    plot(kcverr, 'g-')
    title(figtitle);
    legend('Train Error', 'Test Error', 'KCVErr')
    hold off
    figure, 
    title(figtitle);
    plot_estimator(alpha{idx}, XTrain, YTrain, XTest, YTest, kernelType, kPar);
end