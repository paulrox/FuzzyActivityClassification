function [ matrix ] = extract_feature_bandwidth( data, sensor, Fs)

for k=1:1:10
    for i=1:1:4
        [x, y] = dataInTimeDomain(data, i, k, sensor);
        bw{k}{1,i} = obw(y, Fs);
    end
end

% In bw_matrix are stored all bandwidths for each activity for each patient

for k=1:1:10
    bw_matrix(k,:) = bw{k};
end

    matrix = bw_matrix;
end

