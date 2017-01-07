
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

 %% Mamdani Classifier AllvsAll
 %  Test Window 1 Sensor 1
 
 d1 = cell2mat(features_raw{f1,1}(1,1));
 d2 = cell2mat(features_raw{f2,1}(1,1));
 d3 = cell2mat(features_raw{f3,1}(1,1));
 d4 = cell2mat(features_raw{f4,1}(1,1));
 
start = 1;
fine = 40;
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];      
 
    output1 = evalfis(input, MamdaniAllvsAll);
    if (i >= 1 && i <=10)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 11 && i <=20)
        if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 21 && i <=30)
         if output1 > 2 && output1 <=3
            TP = TP +1;
        end
    elseif (i >= 31 && i <=40)
           if output1 > 3 && output1 <=4
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_All_vs_All = TP / 40
 FNR_Mamdani_All_vs_All = 1 - TPR_Mamdani_All_vs_All

 
 %% Mamdani Classifier A1vsAll
 %  Test Window 1 Sensor 1
 
 d1 = cell2mat(features_raw{f1,1}(1,1));
 d2 = cell2mat(features_raw{f2,1}(1,1));
 d3 = cell2mat(features_raw{f3,1}(1,1));
 d4 = cell2mat(features_raw{f4,1}(1,1));
 
start = 1;
fine = 40;
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input,MamdaniA1vsAll);
    if (i >= 1 && i <=10)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 11 && i <=20)
        if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 21 && i <=30)
         if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 31 && i <=40)
           if output1 > 1 && output1 <=2
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_A1_vs_All = TP / 40
 FNR_Mamdani_A1_vs_All = 1 - TPR_Mamdani_A1_vs_All

 
 %% Mamdani Classifier A2vsAll
 %  Test Window 1 Sensor 1
 
 d1 = cell2mat(features_raw{f1,1}(1,1));
 d2 = cell2mat(features_raw{f2,1}(1,1));
 d3 = cell2mat(features_raw{f3,1}(1,1));
 d4 = cell2mat(features_raw{f4,1}(1,1));
 
start = 1;
fine = 40;
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input,MamdaniA2vsAll);
    if (i >= 1 && i <=10)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 11 && i <=20)
        if output1 > 1 && output1 <=2
            TP = TP +1;
        end
    elseif (i >= 21 && i <=30)
         if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 31 && i <=40)
           if output1 > 0 && output1 <=1
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_A2_vs_All = TP / 40
 FNR_Mamdani_A2_vs_All = 1 - TPR_Mamdani_A2_vs_All
 %% Mamdani Classifier A3vsAll
 %  Test Window 1 Sensor 1
 
 d1 = cell2mat(features_raw{f1,1}(1,1));
 d2 = cell2mat(features_raw{f2,1}(1,1));
 d3 = cell2mat(features_raw{f3,1}(1,1));
 d4 = cell2mat(features_raw{f4,1}(1,1));
 
start = 1;
fine = 40;
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input, MamdaniA3vsAll);
    if (i >= 1 && i <=10)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 11 && i <=20)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 21 && i <=30)
         if output1 > 2 && output1 <=3
            TP = TP +1;
        end
    elseif (i >= 31 && i <=40)
           if output1 > 0 && output1 <=1
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_A3_vs_All = TP / 40
 FNR_Mamdani_A3_vs_All = 1 - TPR_Mamdani_A3_vs_All
 
 
 %% Mamdani Classifier A4vsAll
 %  Test Window 1 Sensor 1
 
 d1 = cell2mat(features_raw{f1,1}(1,1));
 d2 = cell2mat(features_raw{f2,1}(1,1));
 d3 = cell2mat(features_raw{f3,1}(1,1));
 d4 = cell2mat(features_raw{f4,1}(1,1));
 
start = 1;
fine = 40;
TP = 0;
 for i = start:fine
 
    input = [d1(1,i) d2(1,i) d3(1,i) d4(1,i)];       
 
    output1 = evalfis(input,MamdaniA4vsAll);
    if (i >= 1 && i <=10)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 11 && i <=20)
        if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 21 && i <=30)
         if output1 > 0 && output1 <=1
            TP = TP +1;
        end
    elseif (i >= 31 && i <=40)
           if output1 > 3 && output1 <=4
            TP = TP +1;
        end 
     end
   
    hold on;
 
    plot(i, output1, 'gx')
 
 end
 
 TPR_Mamdani_A4_vs_All = TP / 40
 FNR_Mamdani_A4_vs_All = 1 - TPR_Mamdani_A4_vs_All
 
 