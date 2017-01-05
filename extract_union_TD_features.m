function [ features ] = extract_union_TD_features( sensor )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:3
    for k = 1:(60*2^i)
        
        signal = sensor{i}(:, k);
        
        % Max value
        tmp{1}{i}(1,k) = max(signal);
        
        % Min value
        tmp{2}{i}(1,k) = min(signal);
        
        % Root-Mean-Square Level (RMS)
        tmp{3}{i}(1,k) = rms(signal);
        
        % Mean
        tmp{4}{i}(1,k) = mean(signal);
        
        % Variance
        tmp{5}{i}(1,k) = var(signal);
        
        % Standard deviation
        tmp{6}{i}(1,k) = std(signal);
        
        % Peak to peak
        tmp{7}{i}(1,k) = peak2peak(signal);
        
        % Peak to RMS
        tmp{8}{i}(1,k) = peak2rms(signal);
        
        % Mean of upper and lower envelopes
        [yh,yl] = envelope(signal);
        tmp{9}{i}(1,k) = mean(yh);
        tmp{10}{i}(1,k) = mean(yl);
        
        % Similarity of signal patterns
        tmp{11}{i}(1,k) = dtw(signal(1:1000/2^(i-1)), ...
            signal(1000/2^(i-1)+1:2000/2^(i-1)));
        
        % Compute percentiles
        p25 = prctile(max(signal), 25);
        p75 = prctile(max(signal), 75);
        
        mag = signal;
        
        % Compute squared sum of data below certain percentile (25, 75)
        sumsq25 = sum(mag(mag < p25) .^ 2);
        sumsq75 = sum(mag(mag < p75) .^ 2);
        
        % Sum amplitude signal below 25%
        tmp{12}{i}(1,k) = sumsq25;
        
        % Sum amplitude signal below 75%
        tmp{13}{i}(1,k) = sumsq75;
        
        % Root-Sum-of-Squares of the signal
        tmp{14}{i}(1,k) = rssq(signal);
        
    end;
end;

features = tmp;

end

