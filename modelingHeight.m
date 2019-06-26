clc
clear
close all

% % offset=repmat([-120 0],25,1);
% % posCol=round(posCol/2) + offset;
% camKinect = Kin2('color','depth');
%
% % Create matrices for the images
% frameCol = zeros(540,720,3,'uint8');
% hshow=imshow(frameCol);
% maxf=50;
% ixf=0;
% tic
% while true
%     validData = camKinect.updateData;
%     if validData
%         ixf=ixf+1;%==================
%         if ixf==maxf;
%             break
%         end
%         frameCol = camKinect.getColor;
%         frameDepth = camKinect.getDepth;
%
%
% %         frame(1:2:1080,241:2:1680,:);
%         set(hshow,'CData',frameCol)
%     end
%     drawnow
% end
% toc
% camKinect.delete;


load beepcouple
%start calibration height===============================================
hDep=424;
wDep=512;
hCol=1080;
wCol=1920;
camFlag=1;
sensor_region_val=15;
centDepY=hDep/2;
centDepX=wDep/2;
bufCalib=[];
senseRadius=80;
kCalib=1;
textPosY=30;
bufDst=[];
camKinect = Kin2('color','depth');
[frameCol, frameDepth]=getSingleFrame(camKinect);
frameCol=frameCol(1:2:1080,241:2:1680,:);
hshow1=imshow(frameCol);
% figure;hshow2=imshow(mat2gray(frameDepth));
bufSize=10;
validCount=0;
warmCount=10;
tic
while camFlag
    validData = camKinect.updateData;
    if validData
        validCount=validCount+1;
        [frameCol, frameDepth]=getColorDepth(camKinect);
        [centColX, centColY]=mapDepth2Col(camKinect, [centDepX centDepY]);
        frameCol=frameCol(1:2:1080,241:2:1680,:);
        if centColX~=0 || centColY~=0
            centColX=centColX-120;
            frameCol=insertShape(frameCol,'FilledCircle', [centColX centColY sensor_region_val],...
                'LineWidth', 2, 'color','red');
            frameCol=insertShape(frameCol,'Line', [271 1 375 540; 1 306 720 166],...
                'LineWidth', 1, 'color','red');
            if validCount>warmCount
                frameCol=writeText(frameCol, sprintf('Calibrating Height...(%2.0f%%)',100*(validCount-warmCount)/(bufSize)), 360, textPosY, 'red');
                area=frameDepth(round(centDepY-sensor_region_val/2) : round(centDepY+sensor_region_val/2),...
                    round(centDepX-sensor_region_val/2) : round(centDepX+sensor_region_val/2));
                area=area(:);
                area(area==0)=[];
                absDst=round(mean(area)/10,2);
                bufDst=cat(2,bufDst,absDst);
                if numel(bufDst)==bufSize
                    zeroPoint=round(mean(bufDst),1)
                    frameCol=writeText(frameCol, sprintf('Kinect to Scale: (%3.1fcm)',zeroPoint), 360, 360, 'red');
                    set(hshow1,'CData',frameCol)
                    break
                end
            elseif validCount<=warmCount
                frameCol=writeText(frameCol, sprintf('Warming Up Sensor...(%2.0f%%)',10*round(10*validCount/(warmCount))), 360, textPosY, 'red');
            end
        else
            frameCol=writeText(frameCol, 'Lost Detph Data...', 360, textPosY, 'red');
        end
        set(hshow1,'CData',frameCol)
        %             set(hshow2,'CData',mat2gray(frameDepth))
        drawnow
    end
end
% camKinect.delete;





%Measuring Height=================================
camFlag=1;
nBuf=10;
bufDst=[];
lockHeight=0;
bufHeight=[];
kHeight=1;
textPosY=30;
testCardParams;
[frameCol, frameDepth]=getSingleFrame(camKinect);
maskOri=zeros(size(frameDepth));
frameCol=frameCol(1:2:1080,241:2:1680,:);
hshow=imshow(frameCol);

while camFlag
    validData = camKinect.updateData;
    if validData
%         validCount=validCount+1;if validCount==200; break; end
        [frameCol, frameDepth]=getColorDepth(camKinect);
        frameDepth=medfilt2(frameDepth);
        frameCol=frameCol(1:2:1080,241:2:1680,:);
        [centColX, centColY]=mapDepth2Col(camKinect, [centDepX centDepY]);
        centColX=centColX-120;
        frameDepth(275:424,:)=4000;
        frameDepth(frameDepth==0)=4000;
                mask=maskOri;
        mindst=min(frameDepth(:))
        [x y]=find(frameDepth==mindst);
        mask(frameDepth>=mindst & frameDepth<mindst+80)=1;
%         imshow(mask)
        imshow(frameDepth,[0 4000])
        hold on
        plot(y,x,'r*','markersize',10)
        hold off
        pause(0.1)
        
%         mask=imfill(mask,'holes');
%         mask=bwareaopen(mask,1000);
        
%         s = regionprops(mask, 'Centroid');
%         centroid = cat(1, s.Centroid);
%         numCent=size(centroid,1);
%         if numCent>1
%             dstCent=zeros(1,numCent);
%             for k=1:numCent
%                 dstCent(k)=norm(centroid(k,:)-[centColX centColY]);
%             end
%             [~, ix]=min(dstCent);
%             centroid=centroid(ix,:);
%         end
%         if isempty(centroid)
%             area=frameDepth(round(centDepY-sensor_region_val/2) : round(centDepY+sensor_region_val/2),...
%                 round(centDepX-sensor_region_val/2) : round(centDepX+sensor_region_val/2));
%             area=area(:);
%             area(area==0)=[];
%             absdst=mean(area)/10;
%             bufDst=cat(2,bufDst,absdst);
%             if numel(bufDst)>nBuf
%                 bufDst(1)=[];
%                 dst=mean(bufDst);
%                 hVal=getHeight(zeroPoint,dst);
%                 if dst<50 || isnan(hVal)
%                     set(handles.heightString,'string','Error!');
%                     frameCol=writeText(frameCol, 'Height Not Detected!', centColX, textPosY, 'red');
%                 else
%                     if hVal<1
%                         frameCol=writeText(frameCol, 'Standby', centColX, textPosY, 'blue');
%                     elseif ~isnan(hVal)
%                         frameCol=writeText(frameCol, 'Height Not Valid!', centColX, textPosY, 'blue');
%                     end
%                 end
%             end
%         elseif ~isempty(centroid)
%             cx=centroid(1);
%             cy=centroid(2);
%             cent2core=norm(centroid-[centColX centColY]);
%             if cent2core<senseRadius
%                 area=frameDepth(round(cy-sensor_region_val/2) : round(cy+sensor_region_val/2),...
%                     round(cx-sensor_region_val/2) : round(cx+sensor_region_val/2));
%                 area=area(:);
%                 area(isnan(area) | area==65535)=[];
%                 absdst=mean(area)/10;
%                 bufDst=cat(2,bufDst,absdst);
%                 if numel(bufDst)>nBuf
%                     bufDst(1)=[];
%                     dst=mean(bufDst);
%                     hVal=getHeight(zeroPoint,dst);
%                     if dst<80 || isnan(hVal)
%                         set(handles.heightString,'string','Error!');
%                         frameCol=writeText(frameCol, 'Maximum Height!', centColX, textPosY, 'red');
%                     else
%                         bufHeight=cat(2,bufHeight,hVal);
%                         if numel(bufHeight)>kHeight*nBuf
%                             bufHeight(1)=[];
%                             if sum(abs(gradient(bufHeight)))==0 && ~lockHeight
%                                 lockHeight=1;
%                                 sound(beephigh,fs);
%                                 locked_val=mean(bufHeight);
%                             end
%                         end
%                         if lockHeight
%                             heightStr=sprintf('%2.1f cm', locked_val);
%                             set(handles.heightString,'string',heightStr);
%                             frameCol=writeText(frameCol,'Height Locked!', centColX, textPosY, 'blue');
%                             frameCol=insertShape(frameCol,'Circle', [centColX centColY senseRadius],...
%                                 'LineWidth', 2, 'color','green');
%                             frameCol=insertShape(frameCol,'FilledCircle', [cx cy sensor_region_val],...
%                                 'LineWidth', 2, 'color','green');
%                             set(hshowCam,'CData',frameCol)
%                             %zeroing height weight
%                             testCard(HSTextPos(1,2)-33:HSTextPos(1,2)+30,HSTextPos(1,1)-85:HSTextPos(1,1)+85,:)=255;
%                             testCard=insertText(testCard,HSTextPos(1,:),sprintf('%2.1f cm', locked_val),...
%                                 'FontSize', textHWSize,'BoxOpacity',0,'AnchorPoint','Center');
%                             set(hshowCard,'CData',testCard);
%                             imwrite(testCard,sprintf('%s.jpg',nameStr));
%                             camFlag=0;
%                             pause(0.25)
%                             sound(beeplow,fs)
%                         else
%                             set(handles.heightString,'string',sprintf('%2.1f cm', hVal));
%                             frameCol=writeText(frameCol, 'Valid', centColX, textPosY, 'blue');
%                         end
%                     end
%                 end
%                 frameCol=insertShape(frameCol,'FilledCircle', [cx cy sensor_region_val],...
%                     'LineWidth', 2, 'color','green');
%             else
%                 area=frameDepth(round(centDepY-sensor_region_val/2) : round(centDepY+sensor_region_val/2),...
%                     round(centDepX-sensor_region_val/2) : round(centDepX+sensor_region_val/2));
%                 area=area(:);
%                 area(isnan(area) | area==65535)=[];
%                 absdst=mean(area)/10;
%                 bufDst=cat(2,bufDst,absdst);
%                 if numel(bufDst)>nBuf
%                     bufDst(1)=[];
%                     dst=mean(bufDst);
%                     hVal=getHeight(zeroPoint,dst);
%                     if dst<80 || isnan(hVal)
%                         set(handles.heightString,'string','Error!');
%                         frameCol=writeText(frameCol, 'Maximum Height!', centColX, textPosY, 'red');
%                     end
%                     if hVal<1
%                         frameCol=writeText(frameCol, 'Standby', centColX, textPosY, 'blue');
%                     elseif ~isnan(hVal)
%                         frameCol=writeText(frameCol, 'Height Not Valid!', centColX, textPosY, 'blue');
%                     end
%                 end
%                 frameCol=insertShape(frameCol,'FilledCircle', [cx cy sensor_region_val],...
%                     'LineWidth', 2, 'color','red');
%             end
%         end
%         
%         frameCol=insertShape(frameCol,'Circle', [centColX centColY senseRadius],...
%             'LineWidth', 2, 'color','green');
%         set(hshow,'CData',frameCol)
%         drawnow
    end
end




