addpath(genpath(fullfile('..','Lab-Matlab-Control')));
addpath(genpath(fullfile('..','mgl')));

if ~exist('scriptRunValues','dir')
    mkdir('scriptRunValues');
end

%Decision_Time
decisiontime_max = inf;
save('scriptRunValues/DT.mat','decisiontime_max')

%Specify gatherTAFCDotsSubInfoQuest information
%Will be used to create the save file information.
tag = 'Justin';
id = '43';
session = 1; %Will increment if same session save exists
foldername ='TAFCDotsData'; %What folder to save into
save('scriptRunValues/gatherinfo.mat','tag','id','session','foldername');

%TAFCDotsLogic
name = 'TAFC Reaction Time Perceptual Task';
nBlocks = 1;
trialsPerBlock = 2;
H = .1; %Hazard Rate
coherence = 100; %Percent of dots moving in stimulus direction
duration = 1; %length of time dots are shown
practiceN = 0;

%minT = 1;
%maxT = 1;
%coherenceset = [0 0 0]; %Use if we are switching between multiple
%coherences. Uncomment code in TAFCDotsLogic and TAFCDotsMainDemo.m

save('scriptRunValues/logic_values.mat','name','nBlocks', 'trialsPerBlock','H', ...
    'duration', 'practiceN', 'coherence');

%isClient
isClient = 0;
save('scriptRunValues/isClient.mat','isClient');
TAFCDotsMainDemo()
