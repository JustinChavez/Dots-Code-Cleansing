% Run Snow Dots in pure server mode
% $Id: dotsServer.m 109 2010-09-29 20:56:14Z askliu $
% @param duration time in seconds to keep running.  Default is 3600--one
% hour.  May be inf, if you trust.
% @details
% Lets some remote managers run continuously.  Remote managers from
% another Matlab instance (on this or a different machine) may send
% transaction messages which will control behavior here on the server side.
% @details
% Note that for dotsServer to work, dotsTheMessenger must be configured
% with correct IP addresses and ports.  See dotsTheMachineConfiguration for
% how to specify these values for your machines.
% @ingroup utilities
function dotsServer(duration)
clear classes

if ~nargin || isempty(duration)
    duration = 60*60*10;
end

dm = dotsThePlayablesManager.theObject;
dm.serverMode = true;
dm.clientMode = false;
waitFunction = @()WaitSecs(.001);

group = 'dots server';
serverLoop = topsFunctionLoop;
serverLoop.addFunctionToGroupWithRank({@step, dm}, group, 10);
serverLoop.addFunctionToGroupWithRank({waitFunction}, group, 100);

disp(' ')
disp('DOTS SERVER IS RUNNING...')
disp(' ')
serverLoop.runForGroup(group, duration);