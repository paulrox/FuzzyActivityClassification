function [ y ] = mamdani_all_fitness( x )

global mamdani;
global mamdani_feat;
global mamdani_all_targets;

for i=1:4
    if i==2
        mf_num = 2;
    else
        mf_num = 3;
    end;
    for j=1:mf_num
        if i==2
            mamdani.input(i).mf(j).params = x((j-1)*4+13:4*j+12);
        elseif i == 1
            mamdani.input(i).mf(j).params = x((j-1)*4+1:4*j);
        elseif i == 3
            mamdani.input(i).mf(j).params = x((j-1)*4+21:4*j+20);
        elseif i == 4
            mamdani.input(i).mf(j).params = x((j-1)*4+33:4*j+32);
        end;
    end;
end;

for i=1:8
    x_temp = x((i-1)*5+45:5*i+44);
    mamdani.rule(i).antecedent = x_temp(1:4);
    mamdani.rule(i).consequent = x_temp(5);
end;

res = evalfis(mamdani_feat,mamdani);
filter_res = zeros(40,1);

for i=1:40
    if res(i) >= 0 && res(i) < 1
        filter_res(i) = 0;
    elseif res(i) >= 1 && res(i) < 2
        filter_res(i) = 1;
    elseif res(i) >= 2 && res(i) < 3
        filter_res(i) = 2;
    else
        filter_res(i) = 3;
    end;
end;

y = -sum(mamdani_all_targets == filter_res);

end


        


