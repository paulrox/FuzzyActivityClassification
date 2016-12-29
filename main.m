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

% plot(data{1,1}(:,4),data{1,1}(:,1));
% hold on;
% plot(data{2,1}(:,4),data{2,1}(:,1));
% plot(data{3,1}(:,4),data{3,1}(:,1));
% plot(data{4,1}(:,4),data{4,1}(:,1));
% hold off;

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

%% Features extraction (Time Domain)
% ---- Variance ----

global features_raw;

features_raw = cell(8,1);

feat_variance = cell(3,3);

for k=1:3
    for i=1:3
        for j=1:20*2^k
            feat_variance{k,i} = [feat_variance{k,i} var(sensor{k,i}(:,j))];
        end;
    end;
end;

features_raw{1} = feat_variance;

% ---- Mean Value ----

feat_mean = cell(3,3);

for k=1:3
    for i=1:3
        for j=1:20*2^k
            feat_mean{k,i} = [feat_mean{k,i} mean(sensor{k,i}(:,j))];
        end;
    end;
end;

features_raw{2} = feat_mean;

% ---- Standard Deviation ----

feat_std = cell(3,3);

for k=1:3
    for i=1:3
        for j=1:20*2^k
            feat_std{k,i} = [feat_std{k,i} std(sensor{k,i}(:,j))];
        end;
    end;
end;

features_raw{3} = feat_std;

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

features_raw{4} = feat_midcross;

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

features_raw{5} = feat_dtw;

%% Features extraction (Frequency Domain)

% Sampling frequency
Fs = 1 / 0.082;

% ----Bandwidth----

feat_band = extract_bandwidth(sensor,Fs);
features_raw{6} = feat_band;

% ----Max Peak Frequency----
% Find the frequency which corresponds to the max peak in the frequency
% domain.

feat_maxpeak = extract_fmaxpeak(sensor,Fs);
features_raw{7} = feat_maxpeak;

% ----Average Power ----
% Average power of the signals.

feat_pow = extract_bandpower(sensor);
features_raw{8} = feat_pow;

% ----Peaks distance----
% Find the average distance between peaks in the signal..

feat_peakdist = extract_averagedistance_peaks(sensor,Fs);
features_raw{9} = feat_peakdist;

%% Features Normalization

global features;

features = features_raw;

for i=1:9
    for k=1:3
        for j=1:3
            feat_m =  mean(features_raw{i}{k,j});
            feat_std = std(features_raw{i}{k,j});
            features{i}{k,j} = (features_raw{i}{k,j}-feat_m)/feat_std;
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
% pat_net = cell(3,1);
% 
% for k=1:3
%     pat_net{k} = patternnet(10);
%     pat_net{k}.divideParam.trainRatio = 70/100;
%     pat_net{k}.divideParam.valRatio = 15/100;
%     pat_net{k}.divideParam.testRatio = 15/100;
% 
%     net_in = cell(1,3);
% 
%     net_in{1} = [features{1}{k,1};
%                 features{2}{k,1};
%                 features{3}{k,1}
%                 features{4}{k,1}];
%     net_in{2} = [features{1}{k,2};
%                 features{2}{k,2};
%                 features{3}{k,2}
%                 features{4}{k,2}];
%     net_in{3} = [features{1}{k,3};
%                 features{2}{k,3};
%                 features{3}{k,3}
%                 features{4}{k,3}];
%  
%     pat_net{k} = train(pat_net{k},net_in{3},pat_targets{k});
% 
% end;

%% We select 4 clusters from the dataset and we use them as features.

%[idx, clust_c] = kmeans(sensor1', 4);
%% Setup the GA for the features selection
% For the moment we consider just the sensor1 dataset. For this first try
% we consider the sensor output on a specific volunteer as a feature, so we
% want to find the best sensor outputs by selecting one for each possible
% activity. In other words, we will obtain the four indicies which
% represents the columns in the sensor dataset.

global pat_net;
global pat_nets;
global sens_num t_interval;
global history;

history = struct;
pat_nets = cell(3,3);

for i=1:3
    
    sens_num = i;
    t_interval = 1;

    pat_net = patternnet(10);
    pat_net.divideParam.trainRatio = 70/100;
    pat_net.divideParam.valRatio = 15/100;
    pat_net.divideParam.testRatio = 15/100;

    fitnessFcn = @pattern_fitness;
    nvar = 98;
    options = gaoptimset;
    options = gaoptimset(options,'TolFun', 1e-8, 'Generations', 50, ...
    'SelectionFcn', @selectionroulette, ...
    'CrossoverFcn', @crossoversinglepoint, ...
    'MutationFcn', @mutationgaussian, ...
    'OutputFcn', @ga_output, ...
    'CreationFcn', @gacreationlinearfeasible, ...
    'PlotFcns', @gaplotbestf);

    % Linear inequalities, necessary to avoid solutions with the same
    % feature more than one time.
    A = [1 -1 0 0 zeros(1,94);
         0 1 -1 0 zeros(1,94);
         0 0 1 -1 zeros(1,94)];
    b = [-1; -1; -1];

    [x, fval] = ga(fitnessFcn, nvar, A, b, [], [], [1; 1; 1; 1; ...
        -Inf*ones(94,1)], [9; 9; 9; 9; Inf*ones(94,1)], [], [1 2 3 4], ...
        options);
    
    pat_nets{i,1} = pat_net;
    pat_nets{i,1} = setwb(pat_nets{i,1}, x(5:98));
    pat_nets{i,2} = history;
    pat_nets{i,3} = x(1:4);
    
end;

%% Choose the best sensor.
% We evaluate the patternet performances using the confusion matrix and we
% choose the sensor by which we obtain the best value.

pat_confusion = zeros(1,3);

for i=1:3
    net_in = [features{pat_nets{i,3}(1)}{t_interval,i};
              features{pat_nets{i,3}(2)}{t_interval,i};
              features{pat_nets{i,3}(3)}{t_interval,i};
              features{pat_nets{i,3}(4)}{t_interval,i}];
    net_out = pat_nets{i,1}(net_in);
    pat_confusion(i) = confusion(pat_targets{t_interval},net_out);
end;

best_sensor = find(pat_confusion==min(pat_confusion));

%% Select the features obtained from the GA for the best sensor.

best_feat = pat_nets{best_sensor,3};
selected_tmp = cell(3,1);

for i=1:9
    selected_tmp{1} = [selected_tmp{1} features{i}{1,best_sensor}'];
    selected_tmp{2} = [selected_tmp{2} features{i}{2,best_sensor}'];
    selected_tmp{3} = [selected_tmp{3} features{i}{3,best_sensor}'];
end;

selected_features = cell(3,1);

selected_features{1} = selected_tmp{1}(:,best_feat);
selected_features{2} = selected_tmp{2}(:,best_feat);
selected_features{3} = selected_tmp{3}(:,best_feat);

%% ******* One-against-all Classifiers *******

%% ------- Sugeno-type Inference System -------
%
% Prepare Data for ANFIS.
%
% Checking data - 15% of the total features set. The checking dataset is
% extracted from:
% Activity 1, Volunteer 1
% Activity 2, Volunteer 2
% Activity 3, Volunteer 4
% Activity 4, Volunteer 8
% Activity 1, Volunteer 7
% Activity 2, Volunteer 10
%
% Testing Data - 15% of the total features set. The testing dataset is
% extracted from:
% Activity 1, Volunteer 9
% Activity 2, Volunteer 5
% Activity 3, Volunteer 10
% Activity 4, Volunteer 2
% Activity 3, Volunteer 7
% Activity 4, Volunteer 1

anfis_train = cell(3,5);
anfis_check = cell(3,5);
anfis_test = cell(3,5);

%Indicies of the checking dataset.
checking_indicies = cell(3,1);
checking_indicies{1} = [1 7 12 20 24 38];
checking_indicies{2} = sort([checking_indicies{1}*2 ...
    (checking_indicies{1}*2)-1]);
checking_indicies{3} = sort([checking_indicies{1}*4 ...
    (checking_indicies{1}*4)-1 (checking_indicies{1}*4)-2 ...
    (checking_indicies{1}*4)-3]);

%Indicies of the testing dataset.
testing_indicies = cell(3,1);
testing_indicies{1} = [9 15 27 30 31 32];
testing_indicies{2} = sort([testing_indicies{1}*2 ...
    (testing_indicies{1}*2)-1]);
testing_indicies{3} = sort([testing_indicies{1}*4 ...
    (testing_indicies{1}*4)-1 (testing_indicies{1}*4)-2 ...
    (testing_indicies{1}*4)-3]);

%Indicies of the training dataset.
training_indicies = cell(3,1);
training_indicies{1} = setdiff(setdiff((1:40),checking_indicies{1}), ...
    testing_indicies{1});
training_indicies{2} = setdiff(setdiff((1:80),checking_indicies{2}), ...
    testing_indicies{2});
training_indicies{3} = setdiff(setdiff((1:160),checking_indicies{3}), ...
    testing_indicies{3});

% Extract the checking, testing and training datasets from the features
% set.
% i: time interval.
for i=1:3
    % j: activity to be compared.
    for j=1:4
        anfis_check{i,j} = [selected_features{i}(checking_indicies{i},:) ...
            pat_targets{i}(j,checking_indicies{i})'];
        anfis_test{i,j} = [selected_features{i}(testing_indicies{i},:) ...
            pat_targets{i}(j,testing_indicies{i})'];
        anfis_train{i,j} = [selected_features{i}(training_indicies{i},:) ...
            pat_targets{i}(j,training_indicies{i})'];
    end;
end;

%% Generate FIS structures and train them using ANFIS.

sugeno_fis = cell(5,2);

trnOpt = [20 0 0.01 0.9 1.1];
dispOpt = [NaN NaN NaN NaN];


for i=1:4
    sugeno_fis{i,2} = struct('error',[],'stepsize',[],'chkFis',[],...
        'chkErr',[]);
    sugeno_fis{i,1} = genfis2(anfis_train{1,i}(:,1:4), ...
        anfis_train{1,i}(:,5),0.5);
    [sugeno_fis{i,1},sugeno_fis{i,2}.error,sugeno_fis{i,2}.stepsize,...
        sugeno_fis{i,2}.chkFis,sugeno_fis{i,2}.chkErr] = ...
        anfis(anfis_train{1,i},sugeno_fis{i,1},trnOpt,dispOpt, ...
        anfis_check{1,i});
end;

%% ******* Four-Class Classifier *******

%% ------- Sugeno-type Inference System -------
%
% The FIS targets are coded as integer number in this way:
% - 1: Supine Position;
% - 2: Walking;
% - 3: Dorsiflexion Standing;
% - 4: Stairs Climbing.
%
% The datasets are organized as in the All-Against-One classifiers, so we
% can reuse them.

all_targets = cell(3,1);

all_targets{1} = [ones(1,10), 2*ones(1,10), 3*ones(1,10), 4*ones(1,10)]';
all_targets{2} = [ones(1,20), 2*ones(1,20), 3*ones(1,20), 4*ones(1,20)]';
all_targets{3} = [ones(1,40), 2*ones(1,40), 3*ones(1,40), 4*ones(1,40)]';


for i=1:3
    % j: activity to be compared.
        anfis_check{i,5} = [selected_features{i}(checking_indicies{i},:) ...
            all_targets{i}(checking_indicies{i}')];
        anfis_test{i,5} = [selected_features{i}(testing_indicies{i},:) ...
            all_targets{i}(testing_indicies{i}')];
        anfis_train{i,5} = [selected_features{i}(training_indicies{i},:) ...
            all_targets{i}(training_indicies{i}')];
end;

trnOpt = [30 0 0.01 0.9 1.1];
dispOpt = [NaN NaN NaN NaN];

sugeno_fis{5,2} = struct('error',[],'stepsize',[],'chkFis',[],...
        'chkErr',[]);
sugeno_fis{5,1} = genfis2(anfis_train{1,5}(:,1:4), ... 
   anfis_train{1,5}(:,5),0.5);
% sugeno_fis{5,1} = genfis3(anfis_train{1,5}(:,1:4), ... 
%     anfis_train{1,5}(:,5),'sugeno');
[sugeno_fis{5,1},sugeno_fis{5,2}.error,sugeno_fis{5,2}.stepsize,...
    sugeno_fis{5,2}.chkFis,sugeno_fis{5,2}.chkErr] = ...
    anfis(anfis_train{1,5},sugeno_fis{5,1},trnOpt,dispOpt, ...
    anfis_check{1,5});
