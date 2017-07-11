function t_ = draw(t_)%draw method for class dXtext: prepare graphics for display%   t_ = draw(t_)%%   All DotsX graphics classes have draw methods.  These prepare class %   instances for displaying graphics upon the next dXscreen 'flip'.%%   Updated class instances are always returned.%%----------Special comments-----------------------------------------------%-%%-% Overloaded draw method for class dXtext%-%%-% Note: this routine always returns the object%-% in case it was changed%----------Special comments-----------------------------------------------%%   See also draw dXtext% Copyright 2004 by Joshua I. Gold%   University of Pennsylvaniawn = t_(1).windowNumber;%get realif wn <= 0    return;end% draw only visible objectsfor ti = find([t_.visible]);    % this stuff is FAST    Screen('TextMode',  wn, t_(ti).mode);    Screen('TextSize',  wn, t_(ti).size);    Screen('TextStyle', wn, ...        t_(ti).bold + t_(ti).italic*2 + t_(ti).underline*4 + t_(ti).outline*8);    Screen('TextFont', wn, t_(ti).font);    % this is, uh, slower    Screen('DrawText', wn, t_(ti).string, ...        t_(ti).screen_x, t_(ti).screen_y, clutX(t_(ti).color));end