function val_ = get(t, propertyName)%get method for class dXtarget: query property values
%   val_ = get(t, propertyName)%
%   All DotsX classes have a get method which returns a specified property
%   for a class instance, or a struct containing the values of all the
%   properties of one or more instances.
%
%----------Special comments-----------------------------------------------
%-%%-% Overloaded get method for class dXtarget%-%%-% Get the value of a particular property from%-% the specified target object%----------Special comments-----------------------------------------------
%
%   See also get dXtarget
% Copyright 2004 by Joshua I. Gold%   University of Pennsylvania% just return the value of the given fieldname%   for the first objectval_ = t(1).(propertyName);