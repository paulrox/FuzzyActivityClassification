function [ matrix ] = extract_averagedistance_peaks(data, sensor, Fs)

for k =1:1:10
    for i = 1:1:4
    
        [x, y] = dataInTimeDomain(data, i, k, sensor);
        [P,f] = periodogram(y,[],[],Fs,'power');
        [pk,lc] = findpeaks(P);
        AverageDistance_Peaks{k}(1,i) = mean(diff(f(lc)));
      
    end
end


for k=1:1:10
    av_matrix(k,:) = AverageDistance_Peaks{k};
end
    matrix = av_matrix;

end

