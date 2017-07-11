function event_ = rGraphicsDraw(duration, dont_clear)% function event_ = rGraphicsDraw(duration, dont_clear)%% Calls class-specific draw routine for all the%   drawable objects in ROOT_STRUCT, then draws by%   flipping the screen buffers (once)%% Arguments:%   duration    ... in ms, time to loop draw commands%   dont_clear  ... flag sent to Screen('Flip', ...) default false%% Returns:%   event_      ... a keyboard event that terminated drawing%                   event = [keyCode, value, time];% Copyright 2005 by Joshua I. Gold%   University of Pennsylvaniaglobal ROOT_STRUCTevent_ = [];if nargin < 1    duration = 0;else    % clear old keyboard values for event checking    ROOT_STRUCT.dXkbHID = reset(ROOT_STRUCT.dXkbHID);endif nargin < 2 || isempty(dont_clear)    dont_clear = 0;else    dont_clear = double(dont_clear);end% if nargin < 3 || isempty(wait_for_return)%     wait_for_return = false;% endif ROOT_STRUCT.screenMode == 2        %   drawFlag = 1 ... draw, clear buffer    %   drawFlag = 2 ... draw, do NOT clear buffer    %   drawFlag = 3 ... draw ONCE, clear buffer    %   drawFlag = 4 ... draw ONCE, do NOT clear buffer    df = 4 - 2*(duration > 0) - ~dont_clear;    msg = sprintf('draw_flag=%d;', df);endif nargin < 1 || duration == 0    % flip buffers once    switch ROOT_STRUCT.screenMode        case 0            % debug mode, do nothing        case 1            % loop through the drawables            for dr = ROOT_STRUCT.methods.draw                % call class-specific draw                ROOT_STRUCT.(dr{:}) = draw(ROOT_STRUCT.(dr{:}));            end            % send done drawing command .. sometimes optimizes            Screen('DrawingFinished', ROOT_STRUCT.windowNumber, dont_clear);            % flip the buffers            Screen('Flip', ROOT_STRUCT.windowNumber, 0, dont_clear);        case 2            % remote mode            sendMsgH(msg);    endelse    % flip buffers for duration    start_time = GetSecs;    % convert duration to seconds    duration = duration/1000;    % if remote, send command first    if ROOT_STRUCT.screenMode == 2        sendMsgH(msg);    end    % loop until done    while GetSecs - start_time < duration        if ROOT_STRUCT.screenMode == 1            % loop through the drawables            for dr = ROOT_STRUCT.methods.draw                % call class-specific draw                ROOT_STRUCT.(dr{:}) = draw(ROOT_STRUCT.(dr{:}));            end            % send done drawing command .. sometimes optimizes            Screen('DrawingFinished', ROOT_STRUCT.windowNumber, dont_clear);            % flip the buffers            Screen('Flip', ROOT_STRUCT.windowNumber, 0, dont_clear);        else            % pause briefly            WaitSecs(0.002);        end        % check for keypress        HIDx('run');        v = get(ROOT_STRUCT.dXkbHID, 'values');        if(~isempty(v))            event_ = v(1,:);            break        end    end    % if remote, send done command    if ROOT_STRUCT.screenMode == 2        sendMsgH('draw_flag=0;');    endend