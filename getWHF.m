function getWHF(hObject, eventdata, handles)

global camFlag zeroPoint  colKinect depKinect height width...
    hshowCam testCard hshowCard weightStr beephigh beeplow fs shutter...
    nameStr heightStr  colWebcam faceDetector serialPort weight

testCardParams;

%Measuring Weight=====================================================
textPosY=30;
centY=height/2;
centX=width/2;
clearingDisplay_Callback(handles)
sendMsg(handles,'Connecting Scale...')
pause(0.25)
try
    if isequal(serialPort.Status,'closed')
        fopen(serialPort);
        set(handles.scaleStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    fwrite(serialPort, 'Z');
    serBuf=readSerial(serialPort);
    basicFrame=writeText(uint8(255*ones(height,width,3)), 'Step on Scale!', centX, textPosY, 'blue');
    hshowCam=imshow(basicFrame,'Parent',handles.axes2);
    camFlag=1;
    bufWeight=[];
    bufDat=[];
    nBuf=3;
    nMA=5;
    while camFlag
        fwrite(serialPort, 'R');
        serBuf=readSerial(serialPort);
        preWeight=str2double(char(serBuf));
        bufDat=cat(2,bufDat,preWeight);
        if numel(bufDat)==nMA
            weight=str2double(sprintf('%3.1f',mean(bufDat)));
            bufWeight=cat(2,bufWeight,weight);
            if numel(bufWeight)>nBuf
                bufWeight(1)=[];
            end
            bufDat=[];
            weightStr=sprintf('%3.1f kg',weight);
            set(handles.weightString,'string',weightStr);
            frame= myInsertText(basicFrame,[centX height/2],...
                weightStr,'TextColor','red',...
                'FontSize',150,'AnchorPoint','Center');
            set(hshowCam,'CData',frame);
            drawnow
            dataWeight=str2double(sprintf('%3.1f',mean(bufWeight)));
            if dataWeight==weight && numel(bufWeight)==nBuf && dataWeight~=0
                sound(beephigh,fs)
                frame=writeText(uint8(255*ones(height,width,3)), 'Locked!', centX, textPosY, 'blue');
                frame= myInsertText(frame,[centX height/2],...
                weightStr,'TextColor','red',...
                'FontSize',150,'AnchorPoint','Center');
                set(hshowCam,'CData',frame);
                camFlag=0;
                %zeroing height weight
                testCard(HSTextPos(2,2)-33:HSTextPos(2,2)+30,HSTextPos(2,1)-85:HSTextPos(2,1)+85,:)=255;
                testCard=insertText(testCard,HSTextPos(2,:),weightStr,...
                    'FontSize', textHWSize,'BoxOpacity',0,'AnchorPoint','Center');
                set(hshowCard,'Cdata',testCard)
                pause(0.25)
                sound(beeplow,fs)
            end
        end
    end    
catch
    set(handles.weightString,'string','0.0 kg')
    clearingDisplay_Callback(handles);
    sendMsg(handles,'Error or Scale Not Connected!')
    pause(2)
end


%Measuring Height=================================
camFlag=1; 
nBuf=10;
bufDst=[];
lockHeight=0;
bufHeight=[];
kHeight=1;
sensor_region_val=10;
senseRadius=70; 
maskOri=zeros(height, width);
% maskDetection=uint16(maskOri);
% maskDetection(centY-100:centY+100,centX-100:centX+100)=1;
textPosY=30;
testCardParams;
trigger([colKinect depKinect]);
frameDepth = fliplr(getdata(depKinect));
frameCol=fliplr(getdata(colKinect));
hshowCam=imshow(frameCol,'Parent',handles.axes2);
while camFlag
    trigger([colKinect depKinect])
    frameDepth = fliplr((getdata(depKinect)));
%     frameDepth = maskDetection.*fliplr((getdata(depKinect)));
    frameCol=fliplr(getdata(colKinect));
    frameDepth(frameDepth==0)=inf;
    mask=maskOri;
    mindst=min(frameDepth(:));
    mask(frameDepth>=mindst & frameDepth<mindst+40)=1;
    mask=imfill(mask,'holes');
    mask=bwareaopen(mask,1000);
    s = regionprops(mask, 'Centroid');
    centroid = cat(1, s.Centroid);
    numCent=size(centroid,1);
    if numCent>1
        dstCent=zeros(1,numCent);
        for k=1:numCent
            dstCent(k)=norm(centroid(k,:)-[centX centY]);
        end
        [~, ix]=min(dstCent);
        centroid=centroid(ix,:);
    end
    if isempty(centroid)
        area=frameDepth(round(centY-sensor_region_val/2) : round(centY+sensor_region_val/2),...
            round(centX-sensor_region_val/2) : round(centX+sensor_region_val/2));
        area=area(:);
        area(isnan(area) | area==65535)=[];
        absdst=mean(area)/10;
        bufDst=cat(2,bufDst,absdst);
        if numel(bufDst)>nBuf
            bufDst(1)=[];
            dst=mean(bufDst);
            hVal=getHeight(zeroPoint,dst);
            if dst<80 || isnan(hVal)
                set(handles.heightString,'string','Error!');
                frameCol=writeText(frameCol, 'Height Not Detected!', centX, textPosY, 'red');
            else
                set(handles.heightString,'string',sprintf('%2.1f cm', hVal));
                if hVal<1
                    frameCol=writeText(frameCol, 'Standby', centX, textPosY, 'blue');
                elseif ~isnan(hVal)
                    frameCol=writeText(frameCol, 'Height Not Valid!', centX, textPosY, 'blue');
                end
            end
        end
    elseif ~isempty(centroid)
        cx=centroid(1);
        cy=centroid(2);
        cent2core=norm(centroid-[centX centY]);
        if cent2core<senseRadius
            area=frameDepth(round(cy-sensor_region_val/2) : round(cy+sensor_region_val/2),...
                round(cx-sensor_region_val/2) : round(cx+sensor_region_val/2));
            area=area(:);
            area(isnan(area) | area==65535)=[];
            absdst=mean(area)/10;
            bufDst=cat(2,bufDst,absdst);
            if numel(bufDst)>nBuf
                bufDst(1)=[];
                dst=mean(bufDst);
                hVal=getHeight(zeroPoint,dst);
                if dst<80 || isnan(hVal)
                    set(handles.heightString,'string','Error!');
                    frameCol=writeText(frameCol, 'Maximum Height!', centX, textPosY, 'red');
                else
                    bufHeight=cat(2,bufHeight,hVal);
                    if numel(bufHeight)>kHeight*nBuf
                        bufHeight(1)=[];
                        if sum(abs(gradient(bufHeight)))==0 && ~lockHeight
                            lockHeight=1;
                            sound(beephigh,fs);
                            locked_val=mean(bufHeight);
                        end
                    end
                    if lockHeight
                        heightStr=sprintf('%2.1f cm', locked_val);
                        set(handles.heightString,'string',heightStr);
                        frameCol=writeText(frameCol,'Height Locked!', centX, textPosY, 'blue');
                        frameCol=insertShape(frameCol,'Circle', [centX centY senseRadius],...
                            'LineWidth', 2, 'color','green');
                        frameCol=insertShape(frameCol,'FilledCircle', [cx cy sensor_region_val],...
                            'LineWidth', 2, 'color','green');
                        set(hshowCam,'CData',frameCol)
                        %zeroing height weight
                        testCard(HSTextPos(1,2)-33:HSTextPos(1,2)+30,HSTextPos(1,1)-85:HSTextPos(1,1)+85,:)=255;
                        testCard=insertText(testCard,HSTextPos(1,:),sprintf('%2.1f cm', locked_val),...
                            'FontSize', textHWSize,'BoxOpacity',0,'AnchorPoint','Center');
                        set(hshowCard,'CData',testCard);
                        imwrite(testCard,sprintf('%s.jpg',nameStr));
                        camFlag=0;
                        pause(0.25)
                        sound(beeplow,fs)
                    else
                        set(handles.heightString,'string',sprintf('%2.1f cm', hVal));
                        frameCol=writeText(frameCol, 'Valid', centX, textPosY, 'blue');
                    end
                end
            end
            frameCol=insertShape(frameCol,'FilledCircle', [cx cy sensor_region_val],...
                'LineWidth', 2, 'color','green');
        else
            area=frameDepth(round(centY-sensor_region_val/2) : round(centY+sensor_region_val/2),...
                round(centX-sensor_region_val/2) : round(centX+sensor_region_val/2));
            area=area(:);
            area(isnan(area) | area==65535)=[];
            absdst=mean(area)/10;
            bufDst=cat(2,bufDst,absdst);
            if numel(bufDst)>nBuf
                bufDst(1)=[];
                dst=mean(bufDst);
                hVal=getHeight(zeroPoint,dst);
                if dst<80 || isnan(hVal)
                    set(handles.heightString,'string','Error!');
                    frameCol=writeText(frameCol, 'Maximum Height!', centX, textPosY, 'red');
                else
                    set(handles.heightString,'string',sprintf('%2.1f cm', hVal));
                end
                if hVal<1
                    frameCol=writeText(frameCol, 'Standby', centX, textPosY, 'blue');
                elseif ~isnan(hVal)
                    frameCol=writeText(frameCol, 'Height Not Valid!', centX, textPosY, 'blue');
                end
            end
            frameCol=insertShape(frameCol,'FilledCircle', [cx cy sensor_region_val],...
                'LineWidth', 2, 'color','red');
        end
    end
    
    frameCol=insertShape(frameCol,'Circle', [centX centY senseRadius],...
                    'LineWidth', 2, 'color','green');
%     frameCol=insertShape(frameCol,'Rectangle', [centX-100 centY-100 200 200],...
%                     'LineWidth', 2, 'color','red');
    set(hshowCam,'CData',frameCol)
end


%Taking Photo=========================================================
camFlag=1;
nameFace=nameStr;
bufFlag=[];
nBuf=10;
prevBox=[0 0];
trigger(colWebcam);
frameOri=getdata(colWebcam);
frame=imresize(frameOri,0.5);
clearingDisplay_Callback(handles)
hshowCam=imshow(frame,'Parent',handles.axes2);
while camFlag
    trigger(colWebcam);
    frameOri=getdata(colWebcam);
    frame=imresize(frameOri,0.5);
    bbox = step(faceDetector, frame);
    if ~isempty (bbox)
        bbox = bbox(1,:);    
        frame = insertObjectAnnotation(frame,'rectangle',bbox,nameFace);
        currentBox=[round(bbox(1)+bbox(3)/2) round(bbox(2)+bbox(4)/2)];
        dst=norm(prevBox-currentBox);
        if dst<10
            detFlag=1;
        else
            detFlag=0;
        end
        bufFlag=cat(2,bufFlag,detFlag);
        if numel(bufFlag)>nBuf
            bufFlag(1)=[];
            if sum(bufFlag)==nBuf
               x=round(bbox(1)-0.2*bbox(3)); 
               y=round(bbox(2)-0.3*bbox(4));
               w=round(1.4*bbox(4));
               h=round(4/3*w);
               photo=imcrop(frameOri,2*[x y w h]);
               photo=imresize(photo,[hPic wPic]);
               %zeroing photo
               testCard(rowPic:rowPic+hPic-1,colPic:colPic+wPic-1,:)=255;
               %Inserting Photo 
               testCard(rowPic:rowPic+hPic-1,colPic:colPic+wPic-1,:)=photo;
               set(hshowCard,'CData',testCard)               
               camFlag=0;
               sound(shutter,fs)
               imwrite(testCard,sprintf('%s.jpg',nameStr));
            end
        end
        prevBox=currentBox;
    end
    set(hshowCam,'Cdata',frame)
end