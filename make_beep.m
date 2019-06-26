clc
clear
close all
load beepcouple2
mask=linspace(1,0,1.5*fs);
bh=beephigh(2000:2000+numel(mask)-1).*mask';
bh=bh/max(abs(bh));
sound(bh,fs)
pause(2)

bl=beeplow(11000:11000+numel(mask)-1).*mask';
bl=bl./max(abs(bl));
sound(bl,fs)
pause(2)

[y, fsy]=audioread('shutter.wav');
y=(y(:,1)+y(:,2))/2;
y=imresize(y,[44100/48000*numel(y) 1]);
y=y/max(abs(y));

beephigh=bh(6200:end);
beeplow=bl;
shutter=y;


sound(y,fs)
save beepcouple.mat beephigh beeplow shutter fs