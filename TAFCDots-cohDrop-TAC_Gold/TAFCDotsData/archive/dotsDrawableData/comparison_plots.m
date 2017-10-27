
original_data = load('Original_TAFC_Performance.mat');
original_data = original_data.dots_time;

coh_drop_data = load('coh_drop_TAFC_performance.mat');
coh_drop_data = coh_drop_data.dots_time;
% 
% coh_drop_data_improve = load('coh_drop_TAFC_performance_improved.mat');
% coh_drop_data_improve = coh_drop_data_improve.dots_time;

[o1,o2] = size(original_data);
[c1,c2] = size(coh_drop_data);
% [d1,d2] = size(coh_drop_data_improve);

figure()
%plot last timepoint to get full trial length
hist(cat(2, original_data(:,o2), coh_drop_data(:,c2)), 10);
%hist(original_data(:,o2));
%hold on
%hist(coh_drop_data(:,c2));
h = findobj(gca,'Type','patch');
set(h(1),'Facecolor','b');
set(h(2),'Facecolor','m');
title('Frame Execution Variation');
xlabel('Time Until Trial Finishes Frame Execution');
ylabel('Number of Trials');


all_std = cat(1,std(original_data), std(coh_drop_data));

figure()
%blue is original
%orange is coh_drops
p = plot((1:61),all_std(1,:),(1:61), all_std(2,:));
p(2).Color = 'b';
p(1).LineWidth = 2;
p(1).Color = 'm';
title('Standard Deviation of Respective frame execuation across trials')
xlabel('Frame Number')
ylabel('Standard Deviation of Frame Execution Time Across All Trials')
