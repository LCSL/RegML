% ___ MODIFY HERE ___
%
%
% CHOOSE IF YOU WANT TO WORK ON A SIMULATION DATASET OR LOAD A REAL ONE
%--- simulation_or_real options are 'Simulation', 'Real'
simulation_or_real = 'Simulation';
%
%-------------------------------------------------------------------------------------------------------------------%
% IF YOU CHOSE SIMULATION
%--- n is the number of training and test samples
n = 100;
%--- dim is the dimensionality of your data
dim = 10;
%--- n_rlf is the number of relevant features
n_rlf = 4;
%--- p is the ratio of wrong labels, CHOOSE A VALUE BETWEEN 0 and 1
p = 0;
%
%-------------------------------------------------------------------------------------------------------------------
% IF YOU CHOSE REAL
%--- filename: write the name of the file you want to load (be sure to have the file in the same path of this script)
filename = 'name of the file to load';
%
%-------------------------------------------------------------------------------------------------------------------
%
% ___ END MODIFY ___
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% FROM HERE DO NOT MODIFY THE DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




addpath('./');
addpath('./demo_scripts/Utilities');
addpath('./demo_scripts');
addpath('./gui');
addpath('./PROXIMAL_TOOLBOXES');
addpath('./PROXIMAL_TOOLBOXES/L1L2_TOOLBOX');
addpath('./PROXIMAL_TOOLBOXES/utilities');

if strcmp(simulation_or_real, 'Simulation') % simulation_or_real == 'Simulation'
    [X, Y] = create_training_set(n,dim,n_rlf,p);
    [Xt, Yt] = create_training_set(n,dim,n_rlf,p);
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
