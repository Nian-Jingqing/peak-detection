% Read ECG signal to extract Heart Rate
clear
clc
% Open file and asign the data to a matrix
f =fopen('ECG_308317361_01.mat');
data = textscan(f,'%f %f','HeaderLines',1);
data_mat = cell2mat(data);
ECG_signal = data_mat(:,1);
fclose(f);

% Define time vector 
fs = 1000; 
T = 1/fs; 
t = (0:length(data_mat(:,1))-1)*T;

% Finding the indexes of the R peaks, using a threshold of 0.4 mV.
[~,peak_ind] = findpeaks(ECG_signal,'MinPeakProminence',0.4,'MinPeakDistance',fs*0.2);
% Coverting indexes vector to time vector
peak_times = peak_ind/fs;

% Calculating the Heart rate for each heartbeat, by subtracting the time between each consecutive R wave.
HR_times2 = zeros(1,length(t));
for i = 1:length(peak_times)-1 
    diff = peak_times(i+1)-peak_times(i);
    HR_times2(peak_times(i)*fs:peak_times(i+1)*fs) = 60/diff;
end

plot(t,HR_times2)