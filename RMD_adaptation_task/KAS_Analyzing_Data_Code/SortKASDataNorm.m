function [ pLL, pLH, pHL, pHH ] = SortKASDataNorm (data)
%%%This function sorts the data by Coherence (High or Low) and Time in
%%%Final State (High or Low).  It returns the percentage of each trial type
%%%that the subject got correct, thus giving the info for the psychometric
%%%curve.  

%%% This function is most useful when you are ONLY looking at the
%%% relationship between the time in the final state and accuracy, it does
%%% not look at the relationship between time in the penultimate state and
%%% time in the final state to accuracy.  See Also: SortKASDataTime and
%%% SortKASDatTimeNewData

%%%This function was used most on Chris' data as some of the things it
%%%finds are built into more recent versions of data collection.


lowCohLowT=[0 0];  %first is total number of low coherence, low final time trials, second is correct 
lowCohHiT=[0 0];
hiCohLowT=[0 0];
hiCohHiT=[0 0];



for i=1:length(data)         %For all the data points
    if data(i).coherence<50  %low coherence, less than 50%
        if data(i).tPFS<1 %  Low Final time, less than 1 sec (for new data all low times=.25
            lowCohLowT(1)=lowCohLowT(1)+1;   %Add a count for number of trials
            if data(i).correct==1            %Add a count if it's correct
                lowCohLowT(2)=lowCohLowT(2)+1;
            end
            
          %Same scheme for all other conditions 
        
        else   %Large time
             lowCohHiT(1)=lowCohHiT(1)+1;
            if data(i).correct==1
                lowCohHiT(2)=lowCohHiT(2)+1;
            end
            
            
        end
    else  %high coherence
        if data(i).tPFS<1 %  Low time
            hiCohLowT(1)=hiCohLowT(1)+1;
            if data(i).correct==1
                hiCohLowT(2)=hiCohLowT(2)+1;
            end
            
        else   %Large time
             hiCohHiT(1)=hiCohHiT(1)+1;
            if data(i).correct==1
                hiCohHiT(2)=hiCohHiT(2)+1;
            end
           

        end
    
  
    end
    
pLL= lowCohLowT(2)/lowCohLowT(1);
pLH=lowCohHiT(2)/lowCohHiT(1);
pHL=hiCohLowT(2)/hiCohLowT(1);
pHH=hiCohHiT(2)/hiCohHiT(1);
    
    
    
end





end

