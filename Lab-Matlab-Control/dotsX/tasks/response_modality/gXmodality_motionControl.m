function motionControl_ = gXmodality_motionControl(varargin)

% what is the dot location and motion axis?
if nargin==2 && ischar(varargin{1}) && isstruct(varargin{2})
    dot = varargin{2};
else
    dot.ang = 45;
end

b = 1.5;
l = .01;
g = .5;
arg_dXquest = { ...
    'T0',           0, ...
    'Tstd',         10, ...
    'blankValue',   nan, ...
    'refValue',     2.^7/10, ...
    'values',       [2.^(5:9)/10, 99], ...
    'estimateType', 'mean', ...
    'psychParams',  { ...
                    [6   b l g], ...
                    [1   b l g], ...
                    [-4  b l g], ...
                    [-10 b l g], ...
                    }, ...
    'CIsignif',     .95, ...
    'CIcritdB',     2, ... % dB width defining converged CI
    'goPastConvergence', true, ...
    'name',         {'Q65', 'Q84', 'Q92', 'Q99'}, ...
    'ptr',          {{'dXdots', 1, 'coherence'}}, ...
    'showPlot',     false};

arg_dXtc = { ...
    'name',     'dot_dir', ...
    'values',	[0, 180]+dot.ang, ...
    'ptr',      {{'dXdots', 1, 'direction'}}};

arg_dXlr = { ...
    'ptr',      {{'dXdots', 1, 'direction'}}};

arg_dXdu = { ...
    'ptr',      {{'dXdots', 1, 'direction'}}};

% {'group', reuse, set now, set always}
static = {'current', true, true, false};
reswap = {'current', false, true, true};
motionControl_ = { ...
    'dXquest',	4,  reswap, arg_dXquest; ...
    'dXtc',     1,  reswap, arg_dXtc; ...
    'dXlr',     1,  static, arg_dXlr; ...
    'dXdu',     1,  static, arg_dXdu; ...
    };