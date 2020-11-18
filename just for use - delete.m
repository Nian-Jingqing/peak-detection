% Read ECG signal to extract Heart Rate
clear
clc
% Open file and asign the data to a matrix
sig1=load('ECG_308317361_01.mat');
ECG_signal = sig1.sig;


% Define time vector 
fs = 1000; 
T = 1/fs; 
t = (0:length(ECG_signal)-1)*T;

% Normalize ECG signal
min_val = min(ECG_signal);
max_val = max(ECG_signal);

norm_ECG = -1+(2*(ECG_signal-min_val))/(max_val-min_val);


% Finding the indexes of the R peaks, using a threshold of 0.4 mV.
[~,peak_ind] = findpeaks(norm_ECG,'MinPeakProminence',850,'MinPeakDistance',fs*0.2);
% Coverting indexes vector to time vector
R_peaks_times = peak_ind/fs;


% Calculating the Heart rate for each heartbeat, by subtracting the time between each consecutive R wave.
%HR_times2 = zeros(1,length(t));
%for i = 1:length(peak_times)-1 
%    diff = peak_times(i+1)-peak_times(i);
%    HR_times2(peak_times(i)*fs:peak_times(i+1)*fs) = 60/diff;
%end

%plot(t,HR_times2)