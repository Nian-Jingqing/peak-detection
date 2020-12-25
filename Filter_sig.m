function [filtered_signal] = Filter_sig(signal,PLFREQ)
% Filter_sig recieves a signal with breathing noise at 0.5 Hz frequencies,
% and network noise at the given frequency - PLFREQ - and at 2*PLFREQ.
% The function returns the filtered signal, without the noise frequencies.

% Note that this function uses filtfilt() function, in order to overcome
% group delay, by filtering the signal twice - forward and backwards.

% Set sample frequency
fs = 1000;

% Filter with FIR hamming HPF to eliminate baseline wander
hd = HPF;
filtered_signal = filtfilt(hd.Numerator,1,signal);

% Compensating for group delay - DELETE THIS
%delay = mean(grpdelay(hd));
%filtered_signal(1:delay) = [];
%                                DELETE THIS

% Filter with IIR butterworth band stop filter to eliminate breathing frequency (0.5 Hz)
hd1 = breath_filter;
filtered_signal = filtfilt(hd1.sosMatrix,hd1.ScaleValues,filtered_signal);


% Using FIR notch filters to eliminate network noises
filterOrder = 2000;

freqVec1 = [(PLFREQ-1)/(fs/2) , (PLFREQ+1)/(fs/2)] ;
freqVec2 = [(PLFREQ*2-1)/(fs/2) , (PLFREQ*2+1)/(fs/2)] ;


filter1 = fir1(filterOrder,freqVec1,'stop');
filter2 = fir1(filterOrder,freqVec2,'stop');

filtered_signal = filtfilt(filter1,1,filtered_signal);
filtered_signal = filtfilt(filter2,1,filtered_signal);

end

