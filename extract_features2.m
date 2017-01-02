function [ret] = extract_features2(  sensor, uniformSampleRate )

for i = 1: 1: 3
    for j = 1: 1: 3
        for k = 1: 1: (20*2^i)
            
            
            y = sensor{i, j}(:, k);
            %% feature in Freq domain
            % Y-Axis data only
            y = y - mean(y);
            
            % apply fast fourier transformation to the signal
            % Next power of 2 from length of averaged rms acceleration
            NFFT = 2 ^ nextpow2(length(y));
            freqAccel = fft(y, NFFT) / length(y);
            f = uniformSampleRate / 2 * linspace(0, 1, NFFT / 2 + 1);
            
            % amplitude of spectrum
            amplitudeSpectrum = 2 * abs(freqAccel(1:NFFT / 2 + 1));
            
            % Freq. feature 1, single sideed bandwidth is uniformSampleRate / 2, we are
            % interested in 5Hz out of uniformSampleRate / 2.
            sum5Hz = sum(amplitudeSpectrum);
            [maxVal, maxIndx] = max(amplitudeSpectrum); % Find peak
            maxFreq = f(maxIndx); %Freq. feature 2
            
            % We are interested in single sided 0-5Hz data.
            dataLength = ceil(length(f) * (5 / (uniformSampleRate / 2)));
            dataOfInterest = amplitudeSpectrum(1:dataLength);
            minDistance = ceil(length(f)/uniformSampleRate);
            warning Off; % Idling might not have peaks, turn off warning.
            [vals, loc] = findpeaks(2*abs(dataOfInterest), 'MINPEAKHEIGHT', 1,...
                'MINPEAKDISTANCE', minDistance, 'SORTSTR', 'descend');
            warning On;
            
            numPeaks = length(vals); % Freq. feature 3, number of peaks
            
            temp{1}{i, j}(1, k) = sum5Hz;
            temp{2}{i, j}(1, k) = maxFreq;
            temp{3}{i, j}(1, k) = numPeaks;
            temp{4}{i, j}(1, k) = obw(ifft(freqAccel), uniformSampleRate);
            
            [P, f] = periodogram(ifft(freqAccel),[],[],uniformSampleRate,'power');
            [~, lc] = findpeaks(P);
            
            temp{5}{i, j}(1, k) = mean(diff(f(lc)));
            temp{6}{i, j}(1, k) = peak2rms(ifft(freqAccel));
            temp{7}{i, j}(1, k) = peak2peak(ifft(freqAccel));
            temp{8}{i, j}(1, k) = mean(ifft(freqAccel));
            temp{9}{i, j}(1, k) = std(ifft(freqAccel));
            [yh,yl] = envelope(ifft(freqAccel));
            temp{10}{i, j}(1, k) = mean(yh);
            temp{11}{i, j}(1, k) = mean(yl);
            temp{12}{i, j}(1, k) = sqrt( mean(amplitudeSpectrum.^2));
            
            temp{13}{i, j}(1, k) = bandpower(ifft(freqAccel));
            
            
            %compute percentiles
            p25 = prctile(max(ifft(freqAccel)), 25);
            p75 = prctile(max(ifft(freqAccel)), 75);
            
            mag = ifft(freqAccel);
            %compute squared sum of data below certain percentile (25, 75)
            sumsq25 = sum(mag(mag < p25) .^ 2);
            sumsq75 = sum(mag(mag < p75) .^ 2);
            
            temp{14}{i, j}(1, k) = sumsq25;
            
            temp{15}{i, j}(1, k) = sumsq75;
            
            temp{15}{i, j}(1, k) = rssq(mag);
            
           % temp{16}{i, j}(1, k) = mean(findchangepts(mag, 'Statistic','rms','MaxNumChanges', 5));
            
            [P, f] = pwelch(ifft(freqAccel));
            [~, lc] = findpeaks(P);
            
            temp{16}{i, j}(1, k) = mean(diff((lc)));
            
            [~,lc] = findpeaks(P,'SortStr','descend', 'NPeaks',3);
            
            temp{17}{i, j}(1, k) = mean(f(lc));
            
            temp{18}{i, j}(1, k) = sum(P);
            
        end
    end
end

ret = temp;

end

