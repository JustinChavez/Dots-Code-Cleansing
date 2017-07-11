% test some questage

clear all

global ROOT_STRUCT
rInit('debug');

name = 'testQ';
rAdd('dXtask', 1, 'name', name);

rGroup(name);
% arg_dXquest = { ...
%     'stimRange',    [.5, 200], ...
%     'stimValues',   1:100, ...
%     'refStim',      10, ...
%     'guessStim',    50, ...
%     'Tstd',         9, ...
%     'estimateType', 'mean', ...
%     'psychParams',  [0 2.5 .01 .5], ...
%     'goPastConvergence', true, ...
%     'name',         'cohQ81',...
%     'ptr',          {{'dXdots', 1, 'coherence'}}, ...
%     'showPlot',     true};

arg_dXquest = { ...
    'stimRange',    [0.010, 3.000], ...
    'stimValues',   [], ...
    'refStim',      .2, ...
    'guessStim',    .5, ...
    'Tstd',         9, ...
    'estimateType', 'mean', ...
    'psychParams',  [0 2.5 .01 .5], ...
    'goPastConvergence', true, ...
    'name',         'timeQ81', ...
    'ptr',          {{}}, ...
    'showPlot',     true};

rAdd('dXquest', 1, arg_dXquest{:});

% simualte some trial
outcome = {'incorrect', 'correct'};
for ii = 1:100
    dB = rGet('dXquest', 1, 'dBvalue');
    c = rand < dBWeibull(dB, [0 2.5 .01 .5]);
    ROOT_STRUCT.dXquest = ...
        endTrial(ROOT_STRUCT.dXquest, true, outcome(c+1));
end

rDone