function val_ = get(v, propertyName)%get method for class dXvideo: query property values%   val_ = get(v, propertyName)%%   All DotsX classes have a get method which returns a specified property%   for a class instance, or a struct containing the values of all the%   properties of one or more instances.%%----------Special comments-----------------------------------------------%-%%-% Overloaded get method for class dXvideo%-%%-% Get the value of a particular property from%-% the specified image object%----------Special comments-----------------------------------------------%%   See also get dXvideo% Copyright 2008 by Benjamin Heasly%   University of Pennsylvania% just return the value of the given fieldname%   for the first objectval_ = v(1).(propertyName);