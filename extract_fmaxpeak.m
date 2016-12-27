function [ret] = extract_fmaxpeak(  sensor, Fs )

for i = 1: 1: 3
   for j = 1: 1: 3
        for k = 1: 1: (i * 40)
            [P,f] = periodogram(sensor{i, j}(:, k),[],[],Fs,'power');
            [~,lc] = findpeaks(P,'SortStr','descend','NPeaks',1);
            temp{i, j}(k, 1) = f(lc);
        end
   end
end

ret = temp;

end

