function [ y ] = pattern_fitness( x )
%PATTERN_FITNESS Fitness function for the GA using the patternnet

global pat_net;
global features;
global pat_targets;
global sens_num;

net_in = [features{x(1)}{1,sens_num};
          features{x(2)}{1,sens_num};
          features{x(3)}{1,sens_num};
          features{x(4)}{1,sens_num}];

pat_net = configure(pat_net, net_in, pat_targets{1});
pat_net = setwb(pat_net, x(5:98));
net_out = pat_net(net_in);

y = perform(pat_net,pat_targets{1},net_out);

end

