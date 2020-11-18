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
R012 = Rwave_detection(ECG_305338691_02); %R012 = index of R waves in signal
R021 = Rwave_detection(ECG_308317361_01); %R021 = index of R waves in signal
R022 = Rwave_detection(ECG_308317361_02); %R022 = index of R waves in signal

%% Plots
%Add required plots
% Define time vector 
fs = 1000; 
T = 1/fs; 
%t = (0:length(ECG_signal)-1)*T;


figure(1)
plot(ECG_305338691_01)
hold on
plot(R011,ECG_305338691_01(R011),'o')

figure(2)
plot(ECG_305338691_02)
hold on
plot(R012,ECG_305338691_02(R012),'o')

figure(3)
plot(ECG_308317361_01)
hold on
plot(R021,ECG_308317361_01(R021),'o')

figure(4)
plot(ECG_308317361_02)
hold on
plot(R022,ECG_308317361_02(R022),'o')


%% Save R-wave detections for all signals
%add your IDs. 
save('ID1_ID2.mat','R011','R012','R021','R022');
toc

