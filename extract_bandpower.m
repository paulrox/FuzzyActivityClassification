function [matrix] = extract_bandpower(  data, sensor )

for k=1:1:10
    for i=1:1:4
        [x, y] = dataInTimeDomain(data, i, k, sensor);
        bp{k}{1,i} = bandpower(y);
    end
end

% In bw_matrix are stored all bandwidths for each activity for each patient

for k=1:1:10
    bp_matrix(k,:) = bp{k};
end

    matrix = bp_matrix;

end

