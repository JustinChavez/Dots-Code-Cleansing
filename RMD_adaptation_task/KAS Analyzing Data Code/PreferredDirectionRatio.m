function [Trialstats,Trialresults]=PreferredDirectionRatio;
%%% This was a function meant to simulate varous rounds of viewing the dots
%%% with varous conditions to see conditions allowed the most equal time
%%% looking at each state.  This was important to know on a trial-by-trial
%%% basis because we wanted to know how adaptation affects the
%%% integration/final choice.  Since adaptation is timing based, if we
%%% manipulate adaptation to be equal for both directions, we want it to
%%% STAY equal.  I believe the result of this function was to show that
%%% having periodic switches kept the timing of viewing each state within a
%%% trial much more consistantly equal than random.  We ended up using
%%% exactly fixed conditions for this reason.


Trialstats=zeros(2,6);
Trialresults={[],[],[],[],[],[]};



for n=1:10  %# simulations
    time=min(2 + exprnd(1),5)*60;       %Pick random time
    direction0=round(rand);          %Pick random start direction 0 or 1
    disp(n);
    %Randswitch for H1
    H=1;
    switches=zeros(1,6);
    randswitchH1=[0,0];
fixswitchH1=[0,0];
randstartH1=[0,0];
randswitchH5=[0,0];
fixswitchH5=[0,0];
randstartH5=[0,0];
    
    for i=1:time                    
      if i==1           %for first itteration, direction for all trials is the same. 
          direction=direction0;
          i=0;
      end
      randswitchH1(direction+1)=randswitchH1(direction+1)+1;  % add one for this part being in state 0 or 1
      if rand<H/59.9237
            direction=mod(direction+1,2);     %randomly switch state from 0 to 1 or 1to 0
            switches(1)=switches(1)+1;
      end   
    end
    
    %Randswitch for H5

    H=4;
    
      for i=1:time 
      if i==1           %for first itteration, direction for all trials is the same. 
          direction=direction0;
          i=0;
      end
      randswitchH5(direction+1)=randswitchH5(direction+1)+1;  % add one for this part being in state 0 or 1
      if rand<H/59.9237
            direction=mod(direction+1,2);     %randomly switch state from 0 to 1 or 1to 0
              switches(2)=switches(2)+1;
      end   
    end
    
    %Fixedswitch for H1
     
     H=1;
     for i=1:time 
      if i==1           %for first itteration, direction for all trials is the same. 
          direction=direction0;
          i=0;
      end
      fixswitchH1(direction+1)=fixswitchH1(direction+1)+1;  % add one for this part being in state 0 or 
      if mod(i,60/H)==0;
            direction=mod(direction+1,2);     %randomly switch state from 0 to 1 or 1to 0
        switches(3)=switches(3)+1;
      end   
    end
    
  %Fixedswitch for H5
 
     H=4;
    for i=1:time 
      if i==1           %for first itteration, direction for all trials is the same. 
          direction=direction0;
          i=0;
      end
      fixswitchH5(direction+1)=fixswitchH5(direction+1)+1;  % add one for this part being in state 0 or 1
      
      if mod(i,60/H)==0;
            direction=mod(direction+1,2);     %randomly switch state from 0 to 1 or 1to 0
        switches(4)=switches(4)+1;
      end   
    end  
    
    %Ramd Start for H1
     H=1;
     j=round(rand*60/H);
     
      for i=1:time 
      if i==1           %for first itteration, direction for all trials is the same. 
          direction=direction0;
          i=0;
      end
      randstartH1(direction+1)=randstartH1(direction+1)+1;  % add one for this part being in state 0 or 1
      j=j+1;
      if mod(j,60/H)==0;
            direction=mod(direction+1,2);     %randomly switch state from 0 to 1 or 1to 0
        switches(5)=switches(5)+1;
      end   
    end
    
  %Fixedswitch for H5
    H=4;
      j=round(rand*60/H);

      for i=1:time 
      if i==1           %for first itteration, direction for all trials is the same. 
          direction=direction0;
          i=0;
      end
      randstartH5(direction+1)=randstartH5(direction+1)+1;  % add one for this part being in state 0 or 1
      j=j+1;
      if mod(j,60/H)==0;
            direction=mod(direction+1,2);     %randomly switch state from 0 to 1 or 1to 0
        switches(6)=switches(6)+1;
      end   
    end  
   
    
    %Flush the ratios into Trial results, matrix set all values back to 0;
    Trialresults{1}=[Trialresults{1};randswitchH1(1)/randswitchH1(2)];
    Trialresults{2}=[Trialresults{2};randswitchH5(1)/randswitchH5(2)];
    Trialresults{3}=[Trialresults{3};fixswitchH1(1)/fixswitchH1(2)];
    Trialresults{4}=[Trialresults{4};fixswitchH5(1)/fixswitchH5(2)];
    Trialresults{5}=[Trialresults{5};randstartH1(1)/randstartH1(2)];
    Trialresults{6}=[Trialresults{6};randstartH5(1)/randstartH5(2)];
    
    
end
%avg and get sd for each type. 
for i=1:6
    Trialstats(1,i)=mean(Trialresults{i});
    Trialstats(2,i)=std(Trialresults{i});
end

    end
    
