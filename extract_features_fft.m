% In this script are extracted some features from the data in the 
% frequency domain. The features are retrieved considering different
% time intervals (164s, 82s, 41s)

%% Data 

load sensor.mat % Data with different time intervals

Fs = 1 / (82e-3); % Sampling Frequency

%% Compute Bandwidth Feature

bandwidth_feat = extract_bandwidth(sensor, Fs);

%% Compute Max Peak Feature

maxpeaks_feat = extract_fmaxpeak(sensor, Fs);

%% Compute Average Power Feature

bandp_feat = extract_bandpower(sensor);

%% Compute Average Peaks Distance

avgdist_feat = extract_averagedistance_peaks(sensor, Fs);