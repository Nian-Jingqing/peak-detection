function [filtered_peaks] = Rwave_detection(ECG_signal)
% This function receives a ECG signal, and returns a vector that contains the indexes in which the R waves appear in the ECG signal
tic
fs = 1000;

first_deriv = zeros(1,length(ECG_signal));
second_deriv = zeros(1,length(ECG_signal));

for n = 3: (length(ECG_signal)-2)
   
    first_deriv(n) = abs(ECG_signal(n+1)-ECG_signal(n-1));
    second_deriv(n) = abs(ECG_signal(n+2)-2*ECG_signal(n)+ECG_signal(n-2));
    
end

% Normalize
min_val = min(first_deriv);
max_val = max(first_deriv);
norm_first_deriv = (first_deriv-min_val)/(max_val-min_val);

min_val = min(second_deriv);
max_val = max(second_deriv);
norm_second_deriv = (second_deriv-min_val)/(max_val-min_val);

linear_combination = 3*norm_first_deriv + 1.1*norm_second_deriv;


% Finding the indexes of the R peaks, using a threshold of 0.1.
[~,peak_ind_comb] = findpeaks(linear_combination,'MinPeakProminence',0.5,'MinPeakDistance',fs*0.4);
% Coverting indexes vector to time vector


% Checking if 6 out of 8 of next samples reach threshold
filtered_peaks = zeros(1,length(peak_ind_comb));
k=0;
for i = 1:length(peak_ind_comb)
    
    index = peak_ind_comb(i);
    check_vec = linear_combination(index+1:index+8);
    threshold = 0.2;
    
    if sum(check_vec>threshold) >= 6   
        k = k+1;
        filtered_peaks(k) = peak_ind_comb(i);      
    end 
end
filtered_peaks = filtered_peaks(1:k);


% to be removed!!!
figure(1) 
findpeaks(linear_combination,'MinPeakProminence',0.5,'MinPeakDistance',fs*0.4);
% to be removed!!!
toc
end

