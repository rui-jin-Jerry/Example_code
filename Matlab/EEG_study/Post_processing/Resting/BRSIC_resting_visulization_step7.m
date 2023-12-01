%% BRSIC_resting_visulization_step7

% This script take FFT data from resting summary table, 
% make plots for visulize connectivity analysis for different methods
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



%% Create a connectivity matrix 

% The connectivity matrix could in different form for its value but
% generally Num_channels * Num_channels 

% The matrix could be generated using: 
% 1: Phase based (ISPC, useful for ERP in oddball maynot useful in resting) 
% 2: Power based
% 3: Mutual information (Flexible freamework)
% 4: Granger Prediction (Flexible freamework)
% 5: Synchrolization likelihood 

% We need to do a complex wavelet convolution to decompose the signal 
% For resting state data, to test connectivity, we may need to segment the
% data into nonoverlaping chunks of a few seconds , compute a correaltion
% coefficient on each segment, and then average the correaltion coe togther
% Same thing also applied to Phase based analysis 

% Segment the whole data into 3s of 60 epochs  
Data = reshape(Resting_EEG_summary.Epoched_Data{12}(1:30,:,:),[30,1000,60]);

%% Spatial filter
X = [Resting_EEG_summary.chanlocs{2}.X];
Y = [Resting_EEG_summary.chanlocs{2}.Y];
Z = [Resting_EEG_summary.chanlocs{2}.Z];

Data = laplacian_perrinX(Data,X,Y,Z);
%% Power-Based connectivity 
% Spearman coorelation (nonnormally distributed and contain outliers) 
% Simply correlating the power time series between two electrodes over a
% period of time 

% Wavelet convolution( band pass filter ) for certain frequeny band and plot correlation coeficient 
% Compute the correlation between two electrodes at certain frequency 

sensor1 = 'Fz'
sensor2 = 'Fp1';

certerfreq = 4;
trial2plot = 20;

% setup wavelet convolution and outputs 
time = -1:1/500:1;
half_of_wavelet_size = (length(time)-1)/2;

% FFT parameters
n_wavelet     = length(time);
n_data        = 1000*60;
n_convolution = n_wavelet+n_data-1;
wavelet_cycles= 4.5;

% FFT of data (note: this doesn't change on frequency iteration)
fft_data1 = fft(reshape(Data(2,:,:),1,1000*60),n_convolution);
fft_data2 = fft(reshape(Data(23,:,:),1,1000*60),n_convolution);

% create wavelet and run convolution
fft_wavelet             = fft(exp(2*1i*pi*centerfreq.*time) .* exp(-time.^2./(2*( wavelet_cycles /(2*pi*centerfreq))^2)),n_convolution);
convolution_result_fft  = ifft(fft_wavelet.*fft_data1,n_convolution) * sqrt(wavelet_cycles /(2*pi*centerfreq));
convolution_result_fft  = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
convolution_result_fft1 = reshape(convolution_result_fft,1000,60);

fft_wavelet             = fft(exp(2*1i*pi*centerfreq.*time) .* exp(-time.^2./(2*( wavelet_cycles /(2*pi*centerfreq))^2)),n_convolution);
convolution_result_fft  = ifft(fft_wavelet.*fft_data2,n_convolution) * sqrt(wavelet_cycles /(2*pi*centerfreq));
convolution_result_fft  = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
convolution_result_fft2 = reshape(convolution_result_fft,1000,60);

figure
subplot(211)
plot(1:2:2000,abs(convolution_result_fft1(:,trial2plot)).^2)
hold on
plot(1:2:2000,abs(convolution_result_fft2(:,trial2plot)).^2,'r')
xlabel('Time (ms)')
set(gca,'xlim',[1 2000])
legend({sensor1;sensor2})

subplot(223)
plot(abs(convolution_result_fft1(:,trial2plot)).^2,abs(convolution_result_fft2(:,trial2plot)).^2,'.')
title('Power relationship')
xlabel([ sensor1 ' ' num2str(centerfreq) 'Hz power' ])
ylabel([ sensor2 ' ' num2str(centerfreq) 'Hz power' ])
r=corr(abs(convolution_result_fft1(:,trial2plot)).^2,abs(convolution_result_fft2(:,trial2plot)).^2,'type','p');
legend([ 'Pearson R = ' num2str(r) ]);

subplot(224)
plot(tiedrank(abs(convolution_result_fft1(:,trial2plot)).^2),tiedrank(abs(convolution_result_fft2(:,trial2plot)).^2),'.')
title('Rank-power relationship')
xlabel([ sensor1 ' ' num2str(centerfreq) 'Hz rank-power' ])
ylabel([ sensor2 ' ' num2str(centerfreq) 'Hz rank-power' ])
r=corr(abs(convolution_result_fft1(:,trial2plot)).^2,abs(convolution_result_fft2(:,trial2plot)).^2,'type','s');
legend([ 'Spearman Rho = ' num2str(r) ]);
set(gca,'ylim',get(gca,'xlim'))


% Cross-correaltion analysis, if there is a lag in time in peak power between two
% time series (electrods)

%% Creat Power based connectivity matrix Pearson and Spearson correlation 
% Compare the power and phase matrix 
 
% Create a num matrix first 

% specify some time-frequency parameters
center_freq   = 5; % Hz
% time2analyze  = 2000; % in ms

% wavelet and FFT parameters
time          = -1:1/500:1;
half_wavelet  = (length(time)-1)/2;
n_wavelet     = length(time);
n_data        = 1000*60;
n_convolution = n_wavelet+n_data-1;

% initialize connectivity output matrix
connectivitymat = zeros(30,30);

% % time in indices
% [junk,tidx] = min(abs(EEG.times-time2analyze));

% create wavelet and take FFT
s = 5/(2*pi*center_freq);
wavelet_fft = fft( exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(s^2))) ,n_convolution);

% compute analytic signal for all channels
analyticsignals = zeros(30,1000,60);
for chani=1:30
    
    % FFT of data
    data_fft = fft(reshape(Data(chani,:,:),1,n_data),n_convolution);
    
    % convolution
    convolution_result = ifft(wavelet_fft.*data_fft,n_convolution);
    convolution_result = convolution_result(half_wavelet+1:end-half_wavelet);
    
    analyticsignals(chani,:,:) = reshape(convolution_result,1000,60);
end

% now compute all-to-all connectivity
for chani=1:30
    for chanj=chani:30 % note that you don't need to start at 1
        Pearson_corr=[];
        Spearman_corr =[];
        for trial = 1:60
        Pearson_corr(end+1) = corr(abs(analyticsignals(chani,:,trial))'.^2,abs(analyticsignals(chanj,:,trial))'.^2,'type','p');
        Spearman_corr(end+1) = corr(abs(analyticsignals(chani,:,trial))'.^2,abs(analyticsignals(chanj,:,trial))'.^2,'type','s');
        end
        
        % connectivity matrix (Pearson on upper triangle; Spearman on lower triangle)
        connectivitymat(chani,chanj) = mean(Pearson_corr);

        connectivitymat(chanj,chani) = mean(Spearman_corr);
        
    end
end

figure
imagesc(connectivitymat)
%set(gca,'clim',[0 .7],'xtick',1:8:EEG.nbchan,'xticklabel',{EEG.chanlocs(1:8:end).labels},'ytick',1:8:EEG.nbchan,'yticklabel',{EEG.chanlocs(1:8:end).labels});
axis square
colorbar

%% Phase-Based connectivity May need space filter 

% names of the channels you want to synchronize
channel1 = 'Fz';
channel2 = 'T7';

% create complex Morlet wavelet
center_freq = 6; % in Hz
time        = -1:1/500:1; % time for wavelet
wavelet     = exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(4/(2*pi*center_freq))^2))/center_freq;
half_of_wavelet_size = (length(time)-1)/2;

% FFT parameters
n_wavelet     = length(time);
n_data        = 1000;
n_convolution = n_wavelet+n_data-1;

% FFT of wavelet
fft_wavelet = fft(wavelet,n_convolution);

% initialize output time-frequency data
phase_data = zeros(2,1000);
real_data  = zeros(2,1000);

% find channel indices
chanidx = zeros(1,2); % always initialize!
chanidx(1) = 23;
chanidx(2) = 2;

% run convolution and extract filtered signal (real part) and phase
for chani=1:2
    fft_data = fft(squeeze(Data(chanidx(chani),:,1)),n_convolution);
    convolution_result_fft = ifft(fft_wavelet.*fft_data,n_convolution) * sqrt(4/(2*pi*center_freq));
    convolution_result_fft = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
 
    % collect real and phase data
    phase_data(chani,:) = angle(convolution_result_fft);
    real_data(chani,:)  = real(convolution_result_fft);
end

Time = 1:1000;

% open and name figure
figure 
set(gcf,'Name','Movie magic minimizes the mystery.');

% draw the filtered signals
subplot(321)
filterplotH1 = plot(Time(1),real_data(1,1),'b');
hold on
filterplotH2 = plot(Time(1),real_data(2,1),'m');
set(gca,'xlim',[Time(1) Time(end)],'ylim',[min(real_data(:)) max(real_data(:))])
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([ 'Filtered signal at ' num2str(center_freq) ' Hz' ])

% draw the phase angle time series
subplot(322)
phaseanglesH1 = plot(Time(1),phase_data(1,1),'b');
hold on
phaseanglesH2 = plot(Time(1),phase_data(2,1),'m');
set(gca,'xlim',[Time(1) Time(end)],'ylim',[-pi pi]*1.1,'ytick',-pi:pi/2:pi)
xlabel('Time (ms)')
ylabel('Phase angle (radian)')
title('Phase angle time series')

% draw phase angle differences in cartesian space
subplot(323)
filterplotDiffH1 = plot(Time(1),real_data(1,1)-real_data(2,1),'b');
set(gca,'xlim',[Time(1) Time(end)],'ylim',[-50 50])
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([ 'Filtered signal at ' num2str(center_freq) ' Hz' ])

% draw the phase angle time series
subplot(324)
phaseanglesDiffH1 = plot(Time(1),phase_data(1,1)-phase_data(2,1),'b');
set(gca,'xlim',[Time(1) Time(end)],'ylim',[-pi pi]*2.2,'ytick',-2*pi:pi/2:pi*2)
xlabel('Time (ms)')
ylabel('Phase angle (radian)')
title('Phase angle time series')

% draw phase angles in polar space
subplot(325)
polar2chanH1 = polar([phase_data(1,1) phase_data(1,1)]',repmat([0 1],1,1)','b');
hold on
polar2chanH2 = polar([phase_data(1,1) phase_data(2,1)]',repmat([0 1],1,1)','m');
title('Phase angles from two channels')
 
% draw phase angle differences in polar space
subplot(326)
polarAngleDiffH = polar([zeros(1,1) phase_data(2,1)-phase_data(1,1)]',repmat([0 1],1,1)','k');
title('Phase angle differences from two channels')
 
% now update plots at each timestep
% Note: in/decrease skipping by 10 to speed up/down the movie
for ti=1:10:1000
    
    % update filtered signals
    set(filterplotH1,'XData',Time(1:ti),'YData',real_data(1,1:ti))
    set(filterplotH2,'XData',Time(1:ti),'YData',real_data(2,1:ti))
    
    % update cartesian plot of phase angles
    set(phaseanglesH1,'XData',Time(1:ti),'YData',phase_data(1,1:ti))
    set(phaseanglesH2,'XData',Time(1:ti),'YData',phase_data(2,1:ti))
    
    % update cartesian plot of phase angles differences
    set(phaseanglesDiffH1,'XData',Time(1:ti),'YData',phase_data(1,1:ti)-phase_data(2,1:ti))
    set(filterplotDiffH1,'XData',Time(1:ti),'YData',real_data(1,1:ti)-real_data(2,1:ti))
    
    subplot(325)
    cla
    polar(repmat(phase_data(1,1:ti),1,2)',repmat([0 1],1,ti)','b');
    hold on
    polar(repmat(phase_data(2,1:ti),1,2)',repmat([0 1],1,ti)','m');
    
    subplot(326)
    cla
    polar(repmat(phase_data(2,1:ti)-phase_data(1,1:ti),1,2)',repmat([0 1],1,ti)','k');
    
    drawnow
end

% Phase lag index without the volum conduction correction 


pli  = abs(mean(sign(imag(exp(1i*diff(phase_data,1))))));
ispc = abs(mean(exp(1i*diff(phase_data,1))));

%% Creat Phase based connectivity matrix ISPC and Phase lag index 
% Compare the power and phase matrix 
 
% Create a num matrix first 

% specify some time-frequency parameters
center_freq   = 5; % Hz
% time2analyze  = 2000; % in ms

% wavelet and FFT parameters
time          = -1:1/500:1;
half_wavelet  = (length(time)-1)/2;
n_wavelet     = length(time);
n_data        = 1000*60;
n_convolution = n_wavelet+n_data-1;

% initialize connectivity output matrix
connectivitymat = zeros(30,30);

% % time in indices
% [junk,tidx] = min(abs(EEG.times-time2analyze));

% create wavelet and take FFT
s = 5/(2*pi*center_freq);
wavelet_fft = fft( exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(s^2))) ,n_convolution);

% compute analytic signal for all channels
analyticsignals = zeros(30,1000,60);
for chani=1:30
    
    % FFT of data
    data_fft = fft(reshape(Data(chani,:,:),1,n_data),n_convolution);
    
    % convolution
    convolution_result = ifft(wavelet_fft.*data_fft,n_convolution);
    convolution_result = convolution_result(half_wavelet+1:end-half_wavelet);
    
    analyticsignals(chani,:,:) = reshape(convolution_result,1000,60);
end

% now compute all-to-all connectivity
for chani=1:30
    for chanj=chani:30 % note that you don't need to start at 1
        xsd = squeeze(analyticsignals(chani,:,:) .* conj(analyticsignals(chanj,:,:)));
        
        % connectivity matrix (phase-lag index on upper triangle; ISPC-time on lower triangle)
        connectivitymat(chani,chanj) = mean(abs(mean(sign(imag(xsd)))));
        
% Overtime 
        connectivitymat(chanj,chani) = mean(abs(mean(exp(1i*angle(xsd)))));
        
    end
end

figure
imagesc(connectivitymat)
%set(gca,'clim',[0 .7],'xtick',1:8:EEG.nbchan,'xticklabel',{EEG.chanlocs(1:8:end).labels},'ytick',1:8:EEG.nbchan,'yticklabel',{EEG.chanlocs(1:8:end).labels});
%set(gca,'clim',[0 .3])
axis square
colorbar

%% SL Synchronization likelihood

tic
[S_matrix, hit_matrix ] = synchronization(Resting_EEG_summary.Epoched_Data{12}',10,10,100,410,0.01,16);
toc

% calculate pairwise time-averaged synchronization likelihood 

S_kl_temp = sum(hit_matrix, 3); % sum the hit matrix across time i, size (num_chan, num_chan)
hit_diag = diag( S_kl_temp );
% at a (k,l) position, s_kl_temp contains the number of hits occuring at both channels k & l, over all i & j
% at a (k,k) position, s_kl_temp contains the number of hits at channel k, over all i & j

S_kl_matrix = hit_diag * ones(1,33) + ones(33,1) * hit_diag';
% at a (k,l) position, s_kl_matrix contains the number of hits occuring at k and at l (hits at both k&l are counted twice)
% at a (k,k) position, s_kl_matrix contains the number of hits occuring at k, times 2

S_kl_matrix = S_kl_matrix + (S_kl_matrix == 0); % if S(k,k) == 0 & S(l,l) == 0 then S(k,l) must also be 0.
% this calculation protects against division by 0

% 2 * ( #k & l are both hit ) / ( #k is hit + #l is hit )
% = harmonic average of ( #k hit / # k & l are hit ) and ( #l hit / # k & l are hit )
S_kl_matrix = 2 * S_kl_temp ./ S_kl_matrix;

figure
imagesc(S_kl_matrix)
axis square
colorbar



