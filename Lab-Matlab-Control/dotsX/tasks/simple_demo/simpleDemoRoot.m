% This file will create a ROOT_STRUCT that is configured for the simple_demo
% task.  The task will run automatically, and the ROOT_STRUCT can be loaded
% again using dXgui. 

% who is the subject?
subject = 'Demo';
paradigmName = ['simpleDemo_', subject];

% create the directory for saving data files
%   this directory must exist before you run the task
FIRADir = ['/Users/lab/GoldLab/Data/simple_demo/', subject];
if ~exist(FIRADir, 'dir')
    mkdir(FIRADir)
end

% pick the task to load
%   filename of the task, number of repetitions to run, task arguments
numTrials = 20;
coherences = [12.8, 25.6, 51,2];
mute = false;
taskList = {'taskSimpleDemo', 3, {numTrials, coherences, mute}};

% use 'local' screen mode to show graphics on this machine
%   rInit will initialize a ROOT_STRUCT which holds all DotsX data.
screenMode = 'local';
rInit(screenMode);

% Add a dXparadigm to the initialized ROOT_STRUCT.  dXparadigm will contain
% manage and execute the task:
%   name            A name unique to this task and this subject�
%   screenMode      Where to show graphics ('debug', 'local', or 'remote')
%   taskList        List of task name, task repetitions, and config. args
%   iti             interval to wait between trials
%   saveToFIRA      Boolean, should DotsX use FIRA to save data?
%   FIRA_doWrite    Boolean, should DotsX write FIRA data to disk?
%   FIRA_saveDir    Where should DotsX write the FIRA data?
%   FIRA_filenameBase	Basis for automatically generated, unique filenames
rAdd('dXparadigm',          1, ...
    'name',                 paradigmName, ...
    'screenMode',           screenMode, ...
    'taskList',             taskList, ...
    'iti',                  1.0, ...
    'saveToFIRA',           true, ...
    'FIRA_doWrite',         true, ...
    'FIRA_saveDir',         FIRADir, ...
    'FIRA_filenameBase',	subject);

% use the dXparadigm instance to load the task into ROOT_STRUCT
%   this calls on all the task definition files
global ROOT_STRUCT
ROOT_STRUCT.dXparadigm = loadTasks(ROOT_STRUCT.dXparadigm);

% ask the dXparadigm where to save the ROOT_STRUCT it just created
ROOTFile = fullfile(rGet('dXparadigm', 1, 'ROOT_saveDir'), paradigmName);
save(ROOTFile, 'ROOT_STRUCT');

% For demonstration purposes, run the task now
% use a try block so as to ignore errors or F3 quitting
try
    runTasks(ROOT_STRUCT.dXparadigm);
catch
    e = lasterror
end

% all done
rDone
clear all
