function [ret] = extract_fmaxpeak(  sensor, Fs )

for i = 1: 1: 3
   for j = 1: 1: 3
        for k = 1: 1: (20*2^i)
            [P,f] = periodogram(sensor{i, j}(:, k),[],[],Fs,'power');
            [~,lc] = findpeaks(P,'SortStr','descend');
            temp{i, j}(1, k) = f(lc(1,1));
        end
   end
end

ret = temp;

end

