function [ pLL, pLH, pHL ,pHH, numLL, numLH, numHL, numHH ] = SortKASDataTime (data)

%%% This function, takes a data set and sorts it by Final Time and
%%% Penultimate Time.  For the LOW Coherence trials (because the high
%%% coherence trials are less informative), it then calculates the total
%%% number of trials of each type and the perecntage correct.  It returns
%%% the pAB, wher p stands for percent, A is the time in the final state
%%% (L=low, H=high), and B is the time in the penultimate state (L=Low,
%%% H=High).  It also returns the number of each type of trial, which is
%%% useful to check if each trial type is being equally represented or rare
%%% in different conditions/versions of the experiemnt

%%% see also SortKASDataTimeNewData.

%%%This code is used by BatchProcessPreFST


LowTLowPre=[0 0];  %first is total number of trials with a low final and prenultimate time, second is correct
LowTHiPre=[0 0];
HiTLowPre=[0 0];
HiTHiPre=[0 0];
LowTs=[];   %An index of all the trials within the data set that had a LOW final time AND a low coherence
HiTs=[];  %An index of all the trials within the data set that had a HIGH final time AND a low coherence


for i=1:length(data)            %Make an index of all low T and hi T trials
    if data(i).coherence<50  %low coherence only because high coherence is less informative
        if data(i).FST<1.0 && data(i).FST>0.1 %  Low time
            LowTs=[LowTs, i];

        elseif data(i).FST<5 && data(i).FST>1.75           %Large time
            HiTs=[HiTs, i];
        end
   
    end
    
  
end

for i=LowTs
    if data(i).PreFST>5   %If the Penultimate state was more than 5 frames (fewer than five frames is too little time for it to really count as a real switch in my opinion, may want to raise this number, but lessens the number of trials you get
    if data(i).PreFST<25  %If the Penultimate state was fewer than 25 frames, or about .4 seconds
        LowTLowPre(1)=LowTLowPre(1)+1;
        if data(i).correct==1
            LowTLowPre(2)=LowTLowPre(2)+1;
        end
    elseif data(i).PreFST<200  %if the Penultimate state was longer than 3.3 seconds
        LowTHiPre(1)=LowTHiPre(1)+1;
        if data(i).correct==1
            LowTHiPre(2)=LowTHiPre(2)+1;
        end
    end   
    end
end

for i=HiTs
    if data(i).PreFST>5
    if data(i).PreFST<25
        HiTLowPre(1)=HiTLowPre(1)+1;
        if data(i).correct==1
            HiTLowPre(2)=HiTLowPre(2)+1;
        end
     elseif data(i).PreFST<100
        HiTHiPre(1)=HiTHiPre(1)+1;
        if data(i).correct==1
            HiTHiPre(2)=HiTHiPre(2)+1;
        end
    end   
    
    end
end

    

    
pLL= LowTLowPre(2)/LowTLowPre(1);
pLH=LowTHiPre(2)/LowTHiPre(1);
pHL=HiTLowPre(2)/HiTLowPre(1);
pHH=HiTHiPre(2)/HiTHiPre(1);
    
numLL=LowTLowPre(1);    
numLH=LowTHiPre(1);
numHL=HiTLowPre(1);
numHH=HiTHiPre(1);






end

