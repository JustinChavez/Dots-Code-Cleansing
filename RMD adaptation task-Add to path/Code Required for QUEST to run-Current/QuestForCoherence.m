function [tree, list] = QuestForCoherence(decisiontime_max)
% Based on Ben Heasley's 2afc demo and Matt Nassar's helicopter task
% TDK 9/20/2013

% path to task svn repository (latest version) and local subfunctions
addpath(genpath(fullfile('..','taskCode','goldLab','TAFCDotsCont')));

% subject ID info
[dataFileName, taskPhase, id] = gatherTAFCDotsSubInfoQuest('Kyra Quest');

topsDataLog.flushAllData();

% initializing
disp('--INITIALIZING--');
time = clock;
randSeed = time(6)*10e6;

if nargin==0
    decisiontime_max = Inf;
end

% load(['./TAFCDotsData/TAFCDots_cg1_main_2Hz1.mat'])
% randSeed = statusData(1).randSeed;
% clear statusData;

logic = TAFCDotsLogicQuest(randSeed);
logic.name = 'TAFC Reaction Time Perceptual Task';
logic.dataFileName = dataFileName;
logic.time = time;
isClient = 0;
% logic.catchTrialProbability = 0;
logic.trialsPerBlock=input('Trials Per Block= ');
logic.adaptor=input('Adapting block? 1=false, 2=true  ');
logic.coherence = input('coherence guess= ');


           
 %Make Quest Object    
            pThreshold = 0.65;
            Guess = logic.coherence;
            GuessDev = 10;

                % These I don't understand
            beta = 3.5;
            delta = 0.01; 
            gamma = 0.5;

            %Creating object
            questobj = QuestCreate(Guess, GuessDev, pThreshold, beta, delta, gamma, .5, 50); 
     logic.questobj=questobj;
            
            






% 
% logic.nBlocks = 1;
% logic.trialsPerBlock = 1;
% logic.catchTrialProbability = 0;
% logic.H = 2;
% logic.coherenceset = 10;
% logic.minT = 10;
% logic.maxT = 10;

logic.decisiontime_max = decisiontime_max;

% Experiment paradigm
[tree, list] = configureTAFCDotsDurQuest(logic, isClient); 
%[tree, list] = configureTAFCDotsCPDetect(logic, isClient);% interrogation
%[tree, list] = configureTAFCDots(logic, isClient); % free-response

% Visualize the task's structure
% tree.gui();
% list.gui();

%% Execute the 2afc task by invoking run() on the top-level object
commandwindow();
tree.run();

%topsDataLog.gui();