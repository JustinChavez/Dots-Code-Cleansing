function index_ = taskModalityFVTLever(varargin)
%FVT Dots task with diagonal motion and lever pulls
%
%   index_ = taskModalityFVTLever(varargin)
%
%   eye tracker for fixation
%   levers for choices
%
%   varargin may contain e.g. {'rightAng', 45, ...} which determines
%   the dot direction associated with a rightward response.  The rest gets
%   passed to dXtask/set via rAdd.
%
%   index_ specifies the new instance in ROOT_STRUCT.dXtask

% copyright 2008 Benjamin Heasly University of Pennsylvania

% which dot direction corresponds to an upward eye response?
if nargin>1 && ischar(varargin{1}) && strcmp(varargin{1}, 'dotParams') ...
        && isstruct(varargin{2})

    arg_dot = {'down-up', varargin{2}};
    varargin(1:2) = [];
else
    arg_dot = {'down-up', []};
end

% name of this task
name = mfilename;

% actions specific to lever pull task
respond = { ...
    'dXkbHID',  {'j', 'right', 'f', 'left'}; ...
    'dXPMDHID', {11, 'right', 9, 'left'}; ...
    'dXasl',    {[1, false], 'error'}};
up = {};
down = {};
left = { ...
    'dXkbHID',  {'j', 'both'}; ...
    'dXPMDHID',	{11, 'both'}; ...
    'dXasl',    {[1, false], 'error'}};
right = { ...
    'dXkbHID',  {'f', 'both'}; ...
    'dXPMDHID',	{9, 'both'}; ...
    'dXasl',    {[1, false], 'error'}};

% Eye task uses two targets
targets = {};

% customize the statelist for eye movements
arg_statelist = {respond, up, down, left, right, targets, name(5:end)};

% get general task settings for modality tasks
arg_dXtask = modality_task_args;

% create this specific task
index_ = rAdd('dXtask', 1, {'root', false, true, false}, ...
    'name',         name(5:end), ...
    'blockReps',    50, ...
    'helpers',      { ...
            'gXmodality_hardware',          1,  true,	{}; ...
            'gXmodality_graphics',          1,  true,	arg_dot; ...
            'gXmodality_motionControl',     1,  false,	arg_dot; ...
            'gXmodalityFVT_statelist',      1,  false,	arg_statelist; ...
            }, ...
    arg_dXtask{:}, varargin{:});