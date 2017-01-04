function [ y ] = pattern_fitness( x )
%PATTERN_FITNESS Fitness function for the GA using the patternnet

global pat_net;
global features;
global pat_targets;
global t_interval sens_num;

net_in = [features{x(1)}{t_interval,sens_num};
          features{x(2)}{t_interval,sens_num};
          features{x(3)}{t_interval,sens_num};
          features{x(4)}{t_interval,sens_num}];

pat_net = configure(pat_net, net_in, pat_targets{t_interval});
pat_net = setwb(pat_net, x(5:98));
net_out = pat_net(net_in);

y = perform(pat_net,pat_targets{t_interval},net_out);

end

