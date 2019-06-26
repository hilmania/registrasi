clc
clear all
close all
height=480;
width=640;
imaqreset;
colKinect = videoinput('kinect',3,sprintf('RGB_%dx%d',width,height));
depKinect = videoinput('kinect',4,sprintf('Depth_%dx%d',width,height));
triggerconfig(depKinect,'manual');
triggerconfig(colKinect,'manual');
set(depKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
set(colKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);


start([colKinect depKinect]);
trigger([colKinect depKinect]);
frameDepth = getdata(depKinect);
frameCol=getdata(colKinect);

xyzPoints = depthToPointCloud(frameDepth,depKinect);
alignedColorImage = alignColorToDepth(frameDepth,frameCol,depKinect);

showPointCloud(xyzPoints,alignedColorImage,'VerticalAxis','y','VerticalAxisDir','down');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
stop([depKinect colKinect])







% 
% player = pcplayer(ptCloud.XLimits,ptCloud.YLimits,ptCloud.ZLimits,...
% 	'VerticalAxis','y','VerticalAxisDir','down');
% 
% xlabel(player.Axes,'X (m)');
% ylabel(player.Axes,'Y (m)');
% zlabel(player.Axes,'Z (m)');
% 
% for i = 1:500    
%     trigger([colKinect depKinect]);
%     frameDepth = fliplr(getdata(depKinect));
%     frameCol=fliplr(getdata(colKinect));
%     ptCloud = pcfromkinect(depKinect,frameDepth,frameCol);
%     view(player,ptCloud);
% end




% % Create a System object™ for the color device.
% 
% colorDevice = imaq.VideoDevice('kinect',1)
% % Change the returned type of color image from single to unint8.
% 
% colorDevice.ReturnedDataType = 'uint8';
% % Create a System object for the depth device.
% 
% depthDevice = imaq.VideoDevice('kinect',2)
% % Initialize the camera.
% 
% step(colorDevice);
% step(depthDevice);
% % Load one frame from the device.
% 
% colorImage = step(colorDevice);
% depthImage = step(depthDevice);
% % Extract the point cloud.
% 
% ptCloud = pcfromkinect(depthDevice,depthImage,colorImage);
% % Initialize a point cloud player to visualize 3-D point cloud data. The axis is set appropriately to visualize the point cloud from Kinect.
% 
% player = pcplayer(ptCloud.XLimits,ptCloud.YLimits,ptCloud.ZLimits,...
% 	'VerticalAxis','y','VerticalAxisDir','down');
% 
% xlabel(player.Axes,'X (m)');
% ylabel(player.Axes,'Y (m)');
% zlabel(player.Axes,'Z (m)');
% % Acquire and view 500 frames of live Kinect point cloud data.
% 
% for i = 1:500    
%    colorImage = step(colorDevice);  
%    depthImage = step(depthDevice);
%  
%    ptCloud = pcfromkinect(depthDevice,depthImage,colorImage);
%  
%    view(player,ptCloud);
% end