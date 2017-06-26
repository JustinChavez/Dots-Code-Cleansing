function [ LowPreFST, HighPreFST, megaLow, megaHigh, MEGA] = BatchProcessPreFST( input_args )
%UNTITLED Summary of this function goes here
%   NOT CURRENTLY USED:  SEE BatchProcessNew

filelist=dir('*.mat');
TenthHzLowFSTLowPreFST=[];
TenthHzLowFSTHighPreFST=[];
TenthHzHighFSTLowPreFST=[];
TenthHzHighFSTHighPreFST=[];

TwoHzLowFSTLowPreFST=[];
TwoHzLowFSTHighPreFST=[];
TwoHzHighFSTLowPreFST=[];
TwoHzHighFSTHighPreFST=[];

numLLL=0;
numLLH=0;
numLHL=0;
numLHH=0;
numHLL=0;
numHLH=0;
numHHL=0;
numHHH=0;


megalow=zeros(4,0);
megahigh=zeros(4,0);
mega=zeros(4,0);
fns={'H_rate';'correct'; 'PreFST'; 'FST'};



for i=1:length(filelist)
    totaldata=load(filelist(i).name);
    statusData=totaldata.statusData;
    
    
    if ~isempty(strfind(filelist(i).name, '2Hz')) %For Fast H rates
        for j=1:length(statusData)
        if statusData(j).coherence<50
            newdata=[2; statusData(j).correct; statusData(j).PreFST/60; statusData(j).FST];
            if statusData(j).PreFST/60>.3 && statusData(j).FST>.03
                megahigh=[megahigh,newdata];
                mega=[mega,newdata];
            end
        end
        end
        
        [LL, LH, HL, HH, numLL, numLH, numHL, numHH]=SortKASDataTime(statusData);
        numHLL=numHLL+numLL;
        numHLH=numHLH+numLH;
        numHHL=numHHL+numHL;
        numHHH=numHHH+numHH;
        
        if ~isnan(LL)
        TwoHzLowFSTLowPreFST=[TwoHzLowFSTLowPreFST, LL];
        end
        if ~isnan(LH)
        TwoHzLowFSTHighPreFST=[TwoHzLowFSTHighPreFST, LH];
        end
        if ~isnan(HL)
        TwoHzHighFSTLowPreFST=[TwoHzHighFSTLowPreFST, HL];
        end
        if~isnan(HH)
        TwoHzHighFSTHighPreFST=[TwoHzHighFSTHighPreFST, HH];
        end
        
    elseif ~isempty(strfind(filelist(i).name, 'tenth')) %For Slow H rates
        for j=1:length(statusData)
        if statusData(j).coherence<50
            newdata=[0.1;statusData(j).correct; statusData(j).PreFST/60; statusData(j).FST];
           if statusData(j).PreFST/60>.3  && statusData(j).FST>.03
                megalow=[megalow,newdata];
                mega=[mega,newdata];
            end
        end
        end
        
        
        [LL, LH, HL, HH, numLL, numLH, numHL, numHH]=SortKASDataTime(statusData);
        numLLL=numLLL+numLL;
        numLLH=numLLH+numLH;
        numLHL=numLHL+numHL;
        numLHH=numLHH+numHH;
        if ~isnan(LL)
        TenthHzLowFSTLowPreFST=[TenthHzLowFSTLowPreFST, LL];
        end
        if ~isnan(LH)
        TenthHzLowFSTHighPreFST=[TenthHzLowFSTHighPreFST, LH];
        end
        if ~isnan(HL)
        TenthHzHighFSTLowPreFST=[TenthHzHighFSTLowPreFST, HL];
        end
        if ~isnan(HH)
        TenthHzHighFSTHighPreFST=[TenthHzHighFSTHighPreFST, HH];
        end
    end
    
      
end

megalow=num2cell(megalow);
megahigh=num2cell(megahigh);
mega=num2cell(mega);

megaLow=cell2struct(megalow,fns,1);
megaHigh=cell2struct(megahigh,fns,1);
MEGA=cell2struct(mega,fns,1);


meanSLL=mean(TenthHzLowFSTLowPreFST);
meanSLH=mean(TenthHzLowFSTHighPreFST);
meanSHL=mean(TenthHzHighFSTLowPreFST);
meanSHH=mean(TenthHzHighFSTHighPreFST);

meanFLL=mean(TwoHzLowFSTLowPreFST);
meanFLH=mean(TwoHzLowFSTHighPreFST);
meanFHL=mean(TwoHzHighFSTLowPreFST);
meanFHH=mean(TwoHzHighFSTHighPreFST);

LowPreFST=[meanSLL, meanFLL; meanSHL, meanFHL];
HighPreFST=[meanSLH, meanFLH; meanSHH, meanFHH];

%figure
%ax1 = subplot(2,1,1);
%bar(ax1,LowPreFST);

%ax2 = subplot(2,1,2);
%bar(ax2,HighPreFST);

disp('Number of Low H rates with LowT PreFinal and Low T final is');
disp(numLLL);
disp('Number of High H rates with LowT PreFinal and Low T final is');
disp(numHLL);
disp('Number of Low H rates with LowT PreFinal and High T final is');
disp(numLLH);
disp('Number of High H rates with LowT PreFinal and High T final is');
disp(numHLH);
disp('Number of Low H rates with HighT PreFinal and Low T final is');
disp(numLHL);
disp('Number of High H rates with HighT PreFinal and Low T final is');
disp(numHHL);
disp('Number of Low H rates with HighT PreFinal and High T final is');
disp(numLHH);
disp('Number of High H rates with HighT PreFinal and High T final is');
disp(numHHH);












end

