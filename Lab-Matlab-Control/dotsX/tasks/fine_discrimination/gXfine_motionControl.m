function motionControl_ = gXmodality_motionControl(varargin)

arg_dXquest = { ...
    'T0',           0, ...
    'Tstd',         10, ...
    'blankValue',   nan, ...
    'refValue',     2.^7/10, ...
    'values',       [2.^(5:9)/10, 99], ...
    'estimateType', 'mean', ...
    'psychParams',  [-3, 2, .01, .5], ...
    'CIsignif',     .95, ...
    'CIcritdB',     2, ... % dB width defining converged CI
    'goPastConvergence', true, ...
    'name',         'Q92', ...
    'ptr',          {{'dXdots', 1, 'coherence'}}, ...
    'showPlot',     false};

% dXtc just keeps track of 2afc trial condition
%   0 = "same" (50%)
%   1 = "different" in interval 1 (25%)
%   2 = "different" in interval 2 (25%)
arg_dXtc = { ...
    'name',     'different_interval', ...
    'values',	[0 0 1 2]};

% {'group', reuse, set now, set always}
static = {'current', true, true, false};
reswap = {'current', false, true, true};
motionControl_ = { ...
    'dXquest',	1,  reswap, arg_dXquest; ...
    'dXtc',     1,  reswap, arg_dXtc; ...
    };