clc
clear all
close all

testCard=imread('Hilman Ibnu2.jpg');
% testCardParams;
% 
% tniAD=imread('LogoTNIAD.png');
% disjasAD=imread('LogoDisjas.png');
% 
% r0=tniAD(:,:,1)==0;
% g0=tniAD(:,:,2)==0;
% b0=tniAD(:,:,3)==0;
% msk1=r0 & g0 & b0;
% msk1=255*uint8(repmat(msk1,[1 1 3]));
% tniAD=tniAD+msk1;
% tniAD=imresize(tniAD,[125 100]);
% 
% r0=disjasAD(:,:,1)==0;
% g0=disjasAD(:,:,2)==0;
% b0=disjasAD(:,:,3)==0;
% msk2=r0 & g0 & b0;
% msk2=255*uint8(repmat(msk2,[1 1 3]));
% disjasAD=disjasAD+msk2;
% disjasAD=imresize(disjasAD,[125 100]);
% 
% 
% margin=50;
% testCard(5:129,margin:margin+100-1,:)=tniAD;
% testCard(5:129,end-margin-100:end-margin-1,:)=disjasAD;
% testCard(titleY:titleY+115,titleX-250:titleX+250,:)=255;
% %title insertion
% testCard=insertText(testCard,[titleX titleY],...
%     sprintf('Kartu Tes Jasmani TNI AD\n         %s',...
%     date),'FontSize', textTitleSize,'BoxOpacity',0,'AnchorPoint','CenterTop');
% 
% imwrite(testCard,'Hilman Ibnu2.jpg')

hFig=figure;
imshow(testCard)
set(hFig,'Units','centimeters','PaperPositionMode','manual','PaperUnits','centimeters')
papersize = [10.5 14.8];
set(hFig,'PaperSize',papersize)
width = 12;         
height = 18;          

myfiguresize = [-.8, -2.25, width, height];
set(hFig, 'PaperPosition', myfiguresize);
print ('-dwin',hFig)
close(hFig)