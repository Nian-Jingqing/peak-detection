clc; clear; close all
fs = 1000;
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


signal = ECG_308317361_01;

[filtered_signal] = Filter_sig(signal,47);



NFFT = 2 ^ nextpow2(length(signal));  %compute FFT length depends on the signal length
Y = fft(signal,NFFT);  %compute the fft of the noisy signal
Y = Y(1:NFFT/2);  %we only need a one sided fft plot
Y_abs = 1/NFFT*abs(Y); %calculate the magnitude and normalize the spectrum
f_fft = (0:NFFT/2-1)*fs/NFFT; %scale the frequency axe and calculate the coresponding frequencys

figure(1)
subplot(2,1,1)
plot(f_fft,Y_abs)


NFFT = 2 ^ nextpow2(length(filtered_signal));  %compute FFT length depends on the signal length
Y = fft(filtered_signal,NFFT);  %compute the fft of the noisy signal
Y = Y(1:NFFT/2);  %we only need a one sided fft plot
Y_abs = 1/NFFT*abs(Y); %calculate the magnitude and normalize the spectrum
f_fft = (0:NFFT/2-1)*fs/NFFT; %scale the frequency axe and calculate the coresponding frequencys

subplot(2,1,2)
plot(f_fft,Y_abs)

figure(2)
plot(filtered_signal)

toc
