function [frame, skelData]=getKinectData(camKinect)
    
frame = camKinect.getColor;
skelData = camKinect.getBodies;