%Plot a classifier and its train and test samples
%   plot_dataset(X, Y)
%   INPUT 
%       X   data of the set (a sample for each row)
%       Y   labels of the set
function plot_dataset(X, Y)
figure
hold on
plot(X(Y > 0, 1), X(Y > 0, 2), 'r*')
plot(X(Y < 0, 1), X(Y < 0, 2), 'b*')
hold off