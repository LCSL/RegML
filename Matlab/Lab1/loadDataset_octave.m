% ___ MODIFY HERE ___
%
%
% CHOOSE IF YOU WANT TO WORK ON A SIMULATION DATASET OR LOAD A REAL ONE
%--- simulation_or_real options are 'Simulation', 'Real'
simulation_or_real = 'Simulation';
%-------------------------------------------------------------------------------------------------------------------
%
%
% IF YOU CHOSE SIMULATION
%--- simulation_name options are 'Toy', 'Moons', 'Gaussians', 'Linear', 'Sinusoidal', 'Spiral'
simulation_name = 'Linear';
%--- n is the number of training samples
n = 100;
%--- nt is the number of test samples
nt = 1000;
%--- p is the ratio of wrong labels, CHOOSE A VALUE BETWEEN 0 and 1
p = 0;
%-------------------------------------------------------------------------------------------------------------------
%
%
% IF YOU CHOSE REAL
%--- filename: write the name of the file you want to load (be sure to have the file in the same path of this script)
filename = 'name of the file to load';
%
% ___ END MODIFY ___
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% FROM HERE DO NOT MODIFY THE DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


addpath('./');
addpath('../../data');
addpath('./dataGeneration');
addpath('./dataset_scripts');
addpath('./example_datasets');
addpath('./spectral_reg_toolbox');

if strcmp(simulation_or_real, 'Simulation') % simulation_or_real == 'Simulation'
    [X, Y, Xt, Yt] = loadDataset(simulation_name,n, nt, p);
else % simulation_or_real == 'Real'
    fprintf('loading file %s\n', filename);
    stru = whos('-file', filename, 'x', 'y', 'xt', 'yt');
    if(size(stru, 1)~=4)
        error('Loaded data not in the right format');
    end
    temp = load(filename);
    X = temp.x;
    y = temp.y;
    Xt = temp.xt;
    yt = temp.yt;
end

% PLOT TRAIN AND TEST SET
figure;
title('Training set');
hold on
plot(X(Y > 0, 1), X(Y > 0, 2), 'r*')
hold on
plot(X(Y < 0, 1), X(Y < 0, 2), 'b*')

figure;
title('Test set');
hold on
plot(Xt(Yt > 0, 1), Xt(Yt > 0, 2), 'r*')
hold on
plot(Xt(Yt < 0, 1), Xt(Yt < 0, 2), 'b*')
