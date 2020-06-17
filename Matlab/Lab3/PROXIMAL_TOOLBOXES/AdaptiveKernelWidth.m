function Width = AdaptiveKernelWidth(X,Opts)
%%%%%%%%%%%%%%%%      USAGE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function
%          = AdaptiveGaussKernelWidth(X,Opts)
%
% calculate a statistics of  K nearest neighbor distance of n D-dimensional
% points
%
%INPUT
% X                   = is an n x D data matrix
% Opts.K              = K of the K-NN
% Opts.StatType       = 'Mean', 'Min', 'Max'
% Opts.Distance Type  = 'Euclidean', 'Manhattan' or  Matrix of Distances
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Compute and sort distances among points

if(Opts.Distance=='Euclidean');    DistanceMatrix=EuclideanDistance(X,X);
elseif(Opts.Distance=='Manhattan'); DistanceMatrix=L1Distance(X,X);
elseif size(Opts.Distances)==[n,n]; DistanceMatrix=Opts.Distances;
else
    error('Unknown distance function!')
end
SortedDistances=sort(DistanceMatrix,2);



KNNDistances=SortedDistances(:,Opts.KNN+1);
KNN.mean=mean(KNNDistances);
KNN.min=min(KNNDistances);
KNN.max=max(KNNDistances);
KNN.median=median(KNNDistances);

% Select only K neighbors and compute statistics
% KSortedDistances=SortedDistances(2:(Opts.KNN+1),:);

if(strcmp(Opts.StatType,'Mean'))
    Width=KNN.mean;
    S=mean(SortedDistances(:,2:size(SortedDistances,2)));
elseif(strcmp(Opts.StatType,'Min'))
    Width=KNN.min;
    S=min(SortedDistances(:,2:size(SortedDistances,2)));
elseif(strcmp(Opts.StatType,'Max'))
    Width=KNN.max;
    S=max(SortedDistances(:,2:size(SortedDistances,2)));
elseif(strcmp(Opts.StatType,'Median'))
    Width=KNN.median;
    S=median(SortedDistances(:,2:size(SortedDistances,2)));
end


if (Opts.PlotDist==1)
    name= [ Opts.StatType ];
    figure(12);
    subplot(2,1,1);
    imagesc(SortedDistances(:,2:size(SortedDistances,2)));title('Sorted Distances');
    subplot(2,1,2); plot(S); hold on;
    plot(Width*ones());
    title(name);
end
if(Opts.verbose==1);
    fprintf(' \n ');
    fprintf('\t Distance Statistics \n ');
    fprintf('Mean Distance=%f \n ', KNN.mean);
    fprintf('Min Distance=%f \n ', KNN.min);
    fprintf('Max Distance=%f \n ', KNN.max);
    fprintf('Median Distance=%f \n ', KNN.median);
    fprintf('Kernel Width =%f \n ', Width);
end;



