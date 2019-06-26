function [x, y, z]=mapDepthCam(camKinect, ptDepth)

ptCam = camKinect.mapDepthPoints2Camera(ptDepth);
x=ptCam(1);
y=ptCam(2);
z=ptCam(3);