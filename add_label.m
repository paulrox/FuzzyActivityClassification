function [ feature_ret ] = add_label( feature, label )

for i=1:1:10
    for j=1:1:length(feature{i})
        feature{i}(j,2) = label;
    end
end

feature_ret = feature;
end

