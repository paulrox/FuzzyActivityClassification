
load MamdaniAllvsAll
load MamdaniA1vsAll
load MamdaniA2vsAll
load MamdaniA3vsAll
load MamdaniA4vsAll
load feat_temp

features_raw = feat_temp;

f1 = 4;
f2 = 5;
f3 = 11;
f4 = 17;

 d1 = cell2mat(features_raw{f1,1}(3,1));
 d2 = cell2mat(features_raw{f2,1}(3,1));
 d3 = cell2mat(features_raw{f3,1}(3,1));
 d4 = cell2mat(features_raw{f4,1}(3,1));
 
start = 1;
fine = 160;

%% Mamdani Classifier AllvsAll 
 %  Test Window 2 Sensor 1
  
 
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];      
 
    output1 = evalfis(input, MamdaniAllvsAll_WINDOW2);
    if (i >= 1 && i <=40)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 41 && i <=80)
        if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 81 && i <=120)
         if output1 > 2 && output1 <=3
            TP = TP +1;
        end
    elseif (i >= 121 && i <=160)
           if output1 > 3 && output1 <=4
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_All_vs_All_WIN3 = TP / 160
 FNR_Mamdani_All_vs_All_WIN3 = 1 - TPR_Mamdani_All_vs_All_WIN3

%% Mamdani Classifier AlvsAll 
 %  Test Window 2 Sensor 1
 
 TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input,MamdaniA1vsAll);
    if (i >= 1 && i <=40)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 41 && i <=80)
        if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 81 && i <=120)
         if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 121 && i <=160)
           if output1 > 1 && output1 <=2
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end

 TPR_Mamdani_A1_vs_All_WIN3 = TP / 160
 FNR_Mamdani_A1_vs_All_WIN3 = 1 - TPR_Mamdani_A1_vs_All_WIN3
 
 %% Mamdani Classifier A2vsAll
 %  Test Window 2 Sensor 1
 
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input,MamdaniA2vsAll);
    if (i >= 1 && i <=40)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 41 && i <=80)
        if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 81 && i <=120)
         if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 121 && i <=160)
           if output1 > 0 && output1 <=1
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_A2_vs_All_WIN3 = TP / 160
 FNR_Mamdani_A2_vs_All_WIN3 = 1 - TPR_Mamdani_A2_vs_All_WIN3

 %% Mamdani Classifier A3vsAll
 %  Test Window 2 Sensor 1
 
 TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input, MamdaniA3vsAll);
    if (i >= 1 && i <=40)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 41 && i <=80)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 81 && i <=120)
         if output1 > 2 && output1 <=3
            TP = TP +1;
        end
    elseif (i >= 121 && i <=160)
           if output1 > 0 && output1 <=1
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_A3_vs_All_WIN3 = TP / 80
 FNR_Mamdani_A3_vs_All_WIN3 = 1 - TPR_Mamdani_A3_vs_All_WIN3
 
 
 %% Mamdani Classifier A4vsAll
 %  Test Window 2 Sensor 1
 
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input,MamdaniA4vsAll);
    if (i >= 1 && i <=40)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 41 && i <=80)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 81 && i <=120)
         if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 121 && i <=160)
           if output1 > 3 && output1 <=4
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_A4_vs_All_WIN3 = TP / 160
 FNR_Mamdani_A4_vs_All_WIN3 = 1 - TPR_Mamdani_A4_vs_All_WIN3
 