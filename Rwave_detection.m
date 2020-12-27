function [R_peaks,filtered_signal] = Rwave_detection(ECG_signal,PLFREQ)
% This function receives an ECG signal, and returns a vector that contains the indexes in which the R waves appear in the ECG signal.
% in order to do so, the function computes the first derivative of the
% signal, compares it to a preset threshold and compares the suspect
% R-waves to the original signal's peaks.

filtered_signal = Filter_sig(ECG_signal,PLFREQ);

% Set sample frequency
fs = 1000;

% Compute first derivative
% First allocate derivative vector to improve runtime
first_deriv = zeros(1,length(filtered_signal));

for n = 3: (length(filtered_signal)-2) 
    
    first_deriv(n) = (-2)*filtered_signal(n-2)-filtered_signal(n-1)+filtered_signal(n+1)+2*filtered_signal(n+2);
    
end

% Normalize the derivative to a scale of 0-1
min_val = min(first_deriv);
max_val = max(first_deriv);
norm_first_deriv = (first_deriv-min_val)/(max_val-min_val);

% Find mean slope to determine slope threshold
mean_slope = mean(norm_first_deriv);
slope_threshold = 1.13*mean_slope;

% Comparing the derivative to the threshold in order to find QRS complexes
i=1;
Min_Distance = fs*0.2; % Setting a time window of 0.2 sec, between each QRS identification
QRS_comp = zeros(1,length(filtered_signal));
k=0;
while i<(length(norm_first_deriv))
    
    if norm_first_deriv(i) > slope_threshold
        % If the slope reaches treshold, save index and jump 0.2 seconds forward
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
% of the maximum point in a window of 0.25 seconds to each direction
window = 0.15*fs;

for i = 1:length(QRS_comp)
    
    index = QRS_comp(i);
    
    if (index>window) && (index<(length(filtered_signal)-window))
        
        check_vec = filtered_signal(index-window:index+window);
        [~,max_ind] = max(check_vec);
        ind_change = max_ind-(window+1);
        QRS_comp(i)= index+ind_change;
        
    end
end


window = 0.32*fs;

for i = 1:length(QRS_comp)
    
    index = QRS_comp(i);
    
    if (index>window) && (index<(length(filtered_signal)-window))
        
        check_vec = filtered_signal(index-window:index+window);
        [~,max_ind] = max(check_vec);
        ind_change = max_ind-(window+1);
        QRS_comp(i)= index+ind_change;
        
    end
end

window = 0.2*fs;

for i = 1:length(QRS_comp)
    
    index = QRS_comp(i);
    
    if (index>window) && (index<(length(filtered_signal)-window))
        
        check_vec = filtered_signal(index-window:index+window);
        [~,max_ind] = max(check_vec);
        ind_change = max_ind-(window+1);
        QRS_comp(i)= index+ind_change;
        
    end
end


% Delete replicated peaks if exsists
R_peaks = unique(QRS_comp);

% Finding the original signal's peak indexes, and comparing it to the indexes we found
% Normalize the original signal to a scale of 0-1
min_val = min(filtered_signal);
max_val = max(filtered_signal);
ECG_signal_norm = (filtered_signal-min_val)/(max_val-min_val);



end
