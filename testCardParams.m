%image parameter

%test Card Size
wIm=820;
hIm=1160;
centWIm =410;
centHIm = 580;
margin=50;
textTitleSize=40; %def 45
textNameSize= 40; %def 60
textHWSize=35; %def 35
textStationSize=25;

%barcode size
hCode=287;
wCode=453;

%photo size
hPic=hCode;
wPic=round(hPic*3/4);

%title position
titleX=centWIm;
titleY=margin-20;

%barcode position
colCode=wIm-wCode-margin;
rowCode=150; 

%photo position
colPic=margin; 
rowPic=rowCode; 

%name Position
nameX=margin-10;
nameY=485;

%rectangle Posisition
rectX=margin;
rectY=600;
rectW=wIm-2*margin;
rectH=hIm-rectY-margin;

%test name position
xLeft=round(rectX+rectW/4);
xRight=round(rectX+3*rectW/4);
yFirst=rectY;
ySecond=yFirst+round(rectH/3);
yThird=ySecond+round(rectH/3);

%height and weight position
HSPos=round([xRight yFirst-rectW/4.6 rectW/4 rectH/3.6]);
HSTextPos=round([HSPos(1)+HSPos(3)/2 HSPos(2)+HSPos(4)/4;...
    HSPos(1)+HSPos(3)/2 HSPos(2)+3*HSPos(4)/4]);