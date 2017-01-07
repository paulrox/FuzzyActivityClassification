%clear
% data.mat
%load sensor_filtered.mat
%load features_raw.mat
%load feat_filtered

feat_temp = extract_features2(sensor_filtered,1/82e-3)';
%%
window = 1;
feat = 5;

label = 1;


for sensor=2:3
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
    title('Average Distance Peaks Feature Distribution')
   
