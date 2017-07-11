function graphics_ = gXreadout_graphics(varargin)

% using dots parameters similar to Watamaniuk and Sekuler 1992
%   also add a probe or biasing dots object, like Jazayeri and Movshon
arg_dXdots = { ...
    'x',            0, ...
    'y',            0, ...
    'density',      {51.3, 5.13}, ... %6% 54.37 3.08, ,12% 57.46 6.16probe
    'diameter',     9, ...
    'size',         2, ...
    'speed',        12, ...
    'coherence',    100, ...
    'direction',    0, ...  % for dots #2, to be set later, by dXtc #4, during the task
    'dirDomain',    [], ... % for dots #1, to be set later, during the task
    'dirCDF',       [], ... % for dots #1, to be set later, during the task
    'color',        [1,1,1]*255};

r = [1,0,0]*128;
g = [0,1,0]*128;
b = [0,0,1]*255;
arg_dXtarget = { ...
    'x',            0, ...
    'y',            0, ...
    'penWidth',     1, ...
    'diameter',     .2, ...
    'diameter2',	{6, 2, 2, 2}, ...
    'color',        {b, b, g, r}};

% find the correct Images folder for the current machine
global ROOT_STRUCT
if ROOT_STRUCT.screenMode == 2

    % remote mode
    dir = '/Applications/DotsX/classes/graphics/Images';

else

    % local mode
    %   is this Ling's laptop?
    [stat,result] = unix('hostname');
    if strncmp(result, 'gold-2', 6)

        dir = '/Users/ling/GoldLab/Matlab/mfiles_lab/DotsX/classes/graphics/Images';
    else

        dir = '/Users/lab/GoldLab/Matlab/mfiles_lab/DotsX/classes/graphics/Images';
    end
end

arg_dXimage = { ...
    'dir',          dir, ...
    'file',         'rightArrow.png', ...
    'useTextures',  true, ...
    'preloadTextures', true, ...
    'x',            {6 0}, ...
    'y',            {0 6}, ...
    'color',        {g r}, ...
    'rotationAngle', {0 -90}};


% {'group', reuse, set now, set always}
reswap = {'current', false, true, false};
graphics_ = { ...
    'dXtarget',     4,  reswap, arg_dXtarget; ...
    'dXdots',       2,  reswap, arg_dXdots; ...
    'dXimage',      2,  reswap,	arg_dXimage; ...
    };