%% BRISC_oddball_preprocessing.m

% Loads each file, removes extraneous channels and appends channel location information.
% To be used with the BRISC EEG datasets. Relevant data processing parameters are set at the
% beginning of the script (in the Settings/Parameters section).
%
% First version written by Daniel Feuerriegel, 1/19 at the University of
% Melbourne.
% 
% Second version written by Rui Jin (Jerry), 11/19 at the University of
% Melbourne
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
subjectIDsToDo = 1:440;


% Get array of subject ID codes
Par = BRISC_oddball_subject_codes(Par);


% Choose experiment name ('bubbles' / 'sound' / 'movie'
Par.experimentName = 'sound';

% Select testing phase
% 'M' 'm' = midline 'EX' 'E' 'e' for Endline possible, need to check the
% exact eeg file name 
Par.testingPhase = 'M';

% Path of the directory where the raw data is stored (usually not relative to
% the MATLAB working directory)
Par.dataFolder_Raw = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Cleaned BRSIC EEG Datasets\Extra_Endline';

% Number of scalp EEG channels in the dataset
% (Should be 32 for our current EEG setup)
Par.nScalpChannels = 32;

% Movement sensor channels
Par.movementSensorChannels = {'x_dir' 'y_dir' 'z_dir'};

% Directory (relative to MATLAB working directory) where the channel
% locations file is stored
Par.channelLocationsDirectory = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Pre-processing Steps\Oddball\Channel Locations';
% Name of the channel locations file to be used
Par.channelLocationsFileName = 'standard-10-5-cap385.elp';

% ================================
% Settings for processing dataset used for checking bad channels

% High-pass filter cutoff (in Hz)
Par.highPassFilterCutoff_ForChecking = 0.1;

% Set Low-pass filter cutoff (in Hz)
Par.lowPassFilterCutoff_ForChecking = 30;

% Set the reference electrode to use
% Cz (vertex) reference = 'CzRef'
% TP9 and TP10 average = 'TP9-10'
% Average reference = 'AverageRef' 
% TP10 average = 'TP10'

Par.referenceOption_ForChecking = 'TP9-10';

% ===============================



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
    
    

    %% -- Import Data File

    % Imports .eeg files as created when using BrainProducts EEG systems
    EEG = pop_fileio([Par.dataFolder_Raw, '/', Par.subjectCodesList{datasetNo},'_', Par.testingPhase, '/',Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '.eeg']);



    %% -- Assign Channel Locations
    % If this does not work, go to EEGLAB -> Edit -> Assign Channel Locations
    % in the GUI
    EEG = pop_chanedit(EEG, 'lookup', [Par.channelLocationsDirectory, '/' Par.channelLocationsFileName]);

    
    %% -- Save the Dataset
    
    EEG_saveFileName = [Par.dataFolder, '/Loaded/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase,  '_', Par.experimentName, '_Loaded.set'];
    EEG = pop_saveset( EEG, 'filename', EEG_saveFileName);

    
    %% -- Make a File Optimised for Manually Checking EEG Data
    
    % Get a list of channel indices by channel labels
    clear channelLabels;
    
    for chanNo = 1:EEG.nbchan

        channelLabels{chanNo} = EEG.chanlocs(chanNo).labels;

    end % of for chanNo

    % Make a vector of movement sensor channel indices (for excluding
    % from EEG processing operations)
    Par.movementSensorChanInds(1) = find(strcmp(channelLabels, Par.movementSensorChannels{1}));
    Par.movementSensorChanInds(2) = find(strcmp(channelLabels, Par.movementSensorChannels{2}));
    Par.movementSensorChanInds(3) = find(strcmp(channelLabels, Par.movementSensorChannels{3}));
    
    
    % Re-reference the data based on the selected reference option
    if strcmp(Par.referenceOption_ForChecking, 'TP9-10') % If using electrodes close to linked mastoids
      
        EEG = pop_reref(EEG, [find(strcmp(channelLabels, 'TP9')), find(strcmp(channelLabels, 'TP10'))], 'exclude', Par.movementSensorChanInds);

    elseif strcmp(Par.referenceOption_ForChecking, 'AverageRef') % If using an average reference

        EEG = pop_reref(EEG, [], 'exclude', Par.movementSensorChanInds); % Exclude indices of movement sensor channels

    elseif strcmp(Par.referenceOption_ForChecking, 'CzRef') % If using a Cz reference

        EEG = pop_reref(EEG, find(strcmp(channelLabels, 'Cz')), 'exclude', Par.movementSensorChanInds);
        
    elseif strcmp(Par.referenceOption_ForChecking, 'TP10') % If using a Cz reference

        EEG = pop_reref(EEG, find(strcmp(channelLabels, 'TP10')), 'exclude', Par.movementSensorChanInds);        

    end % of if strcmp
    
    % High-pass filter the data at selected cutoff frequency
    EEG = pop_eegfiltnew(EEG, [], Par.highPassFilterCutoff_ForChecking, [], true, [], 0);
    
    % Low-pass filter at selected cutoff frequency
    EEG = pop_eegfiltnew(EEG, [], Par.lowPassFilterCutoff_ForChecking, [], 0, [], 0);
    
    
    % File used for checking for bad channels and good/bad sections of data
    EEG_saveFileName = [Par.dataFolder, '/For Checking/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase,  '_', Par.experimentName, '_For_Checking.set'];
    EEG = pop_saveset( EEG, 'filename', EEG_saveFileName);
    

    
    %% -- Save the Parameters File

    save([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step1'], 'Par');
    
end % of for datasetNo 

