function [tree, list] = QuestForCoherence()
% Based on Ben Heasley's 2afc demo and Matt Nassar's helicopter task
% TDK 9/20/2013

% path to task svn repository (latest version) and local subfunctions
addpath(genpath(fullfile('..','taskCode','goldLab','TAFCDotsCont')));


%Justin: Following is my attempt to try and follow 'good' coding 
%procedure. Removing to opt for readability instead.
% try
%     gatherInfo = load('values/gatherinfo.mat','tag','id','session','foldername');
%     tag = gatherInfo.tag;
%     id = gatherInfo.id;
%     session = gatherInfo.session;
%     foldername = gatherInfo.foldername;
% catch ME
%     if (strcmp(ME.identifier,'MATLAB:nonExistentField'))
%         msg = 'Variable was not saved to the loaded file. Check ScriptRun.';
%         causeException = MException('MATLAB:myCode:VariableNotLoaded',msg);
%         ME = addCause(ME,causeException);
%     end
%     rethrow(ME)
% end

%Justin_TODO: taskPhase and id seemed to be unused. Might want to remove.
gatherInfo = load('values/gatherinfo.mat');
[dataFileName, taskPhase, id] = gatherTAFCDotsSubInfoQuest(gatherInfo.tag,...
    gatherInfo.id, gatherInfo.session, gatherInfo.foldername);

topsDataLog.flushAllData();

% initializing
disp('--INITIALIZING--');
time = clock;
randSeed = time(6)*10e6;


% load(['./TAFCDotsData/TAFCDots_cg1_main_2Hz1.mat'])
% randSeed = statusData(1).randSeed;
% clear statusData;

gatherDotsLogic = load('values/TAFCDotsLogic.mat');
logic = TAFCDotsLogicQuest(randSeed);
logic.name = gatherDotsLogic.session_name;
logic.dataFileName = dataFileName;
logic.time = time;
isClient = 0;
% logic.catchTrialProbability = 0;
logic.trialsPerBlock=gatherDotsLogic.TrialsPerBlock;
logic.adaptor=gatherDotsLogic.Adapting_Block;
logic.coherence = gatherDotsLogic.Coherence_Guess;
           

 %Make Quest Object    
Guess = logic.coherence;
gatherGC = load('values/quest_create.mat');

%Creating object
questobj = QuestCreate(Guess, gatherGC.GuessSD,gatherGC.pThreshold,...
    gatherGC.beta, gatherGC.delta, gatherGC.gamma, gatherGC.grain, gatherGC.range); 
logic.questobj=questobj;
            
% logic.nBlocks = 1;
% logic.trialsPerBlock = 1;
% logic.catchTrialProbability = 0;
% logic.H = 2;
% logic.coherenceset = 10;
% logic.minT = 10;
% logic.maxT = 10;
gatherDT = load('values/DT.mat');
logic.decisiontime_max = gatherDT.decisiontime_max;

% Experiment paradigm
[tree, list] = configureTAFCDotsDurQuest(logic, isClient); 
%[tree, list] = configureTAFCDotsCPDetect(logic, isClient);% interrogation
%[tree, list] = configureTAFCDots(logic, isClient); % free-response

% Visualize the task's structure
 %tree.gui();
 %list.gui();

%% Execute the 2afc task by invoking run() on the top-level object
commandwindow();
tree.run();

%topsDataLog.gui();