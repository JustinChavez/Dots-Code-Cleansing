%DATA was created through the plotting features of the other graphs

%First is H_2, second is H_tenth

%TODO: Assumption: edf_data is already loaded
%TODO: Assumtion: only reading first line of DATA
%TODO: Use NumTrials instead of getting length of trial start/end
messages = struct2cell(edf_data.FEVENT);
messages = messages(35,1,:);
messages = squeeze(messages);

sttime = struct2cell(edf_data.FEVENT);
sttime = sttime(4,1,:);
sttime = squeeze(sttime);

%Indices of trial start and end
trial_start_ind = find(strcmp(messages,'STIMSTART'));
trial_end_ind = find(strcmp(messages,'STIMSTOP'));

%get corresponding data timeframe
pupil_time = DATA(1).time;

%get indices of pupil start and stop times
pupil_trial_start = zeros(length(trial_start_ind),1);
for i=1:length(trial_start_ind)
    pupil_trial_start(i) = find(pupil_time(:) == sttime{trial_start_ind(i)});
end

pupil_trial_end = zeros(length(trial_end_ind),1);
for i=1:length(trial_end_ind)
    pupil_trial_end(i) = find(pupil_time(:) == sttime{trial_end_ind(i)});
end

%get pupil data
pupil_data = DATA(1).zCPupil;
pupil_plot = NaN(max(pupil_trial_end - pupil_trial_start),length(trial_start_ind));
pupil_plot_X = NaN(max(pupil_trial_end - pupil_trial_start),length(trial_start_ind));
edf_length = NaN(1,length(trial_start_ind));
for i=1:length(trial_start_ind)
    X = pupil_trial_start(i):pupil_trial_end(i);
    Y = pupil_data(X);
    pupil_plot(1:length(Y),i) = Y;
    pupil_plot_X(1:length(Y),i) = 1:length(Y);
    edf_length(i) = pupil_trial_end(i) - pupil_trial_start(i);
    
end
% figure()
% plot(pupil_plot_X, pupil_plot)
% title('Pupil diameter for entire trial with Hazard = .1')
% xlabel('Time (in milliseconds)')
% ylabel('Pupil Diameter (z-score)')

%ASSUMPTION: corresponding duration and reac_time is already loaded
est_length = (duration * 1000) ;%+ (reac_time * 1000);
%comp_length = cat(1,edf_length,est_length);
comp_length = edf_length - est_length;
figure()
hist(comp_length, 150)
