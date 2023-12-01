%% BRISC_oddball_preprocessing.m

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


% Enter filepath of directory where the EEG EEGLAB-processed data is stored, relative to the
% current MATLAB working directory
Par.dataFolder = 'H:\Back_up_for_Jerry_Unimelb_PC\12_5_Preprocessed_datasets\Roving_Oddball_Preprocessed_Data\Data';

% Subject IDs to process (entry numbers from list of IDs in Par.subjectCodesList)
subjectIDsToDo = 1:441;

% Get array of subject ID codes
Par = BRISC_oddball_subject_codes(Par);


% Choose experiment name ('bubbles' / 'sound' / 'movie'
Par.experimentName = 'sound';

% Select testing phase
% 'M' = midline
Par.testingPhase = 'M';

% Decide whether to run an ICA on the dataset
% (ICA may not be useful for some datasets in the project)
Par.runAnICA = 1; % 1 = Run the ICA / 0 = Don't run



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

    % Load the EEG file for use with ICA
    EEG_ForICA = pop_loadset([Par.dataFolder, '/Epoched/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Epoched_ForICA.set']);
    
    % Load the Par structure (with stored parameters) from Step 1
    % (Loaded into substructure so that Par structure isn't overwritten)
    Par.Step1 = load([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step1']);
    Par.Step2 = load([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step2']);

    
    
    %% -- Run an ICA on the Dataset    
    
    if Par.runAnICA

        % Determine the channels to feed into the ICA algorithm (exclude noisy
        % channels)
        allChannelsIndices = [1:EEG_ForICA.nbchan];
        Par.movementSensorChanInds = Par.Step2.Par.movementSensorChanInds; % Copy from previous step
        Par.channelsForICA = setdiff(allChannelsIndices, [Par.Step2.Par.badChannelIndices, Par.movementSensorChanInds]);
        
        EEG_ForICA = pop_runica(EEG_ForICA, 'extended', 1, 'interupt', 'off', 'chanind', Par.channelsForICA, 'maxsteps', 1024);

    end % of if Par.runAnICA

    
    
    %% -- Save the Dataset
    EEG_ForICA = pop_saveset( EEG_ForICA, 'filename', [Par.dataFolder, '/Post ICA/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_ICA.set']);

    
    pop_selectcomps(EEG_ForICA, [1:size(EEG_ForICA.icaweights,1)] );

    set(gcf,'Name', Par.subjectCodesList{datasetNo});
    
    %% -- Save the Parameters File
    save([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step3'], 'Par');

    
end % of for datasetNo 
