
original_data = load('Original_TAFC_Performance.mat');
original_data = original_data.dots_time;

coh_drop_data = load('coh_drop_TAFC_performance.mat');
coh_drop_data = coh_drop_data.dots_time;

[o1,o2] = size(original_data);
[c1,c2] = size(coh_drop_data);

for i=1:o1
    for j=1:(o2-1)
        original_data(i,j) = original_data(i,j+1) - original_data(i,j);
    end 
end

for i=1:c1
    for j=1:(c2-1)
        coh_drop_data(i,j) = coh_drop_data(i,j+1) - coh_drop_data(i,j);
    end 
end


%60 now since it is between frames

all_std = cat(1,std(original_data(:,1:60)), std(coh_drop_data(:,1:60)));
all_mean = cat(1,mean(original_data(:,1:60)), mean(coh_drop_data(:,1:60)));
figure()
%blue is original
%orange is coh_drops
% p = plot((1:60),all_std(1,:),(1:60), all_std(2,:));
% p(2).Color = 'b';
% p(1).LineWidth = 2;
% p(1).Color = 'm';
% title('Standard Deviation of Respective frame execuation across trials')
% xlabel('Frame Number')
% ylabel('Standard Deviation of Frame Execution Time Across All Trials')

% 
% p = plot((1:60),all_mean(1,:),(1:60), all_mean(2,:));
% p(2) = errorbar((1:60),all_mean(1,:),all_std(1,:));
% %p(2).Color = 'b';
% p(1) = errorbar((1:60),all_mean(2,:),all_std(2,:));
% p(1).LineWidth = 2;
% %p(1).Color = 'm';

errorbar((1:60),all_mean(1,:),all_std(1,:),'b','LineWidth',1,'Marker','o','MarkerSize',1);
hold on;
errorbar((1:60),all_mean(2,:),all_std(2,:),'m','LineWidth',1,'Marker','o','MarkerSize',1);
title('Mean frame draw length')
xlabel('Frame Number')
ylabel('Mean Length in seconds')

