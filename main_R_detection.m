clc; clear; close all
tic
%import all ecg signals
sig1=load('ECG_308317361_N_01.mat');
ECG_308317361_01 = sig1.sig;

sig2=load('ECG_308317361_N_02.mat');
ECG_308317361_02 = sig2.sig;

sig3=load('ECG_305338691_N_01.mat');
ECG_305338691_01 = sig3.sig;

sig4=load('ECG_305338691_N_02.mat');
ECG_305338691_02 = sig4.sig;

clear sig1 sig2 sig3 sig4 

%% R-wave detection 
%call function to detect R-waves 
[R011,filtered_signal_11] = Rwave_detection(ECG_305338691_01,64); %R011 = index of R waves in signal
[R012,filtered_signal_12] = Rwave_detection(ECG_308317361_01,47); %R012 = index of R waves in signal
[R021,filtered_signal_21] = Rwave_detection(ECG_305338691_02,50); %R021 = index of R waves in signal
[R022,filtered_signal_22] = Rwave_detection(ECG_308317361_02,59); %R022 = index of R waves in signal

%% Plots
% Add required plots
% Define time vector 
fs = 1000; 
T = 1/fs; 
t_01 = (0:length(filtered_signal_11)-1)*T;
t_02 = (0:length(filtered_signal_21)-1)*T;

% First plot - the given ECG signals shown in seconds 12-17

figure(1)
plot(t_01(12*fs:17*fs),filtered_signal_11(12*fs:17*fs))
title('first ECG signal in seconds 12-17')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
axis tight

figure(2)
plot(t_02(12*fs:17*fs),filtered_signal_21(12*fs:17*fs))
title('second ECG signal in seconds 12-17')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
axis([12 17 min(filtered_signal_21) max(filtered_signal_21)])

% Second plot - the given ECG signals, with markers on R waves, shown in seconds 20-25

figure(3)
plot(t_01,filtered_signal_11)
title('first ECG signal in seconds 20-25')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
hold on
plot(T*R011,filtered_signal_11(R011),'o')
hold off
axis([20 25 min(filtered_signal_11) max(filtered_signal_11)])

figure(4)
plot(t_02,filtered_signal_21)
title('second ECG signal in seconds 20-25')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
hold on
plot(T*R021,filtered_signal_21(R021),'o')
hold off
axis([20 25 min(filtered_signal_21) max(filtered_signal_21)])

% Computing heart rate for R011 and R021
% Calculating the Heart rate in BPS, by counting the number of
% beats in each minute and dividing by 60.


R011_times = R011./fs;

HR1 = zeros(1,length(R011_times)-1);

i = 1;
while i < length(HR1) 

    HR1(i) = 1/(R011_times(i+1) - R011_times(i));
    i = i + 1;
    
end


R021_times = R021./fs;

HR2 = zeros(1,length(R021_times)-1);

i = 1;
while i < length(HR2) 

    HR2(i) = 1/(R021_times(i+1) - R021_times(i));
    i = i + 1;
    
end

% Third plot - The heart rate of each subject, at each minute recorded on the ECG signal

figure(5)
plot(R011_times(2:end),HR1)
title('The Heart rate as function of time - signal 1')
xlabel('Time(sec)')
ylabel('Heart Rate (beats per second)')

figure(6)
plot(R021_times(2:end),HR2)
title('The Heart rate as function of time - signal 2')
xlabel('Time(sec)')
ylabel('Heart Rate (beats per second)')

%% Save R-wave detections for all signals
%add your IDs. 
save('305338691_308317361.mat','RN011','RN012','RN021','RN022');
toc



%% delete this

figure(7)
plot(t_01(12*fs:17*fs),filtered_signal_11(12*fs:17*fs))
title('first ECG signal in seconds 12-17')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
axis tight

hold on

plot(t_01(12*fs:17*fs),ECG_305338691_01(12*fs:17*fs))





figure(8)
plot(t_01,filtered_signal_11)
title('first ECG signal in seconds 20-25')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
hold on
plot(T*R011,filtered_signal_11(R011),'o')
hold off

