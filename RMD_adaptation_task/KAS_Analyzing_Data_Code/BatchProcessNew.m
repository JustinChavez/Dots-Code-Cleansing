function [ LowPreFST, HighPreFST, megaLow, megaHigh, MEGA] = BatchProcessNew( input_args )
%BatchProcessNew:  Take a directory of data of both Slow switching and Fast
%Switching and sort by Final State and Prefinal State and get the overall
%percentage correct in each condition.  Also makes graph.
%   Detailed explanation goes here

filelist=dir('*.mat');  %Grab all the files in the current directory that end in .mat

%Initialize a matrix for all possible coditions [total,correct].
%Conditions are Hazard Rate (.5 or 3), Final State Time (Low=.25 or
%High=2.25), and Penultimate State time (PreFSTL: Low= 20 frames=.3 seconds or
%High=120 frames, or 2 seconds).  If there is an a in front of it, that
%stands for the pre-adaptation.


HalfHLowFSTLowPreFST=[0,0];
HalfHLowFSTHighPreFST=[0,0];
HalfHHighFSTLowPreFST=[0,0];
HalfHHighFSTHighPreFST=[0,0];


aHalfHLowFSTLowPreFST=[0,0];
aHalfHLowFSTHighPreFST=[0,0];
aHalfHHighFSTLowPreFST=[0,0];
aHalfHHighFSTHighPreFST=[0,0];

ThreeHzLowFSTLowPreFST=[0,0];
ThreeHzLowFSTHighPreFST=[0,0];
ThreeHzHighFSTLowPreFST=[0,0];
ThreeHzHighFSTHighPreFST=[0,0];


aThreeHzLowFSTLowPreFST=[0,0];
aThreeHzLowFSTHighPreFST=[0,0];
aThreeHzHighFSTLowPreFST=[0,0];
aThreeHzHighFSTHighPreFST=[0,0];



numSLL=0;
numSLH=0;
numSHL=0;
numSHH=0;
numFLL=0;
numFLH=0;
numFHL=0;
numFHH=0;


anumSLL=0;
anumSLH=0;
anumSHL=0;
anumSHH=0;
anumFLL=0;
anumFLH=0;
anumFHL=0;
anumFHH=0;



%%%megalow is an array of all the low hazard rate trials' pertient information, 
%%%megahigh is an array of all the high hazard rate trials' pertinent info,
%%%mega is an array of all the trials with their pertinent info.

megalow=zeros(4,0);
megahigh=zeros(4,0);
mega=zeros(4,0);
fns={'H_rate'; 'correct'; 'PreFST'; 'tPFS'};



for i=1:length(filelist)
    totaldata=load(filelist(i).name);
    statusData=totaldata.statusData;
    
    
    if ~isempty(strfind(filelist(i).name, 'H3')) %For Fast H rates, has H3 in the name
        if isempty(strfind(filelist(i).name, 'No')) %If you don't find the word No, which implies No Adaptation=For adaptation Trials
            for j=1:length(statusData)
                if statusData(j).coherence<50
                     newdata=[2; statusData(j).correct; statusData(j).PreFST/60; statusData(j).tPFS]; %%%Extract just the parts of interest from the data set, i.e. final state, penultimate state, correct, and whether it was adaptation=2.
                        if statusData(j).PreFST/60>.3 && statusData(j).tPFS>.03  %%Extract JUST the trials that have a penuntimate state of >.3 seconds and final state>.03 seconds
                            megahigh=[megahigh,newdata];  %Store these trials in High H rate
                            mega=[mega,newdata];   %Store these trials in ALL trials
                        end
                end
             end
        
        [LL, LH, HL, HH, numLL, numLH, numHL, numHH]=SortKASDataTimeNewData(statusData);
        anumFLL=anumFLL+numLL;
        anumFLH=anumFLH+numLH;
        anumFHL=anumFHL+numHL;
        anumFHH=anumFHH+numHH;
        
        aThreeHzLowFSTLowPreFST=aThreeHzLowFSTLowPreFST+LL;

        aThreeHzLowFSTHighPreFST=aThreeHzLowFSTHighPreFST+LH;

        aThreeHzHighFSTLowPreFST=aThreeHzHighFSTLowPreFST+HL;

        aThreeHzHighFSTHighPreFST=aThreeHzHighFSTHighPreFST+HH;
 
        else   %For No Adapatation trials
            for j=1:length(statusData)
                if statusData(j).coherence<50
                    newdata=[2; statusData(j).correct; statusData(j).PreFST/60; statusData(j).tPFS];
                        if statusData(j).PreFST/60>.3 && statusData(j).tPFS>.03
                             megahigh=[megahigh,newdata];
                               mega=[mega,newdata];
                        end
                end
             end
        
        [LL, LH, HL, HH, numLL, numLH, numHL, numHH]=SortKASDataTimeNewData(statusData);
        numFLL=numFLL+numLL;
        numFLH=numFLH+numLH;
        numFHL=numFHL+numHL;
        numFHH=numFHH+numHH;
        
        ThreeHzLowFSTLowPreFST=ThreeHzLowFSTLowPreFST+LL;
    
        ThreeHzLowFSTHighPreFST=ThreeHzLowFSTHighPreFST+LH;
       
        ThreeHzHighFSTLowPreFST=ThreeHzHighFSTLowPreFST+HL;
  
        ThreeHzHighFSTHighPreFST=ThreeHzHighFSTHighPreFST+HH;
      
  
        end

    elseif ~isempty(strfind(filelist(i).name, 'dot')) %For Slow H rates
        if isempty(strfind(filelist(i).name, 'No')) %For adaptation Trials
            for j=1:length(statusData)
                if statusData(j).coherence<50
                  newdata=[2; statusData(j).correct; statusData(j).PreFST/60; statusData(j).tPFS];
                    if statusData(j).PreFST/60>.3 && statusData(j).tPFS>.03
                    megalow=[megalow,newdata];
                    mega=[mega,newdata];
                    end
                end
            end
        
        [LL, LH, HL, HH, numLL, numLH, numHL, numHH]=SortKASDataTimeNewData(statusData);
        anumSLL=anumSLL+numLL;
        anumSLH=anumSLH+numLH;
        anumSHL=anumSHL+numHL;
        anumSHH=anumSHH+numHH;
        
        aHalfHLowFSTLowPreFST=aHalfHLowFSTLowPreFST+LL;

        aHalfHLowFSTHighPreFST=aHalfHLowFSTHighPreFST+LH;

        aHalfHHighFSTLowPreFST=aHalfHHighFSTLowPreFST+HL;

        aHalfHHighFSTHighPreFST=aHalfHHighFSTHighPreFST+HH;
 
        else   %For No Adapatation trials
            for j=1:length(statusData)
                if statusData(j).coherence<50
                    newdata=[2; statusData(j).correct; statusData(j).PreFST/60; statusData(j).tPFS];
                        if statusData(j).PreFST/60>.3 && statusData(j).tPFS>.03
                             megalow=[megalow,newdata];
                               mega=[mega,newdata];
                        end
                end
             end
        
        [LL, LH, HL, HH, numLL, numLH, numHL, numHH]=SortKASDataTimeNewData(statusData);
        numSLL=numSLL+numLL;
        numSLH=numSLH+numLH;
        numSHL=numSHL+numHL;
        numSHH=numSHH+numHH;
        
        HalfHLowFSTLowPreFST=HalfHLowFSTLowPreFST+LL;
    
        HalfHLowFSTHighPreFST=HalfHLowFSTHighPreFST+LH;
       
        HalfHHighFSTLowPreFST=HalfHHighFSTLowPreFST+HL;
  
        HalfHHighFSTHighPreFST=HalfHHighFSTHighPreFST+HH;
      
  
    end
    
      
end
end
megalow=num2cell(megalow);
megahigh=num2cell(megahigh);
mega=num2cell(mega);

megaLow=cell2struct(megalow,fns,1);
megaHigh=cell2struct(megahigh,fns,1);
MEGA=cell2struct(mega,fns,1);


meanSLL=HalfHLowFSTLowPreFST(2)/HalfHLowFSTLowPreFST(1);
meanSLH=HalfHLowFSTHighPreFST(2)/HalfHLowFSTHighPreFST(1);
meanSHL=HalfHHighFSTLowPreFST(2)/HalfHHighFSTLowPreFST(1);
meanSHH=HalfHHighFSTHighPreFST(2)/HalfHHighFSTHighPreFST(1);

meanFLL=ThreeHzLowFSTLowPreFST(2)/ThreeHzLowFSTLowPreFST(1);
meanFLH=ThreeHzLowFSTHighPreFST(2)/ThreeHzLowFSTHighPreFST(1);
meanFHL=ThreeHzHighFSTLowPreFST(2)/ThreeHzHighFSTLowPreFST(1);
meanFHH=ThreeHzHighFSTHighPreFST(2)/ThreeHzHighFSTHighPreFST(1);

ameanSLL=aHalfHLowFSTLowPreFST(2)/aHalfHLowFSTLowPreFST(1);
ameanSLH=aHalfHLowFSTHighPreFST(2)/aHalfHLowFSTHighPreFST(1);
ameanSHL=aHalfHHighFSTLowPreFST(2)/aHalfHHighFSTLowPreFST(1);
ameanSHH=aHalfHHighFSTHighPreFST(2)/aHalfHHighFSTHighPreFST(1);

ameanFLL=aThreeHzLowFSTLowPreFST(2)/aThreeHzLowFSTLowPreFST(1);
ameanFLH=aThreeHzLowFSTHighPreFST(2)/aThreeHzLowFSTHighPreFST(1);
ameanFHL=aThreeHzHighFSTLowPreFST(2)/aThreeHzHighFSTLowPreFST(1);
ameanFHH=aThreeHzHighFSTHighPreFST(2)/aThreeHzHighFSTHighPreFST(1);


LowPreFST=[meanSLL, ameanSLL ,meanFLL, ameanFLL; meanSHL, ameanSHL, meanFHL, ameanFHL];
HighPreFST=[meanSLH, ameanSLH; meanSHH, ameanSHH];

figure % Plot the mean correct by Short vs Long Penultimate State
ax1 = subplot(2,1,1);
bar(ax1,LowPreFST);
title('Short Penultimate State');
ylabel('Percent Correct');
axis([-inf,inf,0,1]);
legend('No Adapt, H=.5','Adaptation, H=.5','No Adapt, H=3','Adaptation, H=3');
set(gca,'xticklabel',{'Short Final State=.25 sec', 'Long Final State=2.25 sec'});

ax2 = subplot(2,1,2);
bar(ax2,HighPreFST);
title('Long Penultimate State');
ylabel('Percent Correct');
axis([-inf,inf,0,1]);
legend('No Adapt, H=.5','Adaptation, H=.5');
set(gca,'xticklabel',{'Short Final State=.25 sec', 'Long Final State=2.25 sec'});


NonAdaptation=[meanSLL, meanSLH , meanFLL;  meanSHL, meanFHL, meanSHH];
Adaptation=[ameanSLL, ameanFLL ameanSHL; ameanSLH , ameanFHL, ameanSHH];


figure  % Plot the mean correct by Whether there was Pre-Adaptation or not
ax1 = subplot(2,1,1);
bar(ax1,NonAdaptation);
title('No-Adaptation Percent correct by Condition');
ylabel('Percent Correct');
axis([-inf,inf,0,1]);
legend('H=.5, Penultimate State Short','H=.5 Penultimate State Long','H=3 Penultimate State Short');
set(gca,'xticklabel',{'Short Final State=.25 sec', 'Long Final State=2.25 sec'});

ax2 = subplot(2,1,2);
bar(ax2,Adaptation);
title('Adaptation percent correct by Condition');
ylabel('Percent Correct');
axis([-inf,inf,0,1]);
legend('H=.5, Penultimate State Short','H=.5 Penultimate State Long','H=3 Penultimate State Short');
set(gca,'xticklabel',{'Short Final State=.25 sec', 'Long Final State=2.25 sec'});


disp('Number of Low H rates with Low T final and LowT PreFinal and  is');
disp(numSLL);
disp('Number of High H rates with Low T final  and LowT PreFinal and is');
disp(numFLL);
disp('Number of Low H rates with LowT final and HighT PreFinal is');
disp(numSLH);
disp('Number of High H rates with LowT final and HighT PreFinal is');
disp(numFLH);
disp('Number of Low H rates with HighT final and LowT PreFinal is');
disp(numSHL);
disp('Number of High H rates with HighT final and LowT PreFinal is');
disp(numFHL);
disp('Number of Low H rates with HighT final and HighT PreFinal is');
disp(numSHH);
disp('Number of High H rates with HighT final and HighT PreFinal is');
disp(numFHH);














end