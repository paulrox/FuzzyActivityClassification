function [state, options,optchanged] = ga_output(options,state,flag)
%GA_OUTPUT Template to write custom OutputFcn for GA.
%   [STATE, OPTIONS, OPTCHANGED] = GAOUTPUTFCNTEMPLATE(OPTIONS,STATE,FLAG)
%   where OPTIONS is an options structure used by GA. 
%
%   STATE: A structure containing the following information about the state 
%   of the optimization:
%             Population: Population in the current generation
%                  Score: Scores of the current population
%             Generation: Current generation number
%              StartTime: Time when GA started 
%               StopFlag: String containing the reason for stopping
%              Selection: Indices of individuals selected for elite,
%                         crossover and mutation
%            Expectation: Expectation for selection of individuals
%                   Best: Vector containing the best score in each generation
%        LastImprovement: Generation at which the last improvement in
%                         fitness value occurred
%    LastImprovementTime: Time at which last improvement occurred
%
%   FLAG: Current state in which OutputFcn is called. Possible values are:
%         init: initialization state 
%         iter: iteration state
%    interrupt: intermediate state
%         done: final state
% 		
%   STATE: Structure containing information about the state of the
%          optimization.
%
%   OPTCHANGED: Boolean indicating if the options have changed.
%
%	See also PATTERNSEARCH, GA, OPTIMOPTIONS

%   Copyright 2004-2015 The MathWorks, Inc.

global history;

optchanged = false;

switch flag
 case 'init'
        % disp('Starting the algorithm');
        history.best = [];
        history.mean = [];
        history.gen = [];
    case {'iter','interrupt'}
        % disp('Iterating ...')
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
         %history.best = [history.best; state.Best];
         history.mean = [history.mean; mean(state.Score)];
         history.gen = [history.gen; state.Generation];
    case 'done'
        history.best = state.Best';
        % disp('Performing final task');
end
