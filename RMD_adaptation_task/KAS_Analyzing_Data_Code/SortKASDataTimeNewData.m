function [ LowTLowPre, LowTHiPre, HiTLowPre ,HiTHiPre, numLL, numLH, numHL, numHH ] = SortKASDataTimeNewData (data)

%%%This code is essentially the same as SortKASDataTime except that instead
%%%of returning the percentage for each trial type it returns the number
%%%and the number correct in a 2x2 matrix as well as the number of each
%%%trial types.  This is redundant but is used for the BatchProcessNew.

%%%See Also SortKASTime



LowTLowPre=[0 0];  %first is total, second is correct
LowTHiPre=[0 0];
HiTLowPre=[0 0];
HiTHiPre=[0 0];
LowTs=[];
HiTs=[];


for i=1:length(data)            %Make an index of all low T and hi T trials
    if data(i).coherence<50  %low coherence
        if data(i).tPFS==0.25 %  Low time
            LowTs=[LowTs, i];

        elseif data(i).tPFS==2.25         %Large time
            HiTs=[HiTs, i];
        end
   
    end
    
  
end

for i=LowTs
    if data(i).PreFST>5
    if data(i).PreFST<25
        LowTLowPre(1)=LowTLowPre(1)+1;
        if data(i).correct==1
            LowTLowPre(2)=LowTLowPre(2)+1;
        end
    elseif data(i).PreFST<200
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
     elseif data(i).PreFST<200
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


