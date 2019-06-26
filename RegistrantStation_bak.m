function varargout = RegistrantStation(varargin)
% REGISTRANTSTATION MATLAB code for RegistrantStation.fig
%      REGISTRANTSTATION, by itself, creates a new REGISTRANTSTATION or raises the existing
%      singleton*.
%
%      H = REGISTRANTSTATION returns the handle to a new REGISTRANTSTATION or the handle to
%      the existing singleton*.
%
%      REGISTRANTSTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTRANTSTATION.M with the given input arguments.
%
%      REGISTRANTSTATION('Property','Value',...) creates a new REGISTRANTSTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RegistrantStation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RegistrantStation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RegistrantStation

% Last Modified by GUIDE v2.5 28-Oct-2015 07:24:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RegistrantStation_OpeningFcn, ...
                   'gui_OutputFcn',  @RegistrantStation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RegistrantStation is made visible.
function RegistrantStation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegistrantStation (see VARARGIN)

% Choose default command line output for RegistrantStation
handles.output = hObject;

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
javaFrame    = get(gcf,'JavaFrame');
iconFilePath = 'logoMetaVision.png';
javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
global templateCard hshowCard testCard colKinect depKinect height width...
    colWebcam1 colWebcam2 faceDetector blank0 blank1 blank2 blank3 blank4...
    blank5 hshowCam zeroPoint nameStr codeStr heightStr weightStr...
    jenisKelamin ageYear idCamF idCamW photo

nameStr ='-';
codeStr ='0123456789128'; 
heightStr ='0.0 cm';
weightStr ='0.0 kg';
ageYear=[];
height=480;
width=640;
jenisKelamin='L';

photo=uint8(255*ones(287,150,3));
blank0=uint8(255*ones(height,width,3));
blank1= insertText(blank0,[width/2 height/2], 'Accesing Camera Height...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank2= insertText(blank0,[width/2 height/2], 'Accesing Camera Face...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank3= insertText(blank0,[width/2 height/2], 'Accesing Camera Scale...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank4= insertText(blank0,[width/2 height/2], 'Accesing Camera...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank5= insertText(blank0,[width/2 height/2], 'Can not Access Camera!','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
zeroPoint=280;

templateCard=imread('templateCard.bmp');
testCard=templateCard;
hshowCard=imshow(templateCard,'Parent',handles.axes1);
hshowCam=imshow(blank0,'Parent',handles.axes2);

faceDetector = vision.CascadeObjectDetector();

idCamF=2;
idCamW=1;
imaqreset;
colKinect = videoinput('kinect',1,sprintf('RGB_%dx%d',width,height));
depKinect = videoinput('kinect',2,sprintf('Depth_%dx%d',width,height));
triggerconfig(depKinect,'manual');
triggerconfig(colKinect,'manual');
set(depKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
set(colKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);

colWebcam1 = videoinput('winvideo',idCamF,sprintf('RGB24_%dx%d',width,height));
colWebcam2 = videoinput('winvideo',idCamW,sprintf('RGB24_%dx%d',width,height));
triggerconfig(colWebcam1,'manual');
triggerconfig(colWebcam2,'manual');
set(colWebcam1, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
set(colWebcam2, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
src=getselectedsource(colWebcam2);
src.FocusMode='manual';
src.Focus=40;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RegistrantStation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RegistrantStation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in newRegistrant.
function newRegistrant_Callback(hObject, eventdata, handles)
global templateCard hshowCard testCard nameStr codeStr heightStr...
    colKinect depKinect colWebcam1 colWebcam2 weightStr ageYear
clearingDisplay_Callback(hObject, eventdata, handles)
testCardParams;
testCard=templateCard;
nameStr ='-';
codeStr ='0123456789128'; 
heightStr ='0.0 cm';
weightStr ='0.0 kg';
ageYear=[];
% zeroing title
testCard(titleY:titleY+115,titleX-250:titleX+250,:)=255;
%title insertion
testCard=insertText(testCard,[titleX titleY],...
    sprintf('Kartu Tes Jasmani TNI AD\n         %s',...
    date),'FontSize', textTitleSize,'BoxOpacity',0,'AnchorPoint','CenterTop');
set(hshowCard,'Cdata',testCard)
set(handles.nameEntry,'string','-');
set(handles.tLahirEntry,'string','-');
set(handles.noRegEntry,'string','-');
set(handles.heightString,'string',heightStr);
set(handles.weightString,'string',weightStr);
uicontrol(handles.nameEntry);
pause(0.1);
start([colKinect depKinect colWebcam1 colWebcam2])


function nameEntry_Callback(hObject, eventdata, handles)
global hshowCard testCard nameStr
nameStr=get(handles.nameEntry,'string');
nStr=numel(nameStr);
testCardParams;
if nStr>21
    set(handles.nameEntry,'string',nameStr(1:21));
    h=warndlg(sprintf('(%d Char) Max 21 Character',nStr),'Over Character');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    javaFrame    = get(h,'JavaFrame');
    iconFilePath = 'logoMetaVision.png';
    javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
    uiwait(h)
    %zeroing name
    testCard(nameY-45:nameY+105,nameX:nameX+547,:)=255;
    % name insertion========================
    testCard=insertText(testCard,[nameX nameY],'(NAMA)',...
    'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftTop');
    uicontrol(handles.nameEntry);
    return
else
    %zeroing name
    testCard(nameY-45:nameY+105,nameX:nameX+547,:)=255;
    % name insertion========================
    testCard=insertText(testCard,[nameX nameY],nameStr,...
        'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftTop');
    set(hshowCard,'Cdata',testCard)
    uicontrol(handles.tLahirEntry);
end


function tLahirEntry_Callback(hObject, eventdata, handles)
global hshowCard lahirStr noRegStr nameStr testCard jenisKelamin ageYear
lahirStr=get(handles.tLahirEntry,'string');
noRegStr=get(handles.noRegEntry,'string');
nStr=numel(lahirStr);
testCardParams;
if nStr~=6 || isnan(str2double(lahirStr))
    set(hObject,'string','');
    h=warndlg(sprintf('%s\n%s','Make Sure Format is Right!','Birth Format: ddmmyy!'),'Wrong Format');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    javaFrame    = get(h,'JavaFrame');
    iconFilePath = 'logoMetaVision.png';
    javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
    uiwait(h)
    uicontrol(handles.tLahirEntry);
else
    currentDay=date;
    currentYear=str2double(currentDay(end-3:end));
    bornYear=str2double(lahirStr(end-1:end));
    if bornYear>currentYear-2000
        bornYear=bornYear+1900;
    else
        bornYear=bornYear+2000;
    end
    ageYear=currentYear-bornYear;
    %zeroing name
    testCard(nameY-45:nameY+105,nameX:nameX+547,:)=255;
    % name insertion========================
    testCard=insertText(testCard,[nameX nameY+30],...
        sprintf('%s\n(%s/%d Thn)', nameStr,jenisKelamin,ageYear),...
    'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
    set(hshowCard,'Cdata',testCard);
    uicontrol(handles.noRegEntry);
end


function noRegEntry_Callback(hObject, eventdata, handles)
global lahirStr noRegStr testCard hshowCard codeStr
lahirStr=get(handles.tLahirEntry,'string');
noRegStr=get(handles.noRegEntry,'string');
nLahirStr=numel(lahirStr);
nNoRegStr=numel(noRegStr);
testCardParams;
if nNoRegStr >6 || isnan(str2double(noRegStr)) || nLahirStr~=6 || isnan(str2double(lahirStr))
    set(handles.noRegEntry,'string','');
    h=warndlg(sprintf('%s\n%s','Make Sure Format is Right!','Required 6 Numeric!'),'Wrong Format');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    javaFrame    = get(h,'JavaFrame');
    iconFilePath = 'logoMetaVision.png';
    javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
    uiwait(h)
    uicontrol(handles.noRegEntry);
elseif (nNoRegStr <6 && ~isnan(str2double(noRegStr))) || (nNoRegStr ==6 || ~isnan(str2double(noRegStr)))
    noRegStr=cat(2,repmat('0',1,6-nNoRegStr),noRegStr);
    set(handles.noRegEntry,'string',noRegStr)
    uicontrol(handles.noRegEntry);
    inputCode=str2double([lahirStr noRegStr]);
    [~, numericCode, ~, barCode] = encodeEAN13(inputCode);
    codeStr=numericCode;
    %zeroing barcode =================
    testCard(rowCode:rowCode+hCode-1,colCode:colCode+wCode-1,:)=255;
    %Inserting Barcode ==========================
    testCard(rowCode:rowCode+hCode-1,colCode:colCode+wCode-1,:)=barCode;
    set(hshowCard,'Cdata',testCard)
    pause(1e-3);
    getWHF(hObject, eventdata, handles)
    
%     calibratingHeight_Callback(hObject, eventdata, handles)
%     camWeight_Callback(hObject, eventdata, handles)
%     camHeight_Callback(hObject, eventdata, handles)
%     camFace_Callback(hObject, eventdata, handles)
%     imwrite(testCard,sprintf('%s.jpg',nameStr));
end


function calibratingHeight_Callback(hObject, eventdata, handles)
global camFlag calib_flag zeroPoint  colKinect depKinect height width...
    blank1 blank5 hshowCam
clearingDisplay_Callback(hObject, eventdata, handles)
hshowCam=imshow(blank1,'Parent',handles.axes2);
pause(1e-3)
camFlag=1; 
load beepcouple.mat
sensor_region_val=10;
try
    calib_flag=1;
    start([colKinect depKinect]);
    trigger([colKinect depKinect]);
    frameDepth = fliplr(getdata(depKinect));
    frameCol=fliplr(getdata(colKinect));
    set(hshowCam,'CData',frameCol);
    hshowCam=imshow(frameCol,'Parent',handles.axes2);
    centY=height/2;
    centX=width/2;
    nBuf=15;
    bufCalib=[];
    senseRadius=75; 
    kCalib=3;
    textPosY=30;
    testCardParams;
    while camFlag
        trigger([colKinect depKinect])
        frameDepth = fliplr((getdata(depKinect)));
        frameCol=fliplr(getdata(colKinect));
        frameDepth(frameDepth==0)=inf;
        if numel(bufCalib)==1
            sound(beephigh,fs)
        end
        set(handles.heightString,'string','---');
        frameCol=writeText(frameCol, 'Calibrating', centX, textPosY, 'red');
        frameCol=insertShape(frameCol,'FilledCircle', [centX centY sensor_region_val],...
            'LineWidth', 2, 'color','red');
        frameCol=insertShape(frameCol,'Circle', [centX centY senseRadius],...
                        'LineWidth', 2, 'color','green');
        area=frameDepth(round(centY-sensor_region_val/2) : round(centY+sensor_region_val/2),...
            round(centX-sensor_region_val/2) : round(centX+sensor_region_val/2));
        area=area(:);
        area(isnan(area) | area==65535)=[];
        absdst=mean(area)/10;
        bufCalib=cat(2,bufCalib,absdst);
        if numel(bufCalib)== kCalib*nBuf
            zeroPoint=mean(bufCalib);
            zeroPointInt=floor(zeroPoint);%===================================
            zeroPointDec=zeroPoint-zeroPointInt;
            zeroPointDec=round(100*zeroPointDec)/100;
            zeroPoint=zeroPointInt+zeroPointDec;
            calib_flag=0;
            bufCalib=[];
            sound(beeplow,fs)
            camFlag=0;
            set(handles.heightString,'string','0.0 cm');
        end
        set(hshowCam,'CData',frameCol)
    end
    stop([depKinect colKinect]);
catch
    set(handles.heightString,'0.0 cm')
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank5,'Parent',handles.axes2);
    pause(2)
end
clearingDisplay_Callback(hObject, eventdata, handles)



% --- Executes on button press in camWeight.
function camWeight_Callback(hObject, eventdata, handles)
global testCard hshowCard camFlag colWebcam2 blank3 blank5 width...
    hshowCam weightStr nameStr colKinect depKinect colWebcam1
    
testCardParams;
load beepcouple
load tableDigit
centX=width/2;
textPosY=30;
clearingDisplay_Callback(hObject, eventdata, handles)
hshowCam=imshow(blank3,'Parent',handles.axes2);
pause(1)
try
    if ~isrunning(colWebcam2)
        start(colWebcam2);
        stop([colKinect depKinect colWebcam1])
    end
    trigger(colWebcam2);
    frame=writeText(getdata(colWebcam2), 'Step on Scale!', centX, textPosY, 'red');
    set(hshowCam,'CData',frame);
    camFlag=1;
    bufWeight=[];
    nBuf=30;
    while camFlag
        trigger(colWebcam2);
        frame=writeText(getdata(colWebcam2), 'Step on Scale!', centX, textPosY, 'red');
        weight=readWeight(frame,segmentMask,tableCode,tableNum);
        bufWeight=cat(2,bufWeight,weight);
        if ~isnan(weight)
            set(handles.weightString,'string',sprintf('%3.1f kg',abs(weight/10)));
            dataWeight=mean(bufWeight);
            if dataWeight==weight && dataWeight~=0
                sound(beephigh,fs)
                weightStr=sprintf('%3.1f kg',abs(weight/10));
                camFlag=0;
                %zeroing height weight
                testCard(HSTextPos(2,2)-33:HSTextPos(2,2)+30,HSTextPos(2,1)-85:HSTextPos(2,1)+85,:)=255;
                testCard=insertText(testCard,HSTextPos(2,:),sprintf('%3.1f kg',abs(weight/10)),...
                    'FontSize', textHWSize,'BoxOpacity',0,'AnchorPoint','Center');
                set(hshowCard,'Cdata',testCard)
                imwrite(testCard,sprintf('%s.jpg',nameStr));
                pause(0.5)
                sound(beeplow,fs)
            end
        else
            set(handles.weightString,'string',' ');
        end
        if numel(bufWeight)>nBuf
            bufWeight(1)=[];        
        end
        set(hshowCam,'CData',frame)
    end
    stop (colWebcam2);
catch
    set(handles.weightString,'string','0.0 kg')
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank5,'Parent',handles.axes2);
    pause(2)
end
clearingDisplay_Callback(hObject, eventdata, handles)




% --- Executes on button press in camHeight.
function camHeight_Callback(hObject, eventdata, handles)
global testCard camFlag zeroPoint hshowCard...
    colKinect depKinect colWebcam1 colWebcam2 height width...
    hshowCam blank1 blank5 heightStr
camFlag=1; 
load beepcouple.mat
clearingDisplay_Callback(hObject, eventdata, handles)
hshowCam=imshow(blank1,'Parent',handles.axes2);
pause(1);
try
    sensor_region_val=10;
    if ~isrunning(colKinect)
        start([colKinect depKinect]);
        stop([colWebcam1 colWebcam2])
    end
    trigger([colKinect depKinect]);
    frameDepth = fliplr(getdata(depKinect));
    frameCol=fliplr(getdata(colKinect));
    set(hshowCam,'CData',frameCol);
    centY=height/2;
    centX=width/2;
    nBuf=15;
    bufDst=[];
    senseRadius=75; %pixel
    lockHeight=0;
    bufHeightRes=[];
    kHeight=2;
    maskOri=zeros(size(frameDepth));
    textPosY=30;
    testCardParams;
    while camFlag
        trigger([colKinect depKinect])
        frameDepth = fliplr((getdata(depKinect)));
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
                    frameCol=writeText(frameCol, 'Maximum Height!', centX, textPosY, 'red');
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
                        bufHeightRes=cat(2,bufHeightRes,hVal);
                        if numel(bufHeightRes)>kHeight*nBuf
                            bufHeightRes(1)=[];
                            if sum(abs(gradient(bufHeightRes)))==0 && ~lockHeight
                                lockHeight=1;
                                sound(beephigh,fs);
                                locked_val=mean(bufHeightRes);
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
                            pause(0.5)
                            sound(beeplow,fs)
                            camFlag=0;
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
        set(hshowCam,'CData',frameCol)
    end
    stop([depKinect colKinect]);
catch
    set(handles.heightString,'string','0.0 cm')
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank5,'Parent',handles.axes2);
    pause(2)
end
clearingDisplay_Callback(hObject, eventdata, handles)

% --- Executes on button press in camFace.
function camFace_Callback(hObject, eventdata, handles)
global testCard hshowCard camFlag colWebcam1 faceDetector blank2...
    hshowCam nameStr colKinect depKinect colWebcam2 blank5 photo
nameFace=nameStr;
testCardParams;
load beepcouple.mat
clearingDisplay_Callback(hObject, eventdata, handles)
hshowCam=imshow(blank2,'Parent',handles.axes2);
pause(1)
try
    if ~isrunning(colWebcam1)
        start(colWebcam1);
        stop([colKinect depKinect colWebcam2])
    end
    trigger(colWebcam1);
    frameOri=getdata(colWebcam1);
    frame=imresize(frameOri,0.5);
    hshow=imshow(frame,'Parent',handles.axes2);
    camFlag=1;
    bufFlag=[];
    nBuf=30;
    prevBox=[0 0];
    while camFlag
        trigger(colWebcam1);
        frameOri=getdata(colWebcam1);
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
        set(hshow,'Cdata',frame)
    end
    stop (colWebcam1);
catch
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank5,'Parent',handles.axes2);
    pause(2)
end
clearingDisplay_Callback(hObject, eventdata, handles)


% --- Executes on button press in printCard.
function printCard_Callback(hObject, eventdata, handles)
global lahirStr testCard nameStr codeStr heightStr weightStr jenisKelamin ageYear
imwrite(testCard,sprintf('%s.jpg',nameStr));
hFig=figure;
imshow(testCard)
set(hFig,'Units','centimeters','PaperPositionMode','manual','PaperUnits','centimeters')
papersize = [10.5 14.8];
set(hFig,'PaperSize',papersize)
width = 12;         
height = 18; 
myfiguresize = [-0.8, -2.15, width, height];
set(hFig, 'PaperPosition', myfiguresize);
print ('-dwin',hFig)
close(hFig)
BMI=str2double(weightStr(1:end-3))/(str2double(heightStr(1:end-3))/100)^2
% nameStr 
% codeStr 
% heightStr 
% weightStr
% jenisKelamin 
% ageYear

%block code for insert data to database

%initiate container for each test participant
conn = OpenConnection();
tableCardTest = 'disjas_card_test';
listColumnCard = GetColumnTable(conn,tableCardTest);
valueCard = {'',codeStr,'','','','','','',''};
InsertData(conn, listColumnCard, valueCard, tableCardTest);

%init table disjas_master_user
tableMasterUser = 'disjas_master_user';
listColumnUser = GetColumnTable(conn,tableMasterUser);
valueUser = {codeStr, nameStr, '', heightStr, weightStr, lahirStr, jenisKelamin, ageYear};
InsertData(conn, listColumnUser, valueUser, tableMasterUser);

% --- Executes on button press in stopCam.
function stopCam_Callback(hObject, eventdata, handles)
global camFlag
camFlag=0;


% --- Executes on button press in reInitial.
function reInitial_Callback(hObject, eventdata, handles)
global templateCard hshowCard testCard colKinect depKinect height width...
    colWebcam1 colWebcam2 blank0 hshowCam nameStr...
    codeStr heightStr weightStr ageYear idCamF idCamW
cla(handles.axes1,'reset')
set(handles.axes1,'XTick',[],'YTick',[],'ZTick',[],'Xcolor',[1 1 1],'Ycolor',[1 1 1],'Zcolor',[1 1 1])
cla(handles.axes2,'reset')
set(handles.axes2,'XTick',[],'YTick',[],'ZTick',[],'Xcolor',[1 1 1],'Ycolor',[1 1 1],'Zcolor',[1 1 1])

blank0=uint8(255*ones(height,width,3));
initBlank1= insertText(blank0,[width/2 height/2], sprintf('%s\n%s',...
    'Re-Initializing Camera.','         Please Wait!'),'TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
initBlank2= insertText(blank0,[width/2 height/2], sprintf('%s\n%s',...
    'Initialization Done.','   Camera Ready!'),'TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
initBlank3= insertText(blank0,[width/2 height/2], sprintf('%s\n%s',...
    'Failed to Initialize!','   Wrong Cam ID'),'TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
templateCard=imread('templateCard.bmp');
testCard=templateCard;
hshowCard=imshow(testCard,'Parent',handles.axes1);
hshowCam=imshow(initBlank1,'Parent',handles.axes2);

% testCardParams;
height=480;
width=640;
testCard=templateCard;
nameStr ='-';
codeStr ='0123456789128'; 
heightStr ='0.0 cm';
weightStr ='0.0 kg';
ageYear=[];
set(hshowCard,'Cdata',testCard)
set(handles.nameEntry,'string','-');
set(handles.tLahirEntry,'string','-');
set(handles.noRegEntry,'string','-');
set(handles.heightString,'string',heightStr);
set(handles.weightString,'string',weightStr);

idCamF=str2double(get(handles.idCamF,'string'));
idCamW=str2double(get(handles.idCamW,'string'));
imaqreset;
try
    colKinect = videoinput('kinect',1,sprintf('RGB_%dx%d',width,height));
    depKinect = videoinput('kinect',2,sprintf('Depth_%dx%d',width,height));
    triggerconfig(depKinect,'manual');
    triggerconfig(colKinect,'manual');
    set(depKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
    set(colKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);

    colWebcam1 = videoinput('winvideo',idCamF,sprintf('RGB24_%dx%d',width,height));
    colWebcam2 = videoinput('winvideo',idCamW,sprintf('RGB24_%dx%d',width,height));
    triggerconfig(colWebcam1,'manual');
    triggerconfig(colWebcam2,'manual');
    set(colWebcam1, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
    set(colWebcam2, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
    src=getselectedsource(colWebcam2);
    src.FocusMode='manual';
    src.Focus=40;
    set(hshowCam,'CData',initBlank2);
    pause(1)
catch
    set(hshowCam,'CData',initBlank3);
    pause(3)
end
clearingDisplay_Callback(hObject, eventdata, handles)



% --- Executes on button press in testCam.
function testCam_Callback(hObject, eventdata, handles)
global colWebcam1 colWebcam2 colKinect depKinect blank0
if isrunning(colWebcam1) || isrunning(colWebcam2) || isrunning(colKinect) || isrunning(depKinect)
    stop([colWebcam1 colWebcam2 colKinect depKinect])
end
lst=webcamlist;
N=length(lst);
allFrame={};
for k=1:N
    cam=webcam(k);
    im=snapshot(cam);
    im=imresize(im,[480 640]);
    im = insertText(im,[320 240],...
            sprintf('CamID: %d',k),'TextColor','blue',...
            'FontSize',72,'AnchorPoint','Center');
    allFrame{k}=im;
end
blankFrame=uint8(randi([0 255],size(im)));
if N==1
    finalFrame=allFrame;
elseif N==2
    finalFrame=[allFrame{1} allFrame{2}; blankFrame blankFrame];
elseif N==3
    finalFrame=[allFrame{1} allFrame{2}; blankFrame blankFrame];
elseif N==4
    finalFrame=[allFrame{1} allFrame{2}; allFrame{3} allFrame{4}];
else
    finalFrame=insertText(zeros(size(im)),[320 240],...
            'Too Many Cameras!','TextColor','blue',...
            'FontSize',50,'AnchorPoint','Center');
    imshow(finalFrame,'Parent',handles.axes2);
    pause(2)
    finalFrame=blank0;
end
imshow(finalFrame,'Parent',handles.axes2);

% --- Executes on button press in editCard.
function editCard_Callback(hObject, eventdata, handles)
global testCard hshowCard
[file, path, flag]=uigetfile('*.jpg','Choose Card to Edit!');
if flag
    testCard=imread([path file]);
    set(hshowCard,'CData',testCard)
end


function clearingDisplay_Callback(hObject, eventdata, handles)
cla(handles.axes2,'reset')
set(handles.axes2,'XTick',[],'YTick',[],'ZTick',[],'Xcolor',[1 1 1],'Ycolor',[1 1 1],'Zcolor',[1 1 1])


% --- Executes during object creation, after setting all properties.
function nameEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'Backgroundcolor'), get(0,'defaultUicontrolBackgroundcolor'))
    set(hObject,'Backgroundcolor','white');
end


% --- Executes during object creation, after setting all properties.
function tLahirEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLahirEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'Backgroundcolor'), get(0,'defaultUicontrolBackgroundcolor'))
    set(hObject,'Backgroundcolor','white');
end



% --- Executes during object creation, after setting all properties.
function noRegEntry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noRegEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'Backgroundcolor'), get(0,'defaultUicontrolBackgroundcolor'))
    set(hObject,'Backgroundcolor','white');
end



function heightString_Callback(hObject, eventdata, handles)
% hObject    handle to heightString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heightString as text
%        str2double(get(hObject,'String')) returns contents of heightString as a double


% --- Executes during object creation, after setting all properties.
function heightString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heightString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'Backgroundcolor'), get(0,'defaultUicontrolBackgroundcolor'))
    set(hObject,'Backgroundcolor','white');
end



function weightString_Callback(hObject, eventdata, handles)
% hObject    handle to weightString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weightString as text
%        str2double(get(hObject,'String')) returns contents of weightString as a double


% --- Executes during object creation, after setting all properties.
function weightString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weightString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'Backgroundcolor'), get(0,'defaultUicontrolBackgroundcolor'))
    set(hObject,'Backgroundcolor','white');
end



% --- Executes on button press in kelPria.
function kelPria_Callback(hObject, eventdata, handles)
global jenisKelamin nameStr testCard hshowCard ageYear
testCardParams;
togVal=get(handles.kelPria,'value');
if togVal==1
    set(handles.kelWanita,'value',0);
    jenisKelamin='L';
else
    set(handles.kelWanita,'value',1);
    jenisKelamin='P';
end
%zeroing name
testCard(nameY-45:nameY+105,nameX:nameX+547,:)=255;
% name insertion========================
testCard=insertText(testCard,[nameX nameY+30],...
    sprintf('%s\n(%s/%d Thn)', nameStr,jenisKelamin,ageYear),...
    'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
set(hshowCard,'Cdata',testCard);
uicontrol(handles.nameEntry);

% Hint: get(hObject,'Value') returns toggle state of kelPria


% --- Executes on button press in kelWanita.
function kelWanita_Callback(hObject, eventdata, handles)
global jenisKelamin nameStr testCard hshowCard ageYear
testCardParams;
togVal=get(handles.kelWanita,'value');
if togVal==1
    set(handles.kelPria,'value',0);
    jenisKelamin='P';
%     nameEntry_Callback(hObject, eventdata, handles)
else
    set(handles.kelPria,'value',1);
    jenisKelamin='L';
end
%zeroing name
testCard(nameY-45:nameY+105,nameX:nameX+547,:)=255;
% name insertion========================
testCard=insertText(testCard,[nameX nameY+30],...
    sprintf('%s\n(%s/%d Thn)', nameStr,jenisKelamin,ageYear),...
    'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
set(hshowCard,'Cdata',testCard);

uicontrol(handles.nameEntry);
% Hint: get(hObject,'Value') returns toggle state of kelWanita


function idCamW_Callback(hObject, eventdata, handles)
% hObject    handle to idCamW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of idCamW as text
%        str2double(get(hObject,'String')) returns contents of idCamW as a double


% --- Executes during object creation, after setting all properties.
function idCamW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to idCamW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function idCamF_Callback(hObject, eventdata, handles)
% hObject    handle to idCamF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of idCamF as text
%        str2double(get(hObject,'String')) returns contents of idCamF as a double


% --- Executes during object creation, after setting all properties.
function idCamF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to idCamF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



