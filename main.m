%% Computational Intelligence Project 2016
%  Activity recognition using fuzzy classifiers.
%
%  A.Y.: 2016/2017 
%  Authors: Paolo Sassi - Matteo Rotundo
%  
%  This file contains the main script and its execution allows to obtain
%  all the data developed for the project.
%
%--------------------------------------------------------------------------
% Clear the workspace and close all the windows.
clearvars;
close all;
% Load the dataset.
load('data.mat');

%% Separate Data (each sensor is considered as an indipendent dataset)
% We divide the data by putting each sensor output for each volunteer in a
% different matrix, and we get rid of the time column.

% Cell array containing all the timestamps for all the signals.
global timestamps;

timestamps = cell(3,1);
sensor_raw = cell(3,3);

% i-th activity.
for i=1:4
    % i-th activity.
    for j=1:10
        % Time interval: 162 seconds.
        sensor_raw{1,1} = [sensor_raw{1,1} data{i,j}(:,1)];
        sensor_raw{1,2} = [sensor_raw{1,2} data{i,j}(:,2)];
        sensor_raw{1,3} = [sensor_raw{1,3} data{i,j}(:,3)];
        timestamps{1} = [timestamps{1} data{i,j}(:,4)];
        
        % Time interval: 82 seconds.
        sensor_raw{2,1} = [sensor_raw{2,1} data{i,j}(1:1000,1) ...
            data{i,j}(1001:2000,1)];
        sensor_raw{2,2} = [sensor_raw{2,2} data{i,j}(1:1000,2) ...
            data{i,j}(1001:2000,2)];
        sensor_raw{2,3} = [sensor_raw{2,3} data{i,j}(1:1000,3) ...
            data{i,j}(1001:2000,3)];
        timestamps{2} = [timestamps{2} data{i,j}(1:1000,4) ...
            data{i,j}(1001:2000,4)-data{i,j}(1001,4)];
        
        % Time interval: 41 seconds.
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

%% Separate Data (Considering the union of the sensors signals)
% The data is ordered by: Activity -> Sensor -> Volunteer

% Cell array containing all the sensors data.
sensor_union_raw = cell(3,1);

% i-th activity.
for i=1:4
    % k-th sensor.
    for k=1:3
        % j-th volunteer.
        for j=1:10
            % Time interval: 162 seconds.
            sensor_union_raw{1} = [sensor_union_raw{1} data{i,j}(:,k)];
            
            % Time interval: 82 seconds.
            sensor_union_raw{2} = [sensor_union_raw{2} ...
                data{i,j}(1:1000,k) data{i,j}(1001:2000,k)];
            
            % Time interval: 41 seconds.
            sensor_union_raw{3,1} = [sensor_union_raw{3} ...
                data{i,j}(1:500,k) data{i,j}(501:1000,k) ...
                data{i,j}(1001:1500,k) data{i,j}(1501:2000,k)];
        end;
    end;
end;

%% Signal Filtering.
% In this phase the signals from the sensors are filtered and modified in 
% order to remove disturbances and improve the features extraction phase.

global sensor;
global sensor_union;

sensor = cell(3,3);
sensor_union = cell(3,1);

% Load a Low-Pass filter designed using fdatool.
lpf = load('low_pass.mat');

% i-th time interval.
for i = 1:3
    % j-th sensor.
    for j = 1:3
        % k-th signal.
        for k = 1:20*(2^i)
            sensor{i, j}(:,k) = filter(lpf.Hd,sensor_raw{i, j}(:,k));
            sensor{i, j}(:,k) = sensor{i, j}(:,k) - ...
                mean(sensor{i, j}(:,k));  
        end;
    end;
end;

% i-th time interval.
for i=1:3
    % j-th signal.
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

% Merge the features in an unique cell array.
features_raw = [features_TD'; features_FD'];
features_union_raw = [features_union_TD'; features_union_FD'];
features = cell(22,1);
features_union = cell(22,1);

% i-th feature.
for i=1:22
    % k-th time interval.
    for k=1:3
        % j-th sensor.
        for j=1:3
            feat_m =  mean(features_raw{i}{k,j});
            feat_std = std(features_raw{i}{k,j});
            features{i}{k,j} = (features_raw{i}{k,j}-feat_m)/feat_std;
        end;
        % Compute the mean of the selected feature.
        feat_union_m = mean(features_union_raw{i}{k});
        % Compute the standard deviation of the selected feature.
        feat_union_std = std(features_union_raw{i}{k});
        % Normalize.
        features_union{i}{k} = (features_union_raw{i}{k}-feat_union_m)/ ...
            feat_union_std;
    end;
end;

%% Build the target vectors for the sensors.
% The target vectors will be the same for all sensors. We have 4 possible
% activites, so each target vector will be composed by 10 (20 or 40)
% elements equal to 1 and 30 (60 or 120) elements equal to 0.
% The activity are ordered as:
% 1 - supine position;
% 2 - walking;
% 3 - dorsiflexion standing;
% 4 - stairs climbing.

global pat_targets;
global pat_union_targets;
global t_interval;
global t_interval_union;

t_interval = 1;
t_interval_union = 1;
% Targets for the patternet training.
pat_targets = cell(3,1);
pat_union_targets = cell(3,1);

% k-th time interval.
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
% We to the GA to select the four best features from the initial set of 22.
% In particular, the algorithm selects the features and trains the
% patternet at the same time. It is executed 5 times for each sensor.

% global pat_net;
% global pat_nets;
% global sens_num;
% global history;

% history = struct;
% pat_nets = cell(3,3);
% 
% for execution=1:5
%     for i=1:3
%         
%         sens_num = i;
%         
%         pat_net = patternnet(10);
%         
%         fitnessFcn = @pattern_fitness;
%         nvar = 98;
%         options = gaoptimset;
%         options = gaoptimset(options,'TolFun', 1e-8, 'Generations', 300, ...
%             'OutputFcn', @ga_output, ...
%             'Display', 'iter', ...
%             'StallGenLimit', 75);
%         
%         % Linear inequalities, necessary to avoid solutions with the same
%         % feature more than one time.
%         A = [1 -1 0 0 zeros(1,94);
%             0 1 -1 0 zeros(1,94);
%             0 0 1 -1 zeros(1,94)];
%         b = [-1; -1; -1];
%         
%         x = ga(fitnessFcn, nvar, A, b, [], [], [1; 1; 1; 1; ...
%             -Inf*ones(94,1)], [22; 22; 22; 22; Inf*ones(94,1)], [], ...
%             [1 2 3 4], options);
%         
%         pat_nets{i,1} = pat_net;
%         pat_nets{i,1} = setwb(pat_nets{i,1}, x(5:98));
%         pat_nets{i,2} = history;
%         pat_nets{i,3} = x(1:4);
%         
%     end;
%      save(['GA_IND_' num2str(execution)]);
% end;

% Load the pre-computed best result.
load('ga_ind_best.mat');

%% Features selection (Union of signals)
% The same as before but this time we are considering all the sensors
% together. The algorithm is executed 5 times.

% global pat_union_net;
% global pat_union_nets;
% 
% history = struct;
% pat_union_nets = cell(3,1);
% 
% for execution=1:5
%     
%     
%     pat_union_net = patternnet(10);
%     
%     fitnessFcn = @pattern_union_fitness;
%     nvar = 98;
%     options = gaoptimset;
%     options = gaoptimset(options,'TolFun', 1e-8, 'Generations', 300, ...
%         'OutputFcn', @ga_output, ...
%         'Display', 'iter', ...
%         'StallGenLimit', 75);
%     
%     % Linear inequalities, necessary to avoid solutions with the same
%     % feature more than one time.
%     A = [1 -1 0 0 zeros(1,94);
%         0 1 -1 0 zeros(1,94);
%         0 0 1 -1 zeros(1,94)];
%     b = [-1; -1; -1];
%     
%     x = ga(fitnessFcn, nvar, A, b, [], [], [1; 1; 1; 1; ...
%         -Inf*ones(94,1)], [22; 22; 22; 22; Inf*ones(94,1)], [], ...
%         [1 2 3 4], options);
%     
%     pat_union_nets{1,1} = pat_union_net;
%     pat_union_nets{1,1} = setwb(pat_union_nets{1,1}, x(5:98));
%     pat_union_nets{1,2} = history;
%     pat_union_nets{1,3} = x(1:4);
% 
%     save(['GA_UNION_' num2str(execution)]);
% end;

% Load the pre-computed best result.
load('ga_union_best.mat');

%% Find the best sensor (Indipendent datasets)
% We evaluate the patternet performances using the confusion matrix and we
% choose the sensor by which we obtain the best value.

pat_confusion = zeros(1,3);

% i-th sensor.
for i=1:3
    net_in = [features{pat_nets{i,3}(1)}{t_interval,i};
              features{pat_nets{i,3}(2)}{t_interval,i};
              features{pat_nets{i,3}(3)}{t_interval,i};
              features{pat_nets{i,3}(4)}{t_interval,i}];
    net_out = pat_nets{i,1}(net_in);
    pat_confusion(i) = confusion(pat_targets{t_interval},net_out);
end;

% The best sensor is the one by which the confusion value is lower.
% best_sensor = find(pat_confusion==min(pat_confusion));

% In our specific case we choose anyway to use the sensor 1 for the reasons
% written in the project report.

best_sensor = 1;

%% Select the features obtained from the GA (Indipendent datasets)
% We extract the best features from the best sensor.

best_feat = pat_nets{best_sensor,3};
selected_tmp = cell(3,1);

% i-th feature.
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
% Same as before, but this time we are considering the union of all the
% sensors.

net_in = [features_union{pat_union_nets{1,3}(1)}{t_interval_union};
    features_union{pat_union_nets{1,3}(2)}{t_interval_union};
    features_union{pat_union_nets{1,3}(3)}{t_interval_union};
    features_union{pat_union_nets{1,3}(4)}{t_interval_union}];
net_out = pat_union_nets{1,1}(net_in);

% Confusion matrix.
pat_union_confusion = confusion(pat_union_targets{t_interval_union},net_out);

best_union_feat = pat_union_nets{1,3};
selected_union_tmp = cell(3,1);

% i-th sensor.
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

%% ******* One-against-all Classifiers ************************************

%% ------- Sugeno-type Inference System -----------------------------------
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

% Cell array for training data.
anfis_train = cell(3,5);
% Cell array for checking data.
anfis_check = cell(3,5);
% Cell array for testing data.
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
% i-th time interval.
for i=1:3
    % j-th activity.
    for j=1:4
        anfis_check{i,j} = [selected_features{i}(checking_indicies{i},:) ...
            pat_targets{i}(j,checking_indicies{i})'];
        anfis_test{i,j} = [selected_features{i}(testing_indicies{i},:) ...
            pat_targets{i}(j,testing_indicies{i})'];
        anfis_train{i,j} = [selected_features{i}(training_indicies{i},:) ...
            pat_targets{i}(j,training_indicies{i})'];
    end;
end;

%% Generate FIS structures and train them using ANFIS

% Cell array containing the FIS structures (one element for each time
% interval).
sugeno_fis = cell(1,3);
% Cell array containing the FIS outputs.
sugeno_outputs = cell(1,3);
% Cell array containing the FIS TPR and FNR.
sugeno_perf = cell(1,3);

% Anfis training options, defined as: [epoch_num, error_goal,
% initial_step_size, step_size_decrease_rate, step_size_increase_rate].
trnOpt = [40 0 0.01 0.9 1.1];
% Anfis display options, defined as: [anfis_info, error_values, step_size,
% final_results].
dispOpt = [0 0 0 0];

% k-th time interval.
for k=1:3
    % Define an inner cell array to contain the FIS, the outputs and the
    % performances for each classifier.
    sugeno_fis{k} = cell(5,2);
    sugeno_outputs{k} = cell(5,2);
    sugeno_perf{k} = cell(5,1);
    % i-th activity vs. all.
    for i=1:4
        % Structure used to store the returned values by anfis().
        sugeno_fis{k}{i,2} = struct('error',[],'stepsize',[],'chkFis',[],...
            'chkErr',[]);
        % Generate the Sugeno FIS structure.
        sugeno_fis{k}{i,1} = genfis1(anfis_train{k,i},3,'pimf', ...
            'constant');
        %         sugeno_fis{k}{i,1} = genfis2(anfis_train{k,i}(:,1:4), ...
        %             anfis_train{k,i}(:,5),0.3);
        %         sugeno_fis{5,1} = genfis3(anfis_train{k,i}(:,1:4), ...
        %             anfis_train{k,i}(:,5),'sugeno');
        % Prepare temporary data structure.
        test_perf = zeros(10,1);
        sugeno_tmp = cell(10,2);
        sugeno_outputs_tmp = cell(10,2);
        sugeno_perf_tmp = cell(10,1);
        % The performance of the FIS trained used anfis depends on the
        % initial choice of the parameters, which are chosen randomically
        % by MATLAB. For this reason we perform the training 10 times and
        % we take the FIS with the lower testing error.
        % j-th training trial.
        for j=1:10
            % Train the FIS.
            [sugeno_fis{k}{i,1},sugeno_fis{k}{i,2}.error,sugeno_fis{k}{i,2}.stepsize,...
                sugeno_fis{k}{i,2}.chkFis,sugeno_fis{k}{i,2}.chkErr] = ...
                anfis(anfis_train{k,i},sugeno_fis{k}{i,1},trnOpt,dispOpt, ...
                anfis_check{k,i});
            sugeno_tmp{j,1} = sugeno_fis{k}{i,1};
            sugeno_tmp{j,2} = sugeno_fis{k}{i,2};
            % Compute the FIS outputs.
            sugeno_outputs_tmp{j,1} = evalfis(anfis_test{k,i}(:,1:4), ...
                sugeno_tmp{j,1});
            % Filter the outputs.
            for w=1:3*2^k
                if sugeno_outputs_tmp{j,1}(w) <= 0.5
                    sugeno_outputs_tmp{j,2}(w,1) = 0;
                else
                    sugeno_outputs_tmp{j,2}(w,1) = 1;
                end;
            end;
            % Evaluate the performance.
            sugeno_perf_tmp{j} = struct;
            sugeno_perf_tmp{j}.TPR = sum(anfis_test{k,i}(:,5)== ...
                sugeno_outputs_tmp{j,2}) / (3*2^k);
            sugeno_perf_tmp{j}.FNR = 1 - sugeno_perf_tmp{j}.TPR;
            test_perf(j) = sugeno_perf_tmp{j}.TPR;
        end;
        % Find the best FIS structure over the 10 trials.
        anfis_best = find(test_perf==min(test_perf));
        sugeno_fis{k}{i,1} = sugeno_tmp{anfis_best,1};
        sugeno_fis{k}{i,2} = sugeno_tmp{anfis_best,2};
        sugeno_outputs{k}{i,1} = sugeno_outputs_tmp{anfis_best,1};
        sugeno_outputs{k}{i,2} = sugeno_outputs_tmp{anfis_best,2};
        sugeno_perf{k}{i} = sugeno_perf_tmp{anfis_best};
    end;
end;


%% ------- Mamdani-type Inference System -------

% Load the stored Mamdani FIS.
load('MamdaniA1vsAll.mat');
load('MamdaniA2vsAll.mat');
load('MamdaniA3vsAll.mat');
load('MamdaniA4vsAll.mat');

% We store the Mamdani FIS in a cell array.
mamdani_fis = cell(5,1);
mamdani_fis{1} = MamdaniA1vsAll;
mamdani_fis{2} = MamdaniA2vsAll;
mamdani_fis{3} = MamdaniA3vsAll;
mamdani_fis{4} = MamdaniA4vsAll;

% For Mamdani we selected the following features:
% - Bandwidth
% - Average peak distances in power spectrum.
% - Mean value of the lower envelope of the signals.
% - Average frequency of the 3 peaks with more amplitude in frequency
%   domanin.
mamdani_feat_index = [17 18 10 21];

% Compute the Mamdani FIS inputs.
mamdani_in = [features_raw{mamdani_feat_index(1),1}{1,1};
              features_raw{mamdani_feat_index(2),1}{1,1};
              features_raw{mamdani_feat_index(3),1}{1,1};
              features_raw{mamdani_feat_index(4),1}{1,1}];
          
% Compute the Mamdani FIS inputs considering just the inputs which are part
% of the Sugeno testing set.
mamdani_test = mamdani_in(:,testing_indicies{1});

% Compute the outputs and performance of the Mamdani FIS.
mamdani_outputs = cell(5,4);
mamdani_perf = cell(5,2);
% i-th activity vs. all.
for i=1:4
    % Compute the FIS outputs (whole dataset).
    mamdani_outputs{i,1} = evalfis(mamdani_in,mamdani_fis{i});
    % Compute the FIS outputs (testing dataset).
    mamdani_outputs{i,3} = evalfis(mamdani_test,mamdani_fis{i});
    % Filter the outputs.
    for k=1:2:3
        % Whole dataset.
        if k==1
            last_input = 40;
        % Testing set.
        else
            last_input = 6;
        end;
        % j-th input.
        for j=1:last_input
            if mamdani_outputs{i,k}(j) >= 0 && mamdani_outputs{i,k}(j) < 1
                mamdani_outputs{i,k+1}(j,1) = 1;
            elseif mamdani_outputs{i,k}(j) >= 1 && mamdani_outputs{i,k}(j) < 2
                mamdani_outputs{i,k+1}(j,1) = 2;
            elseif mamdani_outputs{i,k}(j) >= 2 && mamdani_outputs{i,k}(j) < 3
                mamdani_outputs{i,k+1}(j,1) = 3;
            else
                mamdani_outputs{i,k+1}(j,1) = 4;
            end;
        end;
        % Clean the filtered output vectors.
        mamdani_outputs{i,k+1}(mamdani_outputs{i,k+1}~=i) = 0;
        mamdani_outputs{i,k+1}(mamdani_outputs{i,k+1}==i) = 1;   
    end;
    
    for k=1:2
        % Compute TPR and FNR.
        mamdani_perf{i,k} = struct;
        if k==1
            % Whole dataset.
            mamdani_perf{i,k}.TPR = sum(pat_targets{1}(i,:)'== ...
                mamdani_outputs{i,k*2}) / 40;
        else
            % Testing set.
            mamdani_perf{i,k}.TPR = sum(anfis_test{1,i}(:,5) == ...
                mamdani_outputs{i,k*2}) / 6;
        end;
        mamdani_perf{i,k}.FNR = 1 - mamdani_perf{i,k}.TPR;
    end;
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

% Compute the target vectors.
all_targets = cell(3,1);
all_targets{1} = [ones(1,10), 2*ones(1,10), 3*ones(1,10), 4*ones(1,10)]';
all_targets{2} = [ones(1,20), 2*ones(1,20), 3*ones(1,20), 4*ones(1,20)]';
all_targets{3} = [ones(1,40), 2*ones(1,40), 3*ones(1,40), 4*ones(1,40)]';

% i-th time interval.
for i=1:3
    anfis_check{i,5} = [selected_features{i}(checking_indicies{i},:) ...
        all_targets{i}(checking_indicies{i}')];
    anfis_test{i,5} = [selected_features{i}(testing_indicies{i},:) ...
        all_targets{i}(testing_indicies{i}')];
    anfis_train{i,5} = [selected_features{i}(training_indicies{i},:) ...
        all_targets{i}(training_indicies{i}')];
end;

% Anfis training options, defined as: [epoch_num, error_goal,
% initial_step_size, step_size_decrease_rate, step_size_increase_rate].
trnOpt = [40 0 0.01 0.9 1.1];
% Anfis display options, defined as: [anfis_info, error_values, step_size,
% final_results].
dispOpt = [0 0 0 0];

% k-th time interval.
for k=1:3
    sugeno_fis{k}{5,2} = struct('error',[],'stepsize',[],'chkFis',[],...
        'chkErr',[]);
    %     sugeno_fis{k}{i,1} = genfis1(anfis_train{k,5},3,'pimf', ...
    %             'constant');
    % Generate the FIS structure.
    sugeno_fis{k}{5,1} = genfis2(anfis_train{k,5}(:,1:4), ...
        anfis_train{k,5}(:,5),0.3);
    %      sugeno_fis{5,1} = genfis3(anfis_train{k,5}(:,1:4), ...
    %         anfis_train{k,5}(:,5),'sugeno');
    % Prepare temporary data structure.
    test_perf = zeros(10,1);
    sugeno_tmp = cell(10,2);
    sugeno_outputs_tmp = cell(10,2);
    sugeno_perf_tmp = cell(10,1);
    % Also in this case we decided to train the FIS 10 times and take just
    % the one with better results.
    for j=1:10
        % Train the FIS.
        [sugeno_fis{k}{5,1},sugeno_fis{k}{5,2}.error,sugeno_fis{k}{5,2}.stepsize,...
            sugeno_fis{k}{5,2}.chkFis,sugeno_fis{k}{5,2}.chkErr] = ...
            anfis(anfis_train{k,5},sugeno_fis{k}{5,1},trnOpt,dispOpt, ...
            anfis_check{k,5});
        sugeno_tmp{j,1} = sugeno_fis{k}{5,1};
        sugeno_tmp{j,2} = sugeno_fis{k}{5,2};
        % Compute the FIS outputs.
        sugeno_outputs_tmp{j,1} = evalfis(anfis_test{k,5}(:,1:4), ...
            sugeno_tmp{j,1});
        % Filter the outputs.
        for w=1:3*2^k
            if  sugeno_outputs_tmp{j,1}(w) < 1.5
                sugeno_outputs_tmp{j,2}(w,1) = 1;
            elseif sugeno_outputs_tmp{j,1}(w) >= 1.5 && ...
                    sugeno_outputs_tmp{j,1}(w) < 2.5
                sugeno_outputs_tmp{j,2}(w,1) = 2;
            elseif sugeno_outputs_tmp{j,1}(w) >= 2.5 && ...
                    sugeno_outputs_tmp{j,1}(w) < 3.5
                sugeno_outputs_tmp{j,2}(w,1) = 3;
            else
                sugeno_outputs_tmp{j,2}(w,1) =4;
            end;
        end;
        % Evaluate the performance.
        sugeno_perf_tmp{j} = struct;
        sugeno_perf_tmp{j}.TPR = sum(anfis_test{k,5}(:,5)== ...
            sugeno_outputs_tmp{j,2}) / (3*2^k);
        sugeno_perf_tmp{j}.FNR = 1 - sugeno_perf_tmp{j}.TPR;
        test_perf(j) = sugeno_perf_tmp{j}.TPR;
    end;
    % Find the best FIS structure over the 10 trials.
    anfis_best = find(test_perf==min(test_perf));
    sugeno_fis{k}{5,1} = sugeno_tmp{anfis_best,1};
    sugeno_fis{k}{5,2} = sugeno_tmp{anfis_best,2};
    sugeno_outputs{k}{5,1} = sugeno_outputs_tmp{anfis_best,1};
    sugeno_outputs{k}{5,2} = sugeno_outputs_tmp{anfis_best,2};
    sugeno_perf{k}{5} = sugeno_perf_tmp{anfis_best};
end;


%% ------- Mamdani-type Inference System -------

% Load the Mamdani FIS.
load('MamdaniAllvsAll.mat');

% Add to the cell array.
mamdani_fis{5} = MamdaniAllvsAll;
mamdani_outputs{5,1} = evalfis(mamdani_in,mamdani_fis{5});
mamdani_outputs{5,3} = evalfis(mamdani_test,mamdani_fis{5});

for k=1:2:3
    if k==1
        % Whole dataset.
        last_input = 40;
    else
        % Testing dataset.
        last_input = 6;
    end;
    % Filter the outputs.
    % j-th input.
    for j=1:last_input
        if mamdani_outputs{5,k}(j) >= 0 && mamdani_outputs{5,k}(j) < 1
            mamdani_outputs{5,k+1}(j,1) = 1;
        elseif mamdani_outputs{5,k}(j) >= 1 && mamdani_outputs{5,k}(j) < 2
            mamdani_outputs{5,k+1}(j,1) = 2;
        elseif mamdani_outputs{5,k}(j) >= 2 && mamdani_outputs{5,k}(j) < 3
            mamdani_outputs{5,k+1}(j,1) = 3;
        else
            mamdani_outputs{5,k+1}(j,1) = 4;
        end;
    end;
end;

% Compute TPR and FNR.
for k=1:2
    mamdani_perf{5,k} = struct;
    if k==1
        % Whole dataset.
        mamdani_perf{5,k}.TPR = sum(all_targets{1}== ...
            mamdani_outputs{5,k*2}) / 40;
    else
        % Testing dataset.
        mamdani_perf{5,k}.TPR = sum(anfis_test{1,5}(:,5)== ...
            mamdani_outputs{5,k*2}) / 6;
    end;
    mamdani_perf{5,k}.FNR = 1 - mamdani_perf{5,k}.TPR;
end;
