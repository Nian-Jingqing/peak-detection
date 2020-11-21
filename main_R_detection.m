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
R011 = Rwave_detection2(ECG_305338691_01); %R011 = index of R waves in signal
R012 = Rwave_detection2(ECG_308317361_01); %R012 = index of R waves in signal
R021 = Rwave_detection2(ECG_305338691_02); %R021 = index of R waves in signal
R022 = Rwave_detection2(ECG_308317361_02); %R022 = index of R waves in signal

%% Plots
%Add required plots
% Define time vector 
fs = 1000; 
T = 1/fs; 
t_01 = (0:length(ECG_305338691_01)-1)*T;
t_02 = (0:length(ECG_305338691_02)-1)*T;


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
% Calculating the Heart rate for each heartbeat, by subtracting the time between each consecutive R wave.
HR1 = zeros(1,length(t_01));
for i = 1:length(R011)-1 
    diff = (R011(i+1)-R011(i))*T;
    HR1(R011(i):R011(i+1)) = 1/diff;
end

HR2 = zeros(1,length(t_02));
for i = 1:length(R021)-1 
    diff = (R021(i+1)-R021(i))*T;
    HR2(R021(i):R021(i+1)) = 60/diff;
end

figure(5)
plot(t_01,HR1)


figure(6)
plot(t_02,HR2)


%% Save R-wave detections for all signals
%add your IDs. 
save('ID1_ID2.mat','R011','R012','R021','R022');
toc

