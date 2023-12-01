%% BRISC_resting_preprocessing.m

% Loads each file and does all preprocessing up to ICA. To be used with the
% BRISC EEG datasets. Relevant data processing parameters are set at the
% beginning of the script (in the Settings/Parameters section).
%
%
% First version written by Daniel Feuerriegel, 1/19 at the University of
% Melbourne.
% 
% Second version written by Rui Jin (Jerry), 11/19 at the University of
% Melbourne
%
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


% NOTE: Figure out where I input the trigger recording function, and how
% this will work for our different paradigms.

% NOTE: Make a separate version of the data which is LP filtered and
% re-referenced


% Enter filepath of directory where the EEGLAB-processed EEG data is stored, relative to the
% current MATLAB working directory
Par.dataFolder = 'H:\Back_up_for_Jerry_Unimelb_PC\12_5_Preprocessed_datasets\Resting_State_Preprocessed_Data\Data';

% Subject IDs to process (entry numbers from list of IDs in Par.subjectCodesList)
subjectIDsToDo = 100;

% Get array of subject ID codes
Par = BRISC_resting_subject_codes(Par);

% Choose experiment name ('bubbles' / 'sound' / 'movie' )
Par.experimentName = 'bubbles';

% Select testing phase
% 'M' = midline
Par.testingPhase = 'M';

% Decide whether to run an ICA on the dataset
% (ICA may not be useful for some datasets in the project)
Par.runAnICA = 0; % 1 = Run the ICA / 0 = Don't run

% Set the reference electrode to use
% Cz (vertex) reference = 'CzRef'
% TP9 and TP10 average = 'TP9-10'
% Average reference = 'AverageRef'
% TP10 reference = 'TP10'
Par.referenceOption = 'TP9-10';

% Set electrode indices for certain electrodes
% Par.ChannelIndices.TP9 = 10;
% Par.ChannelIndices.TP10 = 21;
% Par.ChannelIndices.Cz = 24;

% High-pass filter cutoff (in Hz)
Par.highPassFilterCutoff = 1;

% Set Low-pass filter cutoff (in Hz)
Par.lowPassFilterCutoff = 30;

% Denote the trigger used to mark the start of the resting state period
Par.epochTrigger = {'S100'};

% Start and end times of epoch (relative to the start trigger)
Par.epochStart_sec = 0;
Par.epochEnd_sec = 120;

% Decide whether to epoch the dataset
Par.runepoch = 1; % 1 = Run the epoch / 0 = Don't run

%% EEG Preprocessing Pipeline

for datasetNo = subjectIDsToDo
    
    % Announce the dataset that we are processing
    fprintf(['-----------------------------------------------------',  ...
        '\n\nProcessing subject code ' Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, ' ', Par.experimentName, ' dataset...\n\n', ...
        '-----------------------------------------------------\n\n']);
    
    % Record subject ID in Par structure
    Par.subjectID = Par.subjectCodesList{datasetNo};
    
    % Make another copy of subject code that can easily be located in the
    % workspace
    AAA_subjectID_Code = [Par.subjectID, '_', Par.testingPhase];
    
    
    
    %% -- Load Data File
    
    % Load EEG file with channel locations appended
    EEG = pop_loadset([Par.dataFolder, '/Loaded/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Loaded.set']);
    
    % Load the Par structure (with stored parameters) from Step 1
    % (Loaded into substructure so that Par structure isn't overwritten)
    Par.Step1 = load([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step1']);
    
    
    
    %% -- List Indices of Bad/Noisy Channels
    
    % Get vector of bad channel indices as coded in the following function
    Par = BRISC_resting_bad_channels(Par, datasetNo, EEG);
    
    % Record number of bad channels (for checking dataset quality)
    Par.nBadChans = length(Par.badChannelIndices);
    
    
    
    %% -- Rereference the data
    
    % Get a list of channel indices by channel labels
    clear channelLabels;
    
    for chanNo = 1:EEG.nbchan
        
        channelLabels{chanNo} = EEG.chanlocs(chanNo).labels;
        
    end % of for chanNo
    
    % Make a vector of movement sensor channel indices (for excluding
    % from EEG processing operations)
    
    % Copy movementSensorChannel into main Par structure from Step 1 Par
    % substructure
    Par.movementSensorChannels = Par.Step1.Par.movementSensorChannels;
    
    Par.movementSensorChanInds(1) = find(strcmp(channelLabels, Par.movementSensorChannels{1}));
    Par.movementSensorChanInds(2) = find(strcmp(channelLabels, Par.movementSensorChannels{2}));
    Par.movementSensorChanInds(3) = find(strcmp(channelLabels, Par.movementSensorChannels{3}));
    
    % Re-reference the data based on the selected reference option
    if strcmp(Par.referenceOption, 'TP9-10') % If using electrodes close to linked mastoids
        
        % First check if reference electrodes are listed as bad channels
        if sum(ismember('TP9', Par.badChannelLabels)) > 0 | sum(ismember('TP10', Par.badChannelLabels)) > 0
            
            % Throw an error if this is the case
            error('Channel to be used as a reference electrode is marked as a bad/noisy channel!');
            
        else % If TP9 and TP10 are not bad electrodes
            
            EEG = pop_reref(EEG, [find(strcmp(channelLabels, 'TP9')), find(strcmp(channelLabels, 'TP10'))], 'exclude', Par.movementSensorChanInds);
            
            % Get bad channel indices again (may be different after
            % rereferencing)
            Par = BRISC_resting_bad_channels(Par, datasetNo, EEG);
            
        end % of if ismember
        
    elseif strcmp(Par.referenceOption, 'AverageRef') % If using an average reference
        
        EEG = pop_reref(EEG, [], 'exclude', [Par.badChannelIndices, Par.movementSensorChanInds]);
        
    elseif strcmp(Par.referenceOption, 'CzRef') % If using a Cz reference
        
        % First check if reference electrodes are listed as bad channels
        if sum(ismember('Cz', Par.badChannelLabels)) > 0
            
            % Throw an error if this is the case
            error('Channel to be used as a reference electrode is marked as a bad/noisy channel!');
            
        else
            
            EEG = pop_reref(EEG, find(strcmp(channelLabels, 'Cz')), 'exclude', Par.movementSensorChanInds);
            
            % Get bad channel indices again (may be different after
            % rereferencing)
            Par = BRISC_resting_bad_channels(Par, datasetNo, EEG);
            
        end % of if ismember
        
    elseif strcmp(Par.referenceOption, 'TP10') % If using a Cz reference
        
        % First check if reference electrodes are listed as bad channels
        if sum(ismember('TP10', Par.badChannelLabels)) > 0
            
            % Throw an error if this is the case
            error('Channel to be used as a reference electrode is marked as a bad/noisy channel!');
        else
            EEG = pop_reref(EEG, find(strcmp(channelLabels, 'TP10')), 'exclude', Par.movementSensorChanInds);
            
            % Get bad channel indices again (may be different after
            % rereferencing)
            Par = BRISC_resting_bad_channels(Par, datasetNo, EEG);
            
        end
        
    end % of if strcmp
    
    
    
    %% -- High-Pass Filter the Data
    % High-pass filter at selected cutoff frequency
    EEG = pop_eegfiltnew(EEG, [], Par.highPassFilterCutoff, [], true, [], 0);
    
    
    
    %% -- Low-Pass Filter the Data
    % Low-pass filter at selected cutoff frequency
    EEG = pop_eegfiltnew(EEG, [], Par.lowPassFilterCutoff, [], 0, [], 0);
    
    
    
    %% -- Epoch the Data
    
    if Par.runepoch
        
        % Just one epoch generated for the resting state dataset        
        
        EEG_epoched = pop_epoch( EEG, Par.epochTriggeAr, [Par.epochStart_sec, Par.epochEnd_sec], 'epochinfo', 'yes');        
        
        % Take the wholes datasets if no epoch can be generated (e.g., No
        % trigger/not long enough)
        if isempty(EEG_epoched.data)
            
            clear EEG_epoched
        else           
            
            EEG = EEG_epoched;            
        end
        
        
    else
    end
    
    
    %% -- Run an ICA on the Dataset
    % Note: ICA may be of limited utility with these small datasets
    % (still worth testing if we can isolate ocular artefacts)
    
    % -- Run The ICA
    if Par.runAnICA
        
        % Determine the channels to feed into the ICA algorithm (exclude noisy
        % channels)
        allChannelsIndices = [1:EEG.nbchan];
        Par.channelsForICA = setdiff(allChannelsIndices, [Par.badChannelIndices, Par.movementSensorChanInds]);
        
        EEG = pop_runica(EEG, 'extended', 1, 'interupt', 'off', 'chanind', Par.channelsForICA, 'maxsteps', 1024);
        
    end % of if Par.runAnICA
    
    
    
    %% -- Save the Dataset
    EEG = pop_saveset( EEG, 'filename', [Par.dataFolder, '/Epoched/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Epoched.set']);
        
    
    %% -- Save the Parameters File
    save([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step2'], 'Par');
        
    
end % of for datasetNo
