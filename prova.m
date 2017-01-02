load data.mat
load sensor.mat

feat = extract_features2(sensor, 1/82e-3)

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
NFFT = 2 ^ nextpow2(length(y)); 
freqAccel = fft(y, NFFT) / length(y);
f = uniformSampleRate / 2 * linspace(0, 1, NFFT + 1);


f1 = Fs*(0:(L-1))/L;
plot(f1,P1)

hold on

plot(f1, freqAccel(1:end - 48))