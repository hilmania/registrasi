function getF(hObject, eventdata, handles)

global camFlag hshowCam testCard hshowCard fs shutter...
    nameStr colWebcam faceDetector

testCardParams;

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
            end
        end
        prevBox=currentBox;
    end
    set(hshowCam,'Cdata',frame)
end