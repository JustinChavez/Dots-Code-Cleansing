# Dots-Code-Cleansing
This code programs a TAFC task for participants. It has been adapted from code used from previous projects (since 2013) which contains features irrelevant for future use and software debt (bugs). It is currently in the progress of being stripped of those features and bugs for simplified future use. 

## Prerequisites
Please use MATLAB Version 2016a or earlier. MATLAB 2017 has fatal flaws withing MGL that [are being looked into](https://github.com/justingardner/mgl/issues/20)

The rest of the libraries are contained within this repository. Clone this repository into your desired location to implement.
```
git clone https://github.com/JustinChavez/Dots-Code-Cleansing.git
```
## Deployment
To Run the Demo, use MATLAB to run the file TAFC-Dots-Original/scriptRun.m

This will launch a window where you will see dots moving either left or right. Like so
![alt text](https://raw.githubusercontent.com/JustinChavez/Images/master/Dots-Code-Cleansing/Dots_Moving.png "Dots Moving")

The program will then wait for the participant to enter the direction they infer the dots were moving. Either Left with "f" or Right with "j". 

A dot in the middle of the screen will then light up green or red based on if the participant got the inference right or wrong. 

Right             |  Wrong
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/JustinChavez/Images/master/Dots-Code-Cleansing/Dots_Right.png)  |  ![](https://raw.githubusercontent.com/JustinChavez/Images/master/Dots-Code-Cleansing/Dots_Wrong.png)

After the specified amount of trials and blocks of testing. The results of each test (time to decision, correct decision, coherence, etc.) will be recorded in the folder TAFCDotsData. 

## Adjusting

In the file TAFC-Dots-Original/scriptRun.m you can adjust parameters that will affect how the test is carried out.

# Acknowledgements

Code Adapted from Kyra Schapiro, Christopher Glaze, Matt Nassar, and Ben Heasley.

