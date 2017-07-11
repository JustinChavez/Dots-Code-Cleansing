function index_ = taskDiscrim2afcContrast(varargin)
%Task for 2afc Gaussian contrast discrimination, near accelerating PF shoulder
%   index_ = taskDiscrim2afcContrast(varargin)
%
%   no eyetracker
%   lpHID choices
%
%   varargin gets passed to dXtask/set via rAdd.
%
%   index_ specifies the new instance in ROOT_STRUCT.dXtask

% Copyright 2007 by Benjamin Heasly
%   University of Pennsylvania

arg_dXtc = { ...
    'name',         'texture_index', ...
    'values',       1:12, ...
    'ptr',          {{'dXfunctionCaller', 1, 'indices'}}};

arg_dXlr = { ...
    'ptr',          {{'dXtc', 1, 'value'}}, ...
    'coefficient',  pi/13};

% statelist options that make this task special
lcon = {'jump', {'dXlr', 1, 'value'}, [0 1], {'incorrect'; 'correct'}};
rcon = {'jump', {'dXlr', 1, 'value'}, [0 1], {'correct'; 'incorrect'}};
bcon = {'jump', {'dXlr', 1, 'value'}, [0 1], {'error'; 'error'}};
ptrs = {'dXtc', 'dXlr'};
nofp = {{}, 'dXtarget', 1:2};
show = 200;
arg_statelist = {lcon, rcon, bcon, ptrs, nofp, show};

% pointer to dXtexture background color
bgPtr = {'dXtexture', 1, 'bgLum'};

name = mfilename;
cta = common_task_args;
index_ = rAdd('dXtask', 1, {'root', false, true, false}, ...
    'name',	name(5:end), ...
    'blockReps', 10, ...
    'bgColor', bgPtr, ...
    'helpers', { ...
    'dXtc',             1,	{'current', false, true, false},   arg_dXtc; ...
    'dXlr',             1,	{'current', false, true, true},     arg_dXlr; ...
    'gXnachmias_contrast',1,true,                               []; ...
    'gXnachmias_helpers',1, true,                               []; ...
    'gXnachmias_statelist',1,false,	arg_statelist}, ...
    cta{:}, varargin{:});