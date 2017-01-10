function [ feature_ret ] = add_label( feature, label )
    temp = length(feature) / 4;
    feat_temp = feature;
    for j=1:1:length(feature)
        if (j == temp)
            if label < 4
               label = label + 1;
            end
            temp = temp + length(feature) / 4;
        end
        feat_temp(2,j) = label;
        
    end
    
    feature_ret = feat_temp;
end

