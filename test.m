clear
clc

%import all ecg signals

sig=load('ECG_308317361_01');
sig1 = sig.sig;

fs = 1000;
Ts = 1/fs;


figure; plot(sig1(1:10000))
grid on

rwave = ginput(4);

for i = 1:4
    
  [M,ind] = max(sig1(floor(rwave(i,1))-100:floor(rwave(i,1)+100)));
  rwave(i,1) = ind;
    
end
    
    
plot(1:10000,sig1(1:10000),rwave(:,1),sig1(rwave(:,1)),'O')