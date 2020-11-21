function [R_peaks] = Rwave_detection2(ECG_signal)
% This function receives a ECG signal, and returns a vector that contains the indexes in which the R waves appear in the ECG signal.
% in order to do so, the function uses **************
tic
% Set sample frequency
fs = 1000;

% Compute first derivative
% First allocate derivative vector to improve runtime
first_deriv = zeros(1,length(ECG_signal));

for n = 3: (length(ECG_signal)-2)
   
    first_deriv(n) = (-2)*ECG_signal(n-2)-ECG_signal(n-1)+ECG_signal(n+1)+2*ECG_signal(n+2);
 
end

% Normalize the derivative to a scale of 0-1
min_val = min(first_deriv);
max_val = max(first_deriv);
norm_first_deriv = (first_deriv-min_val)/(max_val-min_val);

% Find maximum slope to determine slope threshold


%max_points = findpeaks(first_deriv,'NPeaks',round(length(ECG_signal)*0.015),'SortStr','descend','MinPeakDistance',fs);
%max_slope = max_points(round(end/2));
mean_slope = mean(norm_first_deriv);
slope_threshold = 1.1*mean_slope;

i=1;
Min_Distance = fs*0.2;
QRS_comp = zeros(1,length(ECG_signal));
k=0;
while i<(length(norm_first_deriv))
    
    if norm_first_deriv(i) > slope_threshold
        % If the slope reaches treshold, save index and jump 0.2 second forward
        k = k+1;
        QRS_comp(k) = i;
        i = i + Min_Distance;
    else
        i = i+1;
    end
end

% Cut unnecessary zeros out of the vector
QRS_comp = QRS_comp(1:k);

% In order to adjust the indexes to the peak exactly, we change it to the index
% of the maximum point in a window of 350 samples to each direction
window = 0.25*fs;

for i = 1:length(QRS_comp)
    
    index = QRS_comp(i);
    
    if (index>window) && (index<(length(ECG_signal)-window))
        
        check_vec = ECG_signal(index-window:index+window);
        [~,max_ind] = max(check_vec);
        ind_change = max_ind-(window+1);
        QRS_comp(i)= index+ind_change;
        
    end
end

% Delete replicated peaks if exsists
QRS_comp = unique(QRS_comp);


% Normalize the original signal to a scale of 0-1
min_val = min(ECG_signal);
max_val = max(ECG_signal);
ECG_signal_norm = (ECG_signal-min_val)/(max_val-min_val);

% Finding the peaks of the original signal
 [~,ECG_peaks] = findpeaks(ECG_signal_norm,'MinPeakProminence',0.3,'MinPeakDistance',fs*0.3);

R_peaks = intersect(QRS_comp,ECG_peaks);

toc
end
