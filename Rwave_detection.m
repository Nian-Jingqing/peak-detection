function [peak_ind,peak_ind_1,peak_ind_2,peak_ind_comb] = Rwave_detection(ECG_signal,figure_num)  % remove figure_num
% This function receives a ECG signal, and returns a vector that contains the indexes in which the R waves appear in the ECG signal
tic
% Define time vector 
fs = 1000; 
T = 1/fs; 
t = (0:length(ECG_signal)-1)*T;


first_deriv = zeros(1,length(ECG_signal));
second_deriv = zeros(1,length(ECG_signal));

for n = 3: (length(ECG_signal)-2)
   
    first_deriv(n) = abs(ECG_signal(n+1)-ECG_signal(n-1));
    second_deriv(n) = abs(ECG_signal(n+2)-2*ECG_signal(n)+ECG_signal(n-2));
    
end

linear_combination = 1.3*first_deriv + 1.1*second_deriv;

% Normalize deriv
min_val = min(first_deriv);
max_val = max(first_deriv);

norm_der1 = -1+(2*(first_deriv-min_val))/(max_val-min_val);

min_val = min(second_deriv);
max_val = max(second_deriv);

norm_der2 = -1+(2*(second_deriv-min_val))/(max_val-min_val);

min_val = min(linear_combination);
max_val = max(linear_combination);

norm_comb = (linear_combination-min_val)/(max_val-min_val);


% Normalize ECG signal
min_val = min(ECG_signal);
max_val = max(ECG_signal);

norm_ECG = -1+(2*(ECG_signal-min_val))/(max_val-min_val);


% Finding the indexes of the R peaks, using a threshold of 0.4 mV.
[~,peak_ind] = findpeaks(norm_ECG,'MinPeakProminence',0.6,'MinPeakDistance',fs*0.2);
[~,peak_ind_1] = findpeaks(norm_der1,'MinPeakProminence',0.4,'MinPeakDistance',fs*0.2);
[~,peak_ind_2] = findpeaks(norm_der2,'MinPeakProminence',0.4,'MinPeakDistance',fs*0.2);
[~,peak_ind_comb] = findpeaks(norm_comb,'MinPeakProminence',0.25,'MinPeakDistance',fs*0.2);
% Coverting indexes vector to time vector



% to be removed!!!
figure(1) 
findpeaks(norm_ECG,'MinPeakProminence',0.6,'MinPeakDistance',fs*0.2);

figure(2)
findpeaks(norm_der1,'MinPeakProminence',0.4,'MinPeakDistance',fs*0.2);

figure(3)
findpeaks(norm_der2,'MinPeakProminence',0.4,'MinPeakDistance',fs*0.2);

figure(4)
findpeaks(norm_comb,'MinPeakProminence',0.25,'MinPeakDistance',fs*0.2);
% to be removed!!!
toc
end

