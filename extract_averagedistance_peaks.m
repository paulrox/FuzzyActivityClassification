function [ret] = extract_averagedistance_peaks(  sensor, Fs )

for i = 1: 1: 3
   for j = 1: 1: 3
        for k = 1: 1: (i * 40)
            [P, f] = periodogram(sensor{i, j}(:, k),[],[],Fs,'power');
            [~, lc] = findpeaks(P);
            temp{i, j}(k, 1) = mean(diff(f(lc)));
        end
   end
end

ret = temp;

end

