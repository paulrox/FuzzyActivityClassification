%clear
load data.mat
%load sensor_filtered.mat
%load features_raw.mat
%load feat_filtered

feat_temp = extract_features2(sensor_filtered,1/82e-3)';
%%
sensor = 2;
window = 1;
feat = 17;

label = 1


for sensor=1:3
features1 = add_label2(feat_temp{feat, 1}{window, sensor}, label);
plot(features1(1,1), features1(2,1))


hold on
grid on
for i=1:1:length(features1)
    if (features1(2,i) == 1)
        plot(features1(1,i), features1(2,i), 'k*')
    end
    if (features1(2,i) == 2)
        plot(features1(1,i), features1(2,i), 'bo')
    end
    if (features1(2,i) == 3)
        plot(features1(1,i), features1(2,i), 'gx')
    end
    if (features1(2,i) == 4)
        plot(features1(1,i), features1(2,i), 'rs')
    end
    
    
end
end
    

% feature_band1 = extract_bandwidth_windowed( data, 1, 1, Fs, window )
% feature_band2 = extract_bandwidth_windowed( data, 2, 1, Fs, window )   
% feature_band3 = extract_bandwidth_windowed( data, 3, 1, Fs, window )  
% feature_band4 = extract_bandwidth_windowed( data, 4, 1, Fs, window )  
% 
% feature_band1 = add_label(feature_band1, 1);
% feature_band2 = add_label(feature_band2, 2);
% feature_band3 = add_label(feature_band3, 3);
% feature_band4 = add_label(feature_band4, 4);
% 
% 
% hold on
% 
% for i=1:1:10  
%         plot(feature_band1{i}(:,1), feature_band1{i}(:,2), 'k*')
%         plot(feature_band2{i}(:,1), feature_band2{i}(:,2), 'bo')
%         plot(feature_band3{i}(:,1), feature_band3{i}(:,2), 'gx')
%         plot(feature_band4{i}(:,1), feature_band4{i}(:,2), 'rs')
% end
