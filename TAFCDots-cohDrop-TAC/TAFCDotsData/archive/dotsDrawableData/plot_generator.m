%statusData(1).stimstrct.stimtime


%Script to generate plits that illustrate the accuracy of generating dots
%frames with current architecture

%expectations: 
%-all files have the same structure counts (ex. same amount of
%statusData per all_data)
%-Ordered numbering

START = 14;
END = 14;


all_data = [];
for i=START:END
    all_data = [all_data, load(strcat('Justin_43_main_',num2str(i),'.mat'))];
end

[~, dim1] = size(all_data);
[dim2, ~] = size(all_data(1).statusData);

dots_time = [];
%get all test
for i=1:dim1
    %not all statusData's are created equal
   for j=1:size(all_data(i).statusData,1)
       tind = all_data(i).statusData(j).stimstrct.tind;
       if (tind ~= 61)
           continue
       end
       dots_time = cat(1, dots_time, all_data(i).statusData(j).stimstrct.stimtime(1:tind));
   end
end
[dotsDim1, dotsDim2] = size(dots_time);

%normalize time series data to start at 0
for i=1:dotsDim1
    dots_time(i,:) = dots_time(i,:) - dots_time(i,1);
end

%total length of each trial
%Only need 100 trials for comparison
dots_time = dots_time(1:95, :);
%% PLOTS - For Data Number 12
% 
figure()
plot(dots_time')
title('Frame Executions over 95 trials (1 Second Length)')
xlabel('Frame Number')
ylabel('Frame Execution Time (in seconds)');

figure()
plot(std(dots_time))
title('Standard Deviation of Respective frame execuation across trials')
xlabel('Frame Number')
ylabel('Standard Deviation of Frame Execution Time Across All Trials')

%  figure()
%  hist(dots_time(:,dotsDim2), 25)
%  title('Frame Execution Variation')
%  xlabel('Time Until Trial Finishes Frame Execution')
%  ylabel('Number of Trials')

save('coh_drop_TAFC_performance','dots_time');


