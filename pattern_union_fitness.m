function [ y ] = pattern_union_fitness( x )
%PATTERN_UNION_FITNESS Fitness function for the GA using the patternnet

global pat_union_net;
global features_union;
global pat_union_targets;
global t_interval_union;

net_in = [features_union{x(1)}{t_interval_union};
    features_union{x(2)}{t_interval_union};
    features_union{x(3)}{t_interval_union};
    features_union{x(4)}{t_interval_union}];

pat_union_net = configure(pat_union_net, net_in, ...
    pat_union_targets{t_interval_union});
pat_union_net = setwb(pat_union_net, x(5:98));
net_out = pat_union_net(net_in);

y = perform(pat_union_net,pat_union_targets{t_interval_union},net_out);

end

