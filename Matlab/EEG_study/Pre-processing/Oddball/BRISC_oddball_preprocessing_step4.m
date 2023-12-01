%% BRISC_oddball_preprocessing.m

% Removes selected independent components and saves file. To be used with the
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


% Enter filepath of directory where the EEGLAB-processed EEG data is stored, relative to the
% current MATLAB working directory
Par.dataFolder = 'H:\Back_up_for_Jerry_Unimelb_PC\12_5_Preprocessed_datasets\Roving_Oddball_Preprocessed_Data\Data';

% Subject IDs to process (entry numbers from list of IDs in Par.subjectCodesList)
subjectIDsToDo = 1:441;
%Endline  to 684

% Get array of subject ID codes
Par = BRISC_oddball_subject_codes(Par);


% Choose experiment name ('bubbles' / 'sound' / 'movie'
Par.experimentName = 'sound';

% Select testing phase
% 'M' = midline
Par.testingPhase = 'M';

% Select whether to remove artefactual IC components from the dataset
Par.removeSelectedICs = 1; % 1 = Remove selected ICs / 0 = Don't remove

% Start and end times of baseline period (in ms from trigger onset)
Par.epochBaseline_StartEnd = [-100, 0];

% Epoch rejection amplitude thresholds
Par.epochRejectThreshold_strict = 100;
Par.epochRejectThreshold_moderate = 200;
Par.epochRejectThreshold_lenient = 300;

% Check if need to reref to Pz 
Par.ref_Pz = 0;

EEG_Epoch = table('Size',[0 0]);

%% EEG Preprocessing Pipeline

for datasetNo = subjectIDsToDo
    
    % Announce the dataset that we are processing
    fprintf(['-----------------------------------------------------',  ...
        '\n\nProcessing subject code ' Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, ' ', Par.experimentName, ' dataset...\n\n', ...
        '-----------------------------------------------------\n\n']);
    
    % Record subject ID in Par structure
    Par.subjectID = Par.subjectCodesList{datasetNo};
    
    % Make another copy of subject code that can easily be located in
    % the
    % workspace
    AAA_subjectID_Code = [Par.subjectID, '_', Par.testingPhase];
    
    EEG_Epoch.subjectid{datasetNo} = Par.subjectID;
    EEG_Epoch.testingPhase{datasetNo} = Par.testingPhase;
    
    
    %% -- Load Data File
    
    % Load EEG file with channel locations appended
    EEG = pop_loadset([Par.dataFolder, '/Epoched/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Epoched.set']);
    
    % Load the Par structure (with stored parameters) from Step 2
    % (Loaded into substructure so that Par structure isn't overwritten)
    Par.Step1 = load([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step1']);
    Par.Step2 = load([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step2']);
    Par.Step3 = load([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step3']);
    
    
    
    %% -- Mark Independent Components to Remove
    
    if Par.removeSelectedICs
        
        % Load epoched EEG file with ICA results
        EEG_ICA = pop_loadset([Par.dataFolder, '/Post ICA/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_ICA.set']);
        
        % Copy independent component information to dataset that has not
        % been savagely high-pass filtered
        EEG.icaweights = EEG_ICA.icaweights;
        EEG.icasphere = EEG_ICA.icasphere;
        EEG.icawinv = EEG_ICA.icawinv;
        EEG.icachansind = EEG_ICA.icachansind;
        EEG.icaact = EEG_ICA.icaact;
        
        clear EEG_ICA; % Clear out extra dataset.
        
        % Get vector of artefact ICs
        Par = BRISC_oddball_ICs_to_remove(Par, datasetNo);
        
        % Remove the components
        EEG = pop_subcomp(EEG, Par.ICsToRemove, 0);
        
    end % of if Par.removeSelectedICs
    
    
    
    %% -- Interpolate Noisy Electrodes Using the Cleaned Data
    
    % Use bad channels vector defined in Par structure at step 2
    % Spherical spline interpolation
    
    if isempty(Par.Step2.Par.badChannelIndices) == 0 % If any bad channels have been identified
        
        EEG = pop_interp(EEG, Par.Step2.Par.badChannelIndices, 'spherical');
        
    end % of if length
    
    
    
    %% -- Baseline Correct Epochs
    
    % Baseline correct to prestimulus interval
    EEG = pop_rmbase(EEG, Par.epochBaseline_StartEnd);
    
    %% Record EEG epoch size
    
    EEG_Epoch.epochsize_before(datasetNo) = size(EEG.epoch,2);
    
    
    %% -- Final Artefact Rejection (After Cleaning Data)
    
    % Find and exclude movement sensor channels
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
    
    allChannelsIndices = [1:EEG.nbchan];
    
    % reref to Pz
    if Par.ref_Pz
    EEG = pop_reref(EEG, find(strcmp(channelLabels, 'Pz')), 'exclude', Par.movementSensorChanInds);
    else
    end
    
    % Chooes the 9 frontal channels
    Par.channelsForAR = find(strcmp('Fz',channelLabels)| ...
        strcmp('FC2',channelLabels)|strcmp('FC1',channelLabels)| strcmp('F4',channelLabels)| strcmp('FC5',channelLabels)|...
        strcmp('F8',channelLabels)|strcmp('F7',channelLabels) |strcmp('FC6',channelLabels)|strcmp('F3',channelLabels));
    
    % All frontal channels
    %|strcmp('F3',channelLabels) strcmp('FT9',channelLabels)  |
    %strcmp('FC2',channelLabels)| strcmp('F8',channelLabels)| |...
    %  strcmp('FT10',channelLabels) strcmp('F4',channelLabels)|
    %  strcmp('F7',channelLabels) | |strcmp('FC1',channelLabels)
    
    % Amplitude-based artefact rejection
    % Process 3 versions of the dataset (each with different artefact
    % rejection thresholds)
    
    % Strict cutoff
    EEG_strict = pop_eegthresh(EEG, 1, ...
        Par.channelsForAR, ...
        -Par.epochRejectThreshold_strict, ...
        Par.epochRejectThreshold_strict, ...
        Par.Step2.Par.epochStart_sec, Par.Step2.Par.epochEnd_sec, ...
        0, 1);
    
    % Moderate cutoff
    EEG_moderate = pop_eegthresh(EEG, 1, ...
        Par.channelsForAR, ...
        -Par.epochRejectThreshold_moderate, ...
        Par.epochRejectThreshold_moderate, ...
        Par.Step2.Par.epochStart_sec, Par.Step2.Par.epochEnd_sec, ...
        0, 1);
    
    % Lenient cutoff
    EEG_lenient = pop_eegthresh(EEG, 1, ...
        Par.channelsForAR, ...
        -Par.epochRejectThreshold_lenient, ...
        Par.epochRejectThreshold_lenient, ...
        Par.Step2.Par.epochStart_sec, Par.Step2.Par.epochEnd_sec, ...
        0, 1);
    
    %% Record EEG table size
    
    EEG_Epoch.epochsize_after(datasetNo) = size(EEG_moderate.epoch,2);
    
    
    %% -- Save the Datasets
    
    EEG_strict = pop_saveset( EEG_strict, 'filename', [Par.dataFolder, '/Cleaned/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Cleaned_Strict.set']);
    
    EEG_moderate = pop_saveset( EEG_moderate, 'filename', [Par.dataFolder, '/Cleaned/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Cleaned_Moderate.set']);
    
    EEG_lenient = pop_saveset( EEG_lenient, 'filename', [Par.dataFolder, '/Cleaned/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Cleaned_Lenient.set']);
    
    
    %% Register repNumbers
    
    repNumbers = nan(1, size(EEG_moderate.data, 3));
    
    
    for epochNo = 1:size(EEG_moderate.data, 3)
        
        for eventInd = 1:length(EEG_moderate.epoch(epochNo).eventtype)
            
            try
                
                switch EEG_moderate.epoch(epochNo).eventtype{eventInd}
                    case 'S201'
                        repNumbers(epochNo) = 1;
                    case 'S202'
                        repNumbers(epochNo) = 2;
                    case 'S203'
                        repNumbers(epochNo) = 3;
                    case 'S204'
                        repNumbers(epochNo) = 4;
                    case 'S205'
                        repNumbers(epochNo) = 5;
                    case 'S206'
                        repNumbers(epochNo) = 6;
                    case 'S207'
                        repNumbers(epochNo) = 7;
                    case 'S208'
                        repNumbers(epochNo) = 8;
                    case 'S209'
                        repNumbers(epochNo) = 9;
                    case 'S210'
                        repNumbers(epochNo) = 10;
                end
                
            catch
                
            end
            
        end % of for eventInd
        
        
    end % of for epochNo
    
    EEG_Epoch.repNum{datasetNo} = repNumbers;
    
    
    %% -- Save the Parameters File
    save([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.experimentName, '_', Par.testingPhase, '_EEG_params_step4'], 'Par');
    
    
    
end % of for datasetNo

