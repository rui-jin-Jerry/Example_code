%% BRISC_oddball_visualization_step8.m

% Different ploting methods  

clc
clear all
close all

% Load ERP summary table 
load('Oddball_ERP_summary.mat')

%% Setting parameters 

% Channel of interest 
Par.channel_index = [2 3 27 7 26 6 25 4 28];


%% Figure 1, For different repetition num average for all subject

% X: timsstampe [-100 400] ms
% Y: Average ERP of all epoches for channels of interest for reptition from 1 3:10


figure
setcolor = @(h, newcolor) set(h, 'Color', newcolor);
title('Average ERP for all epoches of all reps');
hold on

% set to trimmean if needed 
for rep = [1 3:10]
eval(['currentplot = plot(-100:2:399,nanmean(cat(1,Oddball_ERP_summary.mean_ERP_repetition_',num2str(rep),'{:}),1));'])

eval('setcolor(currentplot,[ 1 0 0]);')

hold on

pause(1)

end


%% Figure 2, For deviant (1) and standard repeition (3:10) num average for all subject 

% X: timsstampe [-100 400] ms
% Y: Average ERP of all epoches for channels of interest for reptition 1 and average of 3:10
% The solid line is mean, and shaded area is standard error for different subjects

figure
set(gca,'fontname','times')
set(gca,'fontsize',20)
% title('Average ERP for all epoches of deviant and standard');
hold on
p1 = plot(-100:2:399,nanmean(cat(1,Oddball_ERP_summary.mean_ERP_repetition_1{:}),1),'k');

hold on 

% stdshade(cat(1,Oddball_ERP_summary.mean_ERP_repetition_1{:}),0.2,'b',-100:2:399)

p2 = plot(-100:2:399,nanmean(cat(1,Oddball_ERP_summary.mean_ERP_standard{:}),1),'r');

% stdshade(cat(1,Oddball_ERP_summary.mean_ERP_standard{:}),0.2,'r',-100:2:399)



refline([ 0 0 ])

xlabel('Latency (ms)')
ylabel('Amplitude (uV)')


legend([p1,p2],{'Deviant','Standard'})
legend('boxoff')
legend('Location','northwest')

%% Figure 3, For mean MMN average for all subject 

% X: timsstampe [-100 400] ms
% Y: Average MMN (Deviant 1 - Standard 3:10) of all epoches for channels of interest for reptition 1 and average of 3:10
% The solid line is mean, and shaded area is standard deviation for different subjects

figure 

title ('Average MMN for all subjects');
hold on 

plot(-100:2:399,nanmean(cat(1,Oddball_ERP_summary.mean_MMN{:}),1),'k');

hold on 

stdshade(cat(1,Oddball_ERP_summary.mean_MMN{:}),0.2,'b',-100:2:399)

refline([ 0 0 ])


%% Figure 4, Topoplotss for the visualization of where and how the response happends individual subject

% For single subject
subject_index = 6;

figure

for timewindow = 1:10

topoplot(mean(mean(Oddball_ERP_summary.repetition_1{subject_index}(:,[((25*(timewindow-1))+1):25*(timewindow)],:),2),3),Oddball_ERP_summary.chanlocs{6});
hold on 

pause(1)

end

figure

for timewindow = 1:10

subplot(2,5,timewindow);
   
title(['timewindow  ',num2str(50*(timewindow-1)-100),':',num2str(50*(timewindow)-100)])
topoplot(mean(mean(Oddball_ERP_summary.repetition_1{subject_index}(:,[((25*(timewindow-1))+1):25*(timewindow)],:),2),3),...
    Oddball_ERP_summary.chanlocs{27},'electrodes','labels');
hold on 

pause(1)

end


%% Figure 5, Topoplots for Deviant repetition (1) across different time windows

% subplots: 10 different timewindows (-100:50:400) relative to stimuli presentation
% colorbar: indicate the high and lower ERP response 
% label: indicate the channel name and location

% Get the min and max value to unify axis later 

% Set repetition number to 1 deviant response 
rep = 1;

ERP_Allchan = [];

for subject = 1:size(Oddball_ERP_summary,1)
    
    try
    eval(['ERP_Allchan = cat(3,ERP_Allchan,Oddball_ERP_summary.mean_ERP_repetition_allChan_',...
        num2str(rep),'{subject});']);
    catch
        fprintf(['Error channel number: ',Oddball_ERP_summary.subjectid{subject},'\n'])
    end
    
end
    
figure
sgtitle('Repetition 1 deviant mean ERP topoplots over -100 to 400ms')
for timewindow = 1:10

subplot(2,5,timewindow);
   
title(['timewindow  ',num2str(50*(timewindow-1)-100),':',num2str(50*(timewindow)-100)])
topoplot_decoding(nanmean(ERP_Allchan(:,[((25*(timewindow-1))+1):25*(timewindow)],:),[2 3]),Oddball_ERP_summary.chanlocs{1},...
    'maplimits',[min(nanmean(ERP_Allchan,3),[],'all') max(nanmean(ERP_Allchan,3),[],'all')],'electrodes','labels');

hold on 
colorbar
pause(0.5)

end



%% Figure 6, Topoplots for Standard repetition (3:10) across different time windows

% subplots: 10 different timewindows (-100:50:400) relative to stimuli presentation
% colorbar: indicate the high and lower ERP response 
% label: indicate the channel name and location
% Get the min and max value to unify axis later 

% Set repetition number to 3:10 standard responses
rep = 4:10;

ERP_Allchan_S = [];

for subject = 1:size(Oddball_ERP_summary,1)
    
    try
    ERP_Allchan_S = cat(3,ERP_Allchan_S,Oddball_ERP_summary.mean_ERP_allchan_standard{subject});
    catch
        fprintf(['Error channel number: ',Oddball_ERP_summary.subjectid{subject},'\n'])
    end
    
end

figure
sgtitle('Repetition 3:10 standard mean ERP topoplots over -100 to 400ms')

for timewindow = 1:10

subplot(2,5,timewindow);
   
title(['timewindow  ',num2str(50*(timewindow-1)-100),':',num2str(50*(timewindow)-100)])
topoplot(nanmean(ERP_Allchan_S(:,[((25*(timewindow-1))+1):25*(timewindow)],:),[2 3]),Oddball_ERP_summary.chanlocs{1},...
    'maplimits',[min(nanmean(ERP_Allchan,3),[],'all') 2],'electrodes','labels');

hold on 
colorbar
pause(0.5)

end

%% Figure 7, Topoplots for MMN all chan (deviant - standerd) across different time windows

% subplots: 10 different timewindows (-100:50:400) relative to stimuli presentation
% colorbar: indicate the high and lower MMN response 
% label: indicate the channel name and location
% Get the min and max value to unify axis later 

% Set repetition number to 3:10 standard responses
rep = 4:10;

ERP_Allchan_MMN = [];

for subject = 1:size(Oddball_ERP_summary,1)
    
    try
    ERP_Allchan_MMN = cat(3,ERP_Allchan_MMN,Oddball_ERP_summary.mean_MMN_allChan{subject});
    catch
        fprintf(['Error channel number: ',Oddball_ERP_summary.subjectid{subject},'\n'])
    end
    
end

figure
sgtitle('Mean MMN topoplots over -100 to 400ms')

for timewindow = 1:10

subplot(2,5,timewindow);
   
title(['timewindow  ',num2str(50*(timewindow-1)-100),':',num2str(50*(timewindow)-100)])
topoplot(nanmean(ERP_Allchan_MMN(:,[((25*(timewindow-1))+1):25*(timewindow)],:),[2 3]),Oddball_ERP_summary.chanlocs{1},...
    'maplimits',[min(nanmean(ERP_Allchan_MMN,3),[],'all') max(nanmean(ERP_Allchan_MMN,3),[],'all')],'electrodes','labels');

hold on 
colorbar
pause(0.5)

end

% Sub figure plot of interest time window 
figure
set(gca,'fontname','times')
set(gca,'fontsize',20)
title(['Timewindow  ','200-400 ms'])
topoplot(nanmean(ERP_Allchan_MMN(:,[150:250],:),[2 3]),Oddball_ERP_summary.chanlocs{1},...
   'electrodes','labels');

hold on 
colorbar

%% Figure 8, Mean MMN applitutude for different repetition numbers 

% Y: Mean amplitude for MMN between certain period 
% X: Repetition number 3-10 for MMN 

all_subject = [];

for rep = 4:10
    
eval(['diff_wave = nanmean(cat(1,Oddball_ERP_summary.diff_wave_1_vs_',num2str(rep),'{:}),1);'])    
    
all_subject = [all_subject; diff_wave(100:150)];

end


figure

errorbar(4:10,nanmean(all_subject,2),nanstd(all_subject,0,2))

refline([ 0 0 ])



%% Figure 9, Mean amplitude for Deviants response after different repetition numbers 

% Y: Mean amplitude for Deviant response between certain period (100ms-200ms post stimuli)
% X: Repetition number 4-10 before the Deviant response

mean_rep = [];
ste_rep = [];


for i = 4:10%[10,9,8,7,6,5,4]
    
    eval(join(['A = cellfun(@(x) nanmean(x,3),Oddball_ERP_summary.rep',num2str(i),'_1,',"'UniformOutput',false);"],''))
    
   A = cat(3,A{:}); 
    
   A = nanmean(A(Par.channel_index,95:105,:),[1 2]);

   mean_rep(end+1)  = nanmean(A);  
   
   ste_rep(end+1)  = nanstd(A)/sqrt(length(A));   
   
end
   
figure
T = errorbar(mean_rep, ste_rep);

T.XData= [4:10];

title('Devaint response 90-110ms after x number of repetition') 
%% Figure 10, Mean amplitude for Deviants response after different repetition numbers in box_plot

% Y: Mean amplitude for Deviant response between certain period (100ms-200ms post stimuli)
% X: Repetition number 4-10 before the Deviant response


figure
for i = 4:10%[10,9,8,7,6,5,4]
    
    eval(join(['A = cellfun(@(x) nanmean(x,3),Oddball_ERP_summary.rep',num2str(i),'_1,',"'UniformOutput',false);"],''))
    
   A = cat(3,A{:}); 
    
   A = nanmean(A(Par.channel_index,150:250,:),[1 2]);
   
   notBoxPlot(squeeze(A),i)
   
   hold on
 
end
   

%% Figure 11, Find N2 negative peak 


N2_peaks = cellfun(@(x) min(x(125:150)),Oddball_ERP_summary.mean_MMN);

figure
notBoxPlot(N2_peaks,1);

figure
histfit(N2_peaks)


%% Figure 12, Find the difference between baseline and midline in outcome measures via histgram

% For distribution of difference between baseline and midline outcome measures

for index  = 3:34
    
 
      eval(join(['Oddball_ERP_summary.',Variable_name_diff{index},'=', 'Oddball_ERP_summary.',Variable_name{index},'-','Oddball_ERP_summary.',Variable_name_base{index},';'],''))
    

end

histfit(Oddball_ERP_summary.CogCS_diff);



%% Figure 13, Heat map for mass_univarite_analysis

% X: Timepoints 1:250 for -100 to 400ms
% Y: EEG Channels 
% Heat: For ttest results p value 

rep_1 = cellfun(@(x) mean(x(1:30,:,:),3),Oddball_ERP_summary.repetition_1,'UniformOutput',false);
rep_1 = cat(3,rep_1{:});


rep_s = cellfun(@(x) mean(x(1:30,:,:),3),Oddball_ERP_summary.repetition_6,'UniformOutput',false);
rep_s = cat(3,rep_s{:});


ttest_results_h = [];
ttest_results_p = [];


for channel = 1:30
    
    for timepoint = 1:250
        
    [h ,p ]= ttest(rep_1(channel,timepoint,:),rep_s(channel,timepoint,:),'Alpha',0.0005);    
        
    ttest_results_h(channel,timepoint) = h;  
    ttest_results_p(channel,timepoint) = p;  
        
    end
    
    
end


figure
imagesc(ttest_results_p);
colorbar


%% Figure 14, Set up for MVPA oddball support correlation 

% Set up variables for MVPA analysis 

% Set the eeg_sorted_cond (EEG Signal)

eeg = cellfun(@(x) mean(x(1:30,1:250,:),3)',Oddball_ERP_summary.mean_MMN_allChan,'UniformOutput',false);

eeg_sorted_cond = {cat(3,eeg{:})};

save('C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\MVPA_Analysis\eeg_sorted_cond','eeg_sorted_cond');

% Set the SVR_labels ready (Outcome measures)

SVR_labels = {cat(1,Oddball_ERP_summary.CogCS(:))};

save('C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\MVPA_Analysis\eeg_sorted_cond_regress_sorted_cond','SVR_labels');

% Run Decoding analysis will generate time - chance plot

run('C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\MVPA_Analysis\run_decoding_analyses')

%% Figure 15, Corr plot for P3 and Outcome measurements

figure

corrplot([cellfun(@(x) mean(x(150:250)),Oddball_ERP_summary.mean_ERP_repetition_1),...
    cellfun(@(x) mean(x(150:250)),Oddball_ERP_summary.mean_ERP_standard),cellfun(@(x) mean(x(150:250)),Oddball_ERP_summary.mean_MMN)...
    Oddball_ERP_summary.CogCS,Oddball_ERP_summary.LangSumCS,Oddball_ERP_summary.MotSumCS],'testR','on','varNames',{'rep1','stand','MMN','cog','lang','mot'})

%

figure

corrplot([cellfun(@(x) mean(x(150:250)),Oddball_ERP_summary.mean_ERP_repetition_1),...
    cellfun(@(x) mean(x(150:250)),Oddball_ERP_summary.mean_ERP_standard),cellfun(@(x) mean(x(150:250)),Oddball_ERP_summary.mean_MMN)...
    Oddball_ERP_summary.CogCS.*Oddball_ERP_summary.Age_days,Oddball_ERP_summary.LangSumCS.*Oddball_ERP_summary.Age_days,Oddball_ERP_summary.MotSumCS.*Oddball_ERP_summary.Age_days],'testR','on','varNames',{'rep1','stand','MMN','cog*','lang*','mot*'})



