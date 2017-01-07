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


%% GA plots.

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
    title(['Features selection for union of sensor data using GA']);
%% Sugeno FIS 1 vs. All Plots.

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

%% Sugeno FIS All vs. All Plots.

figure;
plot(sugeno_fis{1}{5,2}.chkErr);
title(['Sugeno FIS Checking Error Activity ' num2str(i) ' vs. All']);
xlabel('Epoch');
ylabel('Error');

% Training error.
figure;
plot(sugeno_fis{1}{5,2}.error);
title(['Sugeno FIS Training Error Activity ' num2str(i) ' vs. All']);
xlabel('Epoch');
ylabel('Error');

% Testing error.
figure;
plot(sugeno_outputs{1}{5,1}, '*r');
title(['Sugeno FIS Output Error Activity ' num2str(i) ' vs. All']);
xlabel('Input Number');
ylabel('Value');
hold on;
plot(anfis_test{1,5}(:,5), 'ob');
plot(sugeno_outputs{1}{5,2}, 'xk');
legend('FIS output', 'Target', 'Filtered output');