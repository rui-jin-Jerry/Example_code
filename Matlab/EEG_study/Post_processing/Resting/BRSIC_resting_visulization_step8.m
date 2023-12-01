%% BRSIC_resting_visulization_step8

% Other models (except fooof) for Frequency spectrum Modeling in resting state 
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

%% Setting Parameters

Par.FFT_tableFolder = 'C:\Users\RJIN3\OneDrive - The University of Melbourne\Documents\BRSIC\BRISC_EEG\Postprocessing_Code\Resting_State';

% Choose experiment name ('bubbles' / 'sound' / 'movie')
Par.experimentName = 'bubbles';

% Select testing phase and channels
% 'M' = midline | 2 = Fz 
Par.testingPhase = 'M';

% The frequency range we are interested 
% Hz from 1:30 but in 500 sample with first as zero should be 3:61 (Because
% of the high and low filter 
Par.Frequency_index_range = 3:61;

% Chooes electrod of interest like Fz code 2 

Par.sample_points = 1000; % 2s of 500 rate for 1000 samples 
Par.strate = 500;
Par.nyquist = Par.strate/2;

Par.FFT_Frequencies = linspace(0,Par.nyquist,Par.sample_points/2+1);

Par.Frequency_range = Par.FFT_Frequencies(Par.Frequency_index_range);



%% Modeling by setting pre-defined paramters 


srate = 500; % sampling rate in Hz
f = 10; % frequency of the sine wave in Hz
time = 0:1/srate:5; % time, from -1 to 1 second in steps of 1/sampling-rate

sine_wave = exp(2*pi*1i*f.*time); % complex wavelet

% make a Gaussian
s=6/(2*pi*f);
gaussian_win = 0.3*exp(-(time-5).^2./(2*s^2));

% and together they make a wavelet!
wavelet = sine_wave .* gaussian_win;

figure
plot(time,gaussian_win) 
ylim([0 3])

hold on
fplot(@(x) 2/x^1,[0 5])
% plots the Gaussian window

T = 2./time.^1;

plot(time, gaussian_win+T)

%% The Model for power spectrum by setting pre-defined paramters 

% The 1/f part is yf = y(1)/(x^&)
% The Gussian part yg = A*exp(-(time-alpha).^2./(2*s^2));
% A for amplitude the peak power of alpha 
% alpha is for central bandwith
% time for frequencies bands 1-30 in 0.5 gap
% s for standeviation could set to 1.76

All_FFT = cat(3,Resting_EEG_summary.Freq_Timewind{:});
x = 1:0.5:30;
b = 1;
yf = max(mean(All_FFT(Channel_of_interest,Par.Frequency_index_range,:),3))./x.^1;
figure
plot(x,yf)


A = 0.9;
alpha = 4.7;
time = 1:0.5:30;
s = 1.76;
yg = A*exp(-(time-alpha).^2./(2*s^2));

figure
plot(time,yg)
hold on
plot(time, yg+yf)

xlim([1 30])


%% Setting Normarative value for Bell and 1/F model and least fitting 

A = 0; Ar = [0,5];
f = 5;fr = [4,10];
%sigma = 5;sigma_r = [0.5,10];

h = 3;hr = [1,5];
s = 4;sr = [1,10];

N = 1;Nr = [1,10];
r = 0.8;r_r = [0.6,1.2];
d = 1;
ERR = [];

x = linspace(1,30,59);

% Set a signal for simulate
signal = mean(Resting_EEG_summary.Freq_Timewind{1}(1,3:61,:),3);

for iter = 1:50
    
    N = signal(1);
    
    itv = 200;
    rj = linspace(r_r(1),r_r(end),itv);err = [];
    for j = 1:itv
        y1 = zeros(1,length(signal));y1(round(f-h/2)+1:round(f-h/2)+round(h)) = A*dune_win(round(h),s);
        y2 = N*(x.^(-rj(j)));
        simu = y1+y2;
        
        logx = log(x);
        
        simu_i = interp1(logx,log(simu),linspace(min(logx),max(logx),length(x)));
        signal_i = interp1(logx,log(signal),linspace(min(logx),max(logx),length(x)));
        err(j) = sum(abs((simu_i) - (signal_i)).^2);
        err(j) = sum(abs((simu_i) - (signal_i)));

    end
    r = rj(err==min(err));r = r(1);

    itv = 100;
    Aj = linspace(Ar(1),Ar(end),itv);err = [];
    for j = 1:itv
        y1 = zeros(1,length(signal));y1(round(f-h/2)+1:round(f-h/2)+round(h)) = Aj(j)*dune_win(round(h),s);
        y2 = N*(x.^(-r));
        sim = y1+y2;
        err(j) = sum(((sim([round(f)+[-2,-1,0,1,2]]))-(signal([round(f)+[-2,-1,0,1,2]]))).^2);
    end
    A = Aj(err==min(err));A = A(1);
    
    itv = 10;
    fj = linspace(fr(1),fr(end),itv);err = [];
    for j = 1:itv
        y1 = zeros(1,length(signal));y1(round(fj(j)-h/2)+1:round(fj(j)-h/2)+round(h)) = A*dune_win(round(h),s);
        y2 = N*(x.^(-r));
        sim = y1+y2;
        err(j) = sum(((sim([round(f)+[-2,-1,0,1,2]]))-(signal([round(f)+[-2,-1,0,1,2]]))).^2);

    end
    f = fj(err==min(err));f = f(1);


    itv = 20;
    h_j = linspace(hr(1),hr(end),itv);err = [];
    for j = 1:itv
        y1 = zeros(1,length(signal));y1(round(f-h_j(j)/2)+1:round(f-h_j(j)/2)+round(h_j(j))) = A*dune_win(round(h_j(j)),s);
        y2 = N*(x.^(-r));
        sim = y1+y2;
        err(j) = sum(((sim([round(f)+[-2,-1,0,1,2]]))-(signal([round(f)+[-2,-1,0,1,2]]))).^2);
    end
    h = h_j(err==min(err));h = h(1);
    

    

    y1 = zeros(1,length(signal));y1(round(f-h/2)+1:round(f-h/2)+round(h)) = A*dune_win(round(h),s);
    y2 = N*(x.^(-r));
    
    sim = y1+y2;

    ERR(iter) = sum(abs(log(y2+y1) - log(signal)));

if iter>1 && ERR(iter)==ERR(iter-1) break;end
    
end

figure
plot(x,signal)
hold on
plot(x,sim)
figure
plot(x,signal-sim)

% Maybe the bell function is not a good one


