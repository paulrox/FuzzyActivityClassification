function [ y ] = pattern_union_fitness( x )
%PATTERN_UNION_FITNESS Fitness function for the GA using the patternnet

global pat_union_net;
global features_union;
global pat_union_targets;

net_in = [features_union{x(1)}{1};
    features_union{x(2)}{1};
    features_union{x(3)}{1};
    features_union{x(4)}{1}];

pat_union_net = configure(pat_union_net, net_in, ...
    pat_union_targets{1});
pat_union_net = setwb(pat_union_net, x(5:98));
net_out = pat_union_net(net_in);

y = perform(pat_union_net,pat_union_targets{1},net_out);

end

