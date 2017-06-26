function [statusData] = CalcFST(a)
%%% This Function calculates an array of Final State Times for data that
%%% does not have it explicitly coded into the process.  This includes
%%% Chris's old data. 
%a is a datafile for which there is no FST
%The function will add the FST to the old data file, you just need to save
%it under the same name when you finish running it. That could proabably be
%built in too, but I didn't know how.

FSTa={};
for i=1:size(a)  %For all the rows=trials of the file you gave it.
    total=length(a(i).directionvc);  %Total amount of time is the length of directionvc vector
    h=0;
    while a(i).directionvc(total-h)==a(i).directionvc(total-h-1)  %Starting at the end of direction vector, move backwards until it's not the same: that is the switch point
        h=h+1;
        if total-h-1<=0
            break;
        end
        
    end
   

 
     
    FSTa{i}=h/60;  %Have to divide the number of frames back by the frame rate to get time





end
fnp=fieldnames(a);
fnt=[fnp; 'FST'];
cp=struct2cell(a);
c=[cp; FSTa];
statusData=cell2struct(c,fnt,1);



end

