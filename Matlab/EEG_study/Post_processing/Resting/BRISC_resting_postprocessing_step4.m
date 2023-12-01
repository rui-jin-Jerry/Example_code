%% BRISC_resting_postprocessing_step4.m

% Select and generate summary table for resting datasets. To be used with the
% BRISC EEG datasets. Relevant data processing parameters are set at the
% beginning of the script (in the Settings/Parameters section).
%
%
% First version written by Rui Jin (Jerry), 11/19 at the Peter doherty institute | University of Melbourne
%
% NOTE ------ IMPORTANT -------- Turn Option "Use memory mapped array under
% matlab 7x..." To OFF (unticked) in the EEGLab Memory and Other Options
% settings. Many functions (like interpolation) won't work properly unless
% this is disabled!
%
%
% NOTE ---- To avoid automatic conversion to single precision set EEGLab to
% NOT make two files (.fdt and .set) when saving data (uncheck the option)
% as this will automatically convert files to single precision.



%% Housekeeping
% Clear all variables in the workspace, and close all windows
clear all;
close all;

% Reset EEGLab settings to:
% - Not use memory mapped objects
% - Not use single precision (use double precision instead)
pop_editoptions( 'option_storedisk', 1, ...
    'option_savetwofiles', 0, ...
    'option_saveversion6', 0, ...
    'option_single', 0, ...
    'option_memmapdata', 0, ...
    'option_eegobject', 0, ...
    'option_computeica', 1, ...
    'option_scaleicarms', 0, ...
    'option_rememberfolder', 1, ...
    'option_donotusetoolboxes', 0, ...
    'option_checkversion', 0, ...
    'option_chat', 0);

% Change working directory to that which contains this script
mfile_name = mfilename('fullpath');
[pathstring, nameOfFile, extensionString]  = fileparts(mfile_name);
cd(pathstring);

%% Setting Parameters

% Enter filepath of directory where the EEGLAB-processed EEG data is stored, relative to the current MATLAB working directory
Par.dataFolder = 'H:\Back_up_for_Jerry_Unimelb_PC\12_5_Preprocessed_datasets\Resting_State_Preprocessed_Data\Data\Cleaned';

% Choose experiment name ('bubbles' / 'sound' / 'movie')
Par.experimentName = 'bubbles';

% Select testing phase
% 'M_' = midline 'E_' = endline 'EX' = extra_endline
Par.testingPhase = 'EX';

% The standard channel location order
if strcmp(Par.testingPhase,'M_')
Par.channel_loc = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Post-processing steps\Oddball\Channel_Loc.mat';
else
Par.channel_loc = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Post-processing steps\Oddball\Channel_Loc_TP9.mat';
end

% Load the standard channel location 
load(Par.channel_loc);

% Load the cleaned datasets and Enter the trial_stage you want to extract 
Par.filesList = dir2(Par.dataFolder);
Par.subject_index = find(strcmp(Par.testingPhase,cellfun(@(x) x(8:9),{Par.filesList(:).name},'UniformOutput',false)));

% Directory (relative to MATLAB working directory) where the channel
% locations file is stored
Par.channelLocationsDirectory = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Documents\BRSIC\BRISC_EEG\Preprocessing_Code\Resting_State\Channel Locations';
% Name of the channel locations file to be used
Par.channelLocationsFileName = 'standard-10-5-cap385.elp';

% Movement sensor channels
Par.movementSensorChannels = {'x_dir' 'y_dir' 'z_dir'};

% Enter if need to be Pz ref
Par.reRef = 0;
Par.re_channel = 'Pz';

% Enter the pre-set trigger 100
Par.epochTrigger = {'S100'};

% Start and end times of epoch (relative to the start trigger) 120s 2 mins
Par.epochStart_sec = 0;
Par.epochEnd_sec = 120;

%% EEG postprocessing pipline

% Initializing a table containing everything
Resting_EEG_summary = table('Size',[0 0]);

for datasetNo = 1:length(Par.subject_index)
    
    % Loadset the .set cleaned eeg file
    
    EEG = pop_loadset([Par.dataFolder,'\', Par.filesList(Par.subject_index(datasetNo)).name]);
    
    
    %% -- Compare with the channel location and reorder the channel with wrong channel order 
    
    % Index channel labels and re-order them
    for Channel_id = 1:size(Channel_Loc,2)
             
      holder(Channel_id,:) = squeeze(EEG.data(find(strcmp(Channel_Loc(Channel_id).labels,{EEG.chanlocs.labels})),:));
        
    end
    
    % Reset the data and channel order
    EEG.data = holder;
    EEG.chanlocs = Channel_Loc;
    
    % Testing 
    assert(size(holder,1)==34);

    
     %% Check is need to re-reference to Pz
    
    if Par.reRef
    clear channelLabels;
    
    for chanNo = 1:EEG.nbchan
        
        channelLabels{chanNo} = EEG.chanlocs(chanNo).labels;
        
    end % of for chanNo
    
    % Make a vector of movement sensor channel indices (for excluding from EEG processing operations)
    Par.movementSensorChanInds(1) = find(strcmp(channelLabels, Par.movementSensorChannels{1}));
    Par.movementSensorChanInds(2) = find(strcmp(channelLabels, Par.movementSensorChannels{2}));
    Par.movementSensorChanInds(3) = find(strcmp(channelLabels, Par.movementSensorChannels{3}));
    
    EEG = pop_reref(EEG, find(strcmp(channelLabels, 'Pz')), 'exclude', Par.movementSensorChanInds);
    
    end
    
    % Testing 
    assert(ismember('Pz',EEG.chanlocs.labels))
   
    
    %%  Epoch EEG datasets
    
    try
        EEG_epoched = pop_epoch(EEG, Par.epochTrigger, [Par.epochStart_sec, Par.epochEnd_sec], 'epochinfo', 'yes');
    catch
        EEG_epoched  = EEG;   % If no epoch can be generated
    end
      
    % If the epoch period is not long enough 120s
    if ~isempty(EEG_epoched.epoch)
        Resting_EEG_summary.Epoched_Data(datasetNo) = {EEG_epoched.data};
        Resting_EEG_summary.Epoched_Time(datasetNo) = {EEG_epoched.times};
    else
        Start_time = 1; % Pre-set epoch time to the start of trial
        for i = 1:length(EEG.event)
            if strcmp(EEG.event(i).type,'S100')
                Start_time = EEG.event(i).latency;
            else
            end
        end
        if Start_time == 1 % No trigger found just use the first 120s
            if size(EEG.data,length(size(EEG.data))) >60000                
                Resting_EEG_summary.Epoched_Data(datasetNo) = {EEG.data(:,Start_time:60000)};
                Resting_EEG_summary.Epoched_Time(datasetNo) = {EEG.times(Start_time:60000)};
            else % Use what left if the datasets < 120s
                Resting_EEG_summary.Epoched_Data(datasetNo) = {EEG.data(:,Start_time:end)};
                Resting_EEG_summary.Epoched_Time(datasetNo) = {EEG.times(Start_time:end)};
            end
        else 
            Resting_EEG_summary.Epoched_Data(datasetNo) = {EEG.data(:,Start_time:end)};
            Resting_EEG_summary.Epoched_Time(datasetNo) = {EEG.times(Start_time:end)};
        end
    end
    
    % Testing 
    assert(~isempty(Resting_EEG_summary.Epoched_Data(datasetNo)))
    assert(~isempty(Resting_EEG_summary.Epoched_Time(datasetNo)))
    
    
    %% Assign EEG info to summary table
    
    Resting_EEG_summary.subjectid{datasetNo} = EEG.filename(1:6);
    Resting_EEG_summary.trial_stage{datasetNo} = EEG.filename(8:9);
    Resting_EEG_summary.timepoint(datasetNo) = {EEG.times};
    Resting_EEG_summary.chanlocs(datasetNo) = {EEG.chanlocs};
    Resting_EEG_summary.fft_timepoint(datasetNo) = cellfun(@(x) x-x(1),Resting_EEG_summary.Epoched_Time,'UniformOutput',false);

    % Testing 
    assert(Resting_EEG_summary.fft_timepoint{datasetNo}(1) == 0);
    
    
end

%% Save the variable

% save('Resting_EEG_summary.mat','Resting_EEG_summary', '-v7.3');

