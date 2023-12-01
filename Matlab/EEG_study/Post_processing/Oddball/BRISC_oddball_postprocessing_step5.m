%% BRISC_oddball_postprocessing_step5.m

% Removes selected independent components and saves file. To be used with the
% BRISC EEG datasets. Relevant data processing parameters are set at the
% beginning of the script (in the Settings/Parameters section).
%
%
% First version written by Daniel Feuerriegel, 1/19 at the University of
% Melbourne.
% Second version updated by Harley Stiebel, 8/19 at the Walter+Eliza Hall
% Institute and University of Melbourne.
% Third version updated by Rui Jin, 10/19 at the Peter doherty institute
% and University of Melbourne
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
Par.dataFolder = 'H:\Back_up_for_Jerry_Unimelb_PC\12_5_Preprocessed_datasets\Roving_Oddball_Preprocessed_Data\Data\Cleaned';

% The standard channel location order
Par.channel_loc = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Post-processing steps\Oddball\Channel_Loc.mat';
Par.channel_loc_TP9 = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Post-processing steps\Oddball\Channel_Loc_TP9.mat';

% Choose experiment name ('bubbles' / 'sound' / 'movie')
Par.experimentName = 'sound';

% Select the filtering cutoff method
Par.cutoff_method = 'Moderate';

% Load .mat ERP file names, only pick the moderate cleaned, dependend what cutoff data you want to analysis
filesList = dir(sprintf('%s/*_Cleaned_%s.set',Par.dataFolder,Par.cutoff_method));
Par.subjectNos = length(filesList);
Par.subjectCodesList = cellfun(@(x) x(1:6),{filesList(:).name},'UniformOutput',false);
Par.trialstage = cellfun(@(x) x(8:9),{filesList(:).name},'UniformOutput',false);
Par.subject_index = find(strcmp('EX',Par.trialstage)); % Subject IDs to process (For different trialstages)

% Load the standard channel location
load(Par.channel_loc_TP9);
% Channel_Loc = Channel_Loc([1:12 14:34]);

% Directory (relative to MATLAB working directory) where the channel locations file is stored
Par.channelLocationsDirectory = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Documents\BRSIC\BRISC_EEG\Preprocessing_Code\Resting_State\Channel Locations';

% Name of the channel locations file to be used
Par.channelLocationsFileName = 'standard-10-5-cap385.elp';

% Movement sensor channels
Par.movementSensorChannels = {'x_dir' 'y_dir' 'z_dir'};

% Initial a empty table
ERP = table('Size',[0 0]);

% Enter if need to be Pz ref
Par.reRef = 0;
Par.re_channel = 'Pz';

%% EEG Postprocessing Pipeline

for datasetNo = 1:length(Par.subject_index)
    
    
    %% -- Load Data File
    
    % Load EEG
    
    EEG = pop_loadset([Par.dataFolder, '/', filesList(Par.subject_index(datasetNo)).name]);
    
    
    %% -- Compare with the channel location and reorder the channel with wrong channel order
    
    holder = [];
    
    for C_id = 1:size(Channel_Loc,2)
        
        num = find(strcmp(Channel_Loc(C_id).labels,{EEG.chanlocs.labels}));
        
        holder(C_id,:,:) = EEG.data(num,:,:);
        
    end
    
    EEG.data = holder;
    
    EEG.chanlocs = Channel_Loc;
    
    %% Get a list of channel indices by channel labels Re ref to Pz
    
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
    
    
    %% Get Relevant Info For Each Epoch
    
    repNumbers = nan(1, size(EEG.data, 3));
    
    
    for epochNo = 1:size(EEG.data, 3)
        try
        for eventInd = 1:length(EEG.epoch(epochNo).eventtype)
                 
                switch EEG.epoch(epochNo).eventtype{eventInd}
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
                   
        end % of for eventInd
        catch
               
        end
        
    end % of for epochNo
    
    %%  Get relevant info for tone frequency
    
    freqNumbers = nan(1, size(EEG.data, 3));
    
    
    for epochNo = 1:size(EEG.data, 3)
         try
        for eventInd = 1:length(EEG.epoch(epochNo).eventtype)
            
           
                
                switch EEG.epoch(epochNo).eventtype{eventInd}
                    case 'S111'
                        freqNumbers(epochNo) = 1;
                    case 'S112'
                        freqNumbers(epochNo) = 2;
                    case 'S113'
                        freqNumbers(epochNo) = 3;
                    case 'S114'
                        freqNumbers(epochNo) = 4;
                    case 'S115'
                        freqNumbers(epochNo) = 5;
                    case 'S116'
                        freqNumbers(epochNo) = 6;
                    case 'S117'
                        freqNumbers(epochNo) = 7;
                    case 'S118'
                        freqNumbers(epochNo) = 8;
                    case 'S119'
                        freqNumbers(epochNo) = 9;
                    case 'S120'
                        freqNumbers(epochNo) = 10;
                    case 'S121'
                        freqNumbers(epochNo) = 11;
                    case 'S122'
                        freqNumbers(epochNo) = 12;
                    case 'S123'
                        freqNumbers(epochNo) = 13;
                    case 'S124'
                        freqNumbers(epochNo) = 14;
                    case 'S125'
                        freqNumbers(epochNo) = 15;
                    case 'S126'
                        freqNumbers(epochNo) = 16;
                    case 'S127'
                        freqNumbers(epochNo) = 17;
                    case 'S128'
                        freqNumbers(epochNo) = 18;
                    case 'S129'
                        freqNumbers(epochNo) = 19;
                    case 'S130'
                        freqNumbers(epochNo) = 20;
                    case 'S131'
                        freqNumbers(epochNo) = 21;
                    case 'S132'
                        freqNumbers(epochNo) = 22;
                    case 'S133'
                        freqNumbers(epochNo) = 23;
                    case 'S134'
                        freqNumbers(epochNo) = 24;
                    case 'S135'
                        freqNumbers(epochNo) = 25;
                    case 'S136'
                        freqNumbers(epochNo) = 26;
                    case 'S137'
                        freqNumbers(epochNo) = 27;
                    case 'S138'
                        freqNumbers(epochNo) = 28;
                    case 'S139'
                        freqNumbers(epochNo) = 29;
                    case 'S140'
                        freqNumbers(epochNo) = 30;
                        
                end
                

            
        end % of for eventInd
                    catch
                
            end
        
    end % of for epochNo
    
    %% Sort Epochs by repetition number and get ERPs /change to table
    
    % Get subject timepoints and channel information
    ERP.subject{datasetNo} = EEG.filename(1:6);
    ERP.trialstage{datasetNo} = EEG.filename(8:9);
    ERP.timepoints{datasetNo} = EEG.times;
    ERP.chanlocs{datasetNo} = EEG.chanlocs;
    ERP.data{datasetNo} = EEG.data;
    ERP.repetitionNo{datasetNo} = repNumbers;
    ERP.freqNo{datasetNo} = freqNumbers;
    

    
end % of for datasetNo



%% Save the variable

% save('ERP.mat','ERP', '-v7.3');

