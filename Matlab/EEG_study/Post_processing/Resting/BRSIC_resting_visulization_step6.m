%% BRSIC_resting_visulization_step6

% This script take FFT data from resting summary table, 
% make plots for visulize frequency domain resting % Mean median and trimmean power
%
% ***** Note *****
% 1) We focus on 5 Frequncy band Delta: 1~3 Hz Theta 4~7Hz Alpha 8~12Hz 
%    Beta 13~35hz 
% 2) Data has been high and low pass filtered, so only focus on 1Hz to 30Hz
% 3) Apply epoch rejection after we seperate the whole segment into 2s
%    epoches of whole testing phase
% 4) So we have 60 bin of frequency in seperate of 0.5Hz 

%
% First version written by Rui Jin | University of Melbourne. 11/19

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

Par.FFT_tableFolder = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Documents\BRSIC\BRISC_EEG\Postprocessing_Code\Resting_State';

% Choose experiment name ('bubbles' / 'sound' / 'movie')
Par.experimentName = 'bubbles';

% Select testing phase and channels
Par.testingPhase = 'M';

% The frequency range we are interested 
% Hz from 1:30 but in 500 sample with first as zero should be 3:61
Par.Frequency_index_range = 1:59;

% Enter pre-defined range for different band 
Par.delta = [1:5];
Par.theta = [6:12];
Par.alpha = [13:17];
Par.beta = [18:59];

% Chooes electrod of interest like Fz code 2 

Par.sample_points = 1000;
Par.strate = 500;
Par.nyquist = Par.strate/2;

Par.FFT_Frequencies = linspace(0,Par.nyquist,Par.sample_points/2+1);

Par.Frequency_range = Par.FFT_Frequencies(Par.Frequency_index_range);

%% Load summary table and cross reference with outcome measures 

load('Resting_EEG.mat')

Resting_EEG_summary = Resting_EEG;

%% Register the outliers (subject) because no amplitude threshold have been
% applied to the epoch (Every datasets out of 3 standard deviantion will be
% considered as out liers and get pined in the datasets. 

% Set up to 3:61 Frequency range
Resting_EEG_summary.Freq_Timewind = cellfun(@(x) x(:,Par.Frequency_index_range,:), Resting_EEG_summary.Freq_Timewind, 'UniformOutput', false);

Outlier_datasets = [];

for channelid = 1:30
    
Channel_of_interest = channelid;

All_FFT_mean = cellfun(@(x) mean(x,3), Resting_EEG_summary.Freq_Timewind, 'UniformOutput', false);

Delta_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.delta)),All_FFT_mean);
Theta_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.theta)),All_FFT_mean);
Alpha_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.alpha)),All_FFT_mean);
Beta_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.beta)),All_FFT_mean);

    
T = [find(isoutlier(Delta_mean,'mean'))',find(isoutlier(Theta_mean,'mean'))',find(isoutlier(Alpha_mean,'mean'))',...
    find(isoutlier(Beta_mean,'mean'))'];

Outlier_datasets = unique([Outlier_datasets,T ]);

end

All = Resting_EEG_summary;
Remained_datasets = setdiff(1:1:size(Resting_EEG_summary,1),Outlier_datasets);
Resting_EEG_summary = Resting_EEG_summary(Remained_datasets,:);


%% Figure 1 Box-plot for power amplitudes in difference frequency bandwidth
 
% X axis:Different Bandwidth
% Y axis: Mean power over that frequency bandwidth

figure
% Using Fz 
Channel_of_interest =2;
All_FFT_mean = cellfun(@(x) mean(x,3), Resting_EEG_summary.Freq_Timewind, 'UniformOutput', false);

Delta_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.delta)),All_FFT_mean);
Theta_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.theta)),All_FFT_mean);
Alpha_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.alpha)),All_FFT_mean);
Beta_mean = cellfun(@(x) mean(x(Channel_of_interest,Par.beta)),All_FFT_mean);


notBoxPlot([Delta_mean,Theta_mean,Alpha_mean,...
   Beta_mean],[1,2,3,4]);

title(['Channel: ',Resting_EEG_summary.chanlocs{1}(Channel_of_interest).labels]) 
xticklabels({'Delta 1-3Hz','Theta 3-7Hz','Alpha 7-12Hz','Beta 12-30Hz'})
ylabel('Mean Power')
set(gca,'FontSize',20)
set(gca, 'FontName', 'Times New Roman')



%% Figure 2 Line plot for Frequency - Power average for channel of interest

% X axis: Frequency bins 
% Y axis: Power sqare root of amplitude of certain frequency 
% all sampling from datasets
% Frequency resolution is 0.5Hz

% Refer chanloc variable for name 
Channel_of_interest =[13];
All_FFT = cat(3,Resting_EEG_summary.Freq_Timewind{:});

figure 

% For individual like 
hold on
for index = 1:size(Resting_EEG_summary,1)
    
T = plot(Par.Frequency_range,mean(Resting_EEG_summary.Freq_Timewind{index}(Channel_of_interest,:),1),'Color',[0.5 0.5 0.5]);

T.Color(4) = 0.25;

hold on   
    
end
% subplot(2,1,1)
plot(Par.Frequency_range,nanmean(All_FFT(Channel_of_interest,Par.Frequency_index_range,:),[1 3]),'Color','r','LineWidth',0.6)


title(['Channel: ',Resting_EEG_summary.chanlocs{1}(Channel_of_interest).labels])

xlim([1 30])
% ylim([0 6])
xlabel('Frequency Hz') 
ylabel('Power')
set(gca,'FontSize',20)
set(gca, 'FontName', 'Times New Roman')

% for index = 1:size(Resting_EEG_summary,1)
%     
%    if max(Resting_EEG_summary.Freq_Timewind{index}(2,:)) >15
%        error('sds')
%    else
%    end
% end
% 
% Resting_EEG_summary(385,:) = [];


%% Add color coding 

hold on

Delta = area([1 3],[max(yticks) max(yticks)],'FaceAlpha',0.3,'FaceColor','r','EdgeAlpha',0);
Theta = area([3 6],[max(yticks) max(yticks)],'FaceAlpha',0.3,'FaceColor','b','EdgeAlpha',0);
Alpha = area([6 9],[max(yticks) max(yticks)],'FaceAlpha',0.3,'FaceColor','k','EdgeAlpha',0);
Beta = area([9 30],[max(yticks) max(yticks)],'FaceAlpha',0.3,'FaceColor','g','EdgeAlpha',0);

legend([Delta,Theta,Alpha,Beta],{'Delta 1-3Hz','Theta 3-6Hz','Alpha 6-9Hz','Beta 9-30Hz'},'Location','bestoutside','Box','off')

%% Add fitting 1/f model 

hold on
y = max(mean(All_FFT(Channel_of_interest,Par.Frequency_index_range,:),3));
fplot(@(x) y*1/(x^0.85),[1 30])
title(['Channel: ',Resting_EEG_summary.chanlocs{1}(Channel_of_interest).labels])


%% Add more fitting model

subplot(2,1,2)
x = 1:0.5:30;
R = y*1./(x.^1);

plot(Par.Frequency_range,mean(All_FFT(Channel_of_interest,Par.Frequency_index_range,:),3)./R)
xlim([1 30])
% ylim([0 6])
xlabel('Frequency Hz')

set(gca,'FontSize',20)
set(gca, 'FontName', 'Times New Roman')
refline([0 1])
    
%% Figure 3, Topoplots for different bandwidth 

All_FFT = cat(3,Resting_EEG_summary.Freq_Timewind{:});

figure('Position',[0 0 1086 480]);

subplot(1,4,1) 
title('Delta')
topoplot(mean(All_FFT(:,Par.delta,:),[2 3]),Resting_EEG_summary.chanlocs{1},...
    'maplimits',[0 7] ,'electrodes','labels');
colorbar

subplot(1,4,2)
title('Theta')
topoplot(mean(All_FFT(:,Par.theta,:),[2 3]),Resting_EEG_summary.chanlocs{1},...
     'maplimits',[0 2.5] ,'electrodes','labels');
colorbar 

subplot(1,4,3)
title('Alpha')
topoplot(mean(All_FFT(:,Par.alpha,:),[2 3]),Resting_EEG_summary.chanlocs{1},...
    'maplimits',[0 1.5] , 'electrodes','labels');
colorbar 

subplot(1,4,4)
title('Beta')
topoplot(mean(All_FFT(:,Par.beta,:),[2 3]),Resting_EEG_summary.chanlocs{1},...
     'maplimits',[0 1] ,'electrodes','labels');
colorbar 




%% Figure 5, Regression plot for log-log frequency power analysis  

Channel_of_interest =2;
All_FFT = cat(3,Resting_EEG_summary.Freq_Timewind{:});

figure

plotregression(log(Par.Frequency_range),log(mean(All_FFT(Channel_of_interest,Par.Frequency_index_range,:),3)),'Regression')


% Initial variables

Resting_EEG_summary.slope_log_log{1} = 0;
Resting_EEG_summary.R_log_log{1} = 0;

for subjectid = 1:size(Resting_EEG_summary,1)
    
    for channelid = 1:30

[Resting_EEG_summary.slope_log_log{subjectid}(channelid,:),Resting_EEG_summary.R_log_log{subjectid}(channelid,:),b] = regression(log(Par.Frequency_range),...
    log(mean(Resting_EEG_summary.Freq_Timewind{subjectid}(channelid,Par.Frequency_index_range,:),3)));

    end
end

figure
scatter(1:30,mean(cat(2,Resting_EEG_summary.slope_log_log{:}),2));
hold on 
scatter(1:30,mean(cat(2,Resting_EEG_summary.slope_log_log{:}),2));

figure
topoplot(mean(cat(2,Resting_EEG_summary.slope_log_log{:}),2),Resting_EEG_summary.chanlocs{1},'maplimits',[-1.1 -0.5 ])
colorbar

figure
topoplot(mean(cat(2,F.slope_log_log{:}),2),Resting_EEG_summary.chanlocs{1},'maplimits',[-1.2 -0.7 ])
colorbar

%% Figure6: Use 1/F function to model the infants' frequency power analysis to increase our power on the individual difference  
% Carefull to develop a profile to decide infants different bandwithds,
% because it is different from adults nomorative datasets

% ****** EXAMPLE NORMALISATION ******

% T = Resting_EEG_summary.Freq_Timewind{1}(16,3:61,:);
% base_power = mean(T,3);
% dbconvert = 10*log10( bsxfun(@rdivide,T,base_power));
% f = mean(dbconvert,3);
% figure
% plot(f)

% ****** EXAMPLE NORMALISATION ******

% Convert the Time-Frequency into the db intense for the normalisation  

Resting_EEG_summary.dbconverted_Fre_Time{1} = 0;

    for channelid = 1:33

    cellfun(@(x) 10*log10(bsxfun(@rdivide,x(channelid,3:61,:),trimmean(x(channelid,3:61,:),20,3))),...
    Resting_EEG_summary.Freq_Timewind,'UniformOutput', false);
    
    
    end

channelid = 9;
    
dbconverted_Fre_Time = cellfun(@(x) 10*log10(bsxfun(@rdivide,x(channelid,3:61,:),mean(x(channelid,3:61,:),3))),...
    Resting_EEG_summary.Freq_Timewind,'UniformOutput', false);    
    
figure
plot(Par.Frequency_range,mean(cat(3,dbconverted_Fre_Time{:}),3));
title(['Channel: ',Resting_EEG_summary.chanlocs{1}(channelid).labels])
set(gca,'FontSize',20)
set(gca, 'FontName', 'Times New Roman')
% % ylim([-1.5 0.5])
% refline([ 0 0])

% Individual line plot 

figure

plot(Par.Frequency_range,trimmean(dbconverted_Fre_Time{9},20,3));

%% Figure 7: Set group and compare between Aneamea and NO_Aneamea

% Compare the Anaemia and No anaemia 

Resting_Anaemia = Resting_EEG_summary(Resting_EEG_summary.Anaemia==1,:);

Resting_NoAnaemia = Resting_EEG_summary(Resting_EEG_summary.Anaemia==0,:);


% not box Let's compare the Anaemia and No-Anaemia in the outcome measures
% Bayles scores 

figure
notBoxPlot([Resting_Anaemia.CogCS'],[1]);
hold on
notBoxPlot([Resting_NoAnaemia.CogCS'],[2]);

notBoxPlot([Resting_Anaemia.LangSumCS'],[3]);
notBoxPlot([Resting_NoAnaemia.LangSumCS'],[4]);

notBoxPlot([Resting_Anaemia.MotSumCS'],[5]);
notBoxPlot([Resting_NoAnaemia.MotSumCS'],[6]);


xticklabels({'','AnaemiaCogCS','No AnaemiaCogCS','AnaemiaLangSumCS','No AnaemiaLangSumCS','AnaemiaMotSumCS','No AnaemiaMotSumCS'})

figure
notBoxPlot([Resting_Anaemia.Appro'],[1]);
hold on
notBoxPlot([Resting_NoAnaemia.Appro'],[2]);

notBoxPlot([Resting_Anaemia.Adapt'],[3]);
notBoxPlot([Resting_NoAnaemia.Adapt'],[4]);

notBoxPlot([Resting_Anaemia.GenEmot'],[5]);
notBoxPlot([Resting_NoAnaemia.GenEmot'],[6]);

notBoxPlot([Resting_Anaemia.Attentiveness'],[7]);
notBoxPlot([Resting_NoAnaemia.Attentiveness'],[8]);

notBoxPlot([Resting_Anaemia.Robustness'],[9]);
notBoxPlot([Resting_NoAnaemia.Robustness'],[10]);

notBoxPlot([Resting_Anaemia.Cooper'],[11]);
notBoxPlot([Resting_NoAnaemia.Cooper'],[12]);

% 
figure
notBoxPlot([Resting_Anaemia.Posemo'],[1]);
hold on
notBoxPlot([Resting_NoAnaemia.Posemo'],[2]);

notBoxPlot([Resting_Anaemia.Negemo'],[3]);
notBoxPlot([Resting_NoAnaemia.Negemo'],[4]);

notBoxPlot([Resting_Anaemia.Fear'],[5]);
notBoxPlot([Resting_NoAnaemia.Fear'],[6]);

notBoxPlot([Resting_Anaemia.Social'],[7]);
notBoxPlot([Resting_NoAnaemia.Social'],[8]);

notBoxPlot([Resting_Anaemia.Orientation'],[9]);
notBoxPlot([Resting_NoAnaemia.Orientation'],[10]);

notBoxPlot([Resting_Anaemia.Sleep'],[11]);
notBoxPlot([Resting_NoAnaemia.Sleep'],[12]);

%

figure
notBoxPlot([Resting_Anaemia.Underweight'],[1]);
hold on
notBoxPlot([Resting_NoAnaemia.Underweight'],[2]);

% 

figure
notBoxPlot([Resting_Anaemia.HbFgdl_venous'],[1]);
hold on
notBoxPlot([Resting_NoAnaemia.HbFgdl_venous'],[2]);

% corrplot get the correlation 

figure

corrplot(Resting_EEG_summary(:,[15,41]))

figure

corrplot(Resting_Anaemia(:,16:24))

figure

corrplot(Resting_NoAnaemia(:,17:19))

figure

Delta_A = cellfun(@(x) mean(x,2),Resting_Anaemia.Delta_mean,'UniformOutput',false);

topoplot(mean(cat(2,Delta_A{:}),2),Channel_Loc,'maplimits',[0 4] ,'electrodes','labels')

Delta_A = cellfun(@(x) mean(x,2),Resting_NoAnaemia.Delta_mean,'UniformOutput',false);

topoplot(mean(cat(2,Delta_A{:}),2),Channel_Loc,'maplimits',[0 4] ,'electrodes','labels')


Theta_A = cellfun(@(x) mean(x,2),Resting_Anaemia.Theta_mean,'UniformOutput',false);

topoplot(mean(cat(2,Theta_A{:}),2),Channel_Loc,'maplimits',[0 2] ,'electrodes','labels')

Theta_A = cellfun(@(x) mean(x,2),Resting_NoAnaemia.Theta_mean,'UniformOutput',false);

topoplot(mean(cat(2,Theta_A{:}),2),Channel_Loc,'maplimits',[0 2] ,'electrodes','labels')




%% Figure 8:  Hist/Corr plot for mean amplitude of different bandwith power with outcome measure


for index = 1:size(Resting_EEG_summary,1)
       
      Resting_EEG_summary.Delta_mean{index} = ...
          mean(Resting_EEG_summary.Freq_Timewind{index}(:,Par.delta,:),3);
    
      Resting_EEG_summary.Theta_mean{index} = ...
          mean(Resting_EEG_summary.Freq_Timewind{index}(:,Par.theta,:),3);      
      
      Resting_EEG_summary.Alpha_mean{index} = ...
          mean(Resting_EEG_summary.Freq_Timewind{index}(:,Par.alpha,:),3);   
      
       Resting_EEG_summary.Beta_mean{index} = ...
          mean(Resting_EEG_summary.Freq_Timewind{index}(:,Par.beta,:),3);     
            
end


Delta = cell2mat(cellfun(@(x) mean(x,[1,2]),Resting_EEG_summary.Delta_mean,'UniformOutput',false));
Theta = cell2mat(cellfun(@(x) mean(x,[1,2]),Resting_EEG_summary.Theta_mean,'UniformOutput',false));
Alpha = cell2mat(cellfun(@(x) mean(x,[1,2]),Resting_EEG_summary.Alpha_mean,'UniformOutput',false));
Beta = cell2mat(cellfun(@(x) mean(x,[1,2]),Resting_EEG_summary.Beta_mean,'UniformOutput',false));

figure
subplot(2,2,1)
histfit(Delta)
title('Delta')

subplot(2,2,2)
histfit(Theta)
title('Theta')

subplot(2,2,3)
histfit(Alpha)
title('Alpha')

subplot(2,2,4)
histfit(Beta)
title('Beta')

figure
corrplot([Delta,Theta,Alpha,Beta])

figure
corrplot([Resting_EEG_summary.HbFgdl_venous,Delta,Theta,Alpha,Beta])

% Let look some topplot 
figure
topoplot(mean(Resting_EEG_summary.Theta_mean{1},2),Channel_Loc,'electrodes','labels');


%% Figure 9: Peaks in fooof model

% Hist fit plot the centre frquency 

Resting_EEG_summary.All_peaks = cellfun(@(x) x(1),Resting_EEG_summary.Peaks);
Resting_EEG_summary.All_peaks_a = cellfun(@(x) x(2),Resting_EEG_summary.Peaks);
Resting_EEG_summary.All_exp = All_exp;


figure
a = subplot(2,2,1)
histfit(Resting_EEG_summary.All_peaks);

% Hist fit plot the amplitude
b = subplot(2,2,2)
histfit(Resting_EEG_summary.All_peaks_a);

c = subplot(2,2,3)
histfit(Resting_EEG_summary.All_peaks);

% Hist fit plot the amplitude
d = subplot(2,2,4)
histfit(Resting_EEG_summary.All_peaks_a);

linkaxes([a,c],'x')

linkaxes([b,d],'x')

%% Figure 10: Sperate the midline to two groups based on central peak frequency 6 hz 

Midline  = Resting_EEG_summary(strcmpi(Resting_EEG_summary.trial_stage,'M'),:);
Endline  = Resting_EEG_summary(strcmpi(Resting_EEG_summary.trial_stage,'E'),:);

Midline_A_6 = Midline(Midline.All_peaks>=6,:);
Midline_B_6 = Midline(Midline.All_peaks<6,:);

F_W = mean(cat(3,Midline_A_6.Freq_Timewind{:}),3);

figure
subplot(2,2,1)
topoplot(mean(F_W(:,Par.theta),2),Midline.chanlocs{1},'maplimits',[0 2])
title('Theta')
colorbar
subplot(2,2,2)
topoplot(mean(F_W(:,Par.alpha),2),Midline.chanlocs{1},'maplimits',[0 1])
title('Alpha')
colorbar

subplot(2,2,3)
topoplot(mean(F_W(:,Par.theta),2),Midline.chanlocs{1},'maplimits',[0 2])
title('Theta')
colorbar

subplot(2,2,4)
topoplot(mean(F_W(:,Par.alpha),2),Midline.chanlocs{1},'maplimits',[0 1])
title('Alpha')
colorbar

figure
histfit(All_peaks_a(find(All_peaks>6)));

figure
histfit(All_peaks_a(find(All_peaks<=6)));


%% Figure 11: Fooof results Backgroud 

figure
subplot(2,1,1)
histfit(Resting_EEG_summary.slope_fixed);
title('Slope')

subplot(2,1,2)
histfit(Resting_EEG_summary.offset_fixed);
title('offset')

figure
subplot(2,1,1)
histfit(Midline.slope_fixed);
title('Slope')

subplot(2,1,2)
histfit(Midline.offset_fixed);
title('offset')

figure
subplot(2,1,1)
histfit(Endline.slope_fixed);
title('Slope')

subplot(2,1,2)
histfit(Endline.offset_fixed);
title('offset')

%% Figure 12: Box plot compare the peaks between midline and endline in theta and alphain central frequency and amplitude 

figure
notBoxPlot(cellfun(@(x) x(1), Midline.Peaks_Theta),1 );
hold on
notBoxPlot(cellfun(@(x) x(1), Endline.Peaks_Theta),2 );
 
figure
notBoxPlot(cellfun(@(x) x(2), Midline.Peaks_Theta),1 );
hold on
notBoxPlot(cellfun(@(x) x(2), Endline.Peaks_Theta),2 );
 
figure
notBoxPlot(cellfun(@(x) x(1), Midline.Peaks_Alpha),1 );
hold on
notBoxPlot(cellfun(@(x) x(1), Endline.Peaks_Alpha),2 );
 
figure
notBoxPlot(cellfun(@(x) x(2), Midline.Peaks_Alpha),1 );
hold on
notBoxPlot(cellfun(@(x) x(2), Endline.Peaks_Alpha),2 );


% For thoes who share the both stages 

[x,ia,ib] = intersect(Midline.subjectid,Endline.subjectid);

figure
corrplot([cellfun(@(x) x(1), Midline.Peaks_Theta),cellfun(@(x) x(1), Midline.Peaks_Alpha),Midline.CogCS,Midline.LangSumCS])

% for endline alpha more correlated with cognitive functioning 

figure
corrplot([cellfun(@(x) x(1), Endline.Peaks_Theta),cellfun(@(x) x(1), Endline.Peaks_Alpha),Endline.CogCS,Endline.LangSumCS])

%% Figure 13: Corr plot between flatten mean power and outcome measures 

% Mainly between barly cognitive scores [44 45 46 47] [7 8 9]


figure
corrplot(Midline(:,[44 45 46 47 7 8 9]))

figure
corrplot(Endline(:,[44 45 46 47 7 8 9]))

figure
corrplot(Resting_EEG(:,[51 52 53 54 15 16 17]),'testR','on','varNames',{'delta','theta','alpha','beta','cog','lang','mot'})

figure
corrplot([Resting_EEG.flat_delta,Resting_EEG.flat_theta,Resting_EEG.flat_alpha,Resting_EEG.flat_beta, Resting_EEG.CogCS.*Resting_EEG.Age_days, Resting_EEG.LangSumCS.*Resting_EEG.Age_days,...
    Resting_EEG.MotSumCS.*Resting_EEG.Age_days],'testR','on','varNames',{'delta','theta','alpha','beta','cog*','lang*','mot*'})


figure
corrplot([cellfun(@(x) nanmean(x(:,1)),Resting_EEG.Peaks_Theta),cellfun(@(x) nanmean(x(:,2)),Resting_EEG.Peaks_Theta),cellfun(@(x) nanmean(x(:,1)),Resting_EEG.Peaks_Alpha),cellfun(@(x) nanmean(x(:,2)),Resting_EEG.Peaks_Alpha), Resting_EEG.CogCS.*Resting_EEG.Age_days, Resting_EEG.LangSumCS.*Resting_EEG.Age_days,...
    Resting_EEG.MotSumCS.*Resting_EEG.Age_days],'testR','on','varNames',{'tFreq','tAmp','aFreq','aAmp','cog*','lang*','mot*'})

figure
corrplot([cellfun(@(x) nanmean(x(:,1)),Resting_EEG.Peaks_Theta),cellfun(@(x) nanmean(x(:,2)),Resting_EEG.Peaks_Theta),cellfun(@(x) nanmean(x(:,1)),Resting_EEG.Peaks_Alpha),cellfun(@(x) nanmean(x(:,2)),Resting_EEG.Peaks_Alpha), Resting_EEG.CogCS, Resting_EEG.LangSumCS,...
    Resting_EEG.MotSumCS],'testR','on','varNames',{'tFreq','tAmp','aFreq','aAmp','cog','lang','mot'})

%% Figure 14: Topoplot for flatten mean power

% For All subject
figure
sgtitle('All subject')
subplot(1,4,1)
title('Delta')
topoplot(trimmean(cat(1,Resting_EEG_summary.flat_delta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,2)
title('Theta')
topoplot(trimmean(cat(1,Resting_EEG_summary.flat_theta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,3)
title('Alpha')
topoplot(trimmean(cat(1,Resting_EEG_summary.flat_alpha_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,4)
title('Beta')
topoplot(trimmean(cat(1,Resting_EEG_summary.flat_beta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar


% For midline
figure
sgtitle('Midline')
subplot(1,4,1)
title('Delta')
topoplot(trimmean(cat(1,Midline.flat_delta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,2)
title('Theta')
topoplot(trimmean(cat(1,Midline.flat_theta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,3)
title('Alpha')
topoplot(trimmean(cat(1,Midline.flat_alpha_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,4)
title('Beta')
topoplot(trimmean(cat(1,Midline.flat_beta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar

% For Endline 
figure
sgtitle('Endline')
subplot(1,4,1)
title('Delta')
topoplot(trimmean(cat(1,Endline.flat_delta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,2)
title('Theta')
topoplot(trimmean(cat(1,Endline.flat_theta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,3)
title('Alpha')
topoplot(trimmean(cat(1,Endline.flat_alpha_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar
subplot(1,4,4)
title('Beta')
topoplot(trimmean(cat(1,Endline.flat_beta_all{:}),10,1),Resting_EEG.chanlocs{1},'maplimits',[0 0.2]);
colorbar

%% Figure 15: Topoplot for mean power spectrum without flatten

% For all subject
figure
sgtitle('All subject')
subplot(1,4,1)
title('Delta')
topoplot(trimmean(cat(1,Resting_EEG_summary.delta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,2)
title('Theta')
topoplot(trimmean(cat(1,Resting_EEG_summary.theta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,3)
title('Alpha')
topoplot(trimmean(cat(1,Resting_EEG_summary.alpha_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,4)
title('Beta')
topoplot(trimmean(cat(1,Resting_EEG_summary.beta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar

% For midline
figure
sgtitle('Midline')
subplot(1,4,1)
title('Delta')
topoplot(trimmean(cat(1,Midline.delta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,2)
title('Theta')
topoplot(trimmean(cat(1,Midline.theta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,3)
title('Alpha')
topoplot(trimmean(cat(1,Midline.alpha_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,4)
title('Beta')
topoplot(trimmean(cat(1,Midline.theta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar

% For endline 
figure
sgtitle('Endline')
subplot(1,4,1)
title('Delta')
topoplot(trimmean(cat(1,Endline.delta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,2)
title('Theta')
topoplot(trimmean(cat(1,Endline.theta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,3)
title('Alpha')
topoplot(trimmean(cat(1,Endline.alpha_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar
subplot(1,4,4)
title('Beta')
topoplot(trimmean(cat(1,Endline.theta_all{:}),10,1),Resting_EEG.chanlocs{1});
colorbar

%% Figure 16: Topoplot for background parameter in fooof 

% For Slope
figure
topoplot(trimmean(cat(1,Resting_EEG_summary.slope{:}),10,1),Resting_EEG.chanlocs{1})

figure
topoplot(trimmean(cat(1,Midline.slope{:}),10,1),Resting_EEG.chanlocs{1});

figure
topoplot(trimmean(cat(1,Endline.slope{:}),10,1),Resting_EEG.chanlocs{1});

% For offset 
figure
topoplot(trimmean(cat(1,Resting_EEG_summary.offset{:}),10,1),Resting_EEG.chanlocs{1})

figure
topoplot(trimmean(cat(1,Midline.offset{:}),10,1),Resting_EEG.chanlocs{1});

figure
topoplot(trimmean(cat(1,Endline.offset{:}),10,1),Resting_EEG.chanlocs{1});

%% Figure 17: MVPA correlation analysis 

% Get if have empty outcome measures

% Set the eeg_sorted_cond

eeg = cellfun(@(x) mean(x(1:30,3:61,:),3)',Resting_EEG_summary.Freq_Timewind,'UniformOutput',false);

eeg_sorted_cond = {cat(3,eeg{:})};

save('C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\MVPA_Analysis\eeg_sorted_cond','eeg_sorted_cond');

% Set the SVR_labels ready

SVR_labels = {cat(1,End.LangSumCS(:))};

save('C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\MVPA_Analysis\eeg_sorted_cond_regress_sorted_cond','SVR_labels'); 

% Run Decoding analysis will generate time - chance plot

run('C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\MVPA_Analysis\run_decoding_analyses')

