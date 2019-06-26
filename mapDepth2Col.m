function [colX, colY]=mapDepth2Col(camKinect, depthPoints)

centCol = round(double(camKinect.mapDepthPoints2Color(depthPoints))/2);

colX=centCol(:,1);
colY=centCol(:,2);