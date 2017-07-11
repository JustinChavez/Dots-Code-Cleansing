function c_ = draw(c_)%draw method for class dXcorner: prepare graphics for display%   c_ = draw(c_)%%   All DotsX graphics classes have draw methods.  These prepare class%   instances for displaying graphics upon the next dXscreen 'flip'.%%   Updated class instances are always returned.%%----------Special comments-----------------------------------------------%-%%-% Overloaded draw method for class dXcorner%-%%-% Note: this routine always returns the object%-% in case it was changed%----------Special comments-----------------------------------------------%%   See also draw dXcorner% Copyright 2006 by Joshua I. Gold%   University of Pennsylvania% select only visible onesvv = [c_.visible];if any(vv)    % pick a colors to show    %   use same colorState for all objects...whatever    if c_(1).colorState == 1        colors = vertcat(c_(vv).color);        [c_.colorState] = deal(2);    else        colors = vertcat(c_(vv).color2);        [c_.colorState] = deal(1);    end    % type 'Screen FillRect?' for details. Draws all rectangles at once    Screen('FillRect', c_(1).windowNumber, ...        clutX(colors)', ...        vertcat(c_(vv).drawRect)');end