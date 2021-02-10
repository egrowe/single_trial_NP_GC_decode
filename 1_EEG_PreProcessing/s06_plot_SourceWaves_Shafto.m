%% PlotJK_AllConditions_and_MMN
clear all
close all

%Set colours for the plots
faces_color = [0.3, 0.1, 0.3]; %purple
random_color = [0.1, 0.4, 0.4]; %green

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUT: Settings and filenames for extracting ROI data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filepath = ['/Users/egrow1/Desktop/ALL_SW_noF_0_to_500ms_EBR/']; %set file path
hemisphere = 'Right'; % which hemisphere? Either 'Left' or 'Right'

% Assign variables depending on which hemisphere being examined
if strcmp(hemisphere, 'Left')
    %Name the left hemisphere coordinates to extract and plot
    useCoords = { [-8, 1, 69]; [-20, 36, -20]; [-32, -52, -6]; [-39, -84, 21]}%; % Left hemisphere
    coordLabels = {'L_SP_PFC', 'L_Inf_PFC','L_FFA','L_Occ'}    
elseif strcmp(hemisphere, 'Right')
    %Name the right hemisphere coordinates to extract and plot
    useCoords = { [18, -8, 58]; [22, 35, -16]; [30, -56, -6]; [30, -96, 7];}; % Right hemisphere
    coordLabels = {'R_SP_PFC', 'R_Inf_PFC','R_FFA','R_Occ'}    
end


%Assign other parameters
zscore = 1; %1 = on, 0 = off
timeWindow = [0 500]; %examine this time window
timeIdx = linspace(0,500,301); % find index for time points in data
useWind = [find(timeIdx==timeWindow(1)):find(timeIdx==timeWindow(2))]; %assign idxs by time window
visualise = 1; %to show data visualisation =1, =0 for not
count = 1; %set up counter to plot (if visualise is turned on)

% %% Extract individual ERPs and plot over time
for gg = 1:length(useCoords)
    
    coordList = useCoords{gg}
    
    %% Do it for face trials
    thisVoxel = coordList;
    filename = ['NEW_Source_Waveform_0to500ms_at_' num2str(thisVoxel) '_for_ALL_trials_mSae_faces_aEBfspmeeg_7MJN_0to500ms_trial_205.mat'];
    load ([filepath filename])
    GM_faces(gg,:,:) = waveform;%(:,useWind); % time x trial x feature
    
    %% Do it for RANDOM trials
    thisVoxel = coordList;
    filename = ['NEW_Source_Waveform_0to500ms_at_' num2str(thisVoxel) '_for_ALL_trials_mSae_random_aEBfspmeeg_7MJN_0to500ms_trial_354.mat'];
    load ([filepath filename])
    GM_random(gg,:,:) = waveform;%(:,useWind); % time x trial x feature
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot each wave Face and Random together in a subplot

for gg = 1:length(coordLabels)
    
    faceData = squeeze(GM_faces(gg,:,:)); %extract face data for this coord
    randData = squeeze(GM_random(gg,:,:)); %extract random data this coord

    %Plot using JackKnife plot
    subplot(1,4,gg)    
    plot_JackKnife(mean(faceData), faces_color, '-', 0:2:500)
    hold on;
    plot_JackKnife(mean(randData), random_color, '-', 0:2:500)
    set(gca, 'FontSize', 20); xlim([0 500])
    title(coordLabels{gg})
    
end