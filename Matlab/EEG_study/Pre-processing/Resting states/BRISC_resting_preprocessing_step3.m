%% BRISC_resting_preprocessing.m

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
Par.dataFolder = 'H:\Back_up_for_Jerry_Unimelb_PC\12_5_Preprocessed_datasets\Resting_State_Preprocessed_Data\Data';

% Subject IDs to process (entry numbers from list of IDs in Par.subjectCodesList)
subjectIDsToDo = 776:1002;


% Get array of subject ID codes
Par = BRISC_resting_subject_codes(Par);


% Choose experiment name ('bubbles' / 'sound' / 'movie'
Par.experimentName = 'bubbles';

% Select testing phase
% 'M' = midline
Par.testingPhase = 'EX';

% Select whether to remove artefactual IC components from the dataset
Par.removeSelectedICs = 0; % 1 = Remove selected ICs / 0 = Don't remove



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
    EEG = pop_loadset([Par.dataFolder, '/Epoched/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Epoched.set']);

    % Load the Par structure (with stored parameters) from Step 2
    % (Loaded into substructure so that Par structure isn't overwritten)
    Par.Step2 = load([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step2']);

    

    %% -- Mark Independent Components to Remove
    
    if Par.removeSelectedICs
    
        % Get vector of artefact ICs
        Par = BRISC_resting_ICs_to_remove(Par, datasetNo);
        
        % Remove the components
        EEG = pop_subcomp(EEG, Par.ICsToRemove, 0);
    
    end % of if Par.removeSelectedICs
    
    
    
    %% -- Interpolate Noisy Electrodes Using the Cleaned Data
    
    % Use bad channels vector defined in Par structure at step 2
    % Spherical spline interpolation
    
    if isempty(Par.Step2.Par.badChannelIndices) == 0 % If any bad channels have been identified
        
        EEG = pop_interp(EEG, Par.Step2.Par.badChannelIndices, 'spherical');

    end % of if length
    
    

    %% -- Save the Dataset
    
    EEG = pop_saveset( EEG, 'filename', [Par.dataFolder, '/Cleaned/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_Cleaned.set']);



    %% -- Save the Parameters File
    save([Par.dataFolder, '/Parameters/', Par.subjectCodesList{datasetNo}, '_', Par.testingPhase, '_', Par.experimentName, '_EEG_params_step3'], 'Par');
 

    
end % of for datasetNo 
