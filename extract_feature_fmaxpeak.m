function [ matrix ] = extract_feature_fmaxpeak(data, sensor, Fs)

for k =1:1:10
    for i = 1:1:4
    
        [x, y] = dataInTimeDomain(data, i, k, sensor);
        [P,f] = periodogram(y,[],[],Fs,'power');
        [pk{k}(:, i),lc{k}(:, i)] = findpeaks(P,'SortStr','descend','NPeaks',1);
      
    end
end

for k=1:1:10
    for i=1:1:4
     fp{k}(1,i) = f(lc{k}(1,i));
    end
 
end

% In matrix are stored all max peaks for each activity for each patient

for k=1:1:10
    fp_matrix(k,:) = fp{k};
end
    matrix = fp_matrix;

end

