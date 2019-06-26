clc
clear
[FileName,PathName] = myuigetfile('C:\imgCard\*.jpg','Select Card Image to Print');
% warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
% javaFrame    = get(gcf,'JavaFrame');
% iconFilePath = 'default_icon_48.png';
% javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));