clc
clear
close all

kinect = Kin2('color','depth');

% Create matrices for the images
frameCol = zeros(1080,1920,3,'uint8');
frameDepth = zeros(424,512);
hshow1=imshow(frameCol);
figure;
hshow2=imshow(frameDepth);
maxf=10000;
ixf=0;
tic
while true
    validData = kinect.updateData;
    if validData
        ixf=ixf+1;%==================
        if ixf==maxf;
            break
        end
        frameCol = kinect.getColor;
        frameDepth = kinect.getDepth;
        frameDepth(frameDepth>4000)=4000;
        set(hshow1,'CData',frameCol)
        set(hshow2,'CData',mat2gray(frameDepth))
    end
    drawnow
end
toc
kinect.delete;