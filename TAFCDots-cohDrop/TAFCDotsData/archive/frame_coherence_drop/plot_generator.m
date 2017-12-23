
%Script to generate plits that illustrate the accuracy of generating dots
%frames with current architecture

%expectations: all files have the same structure counts (ex. same amount of
%statusData per all_data)
START = 145;
END = 145;


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

logic_time = [];
for i=1:dim1
    for j=1:dim2
        logic_time = [logic_time all_data(i).statusData(j).trial_time_end];
    end
end

%% PLOTS - Uncomment later
%variations of frames actually generated
figure()
%subplot(3,1,1)
histogram(all_tind, sample_num)
title('Frame Execution is Not Consistant')
xlabel('Count')
ylabel('Frames Executed Per Trial')

figure()
%subplot(3,1,2)
histogram(all_time, sample_num)
title('Trial length is Skewed to take longer than set')
xlabel('Length of trials')
ylabel('Count of trial')

%figure()
%histogram(logic_time, sample_num)
%title('logic timing')


%35 point skew figure
%figure()
%scatter(all_time, all_tind);
%title('length trial allowed is consistant with frames actually executed')
%xlabel('trial length')
%ylabel('trial frames executed')

% all_data(1).statusData(1).stimstrct.tind

