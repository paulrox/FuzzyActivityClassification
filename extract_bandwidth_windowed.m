function [ feature ] = extract_bandwidth_windowed( data, activity, sensor, Fs, window )
   
    for j = 1: 1: 10
        % The number of samples is the last timestamp divided by the
        % selected window
        Nsamples = floor(data{activity, j}(2000, 4) / window);
        t = 1;
        for k = 1: 1: Nsamples
            index = 1;
            while (data{activity, j}(t, 4) < (k * window))
                  temp(:,index) = data{activity, j}(t, sensor);
                  t = t + 1;
                  index = index + 1;
            end
            
            feature_t{j}(k, :) = obw(temp, Fs);
        end
    end
    
    feature = feature_t;
end

