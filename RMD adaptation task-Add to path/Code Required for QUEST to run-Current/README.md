### QuestforCoherence

Contains info about subject (ex. name) and parameters for the Quest object that calculates what the next guess for coherence should be when finding the low coherence.  

Unsure about how exactly this file carries out the function. Some additional information in SomeusefulQuestSuggestions (by Kabir).:
- pThreshold is what your target percent correct is
- GuessDev controls how far from your initial guess the Quest will look

TODO:
- Need to examine file further

### gatherTAFCDotsSubInfo

Generates save file into the correct folder. Can change save folder name/location line 47 after fullfile(...)

TODO:
- change so we don't have to go to line 47 to save the file.


### RDM_EquSwitch_EquPreFinal (MDST)

contains: 
- info about the name to save the data. 
- number of blocks (logic.nblocks)
- number of trials per block (logic.trialsPerBlock)

TODO:
- logic.nblock is currently hardcoded for 1. Not advisable to do anything else because it stores the data slightly differently than it stores a single block which causes analysis code to crash

configureTAFCDotsDur

Real meat of the program. Controls the timing stimuli and sets most of their default parameters. Interconnected with TAFCDotsLogic:
- Moving Dot Objects-Start on line 100. Create and give default properties to the three moving dots objects in the code:
	- stim - test stimulus. not an adaptor so stim.adaptor=false. Also has default direction of 0 (changed later).
	- adaptr - adaptor stimuli. goes 45 degrees. diff color than other adaptr. 
	- adaptr1 - goes 135 degrees. diff color. Note that both stimuli have density half of that of stim. Because they are on the screen simultanously they have an overall density equal to stim.

- Trial (order of events) - starts on line 300. Controls order and timing of events in each trial. State machine:
	- see GoldLab wiki for more info on state machines like this. Certain states contail functions (designated by the @ symbol) that will change properties of the state machine (ex. @editAdapttime will change how long the adaptors are on thourh attribute timeout for the adapt state). 

### TAFCDotsLogic

Two roles:
- First, it contains all the parameters of a trial and chooses/changes them each trial as approporiate. Parameters are clearly labeled within the folder.
- Second, starts and initiates the trials (line 148/165(Quest)). Quest version changes the coherence of the upcoming trial according to the Quest-object's suggestion.

### dotsDrawableDynamicDotKinetogramAdaptorOption

Class description for moving dots stimuli. More information in snow-dots demo documentation. Actual motion is controlled by the function computeNextFrame(self) on line 216. 
