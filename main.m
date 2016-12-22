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

sensor = cell(3,3);
timestamps = cell(3,1);

% Time interval: 162 seconds.
for i=1:4
    for j=1:10
        sensor{1,1} = [sensor{1,1} data{i,j}(:,1)];
        sensor{1,2} = [sensor{1,2} data{i,j}(:,2)];
        sensor{1,3} = [sensor{1,3} data{i,j}(:,3)];
        timestamps{1} = [timestamps{1} data{i,j}(:,4)];
    end;
end;

% Time interval: 82 seconds.
for i=1:4
    for j=1:10
        sensor{2,1} = [sensor{2,1} data{i,j}(1:1000,1) ...
                       data{i,j}(1001:2000,1)];
        sensor{2,2} = [sensor{2,2} data{i,j}(1:1000,2) ...
                       data{i,j}(1001:2000,2)];
        sensor{2,3} = [sensor{2,3} data{i,j}(1:1000,3) ...
                       data{i,j}(1001:2000,3)];
        timestamps{2} = [timestamps{2} data{i,j}(1:1000,4) ...
                         data{i,j}(1001:2000,4)-data{i,j}(1001,4)];
    end;
end;

% Time interval: 41 seconds.
for i=1:4
    for j=1:10
        sensor{3,1} = [sensor{3,1} data{i,j}(1:500,1) ...
                       data{i,j}(501:1000,1) data{i,j}(1001:1500,1) ...
                       data{i,j}(1501:2000,1)];
        sensor{3,2} = [sensor{3,2} data{i,j}(1:500,2) ...
                       data{i,j}(501:1000,2) data{i,j}(1001:1500,2) ...
                       data{i,j}(1501:2000,2)];
        sensor{3,3} = [sensor{3,3} data{i,j}(1:500,3) ...
                       data{i,j}(501:1000,3) data{i,j}(1001:1500,3) ...
                       data{i,j}(1501:2000,3)];
        timestamps{3} = [timestamps{3} data{i,j}(1:500,4) ...
                         data{i,j}(501:1000,4)-data{i,j}(501,4) ...
                         data{i,j}(1001:1500,4)-data{i,j}(1001,4) ...
                         data{i,j}(1501:2000,4)-data{i,j}(1501,4)];
    end;
end;

% The data has been stored ordering first the volunteer and then the
% activity.

%% Features extraction
% ----Variance----

feat_variance = cell(3,3);

for k=1:3
    for i=1:3
        for j=1:20*2^k
            feat_variance{k,i} = [feat_variance{k,i} var(sensor{k,i}(:,j))];
        end;
    end;
end;

% ----Mean Value----

feat_mean = cell(3,3);

for k=1:3
    for i=1:3
        for j=1:20*2^k
            feat_mean{k,i} = [feat_mean{k,i} mean(sensor{k,i}(:,j))];
        end;
    end;
end;

% ----Mid-crossing----
% The function midcross stores the time instants in which the signals
% crosses the 50% reference level. We compute the difference of such time
% instants to discover the interval from a crossing to the next one.
% Finally we compute the variance on that intervals and we use that as
% feature.
% For the moment we skip the signals from the first activity of the first
% volunteer beacuse the timestamps are messed up.
feat_midcross = cell(3,3);

for k=1:3
    for i=1:3
        for j=1:20*2^k
            if (j==2^k)
                feat_midcross{k,i} = [feat_midcross{k,i} NaN];
            else
                feat_midcross{k,i} = [feat_midcross{k,i} ...
                    var(diff(midcross(sensor{k,i}(:,j), ...
                    timestamps{k}(:,j))))];
            end;
        end;
    end;
end;

% Replace NaNs with the mean value.

midcross_sub = cell(1,4);

% Compute the mean of the numeric values.
for k=1:3
    for i=1:3
        for j=1:4
            midcross_sub{j} = feat_midcross{k,i}((5*2^k)*(j-1)+1:(5*2^k)*j);
            notNaN = midcross_sub{j}(~isnan(midcross_sub{j}));
            notNaN_mean = mean(notNaN);
            midcross_sub{j}(isnan(midcross_sub{j})) = notNaN_mean;
            % Substitute all the NaNs with the mean value.
            feat_midcross{k,i}((5*2^k)*(j-1)+1:(5*2^k)*j) = midcross_sub{j};
        end;
    end;
end;

% ----Similarity of Signals patterns----
% In practice, we compare the first half of the signal with the second half
% and we take the distance between them.

feat_dtw = cell(3,3);

for k=1:3
    for i=1:3
        for j=1:20*2^k
            feat_dtw{k,i} = [feat_dtw{k,i} dtw(sensor{k,i}(1:1000/2^(k-1),j),...
                sensor{k,i}(1000/2^(k-1)+1:2000/2^(k-1),j))];
        end;
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

pat_targets = cell(3,1);

for k=1:3
    pat_targets{k} = [ones(1,5*2^k) zeros(1,5*2^k) zeros(1,5*2^k) ...
                      zeros(1,5*2^k);
                      zeros(1,5*2^k) ones(1,5*2^k) zeros(1,5*2^k) ...
                      zeros(1,5*2^k);
                      zeros(1,5*2^k) zeros(1,5*2^k) ones(1,5*2^k) ...
                      zeros(1,5*2^k);
                      zeros(1,5*2^k) zeros(1,5*2^k) zeros(1,5*2^k) ...
                      ones(1,5*2^k)];
end;


           
%% Just try to train a patternet.

global pat_net;

pat_net = cell(3,1);

for k=1:3
    pat_net{k} = patternnet(10);
    pat_net{k}.divideParam.trainRatio = 70/100;
    pat_net{k}.divideParam.valRatio = 15/100;
    pat_net{k}.divideParam.testRatio = 15/100;

    net_in = cell(1,3);

    net_in{1} = [feat_dtw{k,1};
                feat_midcross{k,1};
                feat_variance{k,1}
                feat_mean{k,1}];
    net_in{2} = [feat_dtw{k,2};
                feat_midcross{k,2};
                feat_variance{k,2}
                feat_mean{k,2}];
    net_in{3} = [feat_dtw{k,3};
                feat_midcross{k,3};
                feat_variance{k,3}
                feat_mean{k,3}];
 
    pat_net{k} = train(pat_net{k},net_in{3},pat_targets{k});

end;

%% We select 4 clusters from the dataset and we use them as features.

[idx, clust_c] = kmeans(sensor1', 4);
%% Setup the GA for the features selection
% For the moment we consider just the sensor1 dataset. For this first try
% we consider the sensor output on a specific volunteer as a feature, so we
% want to find the best sensor outputs by selecting one for each possible
% activity. In other words, we will obtain the four indicies which
% represents the columns in the sensor dataset.

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
