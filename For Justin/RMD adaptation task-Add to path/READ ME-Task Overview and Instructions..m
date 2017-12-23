%%% Hello!  If you are reading this, you are working on collecting data for
%%% the task I developed, so thank you!  The following is a short summary
%%% of the task, how to run it, and what code is currently available to
%%% analyze the data. This task is based on (and heavily borrow code from)
%%% Chris Glaze.  For more information, please contact Kyra Schapiro at
%%% kyrasch@mail.med.upenn.edu!

%% Overview of Task Objectives

%%% The purpose of this task is to further investigate the dynamics of 
%%% perception in an uncertain (noisy stimulus) and changing 
%%% (ground truth is changing) environment. Chris found that under these 
%%% conditions, the hazard rate (how often the environment is switching)
%%% seems to have a time-dependnet effect on people's accuracy in low
%%% coherence Random Moving Dots (RDM) task.  The dynamics of this effect
%%% were consistent with the normative model (see eLife paper).  This task
%%% seeks to further investigate whether this effect (aka the crossover
%%% effect) is caused by normative-model dynamics by controling for (what
%%% were average) differences in the penultimate-state viewing time, which
%%% under another model can also explain the findings.  In addition, this
%%% task seeks to investigate whether differential rates of sensory
%%% adaptation in the two hazard rate conditions are responsible/influence
%%% this process by saturating adaptation to the directions of motion prior
%%% to viewing the test stimulus.  Should adaptation be relavent and the
%%% manipulation sucessful, the effect seen in early works should be
%%% changed.

%% Task Design

%%% Each block of trials (currently set at 150 trials per session) can be
%%% of one of two types: Non-Adapting or Adapting.  In the Adapting
%%% condition, an adaption stimulus is played prior to each test
%%% stimulus(described below).  The Adapting stimulus consists of two Dots
%%% Motion Stimuli at 100% coherence going in the directions of possible
%%% choice with slighly differnt colors.  Currently those directions are 45
%%% and 135 degrees (original was 0 and 180).  The directions were chosen
%%% to avoid complications/convolutions that arise under certain conditions
%%% with equal and opposite adapting stimuli.  In the Non-Adapting
%%% Condition, still dots are placed on the screen for a shorter but
%%% non-zero time compared to the Adapting stimulus.  The amounts of time
%%% are specified within the code (configureTAFC... file).

%%% Each block is also one of two hazard rates, currently .5 and 3 Hz.
%%% This creates a total of four basic block condion types.  

%%% After the Adapting stimulus (or nothing if non-adapting), the
%%% test stimulus comes on.  The test stimulus consists of the RDM (at low
%%% coherence for 6/7 of trials or so) changing between the two directions
%%% periodically at the hazard rate of the block.  The test stimulus is
%%% either 4 or 8 seconds followed by a Final State Period.  The final
%%% state period can be either .25 second or 2.25 seconds.  In addition,
%%% for the slower hazard rate, on some portion of the trials the switching
%%% will start mid-period such that the penultimate state of these trials
%%% will be identical in length to the short hazard rate. This length is
%%% currently hard coded based on current hazard rates and will need
%%% adjusting manually if the hazard rates are changed (within
%%% drawableDots... file).

%%% Subjects must indicate their choice by pressing the "J" key for
%%% rightward choices and the "F" key for leftward choices and press the
%%% "SPACE" bar between trials 2-3 times to move to the next trial.

%% Starting Out- How to pick a low coherence

%%% The original effect was seen in a high-noise, low coherence
%%% environment, but how do you pick the correct coherence.  The coherence
%%% should be set such that subjects are correctly identifying the
%%% direction of motion ~65% of time for a 0.5 second stimulus.  And how do
%%% you find this coherence?  Well, it's not an exact science and it can
%%% change even within a trial and with experience with the task.  The
%%% current methodology is instantiated in the scripts and functions with
%%% the "Code Required for Quest to run-Current" Folder, but you don't need
%%% to open the folder to run the current itteration, just have it with the
%%% path and it's there if you need to change any parameters (discussed
%%% below).

%%% To actually run this program to find the correct coherence, you MUST be
%%% in the folder "All Current Experiments Run and Save Files-Add to path",
%%% and as it says, that folder and all subfolders must be added to the
%%% path. Type into the Command Window and press enter: QuestForCoherence

%%% You will then be prompted for Subject ID.  Please type in some
%%% identifer for the subject (Name, initials, nickname, whatever), the
%%% date (mmddyy), and whether it is and Adaptation trial or not (Adapting
%%% or No Adaptation).  

%%% Next you will be prompted to input the number of trials for the
%%% session.  For new subjects and/ or conditions >100 are recomended, for
%%% returning subjects fewer may be input.  Don't worry about puting in too
%%% high of a number as the code is designed to stop when criteria are
%%% reached-however due to varriance in subject ability and random chance,
%%% it does not always stop as soon as theoretically it might.  

%%% You will then be prompted to tell it if you are looking for the
%%% coherence under Adaptation or Non-Adapting conditions.  Type the number
%%% 1 for "Non-Adapting" and 2 for "Adapting".

%%% Finally you will be asked for a coherence guess. For new subjects 40-50
%%% is fairly resonable.  For returning subjects, pick the coherence used
%%% previously.


%%% The subject will then have to view the stimulus and indicate their
%%% perceptual choice with "J"=right and "F"=left and "SPACE" to move on.
%%% The subject should focus on the center fixation point. This point will
%%% turn green if the guess is correct and red if incorrect.  
%%% The coherence will change trial by trial to adjust to the subject's
%%% percent correct in order to try to find 65%.

%%% Once the coherence has been stable for 20 trials with a percent correct
%%% of between 60 and 70, the program will close.  The final coherence and
%%% percent correct will be displayed above the "Close out error message"
%%% in the Command window.

%%% Info on each trial, coherence, and percent correct will be saved in the
%%% "QuestTrials" Folder if you need to go back to look at it.

%%% Important Paramaters you may adjust and where to find them:
    % timessame: This controls the number of trials with stable coherence
    % necessary for the program to quit itself. Currently set to 20.  Found
    % in "configureTAFCDotsDurQuest.mat" in "Code Required for QUEST to
    % run-Current" folder.
    
%%% Known issues:
    % If the initial guess is very low or very high compared to the actual
    % coherence for the subject, the code can get stuck around an incorrect
    % value due to a standard deviation parameter in the code.  The easiest
    % fix is to re-run the QuestForCoherence using a "Coherence Guess" of
    % closer to what was the final coherence on the failed attempt
    % (identifiable within the saved recored of all trials described
    % above).
    
    %SEE ALSO: Running the Main Task Known Issues
%% Running the Main Task-READ ALL before running!

%%% Now that you have a coherence, you can run the main task. As before,
%%% subjects must indciate their choice with the "F" and "J" keys and do
%%% the next trial with "SPACE".  

%%% The code that instantiates the task is currently in the folder "Code
%%% Required for Main Dots Switching Task (Periodic Switching, Equal
%%% Evidence Prior to Final) to Run Current".  This file needs to be in the
%%% path, but you should still be in the file "All Current Experiment Run
%%% and Save Files-Add to path" with all the subfolders of this folder in
%%% the path.  

%%% Into the Command Window type the following and then press enter:
%%% RDM_EquSwitch_EquPreFinal

%%% You will be promted for a Subject ID: It should include in the
%%% following order with spaces: subject ID (Name, initials, etc),
%%% Adaptation condiong ("NoAdapt" for non-adapting OR "Adapt" for
%%% adapting), hazard rate ("Hdot5" for hazard rate=.5 OR "H3" for hazard
%%% rate=3), date (mmddyy).  Then press enter.
    %**** IMPORTANT NOTE:  Current analysis code is hard coded to look for
    % the options in quotes so they MUST be used.  Should the Hazard Rates
    % be changed for the overall task design, this notation should be
    % changed as should the hard coding in the analysis code (see
    % documentation within folder "KAS Analyzing Data Code").
    
%%% You will then be prompted for the hazard rate. Type: 0.5 or 3 as
%%% appropriate.  
    %****  NOTE: This input CONTROLS the H rate of the task and will
    % currently accept typos/non-standard H-rates. This value is not
    % currently tied to the naming scheme but will be saved properly.
    % Future modifications of the code may wish to tie the user-input value
    % to the file name and make only certain numbers accepted, but it is
    % not currently designed that way.
    
%%% The next prompt is whether this is an adapting block.  Type and push
%%% enter: 1 for non-adapting, 2 for adapting.
    %**** NOTE: As above, this input controls whether the trials in the
    % block will have the adapting stimulus before the test stimulus.  It
    % is not tied into the save file name but will be saved in the data.
    % Future itterations may wish to tie this input to the file name.
    
%%% Next prompt is the cohernce set.  This is the set of coherences from
%%% which each trial may be picked.  It should be typed in as [HC, LC, LC,
%%% LC, LC, LC, LC], where HC is a numerical value of high coherence (85 if
%%% LC>20, 80 if 10<LC<20, and 75 if LC<10) and LC is the low coherence
%%% found through Quest (see above).  The reason you have to repeat LC six
%%% times is so that on average six out of very seven trials will be low
%%% coherence.  High coherence trials provide a break for the subject and
%%% help them learn the hazard rate, but low coherence trials are more
%%% informative.  

%%% Finally you will be asked for the number of practice trials (n).  This
%%% number is usually 15 (or 10% of total trials). The first n trials will
%%% all have the highest coherence possible to help introduce the subject
%%% to the task.

%%% The subject may now run the task as in Quest.

%%% The task should run on its own til the end and save the file into
%%% "MainTaskData"
    
%%% Known issues and "solutions":
    % YELLOW DOT ISSUE:
        % Occationally the program will lose contact with the keyboard and
        % not register a response from teh subject.  This results in a
        % yellow fixation point and a lost trial.  
        
        % SOLUTION: New foundation code has been loaded to adress this
        % issue, but it is unclear if it works perfectly yet. If there are
        % only a few yellow dot trials (<5), continue the trial. Otherwise
        % abort the trial unlesss very close to the end.  See "FROZEN" for
        % how to abort.
        
    % FROZEN:
        % Occationally, there will be a problem in the code that creates
        % the RMD and they will not apear on screen properly. They might
        % flash briefly, or may never turn on/there will be no response to
        % pressing "SPACE" to start a trial.
        
        % SOLUTION: First, close the visual stimulus. The Apple key and "."
        % at the same time.  Then press "ENTER" and then type without
        % quotes "mglClose" with that casing and press "ENTER" again.
        % Should this fail, repeat these steps once as you cannot see if
        % you had a typo.  Once the visual stimulus is closed, close and
        % restart matlab.  Make sure to add the appropriate folders back to
        % the path. Should the same Frozen problem occur, try to restart
        % matlab again and/or the computer.  
        
%% Analysis Code:

%%% Congradulations!  You've got data!  And now it's time to analyze it.
%%% You may do whatever analysis you find appropriate, but there are some
%%% functions I've made that do what I consider necessary.  Check out the
%%% documentation associated with those programs found in the folder: "KAS
%%% Analyzing Data Code" to see if I've already written a function that
%%% extracts what you want.  

%%% Assuming you are looking for the same things I was and followed all the
%%% above instructions regarding naming, the next step is extremely simple.
%%% Merely open the folder "MainTaskData" and type BatchProcessNew in the
%%% Command window.  That's it.  This action will generate three things.
%%% One, a bar graph of average percent correct for each trial type over
%%% all subjects separated by A) penultimate time (separate graphs) B)
%%% Final time (X-axis) and C) Hazard rate and adaptation (colored bars).
%%% Two, a bar graph separated by adaptation vs not (separate graphs),
%%% final time (X-axis), and hazard rate/penultimate time (colored bars). I
%%% find this one most helpful for demonstrating A). whether the crossover
%%% effect is in place when there is no adaptation and the penultimate time
%%% is consistent with previous works, B). Whether the penultimate time
%%% control changed the effect and C), whether adaptation changed the
%%% effect.  Finally, the code will display the numerical average in the
%%% Command window (and will also give as an output these values but they
%%% are less well labeled).

%%% For a demo, go to the folder Spring Work found within MainTaskData and
%%% run BatchProcessNew.

%%% Note, this code does NOT treat subjects differently and calculates the
%%% average over all subjects!

%% General Overview of Program Construction

%%% If you want to tweak any of the parameters of the task, it is important
%%% to know where to find them.  To do this, you need to understand the
%%% various files that allow the Quest and Main Task to run.  They are
%%% based on the same structure so I will be using generic versions of the
%%% individual files. Specific versions for Quest will have the same
%%% structure but will say Quest at the end.

%% QuestforCohernce structure: 
    % There isn't much you should need to change here.  It contains the
    % info about the subject and under what name to store the data (see
    % also, gatherTAFCDotsSubInfoQuest).  It also contains the parameters
    % for the Quest object that actually calculates what the next guess for
    % coherence should be when finding the low coherence.  I don't
    % understand how it works very well, but there is some additional info
    % in "SomeusefulQuestSuggestions" which was made by Kabir.  The parts I
    % do know are pThreshold, which is what your target percent correct is,
    % and the GuessDev, which controls how far from your initial guess the
    % Quest will look.  The bigger it is, the better it does generally, but
    % it also takes bigger jumps when it has too high of a GuessDev.  If
    % you are having real problems with the coherences Quest is suggesting
    % and arent' getting good estimates, I suggst you fiddle with these.

%% RDM_EquSwitch_EquPreFinal structure:
    % As above, this object contains the information about the name to save
    % the data (see also gatherTAFCDotsSubInfo). The main things here you
    % might want to change are the number of blocks (logic.nblocks, see
    % also TAFCDotsLogic) and the number of trials per block
    % (logic.trialsPerBlock).  These are currently hard coded for 1 and 150
    % respectively but you can change the trial number per session.  I
    % don't recomend doing multiple blocks at a time because it currently
    % stores the data slighly differently than it stores a single block,
    % which makes the analysis code tend to not work.  
    
%% gatherTAFCDotsSubInfo(Quest) structure:

%%% This function actually generates the save file into the correct folder.
%%% If you want to change the folder into which the data saves, do it here.
%%% On line 47 after the "fullfile(..." replace the name inside the single
%%% quotes with the name of the file you want to save it under.

%% configureTAFCDotsDur(Quest) structure:

%%% This program is the real meat of the program: it controls the timing of
%%% the various stimuli and sets most of their default parameters.  It is
%%% very interconnected with TAFCDotsLogic(Quest) (see below). There are a
%%% pieces which are important to note:
    % Moving Dot Objects-Start on line 100:
           % These lines create and give default properties to the three
           % moving dots objects in the code. The first object is "stim",
           % which is the test stimulus.  It is not an adaptor so
           % stim.adaptor=false.  It also has a default direction of 0, but
           % this is changed later in the code.  The next two objects are
           % "adaptr" and "adaptl".  These are adaptor stimuli so their
           % adaptor property=true.  adaptr goes 45 degrees and adaptl goes
           % 135 degrees.  Also, they are slighly different colors to help
           % the viewer distinguish them as transparent motion.  Finally,
           % you may notice their density is half of that of stim.  This is
           % because both adaptors are on the screen simaltanously, so they
           % have an overall density equal to stim.
           
    % Trial (order of events)-Starts on line 300:
        % This portion controls the order of events and timing of events
        % within each trial.  See GoldLab Wiki for more info on state
        % machines like this. Certain states contain functions (designated
        % by the @ symbol) that will change properties of the state
        % machine.  For example, @editAdapttime will change how long the
        % adaptors are on by changing the attribute 'timeout' for the
        % 'adapt' state.  Most of these functions are pretty straight
        % forward and can be explored to see what they do. 
        
%% TAFCDotsLogic(Quest) structure:

%%% Logic has two roles. First, it contains all the parameters of a trial,
%%% and chooses/changes them each trial as appropriate.  The parameters are
%%% pretty clearly labeled within the folder, so check that out.

%%% The other role of logic is actually starting/initiating the trials.
%%% See line 148 (165 in Quest version) for what logic does when a trial
%%% starts.  The non-quest version has slighly better commented
%%% explainations of what it's doing. The Quest version also changes the
%%% coherence of the upcoming trial acording to the Quest-object's
%%% suggestion in this section.

%% dotsDrawableDynamicDotKinetogramAdaptorOption(Quest) structure:

%%% class description for Moving Dots stimuli.  Properties are fairly well
%%% labled within.  See also snow-dots demo documentation. Has the
%%% additional feature of being an adaptor or not.  The actual motion is
%%% controled by the function computeNextFrame(self) on line 216.  The part
%%% about switching is well documented.  The rest of that function controls
%%% the position of the non-coherent dots and I don't mess with it.

%% Thank You!  And I hope this has been useful!