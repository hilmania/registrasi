clc
clear all
close all
tic
imaqreset;
height=480;
width=640;
colKinect = videoinput('kinect',1,sprintf('RGB_%dx%d',width,height));
depKinect = videoinput('kinect',2,sprintf('Depth_%dx%d',width,height));
triggerconfig(depKinect,'manual');
triggerconfig(colKinect,'manual');
set(depKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
set(colKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);

colWebcam1 = videoinput('winvideo',2,sprintf('RGB24_%dx%d',width,height));
colWebcam2 = videoinput('winvideo',1,sprintf('RGB24_%dx%d',width,height));
triggerconfig(colWebcam1,'manual');
triggerconfig(colWebcam2,'manual');
set(colWebcam1, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
set(colWebcam2, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
tcreate=toc

% tic
% start([colKinect depKinect colWebcam1 colWebcam2])
% tallstart=toc
% tic
% stop([colKinect depKinect colWebcam1 colWebcam2])
% tallstop=toc