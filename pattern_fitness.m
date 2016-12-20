function [ y ] = pattern_fitness( x )
%PATTERN_FITNESS Fitness function for the GA using the patternnet

global pat_net;
global sensor1;
global pat_targets;

net_in = [sensor1(x(1),:);
          sensor1(x(2),:);
          sensor1(x(3),:);
          sensor1(x(4),:)];

pat_net = configure(pat_net, net_in, pat_targets);
pat_net = setwb(pat_net, x(5:98));
% pat_net = train(pat_net,net_in,pat_targets); 
net_out = pat_net(net_in);

y = perform(pat_net,pat_targets,net_out);

end

