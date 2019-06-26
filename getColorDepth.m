function [color, depth]=getColorDepth(camKinect)

color = camKinect.getColor;
depth = camKinect.getDepth;