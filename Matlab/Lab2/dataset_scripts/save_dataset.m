function [] = save_dataset(path, x, y, xt, yt)
%Load a dataset saved with the function save_dataset.
%   INPUT 
%       path     path of the saved file
%   	x train data matrix with a sample for each row 
%   	y vector with the labels of the training set
%   	xt test data matrix with a sample for each row 
%   	yt vector with the labels of the test set
save(path,'x','y', 'xt', 'yt');
