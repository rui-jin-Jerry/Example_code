%% BRISC_resting_postprocessing_step5.m

% Run short_term_fft on summary table for resting datasets. To be used with the
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

% Choose experiment name ('bubbles' / 'sound' / 'movie')
Par.experimentName = 'bubbles';

% Set the parameters for short term fft
Par.windowLength = 2000; % 2s for 1000 samples
Par.sampleRate = 500;

Channel_Loc = 33;

%% Run short term fft on datasets

for datasetNo = 1:size(Resting_EEG_summary,1)
    
    % Set the rest parameters for short term fft
    Par.timeWindows = 1000:500:(floor(Resting_EEG_summary.fft_timepoint{datasetNo}(end)/1000)-1)*1000;
    Par.timepts = Resting_EEG_summary.fft_timepoint{datasetNo};
    Par.AR_AmpCutoff = 150;
    
    Epoched_input(:,:,1) = Resting_EEG_summary.Epoched_Data{datasetNo};
    Epoched_input(:,:,2) = Resting_EEG_summary.Epoched_Data{datasetNo};
    
    Freq_Timewind = [];
    RJtimeWindowindex = [];
    RJtimeWindowAll = {};
    
    % loop for add all the channels exclud the motor sensor
    for channelid = 1:(Channel_Loc-3)
        
        Par.channelToUse = Resting_EEG_summary.chanlocs{datasetNo}(channelid).labels;

        [ a, b, c ] = short_term_fft_epochRJ_2(Epoched_input, Par, Resting_EEG_summary.chanlocs{datasetNo});
        
        Freq_Timewind = cat(1,Freq_Timewind, reshape(mean(a,3),1,size(mean(a,3),1),size(mean(a,3),2)));
           
        RJtimeWindowindex = unique([RJtimeWindowindex , c]);
        
        RJtimeWindowAll{end+1} = c;
        
    end
    
    Freq_Timewind_All = Freq_Timewind;
    
    Freq_Timewind = Freq_Timewind(:,:,setdiff(1:1:size(Freq_Timewind,3),RJtimeWindowindex));
    
    % Consider using only serveral channal for epoch rejection
    
    Resting_EEG_summary.Freq_Timewind(datasetNo) = ...
        {Freq_Timewind};
    
    Resting_EEG_summary.Freq_Timewind_All(datasetNo) = ...
        {Freq_Timewind_All};
    
    Resting_EEG_summary.RJtimeWindow(datasetNo) = ...
        {RJtimeWindowindex};
    
    Resting_EEG_summary.RJtimeWindowAll(datasetNo) = ...
        {RJtimeWindowAll};
    
    
    clear Epoched_input
    
end

%% Reject timewindows based on subset of channels

for index = 1:size(Resting_EEG_summary,1)
    
    RJallnum = [];
    
    for chan = [2 3 28 7 27 22 8 23 15 16 17 12 21 13 18]%[2 7 28 23 8 24] %
        
    RJallnum = [RJallnum, Resting_EEG_summary.RJtimeWindowAll{index}{chan}];
       
    end
    
    Resting_EEG_summary.RJallnum(index) = length(unique(RJallnum));
    
    Resting_EEG_summary.Freq_Timewind{index} = Resting_EEG_summary.Freq_Timewind_All{index}...
        (:,:,setdiff(1:1:size(Resting_EEG_summary.Freq_Timewind_All{index},3),unique(RJallnum))); 
 
    
end

Copy = Resting_EEG_summary;

% Remaining datasets should have at least 30 timewindows /120 total
Resting_EEG_summary = Resting_EEG_summary(cellfun(@(x) size(x,3)>=58,Resting_EEG_summary.Freq_Timewind),:);


Resting_EEG_summary = Copy(cellfun(@(x) size(x,3)<58,Copy.Freq_Timewind),:);


%% Try to set aside a lite version

% Set aside a lite version table
Resting = table('Size',[0 0]);
Resting.subjectid = Resting_EEG_summary.subjectid;
Resting.trial_stage = Resting_EEG_summary.trial_stage;
Resting.chanlocs = Resting_EEG_summary.chanlocs;
Resting.Freq_Timewind = cellfun(@(x) mean(x(:,3:61,:),3),Resting_EEG_summary.Freq_Timewind,'UniformOutput',false);
Resting.RJtimeWindowAll = Resting_EEG_summary.RJtimeWindowAll;

%% Save the variable

%save('Resting_EEG_Midline_TPRef_Lite_Ex.mat','Resting')


% Lite version
% save('Resting_EEG_Lite.mat','Resting_EEG', '-v7.3');

% Full version
% save('Resting_EEG_summary.mat','Resting_EEG_summary', '-v7.3');
