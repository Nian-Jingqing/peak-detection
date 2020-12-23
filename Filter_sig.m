function [filtered_signal] = Filter_sig(signal,PLFREQ)
% Filter_sig 


% Filter 
hd = HPF;
filtered_signal = filter(hd,signal);

hd1 = breath_filter;
filtered_signal = filter(hd1,filtered_signal);



fs = 1000;
filterOrder = 5000;

freqVec1 = [(PLFREQ-1)/(fs/2) , (PLFREQ+1)/(fs/2)] ;
freqVec2 = [(PLFREQ*2-1)/(fs/2) , (PLFREQ*2+1)/(fs/2)] ;


filter1 = fir1(filterOrder,freqVec1,'stop');
filter2 = fir1(filterOrder,freqVec2,'stop');

filtered_signal = filtfilt(filter1,1,filtered_signal);
filtered_signal = filtfilt(filter2,1,filtered_signal);

end

