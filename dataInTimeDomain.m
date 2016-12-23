function [ x, y ] = dataInTimeDomain(data, i, j, k)
% It returns the timestamp and the output of the 
% activity i of patient j by sensor k from the dataset
    
    AiPj = data{i,j};
    AiPjSk = AiPj(:,k);
    
    t = AiPj(:,4);
    
    x = t;
    y = AiPjSk;

end

