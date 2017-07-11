function [taskTree, taskList] = configAudDotTask

% $Id: configAudDotTask.m 110 2010-10-01 16:24:39Z askliu $

% Auditory Dots Task
% Auditory equivalant (putative) of the random dot kinetogram
% Psychophysics experiments to characterize the equivalance between
% auditory and visual decision making

% Author: Andrew Liu, Auditory Research Lab, Univ. of Penn

% portions of code adapted from Matt Nasser's (Josh Gold lab) predictive inference task code
% (which, fyi, is adapted from the snow-dots demo code:
% configureDots2afcTask.m)


%% Initialize snow-dots structures
% Keep track of time using psychtoolbox, this affects timestamps in
% DATA-file
dataLog=topsDataLog.theDataLog;
dataLog.clockFunction = @GetSecs;


%   the taskList is a container for prespecified variables and objects
%   partitioned into arbitrary groups
%   viewable with taskList.gui
taskList = topsGroupedList;
taskName = 'AudDot';

% session start Time Of Day
sessionStartTOD = clock;

%% Setup paramters for stimulus & task
% stimulus parameters
taskList{'stimulus'}{'coherence'} = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1];

% how many trials per block per coherence/direction pair?
% here, assuming uniform sampling across stimulus conditions
% cols = # of coherence conditions; rows = # of direction conditions
taskList{'stimulus'}{'trials count'} = [3 3 3 3 3 3 3 3 3 3 3;...
    3 3 3 3 3 3 3 3 3 3 3];

taskList{'stimulus'}{'directions'} = [1 -1]; %1 for up, -1 for down

taskList{'stimulus'}{'freq hi'} = 6000; %hz, upper end of freq range
taskList{'stimulus'}{'freq lo'} = 1000; %hz, lower end of freq range
taskList{'stimulus'}{'freq step'} = 50; %hz, frequency step of each tone burst

taskList{'stimulus'}{'tone duration'} = 50; %ms, length of tone
taskList{'stimulus'}{'tone soa'} = 150; %ms, average intertone interval

taskList{'stimulus'}{'trial duration'}= 5000; %ms, length of trial

taskList{'stimulus'}{'trial matrix'} = genTrialParameters(taskList);

% task parameters
taskList{'control'}{'session time'} = [num2str(sessionStartTOD(1)) num2str(sessionStartTOD(2)) num2str(sessionStartTOD(3)) num2str(sessionStartTOD(4)) num2str(sessionStartTOD(5))];
taskList{'control'}{'taskList file name'} = strcat(taskName,datestr(sessionStartTOD,'yyyymmdd.HHMMSS'),'_TaskList','.mat');% name of data file and taskList to be saved

taskList{'control'}{'trials per block'} = sum(sum(taskList{'stimulus'}{'trials count'}'));
taskList{'control'}{'blocks per session'} = 1; % how many blocks per session?
taskList{'control'}{'trial presentation'} = 'random'; % block vs. random trial presentation within a block
taskList{'control'}{'task name'} = taskName;

% running tally of performance
taskList{'control'}{'correct trials'} = 0;
taskList{'control'}{'incorrect trials'} = 0;
taskList{'control'}{'error trials'} = 0;

taskList{'control'}{'trials complete'} = 0;
taskList{'control'}{'blocks complete'} = 0;

taskList{'control'}{'last outcome'} = [];
taskList{'control'}{'last RT'} = [];
taskList{'control'}{'sum RT'} = 0;

taskList{'control'}{'mean RT'} = 0;
taskList{'control'}{'percent correct'} = 0;

% ATTENTION!!! NOTICE!!
% in the task, the taskList group taskList{'cur trial'} is instantiated with
% information relevent to the trial at hand (stim start time, response recorded time,

% countdown parameters
taskList{'countdown'}{'show countdown'} = 1; % 1 to show instructions, 0 to not show instructions
taskList{'countdown'}{'font size'} = 80; % font size in ??? units
taskList{'countdown'}{'text position'} = 0; % y position for centered text
taskList{'countdown'}{'text color'} = [255 255 255];
taskList{'countdown'}{'black'} = [0 0 0];

% outcome parameters
taskList{'outcome'}{'show outcome'} = 1;
taskList{'outcome'}{'size'} = 40;
taskList{'outcome'}{'green'} = [0 255 0];
taskList{'outcome'}{'red'} = [255 0 0];
taskList{'outcome'}{'yellow'} = [255 255 0];
taskList{'outcome'}{'black'} = [0 0 0];

taskList{'instructions'}{'show instructions'} = 0;
taskList{'instructions'}{'font size'} = 40;
taskList{'instructions'}{'text position'} = 0;
taskList{'instructions'}{'green'} = [0 255 0];
taskList{'instructions'}{'red'} = [255 0 0];
taskList{'instructions'}{'black'} = [0 0 0];

% screen parameters
taskList{'screen'}{'full screen'} = 1; % 1 for full screen, 0 for not full screen
taskList{'screen'}{'displayIndex'} = 1; % see PTB docs; corresponds to output of Screen('Screens')

% graphics parameters
taskList{'graphics'}{'text on'} = 1; %1 for text to be visible

% timing parameters
taskList{'timing'}{'GO time'} = 0.5; %s, time to display 'GO!'
taskList{'timing'}{'prep countdown'} = 0.75; %s, time to countdown '3,2,1..'
taskList{'timing'}{'outcome timeout'} = 1.5; %s, time to display outcome
taskList{'timing'}{'intertrial'} = 0.5; %s, time after end of trial and before next trial
taskList{'timing'}{'trial timeout'} = 60; %s, time to wait before ending trial (if nothing happens; this usually will not happen)
%% Setup objects that comprise the task

% aud dots connector object (subclass of dotsPlayable)
pm = dotsThePlayablesManager.theObject;

stim = pm.newObject('AudDotPlayable');

taskList{'stimulus'}{'stimulus'} = stim;

% setup screen

% visual/display elements
dm = dotsTheDrawablesManager.theObject;

%kludge to make snow-dots/PTB display correctly on the 2nd display
if length(Screen('Screens')) > 1
    dm.theScreen.displayIndex = 1;
    dm.theScreen.reset();
    dm.theScreen.displayRect = dm.theScreen.displayPixels;
end

%% Instruction Text (not in use currently)
instructionsText0 = dm.newObject('dotsDrawableText');
if taskList{'instructions'}{'show instructions'} ==1
    instructionsText0.color = taskList{'instructions'}{'text color'};
else
    instructionsText0.color = taskList{'instructions'}{'black'};
end
instructionsText0.x = 0;
instructionsText0.y =  taskList{'instructions'}{'text position'};
instructionsText0.string = 'When READY is displayed, press and release L and R triggers to begin.';
instructionsText0.isVisible = taskList{'graphics'}{'text on'};
instructionsText0.backgroundColor = [0 0 0 0];
taskList{'instructions'}{'instructionsText0'}=instructionsText0;

instructionsText1 = dm.newObject('dotsDrawableText');
if taskList{'instructions'}{'show instructions'} ==1
    instructionsText1.color = taskList{'instructions'}{'text color'};
else
    instructionsText1.color = taskList{'instructions'}{'black'};
end
instructionsText1.x = 0;
instructionsText1.y =  taskList{'instructions'}{'text position'};
instructionsText1.string = 'When the sound starts playing, respond as quickly as you can, whether the sound is going up or going down.';
instructionsText1.isVisible = taskList{'graphics'}{'text on'};
instructionsText1.backgroundColor = [0 0 0 0];
taskList{'instructions'}{'instructionsText Speed'}=instructionsText1;

instructionsText2 = dm.newObject('dotsDrawableText');
if taskList{'instructions'}{'show instructions'} ==1
    instructionsText2.color = taskList{'instructions'}{'text color'};
else
    instructionsText2.color = taskList{'instructions'}{'black'};
end
instructionsText2.x = 0;
instructionsText2.y =  taskList{'instructions'}{'text position'};
instructionsText2.string = 'When the sound starts playing, respond as accurately as you can, whether the sound is going up or going down.';
instructionsText2.isVisible = taskList{'graphics'}{'text on'};
instructionsText2.backgroundColor = [0 0 0 0];
taskList{'instructions'}{'instructionsText Accuracy'}=instructionsText2;
% add instructions graphics to a group:
% dm.addObjectToGroup(instructionsText0, taskName);
% dm.addObjectToGroup(instructionsText1, taskName);
% dm.addObjectToGroup(instructionsText2, taskName);


%% Count Down Text
% READY?
countdownText0 = dm.newObject('dotsDrawableText');
if taskList{'countdown'}{'show countdown'} == 1
    countdownText0.color = taskList{'countdown'}{'text color'};
else
    countdownText0.color = taskList{'countdown'}{'black'};
end
countdownText0.x = 0;
countdownText0.y = 0;% taskList{'countdown'}{'text position'};
countdownText0.string = '3';
countdownText0.isVisible = false;
countdownText0.backgroundColor = [0 0 0 0];
taskList{'countdown'}{'3'} = countdownText0;

% 3!
countdownText1 = dm.newObject('dotsDrawableText');
if taskList{'countdown'}{'show countdown'} == 1
    countdownText1.color = taskList{'countdown'}{'text color'};
else
    countdownText1.color = taskList{'countdown'}{'black'};
end
countdownText1.x = 0;
countdownText1.y =  taskList{'countdown'}{'text position'};
countdownText1.string = '2';
countdownText1.isVisible = false;
countdownText1.backgroundColor = [0 0 0 0];
taskList{'countdown'}{'2'} = countdownText1;

% 2!
countdownText2 = dm.newObject('dotsDrawableText');
if taskList{'countdown'}{'show countdown'} == 1
    countdownText2.color = taskList{'countdown'}{'text color'};
else
    countdownText2.color = taskList{'countdown'}{'black'};
end
countdownText2.x = 0;
countdownText2.y =  taskList{'countdown'}{'text position'};
countdownText2.string = '1';
countdownText2.isVisible = false;
countdownText2.backgroundColor = [0 0 0 0];
taskList{'countdown'}{'1'} = countdownText2;

% 1!
countdownText3 = dm.newObject('dotsDrawableText');
if taskList{'countdown'}{'show countdown'} == 1
    countdownText3.color = taskList{'countdown'}{'text color'};
else
    countdownText3.color = taskList{'countdown'}{'black'};
end
countdownText3.x = 0;
countdownText3.y =  taskList{'instructions'}{'text position'};
countdownText3.string = 'GO';
countdownText3.isVisible = false;
countdownText3.backgroundColor = [0 0 0 0];
taskList{'countdown'}{'GO'} = countdownText3;


% outcome point
outcomePoint = dm.newObject('dotsDrawableTargets');
outcomePoint.x = 0; %centered in screen
outcomePoint.y = 0;
outcomePoint.shape = 2; % hi-qual AA circle
outcomePoint.dotSize = taskList{'outcome'}{'size'}; %10 px
outcomePoint.color = [255 0 0]; %black
outcomePoint.isVisible = false;
taskList{'outcome'}{'outcome point'} = outcomePoint;

% add countdown graphics to a group:
dm.addObjectToGroup(countdownText0, taskName);
dm.addObjectToGroup(countdownText1, taskName);
dm.addObjectToGroup(countdownText2, taskName);
dm.addObjectToGroup(countdownText3, taskName);
dm.addObjectToGroup(outcomePoint,taskName);
dm.activateGroup(taskName);

dm.name = 'draw';

%% Input configuration
% HID input (dotsQueryable)
%   create an input object, a gamepad
%   configure it to classify inputs as needed for this task
%   store it in the taskList container
qm = dotsTheQueryablesManager.theObject;
gp = qm.newObject('dotsQueryableHIDGamepad');
taskList{'inputObjects'}{'gamepad'} = gp;

if gp.isAvailable
    % identify button press phenomenons
    %   see gp.phenomenons.gui
    left = gp.phenomenons{'pressed'}{'pressed_button_7'};
    right = gp.phenomenons{'pressed'}{'pressed_button_8'};
    
end

gp.unavailableOutput = 'no input device';

% classify phenomenons to produce arbitrary results
%   each result will match a state name, below
gp.addClassificationInGroupWithRank(left, 'down', taskName, 2);
gp.addClassificationInGroupWithRank(right, 'up', taskName, 3);

% TK: may want an abort/pause button

gp.activeClassificationGroup = taskName;

%% Setup control structures
%Setup task loop

% create three types of control objects:
%       - topsBlockTree organizes flow outside of trials
%       - topsStatelist organizes flow within trials
%       - topsFunctionLoop organizes moment-to-moment, concurrent behaviors
%       within trials
%   connect these to each other
%   store them in the taskList container

% the trunk of the tree, branches are added below
taskTree = topsTreeNode;
taskTree.name = taskName;
taskTree.iterations = taskList{'control'}{'blocks per session'};
taskTree.startFevalable = {@openScreenWindow, dm};
%taskTree.blockActionFevalable = {@(tL)(incrementBlockCounter(tL)),taskList};%increment block counter
taskTree.finishFevalable = {@closeScreenWindow, dm};

taskLoopCalls = topsCallList;
taskLoopCalls.name = 'task loop callList';
taskLoopCalls.alwaysRunning = true;
taskLoopCalls.startFevalable = {@mayDrawNextFrame,dm,true};

%checked with ben re: readData, necessary to flush buffers manually; not
%implicit in QueryablesManager's runBriefly()
taskLoopCalls.addCall({@readData,gp});

taskLoopCalls.finishFevalable = {@mayDrawNextFrame,dm,false};
taskList{'control'}{'task loop calls'} = taskLoopCalls;

% save the taskList loaded for a given session:
save(taskList{'control'}{'taskList file name'}, 'taskList');

% instantiate top level topsBlockTree object ("the trunk of the tree")
% all other task divisions are branches of this trunk

%% Setup state machine & audDotTaskTree (a branch of the main taskTree to
%% run the state machine of the aud dot Task)
audDotMachine = topsStateMachine;
audDots = 'auditory dots decision making';
audDotMachine.name = audDots;

goTime = taskList{'timing'}{'GO time'};
countdownTime = taskList{'timing'}{'prep countdown'};
stimulusTime = taskList{'stimulus'}{'trial duration'}/1000;
outcomeTime = taskList{'timing'}{'outcome timeout'};

hNR = {@callObjectMethod,pm,stim,'haltAndReset'};

% reaction time task

audDotStates = { ...
    'name',    'entry',                 'timeout',      'input',    'exit',     'next'; ...
    'prep0',   {@show,countdownText0},   countdownTime, {},{@hide,countdownText0}, 'prep1';...
    'prep1',   {@show,countdownText1},   countdownTime, {},{@hide,countdownText1},'prep2';...
    'prep2',   {@show,countdownText2},   countdownTime, {},{@hide,countdownText2},'prep3';...
    'prep3',   {@show,countdownText3},   goTime,        {},{@hide,countdownText3},'playStim';...
    'playStim',{@playStim,taskList},stimulusTime, {@queryNextTracked,gp},hNR,'timeout';...
    'up',      {@rightResponse,taskList},0,             {},{@checkOutcome,taskList},'outcome';...
    'down',    {@leftResponse,taskList}, 0,             {},{@checkOutcome,taskList},'outcome';...
    'timeout', {@stimTimeOut,taskList},  0,             {},{@checkOutcome,taskList},'outcome';...
    'outcome', {@show,outcomePoint},     outcomeTime,   {},{@hide,outcomePoint},'';...
    
    };

audDotMachine.addMultipleStates(audDotStates);
% initialize/setup trial before starting the statemachine
audDotMachine.startFevalable = {@startTrial,taskList};
% breakdown/cleanup after trial is done
audDotMachine.finishFevalable= {@finishTrial,taskList};

% uncomment next line for Debugging state machine
% audDotMachine.transitionFevalable  = {@(stInfo)fprintf([stInfo(1).name '->' stInfo(2).name '\n'])};


taskList{'control'}{'audDot statemachine'} = audDotMachine;

% one loop object can accomodate all the trial types below
taskLoop = topsConcurrentComposite;
taskLoop.name = 'main taskloop';
taskLoop.addChild(dm);
taskLoop.addChild(pm);
taskLoop.addChild(taskLoopCalls);
taskLoop.addChild(audDotMachine);
taskList{'control'}{'task loop'} = taskLoop;

%add branch to the main tree trunk (taskTree)
audDotTree = taskTree.newChildNode;
audDotTree.name = audDots;
audDotTree.iterations = taskList{'control'}{'trials per block'}; %number of trials
audDotTree.addChild(taskLoop);

end

function startTrial(tL)
tL{'cur trial'}{'name'} = ['AudDotTrial' num2str(tL{'control'}{'trials complete'}+1)];
topsDataLog.logDataInGroup('Start',tL{'cur trial'}{'name'});
pm = dotsThePlayablesManager.theObject;

gp = tL{'inputObjects'}{'gamepad'};
gp.flushData;

%reset AudDotPlayable
stim = tL{'stimulus'}{'stimulus'};
pm.callObjectMethod(stim,'haltAndReset');

% load next stim parameter set to ADP
trialInfo = genTrial(tL);
tL{'cur trial'}{'trial info'} = trialInfo;

pm.callObjectMethod(stim,'setParams',trialInfo.trialParam);

fBuf = pm.getObjectProperty(stim,'frequencyBuffer');
dBuf = pm.getObjectProperty(stim,'delayBuffer');

topsDataLog.logDataInGroup(trialInfo.trialParam,tL{'cur trial'}{'name'});
topsDataLog.logDataInGroup(fBuf,[tL{'cur trial'}{'name'} ' FreqBuf']);
topsDataLog.logDataInGroup(dBuf,[tL{'cur trial'}{'name'} ' DelayBuf']);
end

function finishTrial(tL)
tL{'control'}{'trials complete'} = tL{'control'}{'trials complete'}+1;

% These RT stats do not take into account error vs. non-error trial RTs
tL{'control'}{'sum RT'} = tL{'control'}{'sum RT'} + tL{'control'}{'last RT'};
tL{'control'}{'mean RT'} = tL{'control'}{'sum RT'}/tL{'control'}{'trials complete'};
tL{'control'}{'percent correct'} = tL{'control'}{'correct trials'} / tL{'control'}{'trials complete'};
fprintf(1,'last trial outcome %s\nlast RT %.4f\nmean RT %.4f\npercent correct %.3f\n',tL{'control'}{'last outcome'},tL{'control'}{'last RT'},tL{'control'}{'mean RT'},tL{'control'}{'percent correct'});

WaitSecs(tL{'timing'}{'intertrial'});
end

function playStim(tL)
pm = dotsThePlayablesManager.theObject;
pm.mayPlayPlayable(tL{'stimulus'}{'stimulus'});

gp = tL{'inputObjects'}{'gamepad'};
gp.flushData;

tL{'cur trial'}{'stim start time'} = GetSecs;
end

function stimTimeOut(tL)
%handle the time out condition
tL{'cur trial'}{'responded time'} = GetSecs;
topsDataLog.logDataInGroup('timeout',tL{'cur trial'}{'name'});

tL{'cur trial'}{'response'}='timeout';

disp('stimulus timed out--no response from user!!');
end

%down
function leftResponse(tL)
tL{'cur trial'}{'responded time'} = GetSecs;
topsDataLog.logDataInGroup('left',tL{'cur trial'}{'name'});

tL{'cur trial'}{'response'}='left';

disp(['LEFT!! ' num2str(GetSecs)]);
end

%up
function rightResponse(tL)
tL{'cur trial'}{'responded time'} = GetSecs;
topsDataLog.logDataInGroup('right',tL{'cur trial'}{'name'});

tL{'cur trial'}{'response'}='right';

disp(['RIGHT!! ' num2str(GetSecs)]);
end

%check to see if user got it right
function checkOutcome(tL)
% check status of last trial, display outcome:
% Correct! Incorrect! Bad Trial/Error!
trialInfo = tL{'cur trial'}{'trial info'};
trialParams = trialInfo.trialParam;

response = tL{'cur trial'}{'response'};
oP = tL{'outcome'}{'outcome point'};

if ((trialParams(6)>0) && strcmp(response,'right')) || ((trialParams(6)<0) && strcmp(response,'left'))
    % success!
    tL{'control'}{'correct trials'} = tL{'control'}{'correct trials'}+1;
    tL{'control'}{'last outcome'} = 'CORRECT';
    topsDataLog.logDataInGroup('CORRECT',tL{'cur trial'}{'name'});
    
    oP.color = tL{'outcome'}{'green'};
    
elseif strcmp(response,'timeout')
    % TRIAL ERROR!
    
    tL{'control'}{'error trials'} = tL{'control'}{'error trials'}+1;
    tL{'control'}{'last outcome'} = 'ERROR';
    topsDataLog.logDataInGroup('ERROR',tL{'cur trial'}{'name'});
    
    oP.color = tL{'outcome'}{'yellow'};
else
    % TRIAL FAIL!
    
    tL{'control'}{'incorrect trials'} = tL{'control'}{'incorrect trials'}+1;
    tL{'control'}{'last outcome'} = 'INCORRECT';
    topsDataLog.logDataInGroup('INCORRECT',tL{'cur trial'}{'name'});
    
    oP.color = tL{'outcome'}{'red'};
end
RT = tL{'cur trial'}{'responded time'}-tL{'cur trial'}{'stim start time'};
topsDataLog.logDataInGroup(tL{'cur trial'}{'stim start time'},[tL{'cur trial'}{'name'} ' stim time']);
topsDataLog.logDataInGroup(tL{'cur trial'}{'responded time'},[tL{'cur trial'}{'name'} ' responded time']);
topsDataLog.logDataInGroup(RT,[tL{'cur trial'}{'name'} ' RT']);

tL{'control'}{'last RT'} = RT;

end

function trialParameterMatrix = genTrialParameters(tL)
% these paramters (coherence, direction) are the parameters we're iterating
% through during the trials
coherence = tL{'stimulus'}{'coherence'};
direction = tL{'stimulus'}{'directions'}; %1 for up, -1 for down

numCoherence = length(coherence);
numDirs = length(direction);

% trial counts: num. of trials for each coherence/direction pair
counts = tL{'stimulus'}{'trials count'};

trialDur = tL{'stimulus'}{'trial duration'}; % length of trial

toneDur = tL{'stimulus'}{'tone duration'}; %ms, length of tone
toneSOA = tL{'stimulus'}{'tone soa'}; %ms, average intertone interval
toneHi = tL{'stimulus'}{'freq hi'}; %hz, upper end of freq range
toneLo = tL{'stimulus'}{'freq lo'}; %hz, lower end of freq range
freqStep = tL{'stimulus'}{'freq step'}; %hz, frequency step of each tone burst

% TK: code to generate all possible stimulus parameter combinations to be
% presented during the trials

% rows = stimulus conditions
% columns = {[coherence, dir*freqStep, hi, lo, toneDur, toneSOA,
% trialDur],[ totesCount, curCount]}
numTrials = numCoherence*numDirs;
trialParameterMatrix = struct('trialParam',cell(1,numTrials),'maxPerBlock',num2cell(zeros(1,numTrials)),'curCount',num2cell(zeros(1,numTrials)));

for i = 1:numCoherence
    for j = 1:numDirs
        trialParameterMatrix(2*(i-1)+j) = struct('trialParam',[coherence(i),toneSOA, toneDur, toneLo, toneHi,...
            direction(j)*freqStep, trialDur],'maxPerBlock',counts(j,i),'curCount',0);
    end
end

end

function trialInfo = genTrial(tL)

trialMatrix = tL{'stimulus'}{'trial matrix'};

if strcmp(tL{'control'}{'trial presentation'},'random')
    % random trial presentation
    numTrialConditions = length(trialMatrix);
    
    trial = ceil(rand(1)*numTrialConditions);
    
    maxNumPerBlock = trialMatrix(trial).maxPerBlock;
    curCount = trialMatrix(trial).curCount+1;
    
    if curCount <= maxNumPerBlock
        trialMatrix(trial).curCount = curCount;
        tL{'stimulus'}{'trial matrix'}=trialMatrix;
        
        trialInfo = trialMatrix(trial);
    else
        trialInfo = genTrial(tL);
    end
    
else
    % place holder for block trial presentation
end
end
