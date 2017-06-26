%Set parameters
pThreshold = 0.65;
Guess = 8;
GuessDev = 4;

% These I don't understand
beta = 3.5;
delta = 0.01; 
gamma = 0.5;

%Creating object
questobj = QuestCreate(Guess, GuessDev, pThreshold, beta, delta, gamma);

%% YOUR CODE WILL BE HERE

%It'll make a guess at what coherence to use to get 65%
newCoherence = QuestQuanitile(questobj);

%CODE TO PLAY STIMULUS AND GET INPUT SOMEWHERE HERE
response = 1; %Or 0 if it's wrong

%now it will actually update
questobj = QuestUpdate(questobj,newCoherence,response);

