%% BRISC_resting_postprocessing_step6.m

% Run short_term_fft on summary table for resting datasets. To be used with the
% BRISC EEG datasets. Relevant data processing parameters are set at the
% beginning of the script (in the Settings/Parameters section). Fooof
% modeling and add outcome measures
%
%
% First version written by Rui Jin (Jerry), 11/19 at the Peter doherty institute | University of Melbourne
%

%% Set parameters

Par.Outcome_Path = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Desktop\Project_BRISC_Erp\3. Data_Analysis_and_Reporting_12MAR2020\5. Output\Data_ERP.csv';

% Enter pre-defined range for different band
Par.delta = [1:5];
Par.theta = [6:12];
Par.alpha = [13:17];
Par.beta = [18:59];


%% Load variables

load('Resting_EEG_summary');

% Set a copy
Resting_EEG = Resting_EEG_summary;

%% Add outcome measures

Outcome = readtable(Par.Outcome_Path);

for index = 1:size(Resting_EEG,1)
    
    id = find(strcmp(Resting_EEG.subjectid{index},Outcome.PID) & strcmp('3',Outcome.Rnd));
    
    
    Resting_EEG(index,6:39) = Outcome(id,8:41);
    
end

% Add variables names
Resting_EEG.Properties.VariableNames(6:39) = Outcome.Properties.VariableNames(8:41);

%Convert to mat
Variable_name = Resting_EEG.Properties.VariableNames([6,8:39]);

for name_id = 1:length(Variable_name)
    
    eval(join(['Resting_EEG.',Variable_name{name_id},'= cellfun(@(x) str2double(x),Resting_EEG.',Variable_name{name_id},",'UniformOutput',false);"],''))
    
    eval(join(['Resting_EEG.',Variable_name{name_id},' = cell2mat(Resting_EEG.',Variable_name{name_id},');'],''))
    
    
end

%% Fooof modeling knee setting outcome

%settings.max_n_peaks = 1;
settings.background_mode = 'knee';
f_range = [1, 30];
freqs = linspace(1,30,59);
Resting_EEG.fooof_results{1} = struct();


for subjectid = 1:size(Resting_EEG,1)
    %3:61
    
    for channelid = 1:30 
        try
            subject_results = fooof(freqs, nanmean(Resting_EEG.Freq_Timewind{subjectid}(channelid,:,:),3),...
                f_range, settings,1);
            
            
            Resting_EEG.fooof_results{subjectid}(channelid).background_params= subject_results.background_params;
            Resting_EEG.fooof_results{subjectid}(channelid).peak_params= subject_results.peak_params;
            Resting_EEG.fooof_results{subjectid}(channelid).gaussian_params= subject_results.gaussian_params;
            Resting_EEG.fooof_results{subjectid}(channelid).error= subject_results.error;
            Resting_EEG.fooof_results{subjectid}(channelid).r_squared= subject_results.r_squared;
            Resting_EEG.fooof_results{subjectid}(channelid).fooofed_spectrum= 10.^subject_results.fooofed_spectrum;
            Resting_EEG.fooof_results{subjectid}(channelid).power_spectrum= 10.^subject_results.power_spectrum;
            Resting_EEG.fooof_results{subjectid}(channelid).bg_fit= 10.^subject_results.bg_fit;
            
            for index_peaks = 1:size(subject_results.peak_params,1);
            
            L1 = [freqs;10.^subject_results.power_spectrum];
            L2 = [freqs;10.^subject_results.bg_fit];
            L3 = [subject_results.peak_params(index_peaks,1),subject_results.peak_params(index_peaks,1),subject_results.peak_params(index_peaks,1);...
                0,1,50];
            
            Dis = InterX(L1,L3)-InterX(L2,L3);
            
            subject_results.peak_params(index_peaks,2) = Dis(2);
            
            end
            
        catch
            Resting_EEG.fooof_results{subjectid}(channelid).background_params= [];
            Resting_EEG.fooof_results{subjectid}(channelid).peak_params= [];
            Resting_EEG.fooof_results{subjectid}(channelid).gaussian_params= [];
            Resting_EEG.fooof_results{subjectid}(channelid).error= [];
            Resting_EEG.fooof_results{subjectid}(channelid).r_squared= [];
            Resting_EEG.fooof_results{subjectid}(channelid).fooofed_spectrum=[];
            Resting_EEG.fooof_results{subjectid}(channelid).power_spectrum=[];
            Resting_EEG.fooof_results{subjectid}(channelid).bg_fit= [];
            
        end
        
    end
    
    
end

%% Fooof results fixed setting outcome

%settings.max_n_peaks = 1;
settings.background_mode = 'fixed';
f_range = [1, 30];
freqs = linspace(1,30,59);
Resting_EEG.fooof_results_fixed{1} = struct();

for subjectid = 1:size(Resting_EEG,1)
    
    
    for channelid = 1:31
        try
            subject_results = fooof(freqs, mean(Resting_EEG.Freq_Timewind{subjectid}(channelid,3:61,:),3),...
                f_range, settings,1);
            
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).background_params= subject_results.background_params;
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).peak_params= subject_results.peak_params;
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).gaussian_params= subject_results.gaussian_params;
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).error= subject_results.error;
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).r_squared= subject_results.r_squared;
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).fooofed_spectrum= subject_results.fooofed_spectrum;
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).power_spectrum= subject_results.power_spectrum;
            Resting_EEG.fooof_results_fixed{subjectid}(channelid).bg_fit= subject_results.bg_fit;
        catch
        end
        
    end
    
    
end

%% Find all the possible peaks in these EEG

% We need to list two peaks range one in the theta and one in the alpha
% Theta: 3:6 Alpha 6:9

for index = 1:size(Resting_EEG,1)
    
    fooof_R = Resting_EEG.fooof_results{index};
    
    P = [];
    
    for ind = 1:length(fooof_R)
        
        Peaks = [];
        
        Peak_id = [];
        
        Peak = fooof_R(ind).peak_params;
        
        if ~isempty(Peak)
            
            Peak_1 = Peak(find(Peak(:,1)<10),:);
            
            Peak_id = find(Peak_1(:,2)==max(Peak_1(:,2)));
            
            if ~isempty(Peak_id)
                
                Peaks(end+1,:) = Peak(Peak_id(1),:);
                
            else
                
                Peaks(end+1,:) = [NaN,NaN,NaN];
                
            end
            
        else
            
            Peaks(end+1,:) = [NaN,NaN,NaN];
            
        end
        
        P = [P;Peaks];
        
    end
    
    Resting_EEG.Peaks{index} = P;
    
end

% For peaks in the theta range

for index = 1:size(Resting_EEG,1)
    
    fooof_R = Resting_EEG.fooof_results{index};
    
    P = [];
    
    for ind = 1:length(fooof_R)
        
        Peaks = [];
        Peak_id = [];
        
        
        Peak = fooof_R(ind).peak_params;
        
        if ~isempty(Peak)
            
            Peak_1 = Peak(find(Peak(:,1)<6 & Peak(:,1)>3),:);
            
            try
                Peak_id = find(Peak(:,2)==max(Peak_1(:,2)));
            catch
            end
            
            if ~isempty(Peak_id)
                
                Peaks(end+1,:) = Peak(Peak_id(1),:);
                
            else
                
                Peaks(end+1,:) = [NaN,NaN,NaN];
                
            end
            
        else
            
            Peaks(end+1,:) = [NaN,NaN,NaN];
            
        end
        
        P = [P;Peaks];
        
    end
    
    Resting_EEG.Peaks_Theta{index} = P;
    
end

% For Alpha
for index = 1:size(Resting_EEG,1)
    
    fooof_R = Resting_EEG.fooof_results{index};
    
    P = [];
    
    for ind = 1:length(fooof_R)
        
        Peaks = [];
        Peak_id = [];
        
        Peak = fooof_R(ind).peak_params;
        
        if ~isempty(Peak)
            
            Peak_1 = Peak(find(Peak(:,1)<9 & Peak(:,1)>6.5),:);
            
            try
                Peak_id = find(Peak(:,2)==max(Peak_1(:,2)));
            catch
            end
            
            if ~isempty(Peak_id)
                
                Peaks(end+1,:) = Peak(Peak_id(1),:);
                
            else
                
                Peaks(end+1,:) = [NaN,NaN,NaN];
                
            end
            
        else
            
            Peaks(end+1,:) = [NaN,NaN,NaN];
            
        end
        
        P = [P;Peaks];
        
    end
    
    Resting_EEG.Peaks_Alpha{index} = P;
    
    
    
end


%% Get the mean power for different band widths corrected from the background flatten results

% Get the flattened mean power

for index = 1:size(Resting_EEG,1)
    
    
    
    for chan = 1:30
        
        
        Resting_EEG.fooof_results{index,1}(chan).flaten_spectrum =  Resting_EEG.fooof_results{index,1}(chan).power_spectrum  - ...
            Resting_EEG.fooof_results{index,1}(chan).bg_fit;
        
        
        
        
    end
    
end

for index = 1:size(Resting_EEG,1)
    
    
    
    for chan = 1:31
        
        
        Resting_EEG.fooof_results_fixed{index,1}(chan).flaten_spectrum =  Resting_EEG.fooof_results_fixed{index,1}(chan).power_spectrum  - ...
            Resting_EEG.fooof_results_fixed{index,1}(chan).bg_fit;
        
        
        
        
    end
    
end

% Flatten mean band power
for index = 1:size(Resting_EEG,1)
    
    bg = Resting_EEG.fooof_results{index,1}(2).flaten_spectrum;
    bgpar = Resting_EEG.fooof_results{index,1}(2).background_params; 
    
    Resting_EEG.flat_delta(index) = mean(bg(Par.delta));
    Resting_EEG.flat_theta(index)  = mean(bg(Par.theta));
    Resting_EEG.flat_alpha(index)  = mean(bg(Par.alpha));
    Resting_EEG.flat_beta(index)  = mean(bg(Par.beta));
    Resting_EEG.offSet(index) = bgpar(1);
    Resting_EEG.knee(index) = bgpar(2);
    Resting_EEG.Exp(index) = bgpar(3);
    
end

find(Resting_EEG.knee>6);

%% For all channel flatten data

Resting_EEG.flat_delta_all{1} = {};
Resting_EEG.flat_theta_all{1} = {};
Resting_EEG.flat_alpha_all{1} = {};
Resting_EEG.flat_beta_all{1} = {};

for index = 1:size(Resting_EEG,1)
    
    
    
    for chan = 1:30
        
        bg = Resting_EEG.fooof_results{index,1}(chan).flaten_spectrum;
        if ~isempty(bg)
            Resting_EEG.flat_delta_all{index}(chan) = {mean(bg(Par.delta))};
            Resting_EEG.flat_theta_all{index}(chan)  = {mean(bg(Par.theta))};
            Resting_EEG.flat_alpha_all{index}(chan)  = {mean(bg(Par.alpha))};
            Resting_EEG.flat_beta_all{index}(chan)  = {mean(bg(Par.beta))};
        else
            Resting_EEG.flat_delta_all{index}(chan) = {0};
            Resting_EEG.flat_theta_all{index}(chan)  = {0};
            Resting_EEG.flat_alpha_all{index}(chan)  = {0};
            Resting_EEG.flat_beta_all{index}(chan)  = {0};
            
            
            
        end
    end
    
end


Resting_EEG.flat_delta_all = cellfun(@(x) cell2mat(x),Resting_EEG.flat_delta_all,'UniformOutput',false);
Resting_EEG.flat_theta_all = cellfun(@(x) cell2mat(x),Resting_EEG.flat_theta_all,'UniformOutput',false);
Resting_EEG.flat_alpha_all = cellfun(@(x) cell2mat(x),Resting_EEG.flat_alpha_all,'UniformOutput',false);
Resting_EEG.flat_beta_all = cellfun(@(x) cell2mat(x),Resting_EEG.flat_beta_all,'UniformOutput',false);

% For not flatten dataset
Resting_EEG.delta_all{1} = {};
Resting_EEG.theta_all{1} = {};
Resting_EEG.alpha_all{1} = {};
Resting_EEG.beta_all{1} = {};

for index = 1:size(Resting_EEG,1)
    
    
    
    for chan = 1:30
        
        bg = Resting_EEG.fooof_results{index,1}(chan).power_spectrum;
        if ~isempty(bg)
            Resting_EEG.delta_all{index}(chan) = {mean(bg(Par.delta))};
            Resting_EEG.theta_all{index}(chan)  = {mean(bg(Par.theta))};
            Resting_EEG.alpha_all{index}(chan)  = {mean(bg(Par.alpha))};
            Resting_EEG.beta_all{index}(chan)  = {mean(bg(Par.beta))};
        else
            Resting_EEG.delta_all{index}(chan) = {0};
            Resting_EEG.theta_all{index}(chan)  = {0};
            Resting_EEG.alpha_all{index}(chan)  = {0};
            Resting_EEG.beta_all{index}(chan)  = {0};
            
            
            
        end
    end
    
end


Resting_EEG.delta_all = cellfun(@(x) cell2mat(x),Resting_EEG.delta_all,'UniformOutput',false);
Resting_EEG.theta_all = cellfun(@(x) cell2mat(x),Resting_EEG.theta_all,'UniformOutput',false);
Resting_EEG.alpha_all = cellfun(@(x) cell2mat(x),Resting_EEG.alpha_all,'UniformOutput',false);
Resting_EEG.beta_all = cellfun(@(x) cell2mat(x),Resting_EEG.beta_all,'UniformOutput',false);


%% For the backgroud parameters slope and offset

% For knee setting
Resting_EEG.slope{1} = {};
Resting_EEG.offset{1} = {};

for index = 1:size(Resting_EEG,1)
    
    
    
    for chan = 1:30
        
        bg = Resting_EEG.fooof_results{index,1}(chan).background_params;
        
        if ~isempty(bg)
            Resting_EEG.slope{index}(chan) = {bg(3)};
            Resting_EEG.offset{index}(chan) = {bg(1)};
            
        else
            Resting_EEG.slope{index}(chan) = {0};
            Resting_EEG.offset{index}(chan) = {0};
            
        end
    end
    
end

Resting_EEG.slope = cellfun(@(x) cell2mat(x),Resting_EEG.slope,'UniformOutput',false);
Resting_EEG.offset = cellfun(@(x) cell2mat(x),Resting_EEG.offset,'UniformOutput',false);



% For fixed setting
Resting_EEG.slope_fixed{1} = {};
Resting_EEG.offset_fixed{1} = {};

for index = 1:size(Resting_EEG,1)
    
    
    
    for chan = 1:30
        
        bg = Resting_EEG.fooof_results_fixed{index,1}(chan).background_params;
        
        if ~isempty(bg)
            Resting_EEG.slope_fixed{index}(chan) = {bg(2)};
            Resting_EEG.offset_fixed{index}(chan) = {bg(1)};
            
        else
            Resting_EEG.slope_fixed{index}(chan) = {1};
            Resting_EEG.offset_fixed{index}(chan) = {1};
            
        end
    end
    
end

Resting_EEG.slope_fixed = cellfun(@(x) cell2mat(x),Resting_EEG.slope_fixed,'UniformOutput',false);
Resting_EEG.offset_fixed = cellfun(@(x) cell2mat(x),Resting_EEG.offset_fixed,'UniformOutput',false);

%% Create another excel .csv file for final analysis 

Resting_csv = table('Size',[0 0]);


for index = 1:size(Resting_EEG,1)
    
    Resting_csv.subjectid{index} = Resting_EEG.subjectid{index};
    Resting_csv.trial_stage{index} = Resting_EEG.trial_stage{index};
    
for channelid = 1:30

% for unflat different bands 
eval(['Resting_csv.delta_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.delta_all{index}(channelid);'])
eval(['Resting_csv.theta_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.theta_all{index}(channelid);'])
eval(['Resting_csv.alpha_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.alpha_all{index}(channelid);'])
eval(['Resting_csv.beta_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.beta_all{index}(channelid);'])

% for flat different bands
eval(['Resting_csv.flat_delta_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.flat_delta_all{index}(channelid);'])
eval(['Resting_csv.flat_theta_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.flat_theta_all{index}(channelid);'])
eval(['Resting_csv.flat_alpha_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.flat_alpha_all{index}(channelid);'])
eval(['Resting_csv.flat_beta_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.flat_beta_all{index}(channelid);'])

% for model derived slop odffset 
eval(['Resting_csv.slope_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.slope{index}(channelid);'])
eval(['Resting_csv.offset_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.offset{index}(channelid);'])


% for peak infor in theta and alpha 
eval(['Resting_csv.theta_CF_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.Peaks_Theta{index}(channelid,1);'])
eval(['Resting_csv.theta_PW_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.Peaks_Theta{index}(channelid,2);'])

eval(['Resting_csv.alpha_CF_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.Peaks_Alpha{index}(channelid,1);'])
eval(['Resting_csv.alpha_PW_',Resting_EEG.chanlocs{1}(channelid).labels,'{index}= Resting_EEG.Peaks_Alpha{index}(channelid,2);'])



end

end

%% Greata another version of the datasets with all the variables  

%For Delta Fz (2)
%For theta Fz, F3, F4, FC1, FC2, Cz, C3, C4 (2,3,28,7,27,22,8,23)
%For Post Alpha Oz, O1, O2 (15,16,17)
%For Mu/Alpha rhythm Cz, C3, C4, CP1, CP2 (22,8,23,11,21)
%For Beta Fz, F3, F4, FC1, FC2, Cz, C3, C4, CP1, CP2, Pz, P3, P4, Oz, O1, O2
%(2,3,28,7,27,22,8,23,11,21,12,13,18,15,16,17)
%For model Fz, F3, F4, FC1, FC2, Cz, C3, C4, CP1, CP2, Pz, P3, P4, Oz, O1, O2
%(2,3,28,7,27,22,8,23,11,21,12,13,18,15,16,17)

Par.ele_delta = [2];
Par.ele_theta = [2,3,28,7,27,22,8,23];
Par.ele_alpha_post = [15,16,17];
Par.ele_alpha_mu = [22,8,23,11,21];
Par.ele_beta = [2,3,28,7,27,22,8,23,11,21,12,13,18,15,16,17];
Par.ele_model = [2,3,28,7,27,22,8,23,11,21,12,13,18,15,16,17];

Resting_csv = table('Size',[0 0]);

for index = 1:size(Resting_EEG,1)
    
    Resting_csv.subjectid{index} = Resting_EEG.subjectid{index};
    Resting_csv.trial_stage{index} = Resting_EEG.trial_stage{index};    

%for band frequency     
Resting_csv.delta(index)   =  nanmean(Resting_EEG.delta_all{index}(Par.ele_delta));
Resting_csv.theta(index)   =  nanmean(Resting_EEG.theta_all{index}(Par.ele_theta));
Resting_csv.alpha_post(index)   =  nanmean(Resting_EEG.alpha_all{index}(Par.ele_alpha_post));
Resting_csv.alpha_mu(index)   =  nanmean(Resting_EEG.alpha_all{index}(Par.ele_alpha_mu));
Resting_csv.beta(index)   =  nanmean(Resting_EEG.beta_all{index}(Par.ele_beta));

%for flat band frequency     
Resting_csv.flat_delta(index)   =  nanmean(Resting_EEG.flat_delta_all{index}(Par.ele_delta));
Resting_csv.flat_theta(index)   =  nanmean(Resting_EEG.flat_theta_all{index}(Par.ele_theta));
Resting_csv.flat_alpha_post(index)   =  nanmean(Resting_EEG.flat_alpha_all{index}(Par.ele_alpha_post));
Resting_csv.flat_alpha_mu(index)   =  nanmean(Resting_EEG.flat_alpha_all{index}(Par.ele_alpha_mu));
Resting_csv.flat_beta(index)   =  nanmean(Resting_EEG.flat_beta_all{index}(Par.ele_beta));

% for model derived slop odffset 

Resting_csv.slope(index)   =  nanmean(Resting_EEG.slope{index}(Par.ele_model));
Resting_csv.offset(index)   =  nanmean(Resting_EEG.offset{index}(Par.ele_model));

% for peak infor in theta and alpha 

Resting_csv.theta_CF(index) = nanmean(Resting_EEG.Peaks_Theta{index}(Par.ele_theta,1));
Resting_csv.theta_PW(index) = nanmean(Resting_EEG.Peaks_Theta{index}(Par.ele_theta,2));

Resting_csv.alpha_post_CF(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_post,1));
Resting_csv.alpha_post_PW(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_post,2));

Resting_csv.alpha_mu_CF(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_mu,1));
Resting_csv.alpha_mu_PW(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_mu,2));




end

save('Resting_csv_midline_s','Resting_csv');

%% Endline Greata another version of the datasets with all the variables  

%For Delta Fz (2)
%For theta Fz, F3, F4, FC1, FC2, Cz, C3, C4 (2,3,28,7,27,22,8,23)
%For Post Alpha Oz, O1, O2 (15,16,17)
%For Mu/Alpha rhythm Cz, C3, C4, CP1, CP2 (22,8,23,12,21)
%For Beta Fz, F3, F4, FC1, FC2, Cz, C3, C4, CP1, CP2, P3, P4, Oz, O1, O2
%(2,3,28,7,27,22,8,23,12,21,12,13,18,15,16,17)
%For model Fz, F3, F4, FC1, FC2, Cz, C3, C4, CP1, CP2, P3, P4, Oz, O1, O2
%(2,3,28,7,27,22,8,23,12,21,13,18,15,16,17)

Par.ele_delta = [2];
Par.ele_theta = [2,3,28,7,27,22,8,23];
Par.ele_alpha_post = [15,16,17];
Par.ele_alpha_mu = [22,8,23,12,21];
Par.ele_beta = [2,3,28,7,27,22,8,23,12,21,13,18,15,16,17];
Par.ele_model = [2,3,28,7,27,22,8,23,12,21,13,18,15,16,17];

Resting_csv = table('Size',[0 0]);

for index = 1:size(Resting_EEG,1)
    
    Resting_csv.subjectid{index} = Resting_EEG.subjectid{index};
    Resting_csv.trial_stage{index} = Resting_EEG.trial_stage{index};    

%for band frequency     
Resting_csv.delta(index)   =  nanmean(Resting_EEG.delta_all{index}(Par.ele_delta));
Resting_csv.theta(index)   =  nanmean(Resting_EEG.theta_all{index}(Par.ele_theta));
Resting_csv.alpha_post(index)   =  nanmean(Resting_EEG.alpha_all{index}(Par.ele_alpha_post));
Resting_csv.alpha_mu(index)   =  nanmean(Resting_EEG.alpha_all{index}(Par.ele_alpha_mu));
Resting_csv.beta(index)   =  nanmean(Resting_EEG.beta_all{index}(Par.ele_beta));

%for flat band frequency     
Resting_csv.flat_delta(index)   =  nanmean(Resting_EEG.flat_delta_all{index}(Par.ele_delta));
Resting_csv.flat_theta(index)   =  nanmean(Resting_EEG.flat_theta_all{index}(Par.ele_theta));
Resting_csv.flat_alpha_post(index)   =  nanmean(Resting_EEG.flat_alpha_all{index}(Par.ele_alpha_post));
Resting_csv.flat_alpha_mu(index)   =  nanmean(Resting_EEG.flat_alpha_all{index}(Par.ele_alpha_mu));
Resting_csv.flat_beta(index)   =  nanmean(Resting_EEG.flat_beta_all{index}(Par.ele_beta));

% for model derived slop odffset 

Resting_csv.slope(index)   =  nanmean(Resting_EEG.slope{index}(Par.ele_model));
Resting_csv.offset(index)   =  nanmean(Resting_EEG.offset{index}(Par.ele_model));

% for peak infor in theta and alpha 

Resting_csv.theta_CF(index) = nanmean(Resting_EEG.Peaks_Theta{index}(Par.ele_theta,1));
Resting_csv.theta_PW(index) = nanmean(Resting_EEG.Peaks_Theta{index}(Par.ele_theta,2));

Resting_csv.alpha_post_CF(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_post,1));
Resting_csv.alpha_post_PW(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_post,2));

Resting_csv.alpha_mu_CF(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_mu,1));
Resting_csv.alpha_mu_PW(index) = nanmean(Resting_EEG.Peaks_Alpha{index}(Par.ele_alpha_mu,2));




end

%save('Resting_csv_endline_s_ex','Resting_csv');


%% Save the variable

% save('Resting_EEG.mat','Resting_EEG', '-v7.3');

save('Resting_csv_endline','Resting_csv');

writetable(R,'Resting_Endline.csv','Delimiter',',')

%% Write a table 

Resting = [Midline;Ex_endline;Endline];

writetable(Resting,'Resting.csv','Delimiter',',')


Resting.delta(find(Resting.delta==0)) = NaN;
Resting.theta(find(Resting.theta==0)) = NaN;
Resting.alpha_post(find(Resting.alpha_post==0)) = NaN;
Resting.alpha_mu(find(Resting.alpha_mu==0)) = NaN;
Resting.beta(find(Resting.beta==0)) = NaN;
Resting.flat_delta(find(Resting.flat_delta==0)) = NaN;
Resting.flat_theta(find(Resting.flat_theta==0)) = NaN;
Resting.flat_alpha_post(find(Resting.flat_alpha_post==0)) = NaN;
Resting.flat_alpha_mu(find(Resting.flat_alpha_mu==0)) = NaN;
Resting.flat_beta(find(Resting.flat_beta==0)) = NaN;
Resting.slope(find(Resting.slope==0)) = NaN;
Resting.offset(find(Resting.offset==0)) = NaN;


