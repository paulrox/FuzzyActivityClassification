


%% Plotting the same activity of the same sensors for different patients
hold on;
for i = 1:1:10
    [x, y] = time_to_frequency(data, 1, i, 1);
    plot(x, y);
end
xlabel('Frequency (Hz)')
ylabel('Magnitude')

%% Plotting different activities of the same sensor and patient
hold on;
for i = 1:1:4
    [x, y] = time_to_frequency(data, i, 1, 1);
    plot(x, y);
end
xlabel('Frequency (Hz)')
ylabel('Magnitude')

%%