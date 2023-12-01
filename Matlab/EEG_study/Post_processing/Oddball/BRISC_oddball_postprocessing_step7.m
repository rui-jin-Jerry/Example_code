%% BRISC_oddball_postprocessing_step7.m

% Removes selected independent components and saves file. To be used with the
% BRISC EEG datasets. Relevant data processing parameters are set at the
% beginning of the script (in the Settings/Parameters section).
% Set up half/half habituration analysis
%

% Third version updated by Rui Jin, 28/07 at Doockland | University of Melbourne
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
% load('ERP.mat')
Oddball_ERP_summary = ERP;

% Set thresholding datasets 
Par.num_threshold = 30;

%% Spliting epoches into different conditions and thresholding them 

% Set 30 repetition number as threshold 
% Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) length(find(x == 1))>=Par.num_threshold,Oddball_ERP_summary.repetitionNo) & cellfun(@(x) length(find(x == 2))~=0,Oddball_ERP_summary.repetitionNo),:);

%% Computer the first and second half mean ERP
      
for datasetNo = 1:size(Oddball_ERP_summary,1)  
    
    f_half = 1:1:floor(length(Oddball_ERP_summary.repetitionNo{datasetNo})/2);
   
    s_half = floor(length(Oddball_ERP_summary.repetitionNo{datasetNo})/2):1:length(Oddball_ERP_summary.repetitionNo{datasetNo});
    
    EEG_data_f_half = Oddball_ERP_summary.data{datasetNo}(:,:,f_half);
    
    EEG_data_s_half = Oddball_ERP_summary.data{datasetNo}(:,:,s_half);
    
    repNumbers  = Oddball_ERP_summary.repetitionNo{datasetNo};
       
    for repetitionNo = 1:10
        
        % Input all repetition number dataset into ERP
        eval(['Oddball_ERP_summary.repetition_',num2str(repetitionNo),'_f_half','{datasetNo}','=','EEG_data_f_half(:, :, repNumbers(f_half) == repetitionNo);']);
        
        eval(['Oddball_ERP_summary.repetition_',num2str(repetitionNo),'_s_half','{datasetNo}','=','EEG_data_s_half(:, :, repNumbers(s_half) == repetitionNo);']);
        

    end    



end % of for datasetNo 

%% Computer the mean amp for first/second half 
 
Par.channel_index = [2 3 27 7 26 6 25 4 28];


for datasetNo = 1:size(Oddball_ERP_summary,1)
     
 
    for repetitionNo = 1:10

        eval(['Oddball_ERP_summary.fmean_ERP_repetition_',num2str(repetitionNo),'(datasetNo)','=','{mean(mean(Oddball_ERP_summary.repetition_',num2str(repetitionNo),'_f_half','{datasetNo}(Par.channel_index,:,:),[1,3]),1)};']);
        
        eval(['Oddball_ERP_summary.fmean_ERP_repetition_allChan_',num2str(repetitionNo),'(datasetNo)','=','{mean(Oddball_ERP_summary.repetition_',num2str(repetitionNo),'_f_half','{datasetNo}(:,:,:),3)};']);
    end
    
    Oddball_ERP_summary.fmean_ERP_standard(datasetNo) = {nanmean(cat(1,Oddball_ERP_summary.fmean_ERP_repetition_4{datasetNo},...
        Oddball_ERP_summary.fmean_ERP_repetition_5{datasetNo},Oddball_ERP_summary.fmean_ERP_repetition_6{datasetNo},...
        Oddball_ERP_summary.fmean_ERP_repetition_7{datasetNo},Oddball_ERP_summary.fmean_ERP_repetition_8{datasetNo},...
        Oddball_ERP_summary.fmean_ERP_repetition_9{datasetNo},Oddball_ERP_summary.fmean_ERP_repetition_10{datasetNo}),1)};
  
    Oddball_ERP_summary.fmean_ERP_allchan_standard(datasetNo) = {nanmean(cat(3,Oddball_ERP_summary.fmean_ERP_repetition_allChan_4{datasetNo},...
    Oddball_ERP_summary.fmean_ERP_repetition_allChan_5{datasetNo},Oddball_ERP_summary.fmean_ERP_repetition_allChan_6{datasetNo},...
    Oddball_ERP_summary.fmean_ERP_repetition_allChan_7{datasetNo},Oddball_ERP_summary.fmean_ERP_repetition_allChan_8{datasetNo},...
    Oddball_ERP_summary.fmean_ERP_repetition_allChan_9{datasetNo},Oddball_ERP_summary.fmean_ERP_repetition_allChan_10{datasetNo}),3)};
   
    Oddball_ERP_summary.fmean_MMN(datasetNo) = {Oddball_ERP_summary.fmean_ERP_repetition_1{datasetNo} - Oddball_ERP_summary.fmean_ERP_standard{datasetNo}};
    
    Oddball_ERP_summary.fmean_MMN_allChan(datasetNo) = {Oddball_ERP_summary.fmean_ERP_repetition_allChan_1{datasetNo} - Oddball_ERP_summary.fmean_ERP_allchan_standard{datasetNo}};
    
end


for datasetNo = 1:size(Oddball_ERP_summary,1)
     
 
    for repetitionNo = 1:10

        eval(['Oddball_ERP_summary.smean_ERP_repetition_',num2str(repetitionNo),'(datasetNo)','=','{mean(mean(Oddball_ERP_summary.repetition_',num2str(repetitionNo),'_s_half','{datasetNo}(Par.channel_index,:,:),[1,3]),1)};']);
        
        eval(['Oddball_ERP_summary.smean_ERP_repetition_allChan_',num2str(repetitionNo),'(datasetNo)','=','{mean(Oddball_ERP_summary.repetition_',num2str(repetitionNo),'_s_half','{datasetNo}(:,:,:),3)};']);
    end
    
    Oddball_ERP_summary.smean_ERP_standard(datasetNo) = {nanmean(cat(1,Oddball_ERP_summary.smean_ERP_repetition_4{datasetNo},...
        Oddball_ERP_summary.smean_ERP_repetition_5{datasetNo},Oddball_ERP_summary.smean_ERP_repetition_6{datasetNo},...
        Oddball_ERP_summary.smean_ERP_repetition_7{datasetNo},Oddball_ERP_summary.smean_ERP_repetition_8{datasetNo},...
        Oddball_ERP_summary.smean_ERP_repetition_9{datasetNo},Oddball_ERP_summary.smean_ERP_repetition_10{datasetNo}),1)};
  
    Oddball_ERP_summary.smean_ERP_allchan_standard(datasetNo) = {nanmean(cat(3,Oddball_ERP_summary.smean_ERP_repetition_allChan_4{datasetNo},...
    Oddball_ERP_summary.smean_ERP_repetition_allChan_5{datasetNo},Oddball_ERP_summary.smean_ERP_repetition_allChan_6{datasetNo},...
    Oddball_ERP_summary.smean_ERP_repetition_allChan_7{datasetNo},Oddball_ERP_summary.smean_ERP_repetition_allChan_8{datasetNo},...
    Oddball_ERP_summary.smean_ERP_repetition_allChan_9{datasetNo},Oddball_ERP_summary.smean_ERP_repetition_allChan_10{datasetNo}),3)};
   
    Oddball_ERP_summary.smean_MMN(datasetNo) = {Oddball_ERP_summary.smean_ERP_repetition_1{datasetNo} - Oddball_ERP_summary.smean_ERP_standard{datasetNo}};
    
    Oddball_ERP_summary.smean_MMN_allChan(datasetNo) = {Oddball_ERP_summary.smean_ERP_repetition_allChan_1{datasetNo} - Oddball_ERP_summary.smean_ERP_allchan_standard{datasetNo}};
    
end

%% Set threshold for outlier to +-100 

F_S = Oddball_ERP_summary;

Oddball_ERP_summary = F_S(:,[1,2,4,28:end]);

save('ERP_Endline_PzRef_Lite_Removed_f_s.mat','Oddball_ERP_summary')

% Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) max(x)<100 & min(x)>-100,Oddball_ERP_summary.smean_ERP_repetition_1)  ,:);
% Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) max(x)<100 & min(x)>-100,Oddball_ERP_summary.smean_ERP_standard)  ,:);
% Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) max(x)<100 & min(x)>-100,Oddball_ERP_summary.mean_ERP_repetition_1)  ,:);
% Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) max(x)<100 & min(x)>-100,Oddball_ERP_summary.mean_ERP_standard)  ,:);
% 

%% Plot functionn

figure
a = subplot(1,2,1);
title('first half')
hold on
plot(mean(cat(1,Oddball_ERP_summary.mean_ERP_repetition_1{:}),1));
stdshade(cat(1,Oddball_ERP_summary.mean_ERP_repetition_1{:}),0.2);
hold on
plot(mean(cat(1,Oddball_ERP_summary.mean_ERP_standard{:}),1));
stdshade(cat(1,Oddball_ERP_summary.mean_ERP_standard{:}),0.2);

b = subplot(1,2,2);
title('second half')
hold on
plot(nanmean(cat(1,Oddball_ERP_summary.smean_ERP_repetition_1{:}),1));
hold on
stdshade(cat(1,Oddball_ERP_summary.smean_ERP_repetition_1{:}),0.2);
plot(mean(cat(1,Oddball_ERP_summary.smean_ERP_standard{:}),1));
stdshade(cat(1,Oddball_ERP_summary.smean_ERP_standard{:}),0.2);

linkaxes([a b],'xy')

figure
a = subplot(1,2,1);
hold on
title('first half')
plot(mean(cat(1,Oddball_ERP_summary.mean_MMN{:}),1));
hold on
stdshade(cat(1,Oddball_ERP_summary.mean_MMN{:}),0.2);

b = subplot(1,2,2);
hold on
title('second half')
plot(mean(cat(1,Oddball_ERP_summary.smean_MMN{:}),1));
hold on
stdshade(cat(1,Oddball_ERP_summary.smean_MMN{:}),0.2);

linkaxes([a b],'xy')


%%

% Remove the outliers before do this 

rep_1 = cellfun(@(x) mean(x(1:30,:,:),3),Oddball_ERP_summary.mean_ERP_repetition_allChan_1,'UniformOutput',false);
rep_1 = cat(3,rep_1{:});


rep_s = cellfun(@(x) mean(x(1:30,:,:),3),Oddball_ERP_summary.smean_ERP_repetition_allChan_1,'UniformOutput',false);
rep_s = cat(3,rep_s{:});


% DO the mass univrrite analysis do the t test everytime 

ttest_results_h = [];
ttest_results_p = [];


for channel = 1:30
    
    for timepoint = 1:250
        
    [h ,p ]= ttest(rep_1(channel,timepoint,:),rep_s(channel,timepoint,:),'Alpha',0.00005);    
        
    ttest_results_h(channel,timepoint) = h;  
    ttest_results_p(channel,timepoint) = p;  
        
    end
    
    
end

% ttest_results_h(find(ttest_results_h == 0)) = 10;

figure
imagesc(ttest_results_p);
colorbar

% Lite = Oddball_ERP_summary(:,[1,2,3,27:end]);

%% 



figure
for index = 1:size(Oddball_ERP_summary,1)
    
    
    plot(Oddball_ERP_summary.smean_ERP_repetition_1{index})
    hold on
    

end

figure
for index = 1:size(Oddball_ERP_summary,1)
    
    
    plot(Oddball_ERP_summary.smean_ERP_standard{index})
    hold on
    

end
%% Get the summary table for midlin/endline/extra-endline

Oddball_ERP_summary.removed_index(:) = 0;
Oddball_ERP_summary_Endline_Removed.removed_index(:) = 1;

Endline = [Oddball_ERP_summary;Oddball_ERP_summary_Endline_Removed];

Oddball_ERP_summary.removed_index(:) = 0;
Oddball_ERP_summary_Midline_Removed.removed_index(:) = 1;

Midline = [Oddball_ERP_summary;Oddball_ERP_summary_Midline_Removed];

Oddball_ERP_summary.removed_index(:) = 0;
Oddball_ERP_summary_Ex_Endline_Removed.removed_index(:) = 1;


Ex_Endline = [Oddball_ERP_summary;Oddball_ERP_summary_Ex_Endline_Removed];

% for f-s analysis 
load('ERP_Midline_TPRef_Lite_Removed_f_s.mat')
Mid = Oddball_ERP_summary;
Mid.removed_index(:) = 0;
load('ERP_Ex_Endline_PzRef_Lite_Removed_f_s.mat')
Ex_End = Oddball_ERP_summary;
Ex_End.removed_index(:) = 0;
load('ERP_Endline_PzRef_Lite_Removed_f_s.mat')
End = Oddball_ERP_summary;
End.removed_index(:) = 0;
load('ERP_Midline_TPRef_Lite_f_s.mat')
Mid_good = Oddball_ERP_summary;
Mid_good.removed_index(:) = 1;
load('ERP_Ex_Endline_PzRef_Lite_f_s.mat')
Ex_End_good = Oddball_ERP_summary;
Ex_End_good.removed_index(:) = 1;
load('ERP_Endline_PzRef_Lite_f_s.mat')
End_good = Oddball_ERP_summary;
End_good.removed_index(:) = 1;

Midline = [Mid_good;Mid];
Ex_Endline = [Ex_End_good;Ex_End];
Endline = [End_good;End];

All = [Midline;Ex_Endline;Endline];% 538 need missing 



Summary = [Midline;Ex_Endline;Endline];

Summary_T = table('Size',[0 0 ]);

Summary_T.subject = Summary.subject;
Summary_T.trialstage = Summary.trialstage;


Summary_T.ERP_Difference_Scores = cellfun(@(x) mean(x(150:250)),Summary.mean_MMN);
Summary_T.ERP_Deviant_Scores = cellfun(@(x) mean(x(150:250)),Summary.mean_ERP_repetition_1);

Summary_T.ERP_N2_difference_Scores = cellfun(@(x) mean(x(95:105)),Summary.mean_MMN);
Summary_T.Removed_index = Summary.removed_index;

Summary_T.ERP_Deviant_firstHalf_Scores = cellfun(@(x) mean(x(150:250)),All.fmean_ERP_repetition_1);
Summary_T.ERP_Deviant_secondHalf_Scores = cellfun(@(x) mean(x(150:250)),All.smean_ERP_repetition_1);


writetable(OddballSummaryV3,'Oddball_Summary_V3.csv');

OddballSummaryV3 = [OddballSummaryV2,Summary_T];

%%

Mid_sum = BRSIC_Subject_Summary(strcmp(BRSIC_Subject_Summary.trialstage,'M'),:);

Ex_sum = BRSIC_Subject_Summary(strcmp(BRSIC_Subject_Summary.trialstage,'EX'),:);

End_sum = BRSIC_Subject_Summary(strcmp(BRSIC_Subject_Summary.trialstage,'E'),:);

Mid_diff = setdiff(Mid_sum.subjectid, Midline.subject);

Ex_diff = setdiff(Ex_sum.subjectid,Ex_Endline.subject);

End_diff = setdiff(End_sum.subjectid,Endline.subject);

Diff_T = table('Size',[0 0]);

Diff_T.subject = End_diff;
for index = 1:size(Diff_T,1)
    
    
   Diff_T.trialstage{index} = 'E';
   Diff_T.ERP_Difference_Scores(index) = NaN;
   Diff_T.ERP_Deviant_Scores(index) = NaN; 
   Diff_T.ERP_Standard_Scores(index) = NaN; 
   Diff_T.ERP_N2_difference_Scores(index) = NaN; 
   Diff_T.Removed_index(index) = 2;
   Diff_T.ERP_Deviant_firstHalf_Scores(index) = NaN;
   Diff_T.ERP_Deviant_secondHalf_Scores(index) = NaN;
   
end

Midline_diff = Diff_T;
Ex_Endline_diff = Diff_T;
Endline_diff = Diff_T;

Diff_sum = [Midline_diff;Ex_Endline_diff;Endline_diff];

OddballSummaryV4 = [OddballSummaryV3;Diff_sum];

writetable(OddballSummaryV4,'Oddball_Summary_V4.csv');

%% Save the variable 
% 
% save('ERP_Endline.mat','Oddball_ERP_summary', '-v7.3');

