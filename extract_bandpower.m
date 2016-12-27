function [ret] = extract_bandpower(  sensor )

for i = 1: 1: 3
   for j = 1: 1: 3
        for k = 1: 1: (i * 40)
            temp{i, j}(k, 1) = bandpower(sensor{i, j}(:, k));
        end
   end
end

ret = temp;

end

