function [statusData] = CalcPreFST(a)

%%% This Function calculates an array of Pre-Final State Times (aka penultimate time) for data that
%%% does not have it explicitly coded into the process.  This includes
%%% Chris's old data. 
%a is a datafile for which there is no PreFST
%The function will add the PreFST to the old data file, you just need to save
%it under the same name when you finish running it. That could proabably be
%built in too, but I didn't know how.

%%%see CalcFST for how it works


PreFSTa={};
for i=1:size(a)
    total=length(a(i).directionvc);
    h=0;
    while a(i).directionvc(total-h)==a(i).directionvc(total-h-1)
        h=h+1;
        if total-h-1<=0
            break;
        end
        
    end
    h=h+1;
    j=1;
     while total-h-j-1>0
         if a(i).directionvc(total-h-j)==a(i).directionvc(total-h-j-1) 
            j=j+1;
         else
             break
         end
     end
     if j==1
         j=0;
     end
     
    PreFSTa{i}=j;





end
fnp=fieldnames(a);
fnt=[fnp; 'PreFST'];
cp=struct2cell(a);
c=[cp; PreFSTa];
statusData=cell2struct(c,fnt,1);



end

