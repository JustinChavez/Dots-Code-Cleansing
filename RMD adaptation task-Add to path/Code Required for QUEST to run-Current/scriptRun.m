%Decision_Time
decisiontime_max = inf;
save('values/DT.mat','decisiontime_max')

%specify gatherTAFCDotsSubInfoQuest information
tag = 'Justin';
id = '43';
session = 1;
foldername ='QuestSaves';
save('values/gatherinfo.mat','tag','id','session','foldername');

%TAFCDotsLogic
session_name = 'TAFC Reaction Time Perceptual Task';
TrialsPerBlock = 2; %was not predefined. Guessed value
Adapting_Block = 1; %1=false, 2=true
Coherence_Guess = .4; %was not predefined. Guessed value
save('values/TAFCDotsLogic.mat','session_name','TrialsPerBlock',...
    'Adapting_Block','Coherence_Guess');

%QuestCreate - define the prior beliefs
pThreshold = 0.65;
%Guess = logic.coherence; set in TAFCDotsLogic
GuessSD = 10; %standard deviation
beta = 3.5;
delta = 0.01; 
gamma = 0.5;
grain = .5;
range = 50;
save('values/quest_create.mat','pThreshold','GuessSD','beta',...
    'delta','gamma','grain','range')

