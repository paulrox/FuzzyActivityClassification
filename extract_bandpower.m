function [ret] = extract_bandpower(  sensor )

for i = 1: 1: 3
   for j = 1: 1: 3
        for k = 1: 1: (20*2^i)
            temp{i, j}(1, k) = bandpower(sensor{i, j}(:, k));
        end
   end
end

ret = temp;

end

