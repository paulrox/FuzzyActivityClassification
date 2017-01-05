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

%% Separate Data (each sensor is considered as an indipendent dataset)
% We divide the data by putting each sensor output for each volunteer in a
% different matrix, and we get rid of the time column.

global timestamps;

sensor_raw = cell(3,3);
timestamps = cell(3,1);

% Time interval: 162 seconds.
for i=1:4
    for j=1:10
        sensor_raw{1,1} = [sensor_raw{1,1} data{i,j}(:,1)];
        sensor_raw{1,2} = [sensor_raw{1,2} data{i,j}(:,2)];
        sensor_raw{1,3} = [sensor_raw{1,3} data{i,j}(:,3)];
        timestamps{1} = [timestamps{1} data{i,j}(:,4)];
    end;
end;

% Time interval: 82 seconds.
for i=1:4
    for j=1:10
        sensor_raw{2,1} = [sensor_raw{2,1} data{i,j}(1:1000,1) ...
                       data{i,j}(1001:2000,1)];
        sensor_raw{2,2} = [sensor_raw{2,2} data{i,j}(1:1000,2) ...
                       data{i,j}(1001:2000,2)];
        sensor_raw{2,3} = [sensor_raw{2,3} data{i,j}(1:1000,3) ...
                       data{i,j}(1001:2000,3)];
        timestamps{2} = [timestamps{2} data{i,j}(1:1000,4) ...
                         data{i,j}(1001:2000,4)-data{i,j}(1001,4)];
    end;
end;

% Time interval: 41 seconds.
for i=1:4
    for j=1:10
        sensor_raw{3,1} = [sensor_raw{3,1} data{i,j}(1:500,1) ...
                       data{i,j}(501:1000,1) data{i,j}(1001:1500,1) ...
                       data{i,j}(1501:2000,1)];
        sensor_raw{3,2} = [sensor_raw{3,2} data{i,j}(1:500,2) ...
                       data{i,j}(501:1000,2) data{i,j}(1001:1500,2) ...
                       data{i,j}(1501:2000,2)];
        sensor_raw{3,3} = [sensor_raw{3,3} data{i,j}(1:500,3) ...
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

%% Separate Data (Considering the union of the sensors signals)
% The data is ordered by: Activity -> Sensor -> Volunteer

sensor_union_raw = cell(3,1);

% Time interval: 162 seconds.
for i=1:4
    for k=1:3
        for j=1:10
            sensor_union_raw{1} = [sensor_union_raw{1} data{i,j}(:,k)];
        end;
    end;
end;

% Time interval: 82 seconds.
for i=1:4
    for k=1:3
        for j=1:10
            sensor_union_raw{2} = [sensor_union_raw{2} ...
                data{i,j}(1:1000,k) data{i,j}(1001:2000,k)];
        end;
    end;
end;

% Time interval: 41 seconds.
for i=1:4
    for k=1:3
        for j=1:10
            sensor_union_raw{3,1} = [sensor_union_raw{3} ...
                data{i,j}(1:500,k) data{i,j}(501:1000,k) ...
                data{i,j}(1001:1500,k) data{i,j}(1501:2000,k)];
        end;
    end;
end;

%% Signal Filtering.

global sensor;
global sensor_union;

sensor = cell(3,3);
sensor_union = cell(3,1);
lpf = load('low_pass.mat');

for i = 1:3
    for j = 1:3
        for k = 1:20*(2^i)
            % sensor{i, j}(:,k) = detrend(sensor_raw{i, j}(:,k));
            sensor{i, j}(:,k) = filter(lpf.Hd,sensor_raw{i, j}(:,k));
            sensor{i, j}(:,k) = sensor{i, j}(:,k) - ...
                mean(sensor{i, j}(:,k));  
        end;
    end;
end;

for i=1:3
    for j=1:60*(2^i)
        sensor_union{i}(:,j) = filter(lpf.Hd,sensor_union_raw{i}(:,j));
        sensor_union{i}(:,j) = sensor_union{i}(:,j) - ...
            mean(sensor_union{i}(:,j));
    end;
end;


%% Features extraction (Time Domain)
% Time domain features:
% 1: Max value;
% 2: Min value;
% 3: Root-Mean-Square level (RMS);
% 4: Mean value;
% 5: Variance;
% 6: Standard deviation;
% 7: Peak to peak;
% 8: Peak to RMS; 
% 9: Mean of upper envelope;
% 10: Mean of lower envelope;
% 11: Similarity of signal patterns;
% 12: Sum of aplitudes below 25%;
% 13: Sum of amplitudes below 75%;
% 14: Root-Sum-of-Squares.

features_TD = extract_TD_features(sensor);
features_union_TD = extract_union_TD_features(sensor_union);

%% Features extraction (Frequency Domain)
% Frequency domain  features:
% 15: Sum of spectrum components;
% 16: Number of peak in spectrum;
% 17: Bandwidth;
% 18: Average peaks distances;
% 19: Average power;
% 20: Average distances in power density signal;
% 21: Average frequency of the 3 peaks with more amplitude;
% 22: Sum of amplitudes in power density.

% Sampling frequency
Fs = 1 / 0.082;

features_FD = extract_FD_features(sensor,Fs);
features_union_FD = extract_union_FD_features(sensor_union,Fs);

%% Features Normalization

global features;
global features_union;

features_raw = [features_TD'; features_FD'];
features_union_raw = [features_union_TD'; features_union_FD'];
features = cell(22,1);
features_union = cell(22,1);

for i=1:22
    for k=1:3
        for j=1:3
            feat_m =  mean(features_raw{i}{k,j});
            feat_std = std(features_raw{i}{k,j});
            features{i}{k,j} = (features_raw{i}{k,j}-feat_m)/feat_std;
        end;
        feat_union_m = mean(features_union_raw{i}{k});
        feat_union_std = std(features_union_raw{i}{k});
        features_union{i}{k} = (features_union_raw{i}{k}-feat_union_m)/ ...
            feat_union_std;
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
global pat_union_targets;

pat_targets = cell(3,1);
pat_union_targets = cell(3,1);

for k=1:3
    pat_targets{k} = [ones(1,5*2^k) zeros(1,5*2^k) zeros(1,5*2^k) ...
        zeros(1,5*2^k);
        zeros(1,5*2^k) ones(1,5*2^k) zeros(1,5*2^k) zeros(1,5*2^k);
        zeros(1,5*2^k) zeros(1,5*2^k) ones(1,5*2^k) zeros(1,5*2^k);
        zeros(1,5*2^k) zeros(1,5*2^k) zeros(1,5*2^k) ones(1,5*2^k)];
    pat_union_targets{k} = [ones(1,15*2^k) zeros(1,15*2^k) ...
        zeros(1,15*2^k) zeros(1,15*2^k);
        zeros(1,15*2^k) ones(1,15*2^k) zeros(1,15*2^k) zeros(1,15*2^k);
        zeros(1,15*2^k) zeros(1,15*2^k) ones(1,15*2^k) zeros(1,15*2^k);
        zeros(1,15*2^k) zeros(1,15*2^k) zeros(1,15*2^k) ones(1,15*2^k)];
end;

%% Features selection (Indipendet Datasets)
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

for execution=1:5
    for i=1:3
        
        sens_num = i;
        t_interval = 1;
        
        pat_net = patternnet(10);
        
        fitnessFcn = @pattern_fitness;
        nvar = 98;
        options = gaoptimset;
        options = gaoptimset(options,'TolFun', 1e-8, 'Generations', 300, ...
            'OutputFcn', @ga_output, ...
            'Display', 'iter', ...
            'StallGenLimit', 75);
        
        % Linear inequalities, necessary to avoid solutions with the same
        % feature more than one time.
        A = [1 -1 0 0 zeros(1,94);
            0 1 -1 0 zeros(1,94);
            0 0 1 -1 zeros(1,94)];
        b = [-1; -1; -1];
        
        x = ga(fitnessFcn, nvar, A, b, [], [], [1; 1; 1; 1; ...
            -Inf*ones(94,1)], [22; 22; 22; 22; Inf*ones(94,1)], [], ...
            [1 2 3 4], options);
        
        pat_nets{i,1} = pat_net;
        pat_nets{i,1} = setwb(pat_nets{i,1}, x(5:98));
        pat_nets{i,2} = history;
        pat_nets{i,3} = x(1:4);
        
    end;
    save(['GA_IND_' num2str(execution)]);
end;

%% Features selection (Union of signals)
% For the moment we consider just the sensor1 dataset. For this first try
% we consider the sensor output on a specific volunteer as a feature, so we
% want to find the best sensor outputs by selecting one for each possible
% activity. In other words, we will obtain the four indicies which
% represents the columns in the sensor dataset.

global pat_union_net;
global pat_union_nets;
global t_interval_union;

history = struct;
pat_union_nets = cell(3,1);

for execution=1:5
    
    t_interval_union = 1;
    
    pat_union_net = patternnet(10);
    
    fitnessFcn = @pattern_union_fitness;
    nvar = 98;
    options = gaoptimset;
    options = gaoptimset(options,'TolFun', 1e-8, 'Generations', 300, ...
        'OutputFcn', @ga_output, ...
        'Display', 'iter', ...
        'StallGenLimit', 75);
    
    % Linear inequalities, necessary to avoid solutions with the same
    % feature more than one time.
    A = [1 -1 0 0 zeros(1,94);
        0 1 -1 0 zeros(1,94);
        0 0 1 -1 zeros(1,94)];
    b = [-1; -1; -1];
    
    x = ga(fitnessFcn, nvar, A, b, [], [], [1; 1; 1; 1; ...
        -Inf*ones(94,1)], [22; 22; 22; 22; Inf*ones(94,1)], [], ...
        [1 2 3 4], options);
    
    pat_union_nets{i,1} = pat_union_net;
    pat_union_nets{i,1} = setwb(pat_union_nets{i,1}, x(5:98));
    pat_union_nets{i,2} = history;
    pat_union_nets{i,3} = x(1:4);
    
    save(['GA_UNION_' num2str(execution)]);
end;

%% Find the best sensor (Indipendent datasets).
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

%% Select the features obtained from the GA (Indipendent datasets).

best_feat = pat_nets{best_sensor,3};
selected_tmp = cell(3,1);

for i=1:22
    selected_tmp{1} = [selected_tmp{1} features{i}{1,best_sensor}'];
    selected_tmp{2} = [selected_tmp{2} features{i}{2,best_sensor}'];
    selected_tmp{3} = [selected_tmp{3} features{i}{3,best_sensor}'];
end;

selected_features = cell(3,1);

selected_features{1} = selected_tmp{1}(:,best_feat);
selected_features{2} = selected_tmp{2}(:,best_feat);
selected_features{3} = selected_tmp{3}(:,best_feat);

%% Select the features obtained from the GA (Union of signals).

net_in = [features_union{pat_union_nets{1,3}(1)}{t_interval_union};
    features_union{pat_union_nets{1,3}(2)}{t_interval_union};
    features_union{pat_union_nets{1,3}(3)}{t_interval_union};
    features_union{pat_union_nets{1,3}(4)}{t_interval_union}];
net_out = pat_union_nets{1,1}(net_in);

% Confusion matrix.
pat_union_confusion = confusion(pat_union_targets{t_interval_union},net_out);

best_union_feat = pat_union_nets{1,3};
selected_union_tmp = cell(3,1);

for i=1:22
    selected_union_tmp{1} = [selected_union_tmp{1} ...
        features_union{i}{1}'];
    selected_union_tmp{2} = [selected_union_tmp{2} ...
        features_union{i}{2}'];
    selected_union_tmp{3} = [selected_union_tmp{3} ...
        features_union{i}{3}'];
end;

selected_union_features = cell(3,1);

selected_union_features{1} = selected_union_tmp{1}(:,best_union_feat);
selected_union_features{2} = selected_union_tmp{2}(:,best_union_feat);
selected_union_features{3} = selected_union_tmp{3}(:,best_union_feat);

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

% Indicies of the checking dataset.
checking_indicies = cell(3,1);
checking_indicies{1} = [1 7 12 20 24 38];
checking_indicies{2} = sort([checking_indicies{1}*2 ...
    (checking_indicies{1}*2)-1]);
checking_indicies{3} = sort([checking_indicies{1}*4 ...
    (checking_indicies{1}*4)-1 (checking_indicies{1}*4)-2 ...
    (checking_indicies{1}*4)-3]);

% Indicies of the testing dataset.
testing_indicies = cell(3,1);
testing_indicies{1} = [9 15 27 30 31 32];
testing_indicies{2} = sort([testing_indicies{1}*2 ...
    (testing_indicies{1}*2)-1]);
testing_indicies{3} = sort([testing_indicies{1}*4 ...
    (testing_indicies{1}*4)-1 (testing_indicies{1}*4)-2 ...
    (testing_indicies{1}*4)-3]);

% Indicies of the training dataset.
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

sugeno_fis = cell(1,3);
sugeno_outputs = cell(1,3);

trnOpt = [20 0 0.01 0.9 1.1];
dispOpt = [NaN NaN NaN NaN];

% 'k' time interval.
for k=1:3
    sugeno_fis{k} = cell(5,2);
    sugeno_outputs{k} = cell(5,1);
    % Activity 'i' vs. All.
    for i=1:4
        sugeno_fis{k}{i,2} = struct('error',[],'stepsize',[],'chkFis',[],...
            'chkErr',[]);
        sugeno_fis{k}{i,1} = genfis2(anfis_train{k,i}(:,1:4), ...
            anfis_train{k,i}(:,5),0.5);
        [sugeno_fis{k}{i,1},sugeno_fis{k}{i,2}.error,sugeno_fis{k}{i,2}.stepsize,...
            sugeno_fis{k}{i,2}.chkFis,sugeno_fis{k}{i,2}.chkErr] = ...
            anfis(anfis_train{k,i},sugeno_fis{k}{i,1},trnOpt,dispOpt, ...
            anfis_check{k,i});
        sugeno_outputs{k}{i,1} = evalfis(anfis_test{k,i}(:,1:4), ...
            sugeno_fis{k}{i,1});
    end;
end;

% Evaluate the performance.


%% ------- Mamdani-type Inference System -------

load('MamdaniA1vsAll.mat');
load('MamdaniA2vsAll.mat');
load('MamdaniA3vsAll.mat');
load('MamdaniA4vsAll.mat');

mamdani_fis = cell(5,1);

mamdani_fis{1} = MamdaniA1vsAll;
mamdani_fis{2} = MamdaniA2vsAll;
mamdani_fis{3} = MamdaniA3vsAll;
mamdani_fis{4} = MamdaniA4vsAll;

% For mamdani we selected the following features:
% - Bandwidth
% - Average peak distances in power spectrum.
% - Mean value of the lower envelope of the signals.
% - Average frequency of the 3 peaks with more amplitude in frequency
%   domanin.
mamdani_feat_index = [17 18 10 21];

mamdani_in = [features_raw{mamdani_feat_index(1),1}{1,1};
              features_raw{mamdani_feat_index(2),1}{1,1};
              features_raw{mamdani_feat_index(3),1}{1,1};
              features_raw{mamdani_feat_index(4),1}{1,1}];

% Compute the outputs and performance of the Mamdani FIS.
mamdani_outputs = cell(5,2);
mamdani_perf = cell(5,1);
for i=1:4
    mamdani_outputs{i} = evalfis(mamdani_in,mamdani_fis{i});
    for j=1:40
        if mamdani_outputs{i,1}(j) >= 0 && mamdani_outputs{i,1}(j) < 1
            mamdani_outputs{i,2}(j,1) = 1;
        elseif mamdani_outputs{i,1}(j) >= 1 && mamdani_outputs{i,1}(j) < 2
            mamdani_outputs{i,2}(j,1) = 2;
        elseif mamdani_outputs{i,1}(j) >= 2 && mamdani_outputs{i,1}(j) < 3
            mamdani_outputs{i,2}(j,1) = 3;
        else
            mamdani_outputs{i,2}(j,1) = 4;
        end;
    end;
    % Clean the filtered output vectors.
    mamdani_outputs{i,2}(mamdani_outputs{i,2}~=i) = 0;
    mamdani_outputs{i,2}(mamdani_outputs{i,2}==i) = 1;
    
    % Compute TPR and FNR.
    mamdani_perf{i} = struct;
    mamdani_perf{i}.TPR = sum(pat_targets{1}(i,:)'== ...
        mamdani_outputs{i,2}) / 40;
    mamdani_perf{i}.FNR = 1 - mamdani_perf{i}.TPR;
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
    anfis_check{i,5} = [selected_features{i}(checking_indicies{i},:) ...
        all_targets{i}(checking_indicies{i}')];
    anfis_test{i,5} = [selected_features{i}(testing_indicies{i},:) ...
        all_targets{i}(testing_indicies{i}')];
    anfis_train{i,5} = [selected_features{i}(training_indicies{i},:) ...
        all_targets{i}(training_indicies{i}')];
end;

trnOpt = [30 0 0.01 0.9 1.1];
dispOpt = [NaN NaN NaN NaN];

for k=1:3
    sugeno_fis{k}{5,2} = struct('error',[],'stepsize',[],'chkFis',[],...
        'chkErr',[]);
    sugeno_fis{k}{5,1} = genfis2(anfis_train{k,5}(:,1:4), ...
        anfis_train{k,5}(:,5),0.5);
    % sugeno_fis{5,1} = genfis3(anfis_train{1,5}(:,1:4), ...
    %     anfis_train{1,5}(:,5),'sugeno');
    [sugeno_fis{k}{5,1},sugeno_fis{k}{5,2}.error,sugeno_fis{k}{5,2}.stepsize,...
        sugeno_fis{k}{5,2}.chkFis,sugeno_fis{k}{5,2}.chkErr] = ...
        anfis(anfis_train{k,5},sugeno_fis{k}{5,1},trnOpt,dispOpt, ...
        anfis_check{k,5});
end;


%% ------- Mamdani-type Inference System -------

load('MamdaniAllvsAll.mat');

mamdani_fis{5} = MamdaniAllvsAll;

mamdani_outputs{5} = evalfis(mamdani_in,mamdani_fis{5});
for j=1:40
    if mamdani_outputs{5,1}(j) >= 0 && mamdani_outputs{5,1}(j) < 1
        mamdani_outputs{5,2}(j,1) = 1;
    elseif mamdani_outputs{5,1}(j) >= 1 && mamdani_outputs{5,1}(j) < 2
        mamdani_outputs{5,2}(j,1) = 2;
    elseif mamdani_outputs{5,1}(j) >= 2 && mamdani_outputs{5,1}(j) < 3
        mamdani_outputs{5,2}(j,1) = 3;
    else
        mamdani_outputs{5,2}(j,1) = 4;
    end;
end;

% Compute TPR and FNR.
mamdani_perf{5} = struct;
mamdani_perf{5}.TPR = sum(all_targets{1}==mamdani_outputs{5,2}) / 40;
mamdani_perf{5}.FNR = 1 - mamdani_perf{5}.TPR;

% % GA optimization trial.
% 
% global mamdani;
% global mamdani_feat;
% global mamdani_all_targets;
% 
% mamdani_feat = [feat_temp{4}{1,1}' feat_temp{5}{1,1}' feat_temp{11}{1,1}' ...
%     feat_temp{17}{1,1}'];
% 
% mamdani_all_targets = [zeros(10,1); ones(10,1); 2*ones(10,1); 3*ones(10,1);];
% 
% mamdani = readfis('Mamdani5.fis');
% 
% A = [zeros(1,44) -1 -1 -1 -1 0 zeros(1,35);
%      zeros(1,49) -1 -1 -1 -1 0 zeros(1,30);
%      zeros(1,54) -1 -1 -1 -1 0 zeros(1,25);
%      zeros(1,59) -1 -1 -1 -1 0 zeros(1,20);
%      zeros(1,64) -1 -1 -1 -1 0 zeros(1,15);
%      zeros(1,69) -1 -1 -1 -1 0 zeros(1,10);
%      zeros(1,74) -1 -1 -1 -1 0 zeros(1,5);
%      zeros(1,79) -1 -1 -1 -1 0];
%  B = [-1; -1; -1; -1; -1; -1; -1; -1];
% 
% fitnessFcn = @mamdani_all_fitness;
% nvar = 84;
% options = gaoptimset;
% options = gaoptimset(options,'TolFun', 1e-8, 'Generations', 100, ...
%     'OutputFcn', @ga_output, ...
%     'CreationFcn', @gacreationlinearfeasible, ...
%     'PlotFcns', @gaplotbestf);
% 
% [x, fval] = ga(fitnessFcn, nvar, A, B, [], [], ...
%     [0.001*ones(44,1);zeros(39,1); 1],[Inf*ones(44,1); 3*ones(39,1); 4], [], ...
%     (45:84),options);

