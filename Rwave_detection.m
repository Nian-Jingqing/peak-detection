function [filtered_peaks] = Rwave_detection(ECG_signal)
% This function receives a ECG signal, and returns a vector that contains the indexes in which the R waves appear in the ECG signal.
% in order to do so, the function uses **************
tic
% Set sample frequency
fs = 1000;

% Compute first and second derivative
% First allocate derivative vectors to improve runtime
first_deriv = zeros(1,length(ECG_signal));
second_deriv = zeros(1,length(ECG_signal));

for n = 3: (length(ECG_signal)-2)
   
    first_deriv(n) = abs(ECG_signal(n+1)-ECG_signal(n-1));
    second_deriv(n) = abs(ECG_signal(n+2)-2*ECG_signal(n)+ECG_signal(n-2));
 
end

% Normalize the derivatives to a scale of 0-1
min_val = min(first_deriv);
max_val = max(first_deriv);
norm_first_deriv = (first_deriv-min_val)/(max_val-min_val);

min_val = min(second_deriv);
max_val = max(second_deriv);
norm_second_deriv = (second_deriv-min_val)/(max_val-min_val);

linear_combination = 3*norm_first_deriv + 1.1*norm_second_deriv;


% Finding the indexes of the R peaks, using a minimum prominence 0f 0.6 and a minimum distance 0f 0.4 seconds
[~,peak_ind] = findpeaks(linear_combination,'MinPeakProminence',0.6,'MinPeakDistance',fs*0.4);

% Checking if 6 out of 8 of surrounding samples reach threshold
% Allocating index vector to improve runtime
filtered_peaks = zeros(1,length(peak_ind));
k=0;
for i = 1:length(peak_ind)
    
    index = peak_ind(i);
    check_vec = linear_combination(index-4:index+4);
    threshold = 0.2;
    
    if sum(check_vec>threshold) >= 7   
        k = k+1;
        filtered_peaks(k) = peak_ind(i);      
    end 
end

% Cut unnecessary zeros out of the vector
filtered_peaks = filtered_peaks(1:k);

% In order to adjust the indexes to the peak exactly, we change it to the index
% of the maximum point in a window of 350 samples to each direction
window = 350;
for i = 1:length(filtered_peaks)
    
    index = filtered_peaks(i);
    
    if (index>window) && (index<(length(ECG_signal)-window))
        check_vec = ECG_signal(index-window:index+window);
        [~,max_ind] = max(check_vec);
        ind_change = max_ind-(window+1);
        filtered_peaks(i)= index+ind_change;
        
    end
end

% Delete replicated peaks if exsists
filtered_peaks = unique(filtered_peaks);

toc
end

