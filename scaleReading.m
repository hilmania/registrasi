clc
clear
close all
serialPort=connectSerial;

fopen(serialPort);
fwrite(serialPort, 'Z');
serBuf=readSerial(serialPort);
readBuf=[];
tic
for k=1:10
    fwrite(serialPort, 'R');
    serBuf=readSerial(serialPort);
    str2num(char(serBuf))
%     sprintf('%skg',char(serBuf))
end
wkt=toc
height=480;
width=640;
centX=width/2;
textPosY=30;
blank0=uint8(255*ones(height,width,3));
basicFrame=writeText(blank0, 'Step on Scale!',...
            centX, textPosY, 'red');
frame= myInsertText(basicFrame,[centX height/2],...
            sprintf('%4.1fkg',188.8),'TextColor','red',...
        'FontSize',155,'AnchorPoint','CenterTop');
        
        imshow(frame)