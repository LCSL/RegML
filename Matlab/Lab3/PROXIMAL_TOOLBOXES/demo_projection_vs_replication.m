% evaluates running time and number of iterations necessary for computing 
% the regularizton path of GLO-prima-dual and GL-prox with replicates

clear all
close all
addpath(genpath('../PROXIMAL_TOOLBOXES'))


%% DATA AND BLOCKS GENERATION
deff = 3;   % number of relevant variables not settable!!!
type = 'regr';
dd = 5000;
db = 100;
overlap = 5;
s2n = 5;

% generate blocks
B = round((dd.*overlap)./db);
blocks = cell(B,1);
% the first 3 blocks are sequential with 20% pairwise overlap
blocks{1} = 1:db;
blocks{2} = (floor(4*db/5)+1):(db+floor(4*db/5));
blocks{3} = [1:floor(db/5) (2*db - floor(2*db/5)+1):(3*db-floor(3*db/5))];
for i = 4:B;
    I = randperm(dd);
    blocks{i} = I(1:db);
end
% add left out varaibles to last block
blocks{i} = union(blocks{i},find(~ismember(1:dd,unique(cell2mat(blocks')))));

% build coefficient vector s.t. the relevant variables are those in the first
% 3 blocks
beta = zeros(dd,1);
beta(union(union(blocks{1},blocks{2}),blocks{3})) = 1;
drel = sum(beta~=0);

% create data set
n = 10*drel;
[X,Y]=create_training_set(n,beta,0,'regr');
sigma_y = std(Y);
Y = Y.*(s2n/sigma_y) + randn(n,1);    

%% PARAMETERS SETTING
% determines optimal range of parameter tau by running
% glo_regpath with high tolerance on a large set of taus. 
% Then find taus s. t. the # of seledted variables is in (0,n)
fprintf('\nDetermining correct parameters range\n')
ntau = 50;
tau_max = norm(X'*Y)/n*10;
tau_min = tau_max/(n*10);
ntau0 = 100;
tau_values = [tau_min tau_min*((tau_max/tau_min)^(1/(ntau0-1))).^(1:(ntau0-1))];
[selected] = glopridu2_regpath(X,Y,blocks,tau_values,'tol_ext',1e-3);
sparsity = sum(selected,1);
clear selected
tmin = find(sparsity>=min((n*.5),dd),1,'last');
tmax = find(sparsity==0,1,'first');
if isempty(tmin); tmin = 1; end
if isempty(tmax); tmax = ntau0; end                
tau_min = tau_values(tmin);
tau_max = tau_values(tmax);
tau_values = [tau_min tau_min*((tau_max/tau_min)^(1/(ntau-1))).^(1:(ntau-1))];

%% GLO-primal-dual
fprintf('\nEvaluating GLO regularization path\n')
tic
[selected,n_iter_glo] = glopridu2_regpath(X,Y,blocks,tau_values);
clear selected 
time_glo = toc;
fprintf('\trunning time = %f\n',time_glo);
fprintf('\tnumber of iterations = %f\n',n_iter_glo);

% GL-prox on duplicated variables
% builds data set with duplicated variables
blocks_rep = cell(length(blocks),1);
Xrep = zeros(n,db*B);
c = 1;
for i_b = 1:length(blocks);
    dtmp = size(Xrep,2);
    blocks_rep{i_b} = c:(c+length(blocks{i_b})-1);
    Xrep(:,blocks_rep{i_b}) = X(:,blocks{i_b});
    c = c+length(blocks{i_b});
end
%% GL-prox
fprintf('\nEvaluating Replicated-Group-Lasso regularization path\n')
tic
[selected,sparsity,n_iter_rep] = grl_regpath(Xrep, Y, blocks_rep, tau_values);
clear selected sparsity
time_rep = toc;
clear Xrep blocks_rep
fprintf('\trunning time = %f\n',time_rep);
fprintf('\tnumber of iterations = %f\n',n_iter_rep);
