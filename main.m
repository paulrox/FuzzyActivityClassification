%% Computational Intelligence Project 2016 -
%  Main script file.
%
%  authors: Paolo Sassi - Matteo Rotundo
%
% Clear the workspace and close all the windows.
clearvars;
close all;
% Load the dataset
load('data.mat');

%% We make a preliminary check on the data by drawing some plots.

% At first we plot the different activities by the first sensor on the
% first volunteer.

plot(data{1,1}(:,4),data{1,1}(:,1));
hold on;
plot(data{2,1}(:,4),data{2,1}(:,1));
plot(data{3,1}(:,4),data{3,1}(:,1));
plot(data{4,1}(:,4),data{4,1}(:,1));
hold off;

%% Separate Data (each sensor is considered as an indipendent dataset)
% We divide the data by putting each sensor output for each volunteer in a
% different matrix, and we get rid of the time column.

global sensor;
global timestamps;

sensor = cell(1,3);
timestamps = cell(4,10);

for i=1:4
    for j=1:10
        sensor{1} = [sensor{1} data{i,j}(:,1)];
        sensor{2} = [sensor{2} data{i,j}(:,2)];
        sensor{3} = [sensor{3} data{i,j}(:,3)];
        timestamps{i,j} = [timestamps{i,j} data{i,j}(:,4)];
    end;
end;

% The data has been stored ordering first the volunteer and then the
% activity.

%% Features extraction
% Variance

feat_variance = cell(1,3);

for i=1:3
    for j=1:40
        feat_variance{i} = [feat_variance{i} var(sensor{i}(:,j))];
    end;
end;


%% Build the target vectors for the sensors.
% The target vectors will be the same for all sensors. We have 4 possible
% activites, so each target vector will be a four elements vector in which
% just the element corresponding to the activity will be 1.
% The activity are ordered as:
% 1 - supine position;
% 2 - walking;
% 3 - dorsiflexion standing;
% 4 - stairs climbing.

global pat_targets;

pat_targets_old = [ones(1,10) zeros(1,10) zeros(1,10) zeros(1,10);
               zeros(1,10) ones(1,10) zeros(1,10) zeros(1,10);
               zeros(1,10) zeros(1,10) ones(1,10) zeros(1,10);
               zeros(1,10) zeros(1,10) zeros(1,10) ones(1,10)];
           
pat_targets = [ones(1,10) zeros(1,10) zeros(1,10) zeros(1,10);
               zeros(1,10) ones(1,10) zeros(1,10) zeros(1,10);
               zeros(1,10) zeros(1,10) ones(1,10) zeros(1,10);
               zeros(1,10) zeros(1,10) zeros(1,10) ones(1,10)];

           
%% We select 4 clusters from the dataset and we use them as features.

[idx, clust_c] = kmeans(sensor1', 4);
%% Setup the GA for the features selection
% For the moment we consider just the sensor1 dataset. For this first try
% we consider the sensor output on a specific volunteer as a feature, so we
% want to find the best sensor outputs by selecting one for each possible
% activity. In other words, we will obtain the four indicies which
% represents the columns in the sensor dataset.

global pat_net;

pat_net = patternnet(10);
pat_net.divideParam.trainRatio = 70/100;
pat_net.divideParam.valRatio = 15/100;
pat_net.divideParam.testRatio = 15/100;

fitnessFcn = @pattern_fitness;
nvar = 98;

options = gaoptimset;
options = gaoptimset(options,'TolFun', 1e-8, 'Generations', 300, ...
    'PlotFcns', @gaplotbestf);

[x, fval] = ga(fitnessFcn, nvar, [], [], [], [], [1; 1; 1; 1], ...
    [2000; 2000; 2000; 2000], [], [1 2 3 4], options);
