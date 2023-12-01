%% BRISC_oddball_postprocessing_step6.m

% Calculate the mean ERP of all epoches for pre-defined channel number and
% Add outcome measures for infants datasets
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


clear all
close all
clc
% Load ERP summary table
load('ERP.mat')
Oddball_ERP_summary = ERP;

%% Setting parameters

% Channel of interest 9 frontal channels
Par.channel_index = [2 3 27 7 26 6 25 4 28];

% Path for outcome measurement .csv
Par.Outcome_Path = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Project_BRISC_Erp\3. Data_Analysis_and_Reporting_12MAR2020\5. Output\Data_ERP.csv';

% Set thresholding datasets 
Par.num_threshold = 30;

%% Spliting epoches into different conditions and thresholding them 

% Set 30 repetition number as threshold 
% Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) length(find(x == 1))>=Par.num_threshold,Oddball_ERP_summary.repetitionNo) & cellfun(@(x) length(find(x == 2))~=0,Oddball_ERP_summary.repetitionNo),:);

% Set aside a back of removed datasets
Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) length(find(x == 1))< Par.num_threshold,Oddball_ERP_summary.repetitionNo) | cellfun(@(x) length(find(x == 2))==0,Oddball_ERP_summary.repetitionNo),:);
Oddball_ERP_summary = Oddball_ERP_summary(cellfun(@(x) length(find(x == 2))~=0,Oddball_ERP_summary.repetitionNo),:);


for datasetNo = 1:size(Oddball_ERP_summary,1)
    
    repNumbers = Oddball_ERP_summary.repetitionNo{datasetNo};
    
    for repetitionNo = 1:10
        
        % Input all repetition number dataset into ERP
        eval(['Oddball_ERP_summary.repetition_',num2str(repetitionNo),'{datasetNo}','=','Oddball_ERP_summary.data{datasetNo}(:, :, repNumbers == repetitionNo);']);
        
        
    end
    
end


%% Calculate the mean ERP of all epoches for pre-defined channel number

for datasetNo = 1:size(Oddball_ERP_summary,1)
        
 
    for repetitionNo = 1:10
        
        eval(['Oddball_ERP_summary.mean_ERP_repetition_',num2str(repetitionNo),'(datasetNo)','=','{mean(mean(Oddball_ERP_summary.repetition_',num2str(repetitionNo),'{datasetNo}(Par.channel_index,:,:),[1 3]),1)};']);
        
        eval(['Oddball_ERP_summary.mean_ERP_repetition_allChan_',num2str(repetitionNo),'(datasetNo)','=','{mean(Oddball_ERP_summary.repetition_',num2str(repetitionNo),'{datasetNo}(:,:,:),3)};']);
    end
    
    Oddball_ERP_summary.mean_ERP_standard(datasetNo) = {mean(cat(1,Oddball_ERP_summary.mean_ERP_repetition_4{datasetNo},...
        Oddball_ERP_summary.mean_ERP_repetition_5{datasetNo},Oddball_ERP_summary.mean_ERP_repetition_6{datasetNo},...
        Oddball_ERP_summary.mean_ERP_repetition_7{datasetNo},Oddball_ERP_summary.mean_ERP_repetition_8{datasetNo},...
        Oddball_ERP_summary.mean_ERP_repetition_9{datasetNo},Oddball_ERP_summary.mean_ERP_repetition_10{datasetNo}),1)};
    %Oddball_ERP_summary.mean_ERP_repetition_3{datasetNo}
    Oddball_ERP_summary.mean_ERP_allchan_standard(datasetNo) = {mean(cat(3,Oddball_ERP_summary.mean_ERP_repetition_allChan_4{datasetNo},...
        Oddball_ERP_summary.mean_ERP_repetition_allChan_5{datasetNo},Oddball_ERP_summary.mean_ERP_repetition_allChan_6{datasetNo},...
        Oddball_ERP_summary.mean_ERP_repetition_allChan_7{datasetNo},Oddball_ERP_summary.mean_ERP_repetition_allChan_8{datasetNo},...
        Oddball_ERP_summary.mean_ERP_repetition_allChan_9{datasetNo},Oddball_ERP_summary.mean_ERP_repetition_allChan_10{datasetNo}),3)};
    
    
    Oddball_ERP_summary.mean_MMN(datasetNo) = {Oddball_ERP_summary.mean_ERP_repetition_1{datasetNo} - Oddball_ERP_summary.mean_ERP_standard{datasetNo}};
    
    Oddball_ERP_summary.mean_MMN_allChan(datasetNo) = {Oddball_ERP_summary.mean_ERP_repetition_allChan_1{datasetNo} - Oddball_ERP_summary.mean_ERP_allchan_standard{datasetNo}};
    
end

% Create different wave between different rep num to deviant (1)
for rep_com = 4:10
    
    outputsetting = {'UniformOutput'};
    
    eval(['Oddball_ERP_summary.diff_wave_1_vs_',num2str(rep_com), ...
        '= cellfun(@minus, Oddball_ERP_summary.mean_ERP_repetition_1,Oddball_ERP_summary.mean_ERP_repetition_',...
        num2str(rep_com),',outputsetting{1},false);']);
    
end

%% Register the deviant response after different reptition num

for index = 1:size(Oddball_ERP_summary,1)
    
    % Deviant response could follow 4,5,6,7,8,9,10
    
    holder10_1 = [];
    counter10_1 = 1;
    holder9_1 = [];
    counter9_1 = 1;
    holder8_1 = [];
    counter8_1 = 1;
    holder7_1 = [];
    counter7_1 = 1;
    holder6_1 = [];
    counter6_1 = 1;
    holder5_1 = [];
    counter5_1 = 1;
    holder4_1 = [];
    counter4_1 = 1;
    
    ind = find(Oddball_ERP_summary.repetitionNo{index} == 1)-1;
    
    ind = nonzeros(ind)';
    
    for id = 1:length(ind)
        
        
        switch Oddball_ERP_summary.repetitionNo{index}(ind(id))
            
            
            case 10
                holder10_1(:,:,counter10_1) = Oddball_ERP_summary.data{index}(:,:,ind(id)+1);
                counter10_1 = counter10_1+1;
            case 9
                holder9_1(:,:,counter9_1) = Oddball_ERP_summary.data{index}(:,:,ind(id)+1);
                counter9_1 = counter9_1+1;
            case 8
                holder8_1(:,:,counter8_1) = Oddball_ERP_summary.data{index}(:,:,ind(id)+1);
                counter8_1 = counter8_1+1;
            case 7
                holder7_1(:,:,counter7_1) =Oddball_ERP_summary.data{index}(:,:,ind(id)+1);
                counter7_1 = counter7_1+1;
            case 6
                holder6_1(:,:,counter6_1) = Oddball_ERP_summary.data{index}(:,:,ind(id)+1);
                counter6_1 = counter6_1+1;
            case 5
                holder5_1(:,:,counter5_1) = Oddball_ERP_summary.data{index}(:,:,ind(id)+1);
                counter5_1 = counter5_1+1;
            case 4
                holder4_1(:,:,counter4_1) = Oddball_ERP_summary.data{index}(:,:,ind(id)+1);
                counter4_1 = counter4_1+1;
                
        end
        
    end
    
    
    Oddball_ERP_summary.rep10_1{index} = mean(holder10_1,3);
    Oddball_ERP_summary.rep9_1{index} = mean(holder9_1,3);
    Oddball_ERP_summary.rep8_1{index} = mean(holder8_1,3);
    Oddball_ERP_summary.rep7_1{index} = mean(holder7_1,3);
    Oddball_ERP_summary.rep6_1{index} = mean(holder6_1,3);
    Oddball_ERP_summary.rep5_1{index} = mean(holder5_1,3);
    Oddball_ERP_summary.rep4_1{index} = mean(holder4_1,3);
    
    
    
    
end

%% Add outcome measures for midline baseline and endline

Outcome = readtable(Par.Outcome_Path);

% 8:41 all variables

size_L = size(Oddball_ERP_summary,2)+1;

for index = 1:size(Oddball_ERP_summary,1)
    
    id = find(strcmp(Oddball_ERP_summary.subject{index},Outcome.PID) & strcmp('3',Outcome.Rnd));
    
%     id_base = find(strcmp(Oddball_ERP_summary.subject{index},Outcome.PID) & strcmp('1',Outcome.Rnd));
%     
%     id_end = find(strcmp(Oddball_ERP_summary.subject{index},Outcome.PID) & strcmp('3',Outcome.Rnd));
%     
    
    Oddball_ERP_summary(index,size_L:size_L+33) = Outcome(id,8:41);
    
%     Oddball_ERP_summary(index,size_L+34:size_L+67) = Outcome(id_base,8:41);
%     
%     %     Oddball_ERP_summary(index,size_L+68:size_L+101) = Outcome(id_end,8:41);
    
    
end

Variable_name = Outcome.Properties.VariableNames(8:41);

% for index = 1:34
%     
%     Variable_name_base{index} =   append(Variable_name{index} ,'_base');
%     
%     Variable_name_diff{index} =   append(Variable_name{index} ,'_diff');
%     
% end

% Add variables names
Oddball_ERP_summary.Properties.VariableNames(size_L:size_L+33) = Variable_name;

% Oddball_ERP_summary.Properties.VariableNames(size_L+34:size_L+67) = Variable_name_base;

%Convert to mat
Variables = [Variable_name([1,3:34])];

for name_id = 1:length(Variables)
    
    eval(join(['Oddball_ERP_summary.',Variables{name_id},'= cellfun(@(x) str2double(x),Oddball_ERP_summary.',Variables{name_id},",'UniformOutput',false);"],''))
    
    eval(join(['Oddball_ERP_summary.',Variables{name_id},' = cell2mat(Oddball_ERP_summary.',Variables{name_id},');'],''))
    
    
end

%% Save the variable

% save('Oddball_ERP_summary.mat','Oddball_ERP_summary', '-v7.3');