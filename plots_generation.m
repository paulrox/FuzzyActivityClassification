%% Computational Intelligence Project 2016
%  Activity recognition using fuzzy classifiers.
%
%  A.Y.: 2016/2017 
%  Authors: Paolo Sassi - Matteo Rotundo
%  
%  Script for plots extraction.
%
%--------------------------------------------------------------------------
clearvars; clc; close all;
% Load the workspace.
load('project_workspace');

%% Signal plots

% Original signal.
plot(timestamps{1}(:,11),sensor_raw{1,1}(:,11));
hold on;
plot(timestamps{1}(:,11),sensor{1,1}(:,11));
%% GA plots

% Independent datasets.
for i=1:3
    figure;
    plot(pat_nets{i,2}.gen,pat_nets{i,2}.mean,'.b');
    hold on;
    plot(pat_nets{i,2}.gen,pat_nets{i,2}.best,'.k');
    legend('Mean','Best');
    xlabel('Generations');
    ylabel('Fitness fcn value');
    title(['Features selection for sensor ' num2str(i) ' using GA']);
end;

% Union of sensor data.
    figure;
    plot(pat_union_nets{1,2}.gen,pat_union_nets{1,2}.mean,'.b');
    hold on;
    plot(pat_union_nets{1,2}.gen,pat_union_nets{1,2}.best,'.k');
    legend('Mean','Best');
    xlabel('Generations');
    ylabel('Fitness fcn value');
    title('Features selection for union of sensor data using GA');
%% Sugeno FIS 1 vs. All Plots

for i=1:4
    % Cheking error.
    figure;
    plot(sugeno_fis{1}{i,2}.chkErr);
    title(['Sugeno FIS Checking Error Activity ' num2str(i) ' vs. All']);
    xlabel('Epoch');
    ylabel('Error');
    
    % Training error.
    figure;
    plot(sugeno_fis{1}{i,2}.error);
    title(['Sugeno FIS Training Error Activity ' num2str(i) ' vs. All']);
    xlabel('Epoch');
    ylabel('Error');
    
    % Testing error.
    figure;
    plot(sugeno_outputs{1}{i,1}, '*r');
    title(['Sugeno FIS Output Error Activity ' num2str(i) ' vs. All']);
    xlabel('Input Number');
    ylabel('Value');
    hold on;
    plot(anfis_test{1,i}(:,5), 'ob');
    plot(sugeno_outputs{1}{i,2}, 'xk');
    legend('FIS output', 'Target', 'Filtered output');
end;

%% Sugeno FIS All vs. All Plots

figure;
plot(sugeno_fis{1}{5,2}.chkErr);
title('Sugeno FIS Checking Error Four-Class');
xlabel('Epoch');
ylabel('Error');

% Training error.
figure;
plot(sugeno_fis{1}{5,2}.error);
title('Sugeno FIS Training Error Four-Class');
xlabel('Epoch');
ylabel('Error');

% Testing error.
figure;
plot(sugeno_outputs{1}{5,1}, '*r');
title('Sugeno FIS Output Error Four-Class');
xlabel('Input Number');
ylabel('Value');
hold on;
plot(anfis_test{1,5}(:,5), 'ob');
plot(sugeno_outputs{1}{5,2}, 'xk');
legend('FIS output', 'Target', 'Filtered output');

%% Plot features
% It is possible to plot different features change the feat variable. 
% It is also possible to plot with different intervals of time changing 
% the variable window.

feat_temp = features_raw;

window = 1;
feat = 5;

label = 1;


for sensor=2:3
    features1 = add_label(feat_temp{feat, 1}{window, sensor}, label);
    plot(features1(1,1), features1(2,1));
    
    hold on
    grid on
    for i=1:length(features1)
        if (features1(2,i) == 1)
            plot(features1(1,i), features1(2,i), 'k*');
        end;
        if (features1(2,i) == 2)
            plot(features1(1,i), features1(2,i), 'bo');
        end;
        if (features1(2,i) == 3)
            plot(features1(1,i), features1(2,i), 'gx');
        end;
        if (features1(2,i) == 4)
            plot(features1(1,i), features1(2,i), 'rs');
        end;
    end;
end;