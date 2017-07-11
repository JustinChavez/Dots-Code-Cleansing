function demoPredInfLogic()
% Put the PredInfLogic class through some paces for demo and testing.

%% Set up a new predictive inference object
time = clock();
randSeed = 5;%time(6)*10e6;
logic = PredInfLogic(randSeed);
logic.name = 'predictive inference demo';
logic.time = time;
logic.nBlocks = 3;
logic.blockHazards = [1 1 1] * 0.1;
logic.safetyTrials = 3;
logic.blockStds = [5 5 15];
logic.trialsPerBlock = 10;
logic.isBlockShuffle = false;
logic.fixedOutcomes = [];
logic.maxOutcome = 100;
logic.isPredictionReset = true;
logic.isPredictionLimited = true;

% Choose payout structure.
% "weights" tell how to mix [omniscient and amnesiac] observers
logic.goldObserverWeights = [2 1];
logic.silverObserverWeights = [1 2];
logic.bronzeObserverWeights = [0 1];
logic.goldPayout = '$15';
logic.silverPayout = '$12';
logic.bronzePayout = '$10';

%% Run through some phoney blocks and trials

% get struct arrays big enough to hold all the data
logic.startSession();
[statusData, payoutData] = logic.getDataArrays();

% simulate a subject and fill in the data arrays at each trial
badTrialRate = .1;
for bb = 1:logic.nBlocks
    logic.startBlock();
    
    for tt = 1:logic.trialsPerBlock
        logic.startTrial();
        
        % sometimes fail the trial
        isGoodTrial = rand(1) > badTrialRate;
        if isGoodTrial
            % use a prediction with a random alpha
            bounds = [logic.lastOutcome logic.lastPrediction];
            if all(isfinite(bounds))
                lower = min(bounds);
                upper = max(bounds);
                prediction = lower + (rand(1)*(upper-lower));
            else
                prediction = logic.maxOutcome/2;
            end
            logic.setPrediction(prediction);
        end
        logic.setGoodTrial(isGoodTrial);
        logic.finishTrial();
        
        % add trial data to data arrays
        statusData(tt,bb) = logic.getStatus();
        payoutData(tt,bb) = logic.getPayout();
    end
end

%% Plot data frmo the phoney run
close all
f = figure();
nTrials = numel(statusData);
trials = 1:nTrials;
blocks = 1 + (0:(logic.nBlocks-1))*logic.trialsPerBlock;

% outcomes and predictions
ax = subplot(3, 1, 1, ...
    'Parent', f, ...
    'XLim', [0, nTrials+1], ...
    'XTick', blocks, ...
    'XGrid', 'on', ...
    'YLim', [0, logic.maxOutcome]);
line(trials, [statusData.currentMean], ...
    'Parent', ax, ...
    'Marker', 'none', ...
    'LineStyle', '-', ...
    'LineWidth', 1, ...
    'Color', [1 1 1]*.25);
line(trials, [statusData.currentOutcome], ...
    'Parent', ax, ...
    'Marker', '*', ...
    'MarkerSize', 10, ...
    'LineStyle', 'none', ...
    'LineWidth', 1, ...
    'Color', [1 1 1]*.55);
line(trials, [statusData.omniscientMean], ...
    'Parent', ax, ...
    'Marker', 'O', ...
    'LineStyle', 'none', ...
    'LineWidth', 1, ...
    'Color', [1 .85 0]);
line(trials, [statusData.currentPrediction], ...
    'Parent', ax, ...
    'Marker', '.', ...
    'LineStyle', 'none', ...
    'LineWidth', 1, ...
    'Color', [1 0 0]);
legend(ax, 'mean outcome', 'current outcome', ...
    '"omniscient" mean', 'current prediction', ...
    'Location', 'northwest')
ylabel(ax, 'outcome range');

% trial counters
ax = subplot(3, 1, 2, ...
    'Parent', f, ...
    'XLim', [0, nTrials+1], ...
    'XTick', blocks, ...
    'XGrid', 'on');
steadies = [statusData.steadyTrials];
line(trials, steadies, ...
    'Parent', ax, ...
    'Marker', '.', ...
    'LineStyle', 'none', ...
    'LineWidth', 1, ...
    'Color', [0 0 1]);
line(trials, [statusData.remainingSafety], ...
    'Parent', ax, ...
    'Marker', 'O', ...
    'LineStyle', 'none', ...
    'LineWidth', 1, ...
    'Color', [0 1 0]);
changes = [statusData.isChangeTrial];
line(trials(changes), steadies(changes), ...
    'Parent', ax, ...
    'Marker', 'X', ...
    'LineStyle', 'none', ...
    'LineWidth', 2, ...
    'Color', [1 0 0]);
legend(ax, 'steady', 'safety', 'change', 'Location', 'northwest');
ylabel(ax, 'trials');

% observer performance
ax = subplot(3, 1, 3, ...
    'Parent', f, ...
    'XLim', [0, nTrials+1], ...
    'XTick', blocks, ...
    'XGrid', 'on');
line(trials, [statusData.amnesiacCumulativeError], ...
    'Parent', ax, ...
    'Marker', 'none', ...
    'LineStyle', '-', ...
    'LineWidth', 1, ...
    'Color', [.65 .45 0]);
line(trials, [statusData.omniscientCumulativeError], ...
    'Parent', ax, ...
    'Marker', 'none', ...
    'LineStyle', '-', ...
    'LineWidth', 1, ...
    'Color', [1 .85 0]);
line(trials, [statusData.cumulativeError], ...
    'Parent', ax, ...
    'Marker', '.', ...
    'LineStyle', 'none', ...
    'LineWidth', 1, ...
    'Color', [1 0 0]);
legend(ax, '"amnesiac"', '"omniscient"', 'subject', ...
    'Location', 'northwest')
ylabel(ax, 'cumulative error');
xlabel(ax, 'trial number');