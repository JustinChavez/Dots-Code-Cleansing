
%Script to generate plits that illustrate the accuracy of generating dots
%frames with current architecture

%expectations: all files have the same structure counts (ex. same amount of
%statusData per all_data)
START = 108;
END = 143;

all_data = [];
for i=START:END
    all_data = [all_data, load(strcat('Justin_43_main_',num2str(i),'.mat'))];
end

[~, dim1] = size(all_data);
[dim2, ~] = size(all_data(1).statusData);

all_tind = [];
all_time = [];
%get all test
for i=1:dim1
   for j=1:dim2
       all_tind = [all_tind all_data(i).statusData(j).stimstrct.tind];
       all_time = [all_time all_data(i).statusData(j).stimstrct.time_end];
   end
end
[~, sample_num] = size(all_tind);

%PLOTS - Uncomment later
%variations of frames actually generated
%histogram(all_tind, sample_num)
%histogram(all_time, sample_num)


% all_data(1).statusData(1).stimstrct.tind

