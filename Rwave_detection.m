function [R_peaks_times] = Rwave_detection(ECG_signal,figure_num)  % remove figure_num
% This function receives a ECG signal, and returns a vector that contains the times in which the R waves appear in the ECG signal


% Define time vector 
fs = 1000; 
T = 1/fs; 
t = (0:length(ECG_signal)-1)*T;


% Finding the indexes of the R peaks, using a threshold of 0.4 mV.
[~,peak_ind] = findpeaks(ECG_signal,'MinPeakProminence',850,'MinPeakDistance',fs*0.2);
% Coverting indexes vector to time vector
R_peaks_times = peak_ind/fs;


% to be removed!!!
figure(figure_num) 
%plot(t,ECG_signal)
findpeaks(ECG_signal,'MinPeakProminence',850,'MinPeakDistance',fs*0.2);
% to be removed!!!
end

