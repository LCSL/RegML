function [x, y, xt, yt] = load_dataset(path)
%Load a dataset saved with the function save_dataset.
%   INPUT 
%       path     path of the saved file
%  OUTPUT
%   x train data matrix with a sample for each row 
%   y vector with the labels of the training set
%   xt test data matrix with a sample for each row 
%   yt vector with the labels of the test set
filevariables = {'x', 'y', 'xt', 'yt'};
load(path, filevariables{:});

 
