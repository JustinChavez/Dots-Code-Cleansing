
classdef TAFCDotsLogic < handle
    % TDK, 6/29/2012
    % For the within trials hazard rate TAFC task 9/11/2013
    
    properties
        % a name to identify this session
        name = '';
        
        % total stimulus duration within a trial (for interrogation
        % paradigm only)
        duration = 0.5;
        
        % hazard rate within trial
        H = 0.03; % time-step in 1/60 sec, since frames change in 60 Hz
             
        % a time to identify this session
        time = 0;
        
        % the number of blocks to run
        nBlocks = 1;
        
        % indicates the current block
        currentBlock = 0;

        % number of trials within each block
        trialsPerBlock = 1;
        
        % running count of good trials in each block
        blockCompletedTrials = 0;
        
        % running count of good and bad trials in each block
        blockTotalTrials = 0;
        
            
        % seed for initializing random number generators
        randSeed = 1;
        
        % initial direction
        direction0 = 0;
        
        % set of coherences to pick from
        coherenceset = [0 0 0];

        choice = 0;
        % temporary variables for storing data
        ReactionTimeData = [];
        PercentCorrData = [];
        
        score = 0;
        
        correct = -1;
        
        directionvc = [];
        
        coherencevc = [];
        
        
        %***
        durationset=[4,8];
        
        decisiontime_max = Inf;
        
        stimstrct = [];
        
        practiceN = 0;
        
        % name of a file that can be used for writing data
        dataFileName = 'TAFCDotsData'
        
        keyhistory = [];

        tPostFinalSwitchset=[.25, 2.25];  %Possible times of viewing stimulus direction in seconds
        tPFS=0;
        adaptorCounter=0;
        adaptor=1; %non-adapting trials by default (1 is false, 2 is true)
        

    end
    
    properties (SetAccess = protected)
        % time after the change of direction
        tAfter;

        % reaction time: the tic starts when the dots change direction
        % this measures the reaction time for hits
        reactionTime;
        
        % the tic of reaction time
        t;
        
        % whether the current trial is good and complete
        isGoodTrial;
        
        coherence;
        
        PreFST=1; %How long was the prefinal state in this trial
        
        shorty=0; %Used for Slow H Rates only, is this trial going to be one with a shroter penultimate state.  Draws from offset set
        
        offsets=[0,0,0,20]; % set of possible offsets 
        

        
    end
    
    methods
        
        % Constructor takes no arguments.
        function self = TAFCDotsLogic(randSeed)
            if nargin
                self.randSeed = randSeed;
            end
            self.startSession();
        end
        
        % Initialize random number functions from randSeed.
        function initializeRandomGenerators(self)
            %             rand('seed', self.randSeed);
            %             randn('seed', self.randSeed);
            
            rng(self.randSeed);
        end
        
        % Set up for the first trial of the first block.
        function startSession(self)
            self.initializeRandomGenerators();
            
            % reset session totals
            self.currentBlock = 0;
            self.blockCompletedTrials = 0;
            self.blockTotalTrials = 0;
        end
        
        % Set up for a new block.
        function startBlock(self)
            % increment the block and choose block parameters
            self.currentBlock = self.currentBlock + 1;
            
            % reset trial-by-trial state
            self.blockCompletedTrials = 0;
            self.blockTotalTrials = 0;
            self.adaptorCounter=0;

        end
        
        % Set up for a new trial.
        function startTrial(self)
            
            % initialize the variables
            timetmp = clock;
            self.randSeed = timetmp(6)*10e6;
            rng(self.randSeed);
            
            self.reactionTime = -1;
            self.t = -1;
            self.choice = 0;
            self.keyhistory = [];
            % default to bad trial, unless set to good
            self.isGoodTrial = false;
            
            
            %If we haven't done enough practice trials, this trial has the
            %highest possible coherence.  Otherwise pick a random coherense
            %from the set
            if self.blockCompletedTrials <= self.practiceN
                self.coherence = max(self.coherenceset);
            else
                randind = randperm(length(self.coherenceset));
                self.coherence = self.coherenceset(randind(1));
            end

            %Pick a random duration
            randpart=randperm(length(self.durationset));
            self.duration = self.durationset(randpart(1));
            
            
            %***Kyra code Pick a random Final time
            randspt = randperm(length(self.tPostFinalSwitchset));
            self.tPFS = self.tPostFinalSwitchset(randspt(1));
            
            %Pick a random offset time
            randnew = randperm(length(self.offsets));
            self.shorty = self.offsets(randnew(1));
            
            
            
            
            %****

            
            
            
            
            
            self.setTimeAfter(0);
            
            
            
            
%             
        end
        
        % records the reaction time
        function setDetection(self)
                self.reactionTime = mglGetSecs(self.t);
        end
        
        function setTimeStamp(self)
                self.t = mglGetSecs;
        end
                

        % the inputTime should be in milliseconds
        function setTimeAfter(self, inputTime) % We are not using tAfter for now.
            self.tAfter = inputTime / 1000; % converting to seconds
        end
        
        % Compute behavioral parameters for the current prediction.
        function computeBehaviorParameters(self)
            if self.choice ~= 0
                self.ReactionTimeData = [self.ReactionTimeData self.reactionTime];
                self.PercentCorrData = [self.PercentCorrData self.correct];
                %self.score = (mean(self.PercentCorrData))./(mean(self.ReactionTimeData));
                
                %Insert code here to calculate timespent in prefinal state
                    %Get lenght of directonvc, time in prefinal stat=i=0; while
                    %directionvc(final-i)=directionvc(final-i-1), add 1 to
                    %i
                    total=length(self.directionvc);
                    disp(total);
             h=0;
             while self.directionvc(total-h)==self.directionvc(total-h-1)
                         h=h+1;
             end
                     h=h+1;
                     self.PreFST=1;
             while total-h-self.PreFST-1>0
                 if self.directionvc(total-h-self.PreFST)==self.directionvc(total-h-self.PreFST-1) 
                    self.PreFST=self.PreFST+1;
                 else
                     break
                 end
              end
                
            end
        end
        
        function setGoodTrial(self)
            self.isGoodTrial = true;
        end
        
        % Finish up the current trial.
        function finishTrial(self)
            
            
            if self.isGoodTrial
                self.blockCompletedTrials = self.blockCompletedTrials + 1;
            end
            self.blockTotalTrials = self.blockTotalTrials + 1;
        end
        
        function finishBlock(self)
            % computing
        end

        % getting a data array
        function status = getDataArray(self, extraTrials)
            if nargin < 2 || isempty(extraTrials)
                extraTrials = 0;
            end
            nTrials = self.trialsPerBlock + extraTrials;
            
            statusFields = fieldnames(self.getStatus());
            empties = cell(size(statusFields));
            template = cell2struct(empties, statusFields);
            status = repmat(template, nTrials, self.nBlocks);
        end
        
        % Summarize the current status of the session in a struct.
        function status = getStatus(self)
            props = properties(self);
            values = cell(size(props));
            for ii = 1:numel(props)
                values{ii} = self.(props{ii});
            end
            status = cell2struct(values, props);
        end
    end
end