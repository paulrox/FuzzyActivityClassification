%% Compute Bandwidth Feature

clear
close all
load data.mat

Fs = 1 / 82;

%
% Bandwidth_sensor_k is a matrix in which the element (i, j) contains the
% bandwidth of the signal referred to the patient i for the activity j
% considering the data retrieved from sensor k
%

bandwidths_sensor_1  = extract_feature_bandwidth(data, 1, Fs);

bandwidths_sensor_2  = extract_feature_bandwidth(data, 2, Fs);

bandwidths_sensor_3  = extract_feature_bandwidth(data, 3, Fs);

%% Compute Max Peak Feature

clear 
close all
load data.mat

Fs = 1 / 82;


%
% maxpeaks_sensor_k is a matrix in which the element (i, j) contains the
% max peak of the signal referred to the patient i for the activity j
% considering the data retrieved from sensor k
%

maxpeaks_sensor_1  = extract_feature_fmaxpeak(data, 1, Fs);

maxpeaks_sensor_2  = extract_feature_fmaxpeak(data, 2, Fs);

maxpeaks_sensor_3  = extract_feature_fmaxpeak(data, 3, Fs);
