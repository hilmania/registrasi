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

% Last Modified by GUIDE v2.5 09-Dec-2015 06:37:26

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
addpath('DataAPI');

% %initial driver mysql
% addpath('DatabaseAPI');
% drivername = 'mysql-connector-java-5.0.8-bin.jar';
% javaaddpath(drivername);

global templateCard hshowCard testCard colKinect depKinect height width...
    colWebcam serialPort faceDetector blank0 blank1 blank2 blank3...
    blank4 hshowCam zeroPoint nameStr codeStr heightStr weightStr...
    jenisKelamin ageYear idCamF photo tensiStr weight beephigh beeplow...
    shutter fs %#ok<NUSED>

% % initiate container for each test participant
% initConn = OpenConnection();

% if isconnection(initConn)
%     % init table disjas_master_test
%     tableName = 'disjas_master_test';
%     lastIdTest = RetrieveIdMasterTest(initConn);
%     tanggal = GetDate(num2str(lastIdTest{1}));
%     
%     currentDate = date;
%     
%     if strcmp(tanggal, currentDate)
%         display('sama');
%     else
%         listColumnTest = GetColumnTable(initConn,tableName);
%         now = date;
%         insertColumn={};
%         for i=1:2
%             insertColumn{i}=listColumnTest{i+1};
%         end
%         valueTest = {now,'Bandung'};
%         InsertData(initConn, insertColumn, valueTest, tableName);
%     end
% else
%     display('Not Connected!');
% end
% ======================================================
tgl = date;
tempat = 'Bandung';
nama_kegiatan = 'Tes Kesegaran';

[flag, ~] = GarjasCreateTest(tgl, tempat, nama_kegiatan)
if flag == 1 
    display('Master test created!');
end

load beepcouple.mat
nameStr ='-';
codeStr ='0123456789128'; 
heightStr ='0.0 cm';
weightStr ='0.0 kg';
weight=0;
ageYear=[];
height=480;
width=640;
jenisKelamin='L';
tensiStr=[];

photo=uint8(255*ones(287,165,3));
blank0=uint8(255*ones(height,width,3));
blank1= insertText(blank0,[width/2 height/2], 'Connecting Camera Height...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank2= insertText(blank0,[width/2 height/2], 'Connecting Camera Face...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank3= insertText(blank0,[width/2 height/2], 'Connecting Camera...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank4= insertText(blank0,[width/2 height/2], 'Camera Not Connected!','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
zeroPoint=280;

templateCard=imread('templateCard.bmp');
testCard=templateCard;
hshowCard=imshow(templateCard,'Parent',handles.axes1);
hshowCam=imshow(blank0,'Parent',handles.axes2);

faceDetector = vision.CascadeObjectDetector();
try
    imaqreset;
    idCamF=findC920ID;
    serialPort=connectSerial;
    colWebcam = videoinput('winvideo',idCamF,sprintf('RGB24_%dx%d',width,height));
    triggerconfig(colWebcam,'manual');
    set(colWebcam, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
    colKinect = videoinput('kinect',1,sprintf('RGB_%dx%d',width,height));
    depKinect = videoinput('kinect',2,sprintf('Depth_%dx%d',width,height));
    triggerconfig(depKinect,'manual');
    triggerconfig(colKinect,'manual');
    set(depKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
    set(colKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
catch
    idCamF=[];%===============
    colKinect = [];
    depKinect = [];    
    colWebcam = [];
end
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
    colKinect depKinect colWebcam weightStr ageYear tensiStr...
    %blank0 height width
clearingDisplay_Callback(hObject, eventdata, handles)
testCardParams;
testCard=templateCard;
nameStr ='-';
codeStr ='0123456789128'; 
heightStr ='0.0 cm';
weightStr ='0.0 kg';
ageYear=[];
tensiStr=[];
% zeroing title
testCard(titleY:titleY+115,titleX-265:titleX+265,:)=255;
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
pause(1e-3)
if ~isrunning(colKinect)
     start(colKinect);
end
if ~isrunning(depKinect)
    start(depKinect);
end
if isrunning(colKinect) && isrunning(depKinect)
    set(handles.chStatus,'BackgroundColor','green','ForegroundColor','red');
end
if ~isrunning(colWebcam)
     start(colWebcam)
     set(handles.cfStatus,'BackgroundColor','green','ForegroundColor','red');
end
% conn = OpenConnection();
% flag = CheckConnection(conn);
% if flag
%    set(handles.conStatus,'BackgroundColor','green','ForegroundColor','red');  
% end

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
global hshowCard lahirStr noRegStr nameStr testCard jenisKelamin ageYear tensiStr
lahirStr=get(handles.tLahirEntry,'string');
noRegStr=get(handles.noRegEntry,'string');
ix=find(lahirStr == '/');
tensiStr=[];
if ~isempty(ix)
    tensiStr=lahirStr(ix(1)+1:end);
    lahirStr=lahirStr(1:ix(1)-1);
end
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
    bornDate=str2double(lahirStr(1:2));
    bornMonth=str2double(lahirStr(3:4));
    bornYear=str2double(lahirStr(5:6));
    currentDay=date;
    currentYear=str2double(currentDay(end-3:end));
    if bornYear>currentYear-2000
        bornYear=bornYear+1900;
    else
        bornYear=bornYear+2000;
    end
    age = calculateAge([bornDate bornMonth bornYear]);
    ageYear=age(1);
    
    %zeroing name
    testCard(nameY-45:nameY+105,nameX:nameX+547,:)=255;
    % name insertion========================
    if ~isempty(tensiStr)
        testCard=insertText(testCard,[nameX nameY+30],...
            sprintf('%s\n(%s/%dThn; Tensi %s)', nameStr,jenisKelamin,ageYear,tensiStr),...
        'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
    else
        testCard=insertText(testCard,[nameX nameY+30],...
            sprintf('%s\n(%s/%dThn)', nameStr,jenisKelamin,ageYear),...
        'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
    end
    set(hshowCard,'Cdata',testCard);
    uicontrol(handles.noRegEntry);
end


function noRegEntry_Callback(hObject, eventdata, handles)
global lahirStr noRegStr testCard hshowCard codeStr blank4 camFlag
lahirStr=get(handles.tLahirEntry,'string');
ix=find(lahirStr == '/');
if ~isempty(ix)
    lahirStr=lahirStr(1:ix(1)-1);
end
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
    drawnow
    try
        getWHF(hObject, eventdata, handles)
    catch
        set(handles.chStatus,'BackgroundColor','yellow','ForegroundColor','black');
        set(handles.cfStatus,'BackgroundColor','yellow','ForegroundColor','black');
        set(handles.scaleStatus,'BackgroundColor','yellow','ForegroundColor','black');
        imshow(blank4,'Parent',handles.axes2)
        pause(3)
        clearingDisplay_Callback(hObject, eventdata, handles)
    end
end


function calibratingHeight_Callback(hObject, eventdata, handles)
global camFlag calib_flag zeroPoint  colKinect depKinect height width...
    blank1 blank4 hshowCam beephigh beeplow fs
clearingDisplay_Callback(hObject, eventdata, handles)
hshowCam=imshow(blank1,'Parent',handles.axes2);
pause(1e-3)
camFlag=1; 
sensor_region_val=10;
try
    calib_flag=1;
    if ~isrunning(colKinect)
        start(colKinect);
    end
    if ~isrunning(depKinect)
        start(depKinect);
    end
    if isrunning(colKinect) && isrunning(depKinect)
        set(handles.chStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    trigger([colKinect depKinect]);
    frameDepth = fliplr(getdata(depKinect));
    frameCol=fliplr(getdata(colKinect));
    set(hshowCam,'CData',frameCol);
    hshowCam=imshow(frameCol,'Parent',handles.axes2);
    centY=height/2;
    centX=width/2;
    nBuf=15;
    bufCalib=[];
    senseRadius=65; 
    kCalib=1;
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
        absdst=mean(area)/10; %resulting cm
        bufCalib=cat(2,bufCalib,absdst);
        if numel(bufCalib)== kCalib*nBuf
            zeroPoint=mean(bufCalib);
            calib_flag=0;
            bufCalib=[];
            sound(beeplow,fs)
            camFlag=0;
            set(handles.heightString,'string','0.0 cm');
        end
        set(hshowCam,'CData',frameCol)
    end
catch
    set(handles.chStatus,'BackgroundColor','yellow','ForegroundColor','black');
    set(handles.heightString,'0.0 cm')
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank4,'Parent',handles.axes2);
    pause(3)
end
clearingDisplay_Callback(hObject, eventdata, handles)



% --- Executes on button press in datWeight.
function datWeight_Callback(hObject, eventdata, handles)
global testCard hshowCard camFlag blank0 height width...
    hshowCam weightStr weight beephigh beeplow fs serialPort
    
testCardParams;
centX=width/2;
textPosY=30;
clearingDisplay_Callback(hObject, eventdata, handles)
blank1= insertText(blank0,[width/2 height/2], 'Connecting Scale...','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
blank2= insertText(blank0,[width/2 height/2], 'Scale Not Connected!','TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
hshowCam=imshow(blank1,'Parent',handles.axes2);
pause(1e-3)
if isempty(serialPort)
    serialPort=connectSerial;
end
try
    if isequal(serialPort.Status,'closed')
        fopen(serialPort);
        set(handles.scaleStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    fwrite(serialPort, 'Z');
    serBuf=readSerial(serialPort);
    basicFrame=writeText(blank0, 'Step on Scale!', centX, textPosY, 'blue');
    set(hshowCam,'CData',basicFrame);
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
                frame=writeText(blank0, 'Locked!', centX, textPosY, 'blue');
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
    set(handles.scaleStatus,'BackgroundColor','yellow','ForegroundColor','black');
    set(handles.weightString,'string','0.0 kg')
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank2,'Parent',handles.axes2);
    pause(3)
end
clearingDisplay_Callback(hObject, eventdata, handles)




% --- Executes on button press in camHeight.
function camHeight_Callback(hObject, eventdata, handles)
global testCard camFlag zeroPoint hshowCard...
    colKinect depKinect height width hshowCam blank1 blank4...
    heightStr beephigh beeplow fs
camFlag=1; 
clearingDisplay_Callback(hObject, eventdata, handles)
hshowCam=imshow(blank1,'Parent',handles.axes2);
pause(1e-3);
try 
    sensor_region_val=10;
    if ~isrunning(colKinect)
        start(colKinect);
    end
    if ~isrunning(depKinect)
        start(depKinect);
    end
    if isrunning(colKinect) && isrunning(depKinect)
        set(handles.chStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    trigger([colKinect depKinect]);
    frameDepth = fliplr(getdata(depKinect));
    frameCol=fliplr(getdata(colKinect));
    set(hshowCam,'CData',frameCol);
    centY=height/2;
    centX=width/2;
    nBuf=10;
    bufDst=[];
    senseRadius=65; %pixel
    lockHeight=0;
    bufHeightRes=[];
    kHeight=1;
    maskOri=zeros(size(frameDepth));
%     maskDetection=uint16(maskOri);
%     maskDetection(centY-100:centY+100,centX-100:centX+100)=1;
    textPosY=30;
    testCardParams;
    while camFlag
        trigger([colKinect depKinect])
        frameDepth = fliplr((getdata(depKinect)));
%         frameDepth = maskDetection.*fliplr((getdata(depKinect)));
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
                        frameCol=writeText(frameCol, 'Lost Tracking!', centX, textPosY, 'red');
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
                            pause(0.25)
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
                        frameCol=writeText(frameCol, 'Lost Tracking!', centX, textPosY, 'red');
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
%         frameCol=insertShape(frameCol,'Rectangle', [centX-100 centY-100 200 200],...
%                         'LineWidth', 2, 'color','red');
        set(hshowCam,'CData',frameCol)
    end
catch
    set(handles.chStatus,'BackgroundColor','yellow','ForegroundColor','black');
    set(handles.heightString,'string','0.0 cm')
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank4,'Parent',handles.axes2);
    pause(3)
end
clearingDisplay_Callback(hObject, eventdata, handles)

% --- Executes on button press in camFace.
function camFace_Callback(hObject, eventdata, handles)
global testCard hshowCard camFlag colWebcam faceDetector blank2...
    hshowCam nameStr blank4 photo shutter fs
nameFace=nameStr;
testCardParams;
clearingDisplay_Callback(hObject, eventdata, handles)
hshowCam=imshow(blank2,'Parent',handles.axes2);
pause(1e-3)
try
    if ~isrunning(colWebcam)
        start(colWebcam);
        set(handles.cfStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    trigger(colWebcam);
    frameOri=getdata(colWebcam);
    frame=imresize(frameOri,0.5);
    hshow=imshow(frame,'Parent',handles.axes2);
    camFlag=1;
    bufFlag=[];
    nBuf=15;
    prevBox=[0 0];
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
        set(hshow,'Cdata',frame)
    end
catch
    set(handles.cfStatus,'BackgroundColor','yellow','ForegroundColor','black');
    clearingDisplay_Callback(hObject, eventdata, handles);
    imshow(blank4,'Parent',handles.axes2);
    pause(3)
end
clearingDisplay_Callback(hObject, eventdata, handles)


% --- Executes on button press in printCard.
function printCard_Callback(hObject, eventdata, handles)
global lahirStr testCard nameStr codeStr heightStr weightStr...
    jenisKelamin ageYear tensiStr

currentFolder = pwd;
baseFileName = sprintf('%s.jpg',nameStr);
fullFileName = fullfile(currentFolder, baseFileName); % No need to worry about slashes now
imwrite(testCard,['imgCard\' baseFileName]);
hFig=figure;
imshow(testCard)
set(hFig,'Units','centimeters','PaperPositionMode','manual','PaperUnits','centimeters')
papersize = [10.5 14.8];
set(hFig,'PaperSize',papersize)
width = 15;         
height = 16; 
myfiguresize = [-2.25, -1.1 width, height]; %myfiguresize = [-1.2, -1.1, width, height]; 13 16
set(hFig, 'PaperPosition', myfiguresize);
print ('-dwinc',hFig)
close(hFig)
BMI=str2double(weightStr(1:end-3))/(str2double(heightStr(1:end-3))/100)^2
% nameStr 
% codeStr 
% heightStr 
% weightStr
% jenisKelamin 
% ageYear
% lahirStr

%block code for insert data to database
[flag, ~] = GarjasRegisterUser(codeStr, nameStr, heightStr, weightStr, lahirStr, jenisKelamin, ageYear);
if flag == 1 
    display('Insert Sukses!');
end

[flag, response] = GarjasCreateContainer(id_user);

% conn = OpenConnection();
% 
% if isconnection(conn)
%     %init table disjas_master_user
%     %check if id exist, if exist then update
%     tableMasterUser = 'disjas_master_user';
%     age=num2str(ageYear);
%     column='id_user';
%     value=codeStr(1:end-1);
%     user = RetrieveData(conn,tableMasterUser,column,value);
%     %
%     if strcmp(user, 'No Data')
%         %insert to table disjas_master_user
%         listColumnUser = GetColumnTable(conn,tableMasterUser);
%         valueUser = {value, nameStr, '', heightStr, weightStr, lahirStr, jenisKelamin, age};
%         InsertData(conn, listColumnUser, valueUser, tableMasterUser);
%         
%         %init table disjas_card_test
%         %get latest id_test
%         tableName = 'disjas_master_test';
%         id='tanggal';
%         valueId=date;
%         alldata = RetrieveData(conn,tableName,id,valueId);
%         idTest = num2str(alldata{1});
%         
%         %init table disjas_card_test
%         tableCardTest = 'disjas_card_test';
%         listColumnCard = GetColumnTable(conn,tableCardTest);
%         n=numel(listColumnCard);
%         insertCardColumn={};
%         for j=1:n-1
%             insertCardColumn{j}=listColumnCard{j+1};
%         end
%         %
%         valueCard = {idTest,value,'','','','','','',''};
%         InsertData(conn, insertCardColumn, valueCard, tableCardTest);
%         
%     else
%         %scenario updating data
%         nomorPeserta = codeStr(1:end-1);
%         
%         tNama = 'nama_user';
%         tTinggi = 'tinggi';
%         tBerat = 'berat';
%         tLahir = 'tgl_lahir';
%         tKelamin = 'jenis_kelamin';
%         tUmur = 'usia';
%         
%         namaUser = nameStr;
%         tinggi = heightStr;
%         berat = weightStr;
%         tglLahir = lahirStr;
%         jnsKelamin = jenisKelamin;
%         usia = age;
%         
%         %massive update row
%         display('Updating...');
%         UpdateData(conn, tNama, namaUser, nomorPeserta, tableMasterUser)
%         UpdateData(conn, tTinggi, tinggi, nomorPeserta, tableMasterUser)
%         UpdateData(conn, tBerat, berat, nomorPeserta, tableMasterUser)
%         UpdateData(conn, tLahir, tglLahir, nomorPeserta, tableMasterUser)
%         UpdateData(conn, tKelamin, jnsKelamin, nomorPeserta, tableMasterUser)
%         UpdateData(conn, tUmur, usia, nomorPeserta, tableMasterUser)
%         display('Finish updating!');
%     end
% else
%     notif = msgbox('Database not connected!');
% end

% --- Executes on button press in stopCam.
function stopCam_Callback(hObject, eventdata, handles)
global camFlag colKinect depKinect colWebcam serialPort
if camFlag
    camFlag=0;
else
    if  isrunning(colKinect)
        stop(colKinect);
    end
    if isrunning(depKinect)
        stop(depKinect);
    end
    if ~isrunning(colKinect) && ~isrunning(depKinect)
        set(handles.chStatus,'BackgroundColor','yellow','ForegroundColor','black');
    end
    if isrunning(colWebcam)
         stop(colWebcam);
         set(handles.cfStatus,'BackgroundColor','yellow','ForegroundColor','black');
    end
    if isequal(serialPort.Status,'open')
        fclose(serialPort);
        set(handles.scaleStatus,'BackgroundColor','yellow','ForegroundColor','black');
    end
end



% --- Executes on button press in startingUp.
function startingUp_Callback(hObject, eventdata, handles)
global templateCard hshowCard testCard colKinect depKinect height width...
    colWebcam serialPort blank0 hshowCam nameStr tensiStr...
    codeStr heightStr weightStr ageYear idCamF

cla(handles.axes1,'reset')
set(handles.axes1,'XTick',[],'YTick',[],'ZTick',[],'Xcolor',[1 1 1],'Ycolor',[1 1 1],'Zcolor',[1 1 1])
cla(handles.axes2,'reset')
set(handles.axes2,'XTick',[],'YTick',[],'ZTick',[],'Xcolor',[1 1 1],'Ycolor',[1 1 1],'Zcolor',[1 1 1])

blank0=uint8(255*ones(height,width,3));
initBlank1= insertText(blank0,[width/2 height/2], sprintf('%s\n%s',...
    'Starting Up System...','      Please Wait!'),'TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
initBlank2= insertText(blank0,[width/2 height/2], sprintf('%s\n%s',...
    '    Succeed','System Ready!'),'TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
initBlank3= insertText(blank0,[width/2 height/2], sprintf('%s\n%s',...
    '         Failed','Check Conection!'),'TextColor','blue',...
    'FontSize',40,'AnchorPoint','Center');
templateCard=imread('templateCard.bmp');
testCard=templateCard;
hshowCard=imshow(testCard,'Parent',handles.axes1);
hshowCam=imshow(initBlank1,'Parent',handles.axes2);
pause(1)

% testCardParams;
height=480;
width=640;
testCard=templateCard;
nameStr ='-';
codeStr ='0123456789128'; 
heightStr ='0.0 cm';
weightStr ='0.0 kg';
ageYear=[];
tensiStr=[];
set(hshowCard,'Cdata',testCard)
set(handles.nameEntry,'string','-');
set(handles.tLahirEntry,'string','-');
set(handles.noRegEntry,'string','-');
set(handles.heightString,'string',heightStr);
set(handles.weightString,'string',weightStr);
set(handles.kelPria,'value',1);
set(handles.kelWanita,'value',0);
pause(1e-3)
try
%     conn = OpenConnection();
%     flag = CheckConnection(conn);
    [flag, ~] = GarjasCheckCon();
    if flag
        set(handles.conStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    if ~isrunning(colKinect)
        start(colKinect);
    end
    if ~isrunning(depKinect)
        start(depKinect);
    end
    if isrunning(colKinect) && isrunning(depKinect)
        set(handles.chStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    if ~isrunning(colWebcam)
        start(colWebcam)
        set(handles.cfStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    if isequal(serialPort.Status,'closed')
        fopen(serialPort);
        set(handles.scaleStatus,'BackgroundColor','green','ForegroundColor','red');
    end
    set(hshowCam,'CData',initBlank2);
    pause(2)
catch
    try
        imaqreset;
        idCamF=findC920ID;
        serialPort=connectSerial;
        colWebcam = videoinput('winvideo',idCamF,sprintf('RGB24_%dx%d',width,height));
        triggerconfig(colWebcam,'manual');
        set(colWebcam, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
        colKinect = videoinput('kinect',1,sprintf('RGB_%dx%d',width,height));
        depKinect = videoinput('kinect',2,sprintf('Depth_%dx%d',width,height));
        triggerconfig(depKinect,'manual');
        triggerconfig(colKinect,'manual');
        set(depKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
        set(colKinect, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
        start(colKinect);
        start(depKinect);
        set(handles.chStatus,'BackgroundColor','green','ForegroundColor','red');
        start(colWebcam)
        set(handles.cfStatus,'BackgroundColor','green','ForegroundColor','red');
        fopen(serialPort);
        set(handles.scaleStatus,'BackgroundColor','green','ForegroundColor','red');
        set(hshowCam,'CData',initBlank2);
        pause(2)
    catch
        set(hshowCam,'CData',initBlank3);
        pause(3)
    end
end
clearingDisplay_Callback(hObject, eventdata, handles)



% --- Executes on button press in connectServer.
function connectServer_Callback(hObject, eventdata, handles)
% hObject    handle to connectServer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~, flag] = OpenConnection();
if flag
   set(handles.conStatus,'BackgroundColor','green','ForegroundColor','red');  
end


% --- Executes on button press in editCard.
function editCard_Callback(hObject, eventdata, handles)
global testCard hshowCard
[file, path, flag]=uigetfile('*.jpg','Choose Card to Edit!');
if flag
    testCard=imread([path file]);
    set(hshowCard,'CData',testCard)
end



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
global jenisKelamin nameStr testCard hshowCard ageYear tensiStr
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
if ~isempty(tensiStr)
    testCard=insertText(testCard,[nameX nameY+30],...
        sprintf('%s\n(%s/%dThn; Tensi %s)', nameStr,jenisKelamin,ageYear,tensiStr),...
        'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
else
    testCard=insertText(testCard,[nameX nameY+30],...
        sprintf('%s\n(%s/%d Thn)', nameStr,jenisKelamin,ageYear),...
        'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
end
set(hshowCard,'Cdata',testCard);
uicontrol(handles.nameEntry);

% Hint: get(hObject,'Value') returns toggle state of kelPria


% --- Executes on button press in kelWanita.
function kelWanita_Callback(hObject, eventdata, handles)
global jenisKelamin nameStr testCard hshowCard ageYear tensiStr
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
if ~isempty(tensiStr)
    testCard=insertText(testCard,[nameX nameY+30],...
        sprintf('%s\n(%s/%dThn; Tensi %s)', nameStr,jenisKelamin,ageYear,tensiStr),...
        'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
else
    testCard=insertText(testCard,[nameX nameY+30],...
        sprintf('%s\n(%s/%d Thn)', nameStr,jenisKelamin,ageYear),...
        'FontSize', textNameSize,'BoxOpacity',0,'AnchorPoint','LeftCenter');
end
set(hshowCard,'Cdata',testCard);

uicontrol(handles.nameEntry);
% Hint: get(hObject,'Value') returns toggle state of kelWanita




function scaleStatus_Callback(hObject, eventdata, handles)
% hObject    handle to scaleStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaleStatus as text
%        str2double(get(hObject,'String')) returns contents of scaleStatus as a double


% --- Executes during object creation, after setting all properties.
function scaleStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chStatus_Callback(hObject, eventdata, handles)
% hObject    handle to chStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chStatus as text
%        str2double(get(hObject,'String')) returns contents of chStatus as a double


% --- Executes during object creation, after setting all properties.
function chStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cfStatus_Callback(hObject, eventdata, handles)
% hObject    handle to cfStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cfStatus as text
%        str2double(get(hObject,'String')) returns contents of cfStatus as a double


% --- Executes during object creation, after setting all properties.
function cfStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cfStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conStatus_Callback(hObject, eventdata, handles)
% hObject    handle to conStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conStatus as text
%        str2double(get(hObject,'String')) returns contents of conStatus as a double


% --- Executes during object creation, after setting all properties.
function conStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
