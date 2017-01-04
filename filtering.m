%clear
load sensor.mat
load data.mat
load Hd.mat

Fs = 1 / 82e-3;

% plot(data{1,1}(:,4), data{1,1}(:,1));
% hold on;
% plot(data{1,1}(:,4), filter(Hd, detrend(sgolayfilt(data{1,1}(:,1),5, 41))));
% 
% legend('signal','filtered signal');
%obw([data{1,1}(:,1),medfilt1(data{1,1}(:,1),3)], Fs);
%obw([data{1,1}(:,1), sgolayfilt(data{1,1}(:,1), 20, 51)], Fs)

%obw([data{1,1}(:,1) data{2,1}(:,1) data{3,1}(:,1) data{4,1}(:,1)], Fs)

%% Compute Bandwidth Feature

%bandwidth_feat = extract_bandwidth(sensor, Fs);

%fb = max([max(bandwidth_feat{1,1}(1,:)) max(bandwidth_feat{1,2}(1,:)) max(bandwidth_feat{1,3}(1,:))])

%% filtering sensor


for i = 1: 1: 3
   for j = 1: 1: 3
       for k = 1: 1: size(sensor{i, j}, 2)
            
                
           % Low Pass Filter
            sensor_filtered{i, j}(:,k) = filter(Hd, sensor{i, j}(:,k));
        
           
       end
   end
end
