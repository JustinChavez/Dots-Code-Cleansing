function [tree, list] = configureTAFCDotsDurQuest(logic, isClient)
% for the within trial change-point task
sc=dotsTheScreen.theObject;
sc.reset('displayIndex', 1);

if nargin < 1 || isempty(logic)
    logic = TAFCDotsLogicQuest();
end

if nargin < 2
    isClient = false;
end

%% Organization:
% Make a container for task data and objects, partitioned into groups.
list = topsGroupedList('TAFCDots data');

%% Important Objects:
list{'object'}{'logic'} = logic;

statusData = logic.getDataArray();
list{'logic'}{'statusData'} = statusData;

%% Constants:
% Store some constants in the list container, for use during configuration
% and while task is running
list{'constants'}{'counter'} = 1;
list{'constants'}{'alternate'} = 0;
list{'constants'}{'duration'} = 0;

list{'timing'}{'feedback'} = 0.2;
list{'timing'}{'intertrial'} = 0;

list{'graphics'}{'isClient'} = isClient;
list{'graphics'}{'white'} = [1 1 1];
list{'graphics'}{'lightgray'} = [0.65 0.65 0.65];
list{'graphics'}{'lightblue'} = [0.60 0.60 0.80];
list{'graphics'}{'gray'} = [0.25 0.25 0.25];
list{'graphics'}{'red'} = [0.75 0.25 0.1];
list{'graphics'}{'yellow'} = [0.75 0.75 0];
list{'graphics'}{'green'} = [.25 0.75 0.1];
list{'graphics'}{'stimulus diameter'} = 10;
list{'graphics'}{'fixation diameter'} = 0.2;
list{'graphics'}{'target diameter'} = 0.22;
list{'graphics'}{'leftward'} = 180;             %***Consider changing here
list{'graphics'}{'rightward'} = 0;

%% Graphics:
% Create some drawable objects. Configure them with the constants above.

% instruction messages
m = dotsDrawableText();
m.color = list{'graphics'}{'gray'};
m.fontSize = 48;
m.x = 0;
m.y = 0;

% a fixation point
fp = dotsDrawableTargets();
fp.colors = list{'graphics'}{'gray'};
fp.width = list{'graphics'}{'fixation diameter'};
fp.height = list{'graphics'}{'fixation diameter'};
list{'graphics'}{'fixation point'} = fp;

% counter
logic = list{'object'}{'logic'};
counter = dotsDrawableText();
counter.string = strcat(num2str(logic.blockTotalTrials + 1), '/', num2str(logic.trialsPerBlock));
counter.color = list{'graphics'}{'gray'};
counter.isBold = true;
counter.fontSize = 20;
counter.x = 0;
counter.y = -5.5;

% score
score = dotsDrawableText();
score.string = strcat('$', num2str(logic.score));
score.color = list{'graphics'}{'gray'};
score.isBold = true;
score.fontSize = 20;
score.x = 0;
score.y = -6;

% que point
qp = dotsDrawableTargets();
qp.colors = list{'graphics'}{'lightgray'};
qp.width = list{'graphics'}{'fixation diameter'};
qp.height = list{'graphics'}{'fixation diameter'};
list{'graphics'}{'fixation point'} = qp;

targs = dotsDrawableTargets();
targs.colors = list{'graphics'}{'gray'};
targs.width = list{'graphics'}{'target diameter'};
targs.height = list{'graphics'}{'target diameter'};
targs.xCenter = 0;
targs.yCenter = 0;
targs.isVisible = false;
list{'graphics'}{'targets'} = targs;

% a random dots stimulus
stim = dotsDrawableDotKinetogram();
stim.colors = list{'graphics'}{'white'};
stim.pixelSize = 5; % size of the dots
stim.direction = 0;                         %Maybe switch to 45?
stim.density = 70;
stim.speed = 6;
stim.diameter = list{'graphics'}{'stimulus diameter'};
%stim.isMovingAsHerd = true;
stim.isVisible = false;
%stim.adaptor=false;
list{'graphics'}{'stimulus'} = stim;

%*** Making adaptation stimuli
adaptr=dotsDrawableDotKinetogram();
adaptr.colors = list{'graphics'}{'lightblue'};
adaptr.pixelSize = 5; % size of the dots                        %Maybe switch to 45?
adaptr.density = 35;
adaptr.speed = 6;
adaptr.diameter = list{'graphics'}{'stimulus diameter'};
adaptr.isVisible = false;
adaptr.direction = 45;
%adaptr.adaptor=true;
list{'graphics'}{'adapt R'} = adaptr;

%adaptl=dotsDrawableDynamicDotKinetogramAdaptorOptionQuest();
adaptl=dotsDrawableDotKinetogram();
adaptl.colors = list{'graphics'}{'lightgray'};
adaptl.pixelSize = 5; % size of the dots                        %Maybe switch to 45?
adaptl.density = 35;
adaptl.speed = 6;
adaptl.diameter = list{'graphics'}{'stimulus diameter'};
adaptl.isVisible = false;
adaptl.direction = 135;
%adaptl.adaptor=true;
list{'graphics'}{'adapt L'} = adaptl;


% aggregate all these drawable objects into a single ensemble
%   if isClient is true, graphics will be drawn remotely

drawables = dotsEnsembleUtilities.makeEnsemble('drawables', isClient);

qpInd = drawables.addObject(qp);
targsInd = drawables.addObject(targs);
stimInd = drawables.addObject(stim);
%*** adaptation
adaptorR = drawables.addObject(adaptr);
adaptorL = drawables.addObject(adaptl);

%*** end Kyra code

fpInd = drawables.addObject(fp);
counterInd = drawables.addObject(counter);
scoreInd = drawables.addObject(score);

% automate the task of drawing all these objects
drawables.automateObjectMethod('draw', @mayDrawNow);

% also put dotsTheScreen into its own ensemble
screen = dotsEnsembleUtilities.makeEnsemble('screen', isClient);
screen.addObject(dotsTheScreen.theObject());

messages = dotsEnsembleUtilities.makeEnsemble('messages', isClient);
msInd = messages.addObject(m);
messages.automateObjectMethod('drawMessage', @mayDrawNow);

% automate the task of flipping screen buffers
screen.automateObjectMethod('flip', @nextFrame);

list{'graphics'}{'drawables'} = drawables;
list{'graphics'}{'messages'} = messages;
list{'graphics'}{'fixation point index'} = fpInd;
list{'graphics'}{'targets index'} = targsInd;
list{'graphics'}{'stimulus index'} = stimInd;
%***
list{'graphics'}{'Adapt R Index'} = adaptorR;
list{'graphics'}{'Adapt L Index'} = adaptorL;
%***
list{'graphics'}{'counter index'} = counterInd;
list{'graphics'}{'score index'} = scoreInd;
list{'graphics'}{'screen'} = screen;


%% Input:
% Create an input source.
% keyboard inputs
keyOpt.PrimaryUsageName = 'Keyboard';
kb = dotsReadableHIDKeyboard(keyOpt);
ui = kb;

% define movements, which must be held down
%   map f-key -1 to left and j-key +1 to right
isF = strcmp({kb.components.name}, 'KeyboardF');
isJ = strcmp({kb.components.name}, 'KeyboardJ');

fKey = kb.components(isF);
jKey = kb.components(isJ);

uiMap.left.ID = fKey.ID;
uiMap.right.ID = jKey.ID;
kb.setComponentCalibration(fKey.ID, [], [], [0 -1]);
kb.setComponentCalibration(jKey.ID, [], [], [0 +1]);

% undefine any default events
IDs = kb.getComponentIDs();
for ii = 1:numel(IDs)
    kb.undefineEvent(IDs(ii));
end

% define events, which fire once even if held down
%   pressing f or j is a 'moved' event
%   pressing space bar is a 'commit' event
kb.defineEvent(fKey.ID, 'moved', 0, 0, true);
kb.defineEvent(jKey.ID, 'moved', 0, 0, true);
isSpaceBar = strcmp({kb.components.name}, 'KeyboardSpacebar');
spaceBar = kb.components(isSpaceBar);
kb.defineEvent(spaceBar.ID, 'commit', spaceBar.CalibrationMax);

isEsc = strcmp({kb.components.name}, 'KeyboardEscape');
EscKey = kb.components(isEsc);
kb.defineEvent(EscKey.ID, 'exit', 0, 0, true);

list{'input'}{'controller'} = ui;
list{'input'}{'mapping'} = uiMap;

%% Outline the structure of the experiment with topsRunnable objects
%   visualize the structure with tree.gui()
%   run the experiment with tree.run()

% "tree" is the start point for the whole experiment
tree = topsTreeNode('2AFC task');
tree.iterations = 1;
tree.startFevalable = {@callObjectMethod, screen, @open};
tree.finishFevalable = {@wrapUp, list};

% "session" is a branch of the tree with the task itself
session = topsTreeNode('session');
session.iterations = logic.nBlocks;
session.startFevalable = {@startSession, logic};
tree.addChild(session);

block = topsTreeNode('block');
block.iterations = logic.trialsPerBlock;
block.startFevalable = {@startBlock, logic};
session.addChild(block);

trial = topsConcurrentComposite('trial');
block.addChild(trial);

trialStates = topsStateMachine('trial states');
trial.addChild(trialStates);

trialCalls = topsCallList('call functions');
trialCalls.addCall({@read, ui}, 'read input');
list{'control'}{'trial calls'} = trialCalls;

% "instructions" is a branch of the tree with an instructional slide show
instructions = topsTreeNode('instructions');
instructions.iterations = 1;
tree.addChild(instructions);

viewSlides = topsConcurrentComposite('slide show');
viewSlides.startFevalable = {@flushData, ui};
viewSlides.finishFevalable = {@flushData, ui};
instructions.addChild(viewSlides);

instructionStates = topsStateMachine('instruction states');
viewSlides.addChild(instructionStates);

instructionCalls = topsCallList('instruction updates');
instructionCalls.alwaysRunning = true;
viewSlides.addChild(instructionCalls);

list{'outline'}{'tree'} = tree;
list{'outline'}{'session'}= session; 
list{'outline'}{'block'}= block;
list{'outline'}{'instructions'}= instructions;

%% Control:
% Create three types of control objects:
%	- topsTreeNode organizes flow outside of trials
%	- topsConditions organizes parameter combinations before each trial
%	- topsStateMachine organizes flow within trials
%	- topsCallList organizes calls some functions during trials
%	- topsConcurrentComposite interleaves behaviors of the state machine,
%	function calls, and drawing graphics
%   .

%% Organize the presentation of instructions
% the instructions state machine will respond to user input commands
states = { ...
    'name'      'next'      'timeout'	'entry'     'input'; ...
    'showSlide' ''          logic.decisiontime_max    {}          {@getNextEvent ui}; ...
     'rightFine' 'showSlide' 0           {}	{}; ...
     'leftFine'  'showSlide' 0           {} {}; ...
    'commit'     ''          0           {}          {}; ...
    };
instructionStates.addMultipleStates(states);
instructionStates.startFevalable = {@doMessage, list, ''};
instructionStates.finishFevalable = {@doMessage, list, ''};

% the instructions call list runs in parallel with the state machine
instructionCalls.addCall({@read, ui}, 'input');

%% Trial
% Define states for trials with constant timing.

tFeed = list{'timing'}{'feedback'};

% define shorthand functions for showing and hiding ensemble drawables
on = @(index)drawables.setObjectProperty('isVisible', true, index);
off = @(index)drawables.setObjectProperty('isVisible', false, index);
cho = @(index)drawables.setObjectProperty('colors', [0.25 0.25 0.25], index);
chf = @(index)drawables.setObjectProperty('colors', [0.45 0.45 0.45], index);

fixedStates = { ...
    'name'      'entry'         'timeout'	'exit'              'next'      'input'; ...
%    'inst'     {@doNextInstruction, av} 1  {}                  ''; ...
    'prepare1'  {on, [fpInd counterInd scoreInd]} 0 {}           'pause'     {}; ...
    'pause'     {chf, fpInd}         0       {@run instructions} 'pause2'    {};...
    'pause2'    {cho, fpInd}         1       {@flushui, list}    'prepare2'  {};...
    'prepare2'  {on,  qpInd}         0       {}                  'check adapt status' {}; ...
    'check adapt status' {@checkAdaptStatus, trialStates, list} 0 {} 'adapt' {};...  % default to not-adapting trials
    'adapt'     {on [adaptorR adaptorL]}   0   {off [adaptorR adaptorL]} 'stimulus1'  {};...       % time how long adaptors on for    
    'stimulus1'  {on stimInd}   .5       {} 'stimulus0' {}; ...
    'stimulus0'  {@flushui, list}   0    {@setTimeStamp, logic}             'decision'     {}; ...
    'decision'  {off stimInd}   logic.decisiontime_max  {}  'moved'  {@getNextEvent ui}; ...
    'moved'    {}         0     {@showFeedback, list} 'choice' {}; ...
    'choice'    {}	tFeed     {}              'complete' {}; ...
    'complete'  {}  0   {}              'counter'          {}; ... % always a good trial for now
    'counter'  {on, [counterInd, scoreInd]}  0   {}              'set'          {}; ... % always a good trial for now
    'set'  {@setGoodTrial, logic}  0   {}              ''          {}; ...
    'exit'     {@closeTree,tree}          0           {}          ''  {}; ...
    };


trialStates.addMultipleStates(fixedStates);
trialStates.startFevalable = {@configStartTrial, list};
trialStates.finishFevalable = {@configFinishTrial, list};
list{'control'}{'trial states'} = trialStates;

trial.addChild(trialCalls);
trial.addChild(drawables);
trial.addChild(screen);


%% Custom Behaviors:
% Define functions to handle some of the unique details of this task.

function flushui(list)
ui = list{'input'}{'controller'};
ui.flushData;
list{'control'}{'current choice'} = 'none';

function configStartTrial(list)
% start Logic trial
logic = list{'object'}{'logic'};
logic.startTrial;

% clear data from the last trial
ui = list{'input'}{'controller'};
ui.flushData();
list{'control'}{'current choice'} = 'none';

% reset the appearance of targets and cursor
%   use the drawables ensemble, to allow remote behavior
drawables = list{'graphics'}{'drawables'};
targsInd = list{'graphics'}{'targets index'};
stimInd = list{'graphics'}{'stimulus index'};
adaptorR = list{'graphics'}{'Adapt R Index'};
adaptorL = list{'graphics'}{'Adapt L Index'};
drawables.setObjectProperty( ...
    'colors', list{'graphics'}{'gray'}, [targsInd]);

% randval = rand;
% randval = 0;

logic.direction0 = round(rand)*90+45;   %*** SETS STARTING DIRECTION TO 0 or 180... now sets to 135 or 45, still need to find where switches 

% let all the graphics set up to draw in the open window
drawables.setObjectProperty('isVisible', false);
                
% drawables.setObjectProperty( ...
%     'tind', 0, [stimInd]);

disp(logic.coherence)
drawables.setObjectProperty( ...
    'coherence', logic.coherence, [stimInd]);

%**** Kyra code
drawables.setObjectProperty( ...
    'coherence', 100, [adaptorR]);

drawables.setObjectProperty( ...
    'coherence', 100, [adaptorL]);

%***

drawables.setObjectProperty( ...
    'direction', logic.direction0, [stimInd]);



% drawables.setObjectProperty( ...
%     'randSeed', NaN, [stimInd]);




                
drawables.callObjectMethod(@prepareToDrawInWindow);

function configFinishTrial(list)
% finish logic trial
logic = list{'object'}{'logic'};
logic.finishTrial;

% print out the block and trial #

%***Below line commented out but displays the current/blocks and
%current/trials

%disp(sprintf('block %d/%d, trial %d/%d',...
    %logic.currentBlock, logic.nBlocks,...
    %logic.blockTotalTrials, logic.trialsPerBlock));

%%% DATA RECORDING -- this takes up a lot of time %%%

tt = logic.blockTotalTrials;
bb = logic.currentBlock;
statusData = list{'logic'}{'statusData'};
statusData(tt,bb) = logic.getStatus();
list{'logic'}{'statusData'} = statusData;

[dataPath, dataName, dataExt] = fileparts(logic.dataFileName);
if isempty(dataPath)
    dataPath = dotsTheMachineConfiguration.getDefaultValue('dataPath');
end
dataFullFile = fullfile(dataPath, dataName);
save(dataFullFile, 'statusData')

% write new tops flow-of-control data to disk
%topsDataLog.writeDataFile();

% only need to wait our the intertrial interval
pause(list{'timing'}{'intertrial'});

%%% END %%%

%
% FUNCTION: showFeedback
%
function showFeedback(list)
logic = list{'object'}{'logic'};
tree=list{'outline'}{'tree'};
session= list{'outline'}{'session'}; 
block= list{'outline'}{'block'};
instructions= list{'outline'}{'instructions'};

% hide the fixation point and cursor
drawables = list{'graphics'}{'drawables'};
fpInd = list{'graphics'}{'fixation point index'};
targsInd = list{'graphics'}{'targets index'};
stimInd = list{'graphics'}{'stimulus index'};
counterInd = list{'graphics'}{'counter index'};
scoreInd = list{'graphics'}{'score index'};
logic.setDetection();
drawables.setObjectProperty('isVisible', false, [fpInd]);
drawables.setObjectProperty('isVisible', true, [targsInd]);

ui = list{'input'}{'controller'};

logic.keyhistory = ui.history;

uiMap = list{'input'}{'mapping'};
isLeft = ui.getValue(uiMap.left.ID) == -1;
isRight = ui.getValue(uiMap.right.ID) == +1;
if isLeft
    list{'control'}{'current choice'} = 'leftward';
    logic.choice = -1; % left
elseif isRight
    list{'control'}{'current choice'} = 'rightward';
    logic.choice = 1; % right
end

stim = drawables.getObject(stimInd);

% logic.directionvc = stim.directionvc(1:stim.tind);          %% What do these mean?
% logic.coherencevc = stim.coherencevc(1:stim.tind);

stimstrct = obj2struct(stim);

logic.stimstrct = stimstrct;

if logic.choice == -1 && stim.direction == 135   %%***edited
    drawables.setObjectProperty( ...
        'colors', list{'graphics'}{'green'}, targsInd);
    logic.correct = 1;

elseif logic.choice == 1 && stim.direction == 45 %**** edited
    drawables.setObjectProperty( ...
        'colors', list{'graphics'}{'green'}, targsInd);
    logic.correct = 1;

elseif logic.choice == 0
    drawables.setObjectProperty( ...
        'colors', list{'graphics'}{'yellow'}, targsInd);
    logic.correct = 0;
else
    drawables.setObjectProperty( ...
        'colors', list{'graphics'}{'red'}, targsInd);
logic.correct = 0;

end

logic.computeBehaviorParameters();

if isnan(mean(logic.oldcoherence))
    avgCoh=0;
else
    avgCoh=mean(logic.oldcoherence);
end

if logic.coherence<=.5+avgCoh && logic.coherence>=avgCoh-.5
    logic.timessame=logic.timessame+1;
    logic.perrcorr=mean(logic.PercentCorrData);
else
    logic.timessame=0; 
    logic.PercentCorrData=[];
    logic.oldcoherence=[];
end

if logic.timessame>=20 && logic.perrcorr<.70 && logic.perrcorr>.60
    disp('final coherence was ');
    disp(logic.coherence);
    disp('percent correct under this regime');
    disp(logic.perrcorr);
    instruction.finish;
    block.finish;
    session.finish;
    tree.finish;
  
end 

if logic.correct == 1
    logic.score = logic.score + 0.1;
elseif logic.correct == 0
    logic.score = logic.score - 0.1;
    if logic.score < 0
        logic.score = 0;
    end
end
    
drawables = list{'graphics'}{'drawables'};
drawables.setObjectProperty('string', strcat(num2str(logic.blockTotalTrials + 1), '/',...
    num2str(logic.trialsPerBlock)), counterInd);
% drawables.setObjectProperty('string', strcat('$', num2str(logic.score)), scoreInd);

%%
% FUNCTION: checkAdaptStatus
%
function checkAdaptStatus(trialStates, list)

% check status... are we adapting? 
logic = list{'object'}{'logic'};
if logic.adaptor==1
    
    % no ... don't do anything
    trialStates.editStateByName('check adapt status', 'next', 'stimulus1');
else
    
    % yes ... go to adapt state, set correct timing
    trialStates.editStateByName('check adapt status', 'next', 'adapt');
    if mod(logic.adaptorCounter,10)==0
        trialStates.editStateByName('adapt', 'timeout', 10)        
    else
        trialStates.editStateByName('adapt', 'timeout', 3)
    end
    logic.adaptorCounter=logic.adaptorCounter+1;
end

%%
% FUNCTION: wrapUp
%
function wrapUp(list)
uiMap = list{'input'}{'mapping'};
if strcmp(uiMap, 'mouse')
    ui = list{'input'}{'controller'};
    ui.isExclusive = false;
    ui.initialize;
end

screen = list{'graphics'}{'screen'};
screen.callObjectMethod(@close);

%%
% FUNCTION: doMessage
%
function doMessage(list, message)
messages = list{'graphics'}{'messages'};
if nargin > 1
    m = message;
else
    m = '';
end
messages.setObjectProperty('string', m);
messages.callByName('drawMessage');
messages.callObjectMethod(@prepareToDrawInWindow);