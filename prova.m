load data.mat
load sensor.mat

feat = extract_features2(sensor_filtered, 1/82e-3)

%%
y = data{1,1}(:,1)
uniformSampleRate = 1 /82e-3
Fs = uniformSampleRate
Y = fft(y)
L = length(y)

P2 = abs(Y/L);
P1 = P2(1:L);
P1(2:end-1) = 2*P1(2:end-1);

%% feature in Freq domain
% Y-Axis data only
y = y - mean(y);

% apply fast fourier transformation to the signal
% Next power of 2 from length of averaged rms acceleration

f1 = Fs*(0:(L-1))/L;
plot(f1,P1)

hold on

plot(f1, y)