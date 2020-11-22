clc; clear; close all
tic
%import all ecg signals
sig1=load('ECG_308317361_01.mat');
ECG_308317361_01 = sig1.sig;

sig2=load('ECG_308317361_02.mat');
ECG_308317361_02 = sig2.sig;

sig3=load('ECG_305338691_01.mat');
ECG_305338691_01 = sig3.sig;

sig4=load('ECG_305338691_02.mat');
ECG_305338691_02 = sig4.sig;

clear sig1 sig2 sig3 sig4 

%% R-wave detection 
%call function to detect R-waves 
R011 = Rwave_detection(ECG_305338691_01); %R011 = index of R waves in signal
R012 = Rwave_detection(ECG_308317361_01); %R012 = index of R waves in signal
R021 = Rwave_detection(ECG_305338691_02); %R021 = index of R waves in signal
R022 = Rwave_detection(ECG_308317361_02); %R022 = index of R waves in signal

%% Plots
% Add required plots
% Define time vector 
fs = 1000; 
T = 1/fs; 
t_01 = (0:length(ECG_305338691_01)-1)*T;
t_02 = (0:length(ECG_305338691_02)-1)*T;

% First plot - the given ECG signals shown in seconds 12-17

figure(1)
plot(t_01(12*fs:17*fs),ECG_305338691_01(12*fs:17*fs))
title('first ECG signal in seconds 12-17')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
axis tight

figure(2)
plot(t_02(12*fs:17*fs),ECG_305338691_02(12*fs:17*fs))
title('second ECG signal in seconds 12-17')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
axis([12 17 min(ECG_305338691_02) max(ECG_305338691_02)])

% Second plot - the given ECG signals, with markers on R waves, shown in seconds 20-25

figure(3)
plot(t_01,ECG_305338691_01)
title('first ECG signal in seconds 20-25')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
hold on
plot(T*R011,ECG_305338691_01(R011),'o')
hold off
axis([20 25 min(ECG_305338691_01) max(ECG_305338691_01)])

figure(4)
plot(t_02,ECG_305338691_02)
title('second ECG signal in seconds 20-25')
xlabel('Time (sec)')
ylabel('Voltage (micro-Volt)')
hold on
plot(T*R021,ECG_305338691_02(R021),'o')
hold off
axis([20 25 min(ECG_305338691_02) max(ECG_305338691_02)])

% Computing heart rate for R011 and R021
% Calculating the Heart rate in BPS, by counting the number of
% beats in each minute and dividing by 60.

HR1 = zeros(1,length(t_01));
i = 1;
time_window = 60;
while i < length(HR1) 
    if i<length(HR1)-time_window*fs
        beats = sum((R011>(t_01(i)*fs))&(R011<(t_01(i+time_window*fs)*fs)));
        HR1(i:i+fs*time_window) = beats/time_window;
    else
        beats = sum((R011>(t_01(i)*fs))&(R011<(t_01(end)*fs)));
        HR1(i:end) = (beats*fs)/length(HR1(i:end));
    end
    i= i+fs*time_window;
end


HR2 = zeros(1,length(t_02));
i = 1;
time_window = 60;
while i < length(HR2) 
    if i<length(HR2)-time_window*fs
        beats = sum((R021>(t_02(i)*fs))&(R021<(t_02(i+time_window*fs)*fs)));
        HR2(i:i+fs*time_window) = beats/time_window;
    else
        beats = sum((R021>(t_02(i)*fs))&(R021<(t_02(end)*fs)));
        HR2(i:end) = (beats*fs)/length(HR2(i:end));
    end
    i= i+fs*time_window;
end

% Third plot - The heart rate of each subject, at each minute recorded on the ECG signal

figure(5)
plot(t_01,HR1)
title('The Heart rate as function of time - signal 1')
xlabel('Time(sec)')
ylabel('Heart Rate (beats per second)')

figure(6)
plot(t_02,HR2)
title('The Heart rate as function of time - signal 2')
xlabel('Time(sec)')
ylabel('Heart Rate (beats per second)')

%% Save R-wave detections for all signals
%add your IDs. 
save('305338691_308317361.mat','R011','R012','R021','R022');
toc

