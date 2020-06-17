function [] = plot_estimator(alpha, xTrain, yTrain, xTest, yTest, ker, par)
%Plot a classifier and its train and test samples
%   [] = plot_estimator(alpha, xTrain, yTrain, xTest, yTest, ker, par)
%   INPUT 
%       alpha        classifier solution
%       xTrain       train samples
%       yTrain       labels of the train samples
%       xTest        test samples
%       yTest        labels of the test samples
%       ker          kernel of the classifier
%       par          parameters of the kernel
d=100;
X1=double(linspace(min([xTrain(:, 1); xTest(:, 1)]), max([xTrain(:, 1); xTest(:, 1)]), d));
X2=double(linspace(min([xTrain(:, 2); xTest(:, 2)]), max(max([xTrain(:, 2); xTest(:, 2)])), d));

Z = zeros(size(X1,2), size(X2, 2));
for i=1:size(X1, 2)
    for j=1:size(X2, 2)
        x_test=[[X1(i), X2(j)]];
        alphac = cell(1);
        alphac{1} = alpha;
        [pred] = classify(alphac, ker, par, xTrain, x_test);
        Z(j,i)= pred{1};
    end
end
hold on
plot(xTest(yTest >= 0, 1) , xTest(yTest >= 0, 2), '.b');
plot(xTest(yTest < 0, 1), xTest(yTest < 0, 2)  , '.r');

plot(xTrain(yTrain >= 0, 1) , xTrain(yTrain >= 0, 2), 'ob');
plot(xTrain(yTrain < 0, 1), xTrain(yTrain < 0, 2)  , 'or');
legend('Positive test samples', 'Negative test samples','Positive train samples', 'Negative train samples')
contour(X1,X2,Z,[0 0]);
hold off
