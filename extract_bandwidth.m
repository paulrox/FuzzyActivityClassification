function [ret] = extract_bandwidth(  sensor, Fs )

for i = 1: 1: 3
   for j = 1: 1: 3
        for k = 1: 1: (20*2^i)
            temp{i, j}(k, 1) = obw(sensor{i, j}(:, k), Fs);
        end
   end
end

ret = temp;

end

