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

% Last Modified by GUIDE v2.5 01-Aug-2016 06:03:56

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
global templateCard hshowCard testCard nameStr codeStr ageYear tensiStr...
    prevDatCard listIdTest listTgl listTempat listNama testDate
    
[flag, ~] = GarjasGetMasterTest();
if ~flag
    h=mywarndlg({'Please Create Group First!'},'No Group Exist!','modal'); 
    pause(2);
    try %#ok<TRYNC>
        close(h) 
    end
    return
end

testCardParams;
testCard=templateCard;
nameStr ='-';
codeStr ='0123456789128'; 
ageYear=[];
tensiStr=[];
prevDatCard=[];
% zeroing title
testCard(titleY:titleY+115,titleX-265:titleX+265,:)=255;
%zeroing height weight
testCard(HSTextPos(2,2)-33:HSTextPos(2,2)+30,HSTextPos(2,1)-85:HSTextPos(2,1)+85,:)=255;
testCard(HSTextPos(1,2)-33:HSTextPos(1,2)+30,HSTextPos(1,1)-85:HSTextPos(1,1)+85,:)=255;
%title insertion

try
    tgl=datestr(datenum(testDate,'ddmmyy')); %langsung dari create group
catch
    tgl=testDate; %dari pemindahan group
end
testCard=insertText(testCard,[titleX titleY],...
    sprintf('Kartu Tes Jasmani TNI AD\n         %s',...
    tgl),'FontSize', textTitleSize,'BoxOpacity',0,'AnchorPoint','CenterTop');

set(hshowCard,'Cdata',testCard)
set(handles.nameEntry,'string','-','enable', 'on');
set(handles.tLahirEntry,'string','-','enable', 'on');
set(handles.noRegEntry,'string','-','enable', 'on');
set(handles.reCapture,'enable','inactive','BackgroundColor',[0.94 0.94 0.94])
set(handles.printCard,'enable','inactive','BackgroundColor',[0.94 0.94 0.94])
set(handles.btnActivate,'string','Unlock ActiveGroup')
set(handles.groupTest,'enable','inactive','Backgroundcolor','white','Foregroundcolor','red')
uicontrol(handles.nameEntry);



function nameEntry_Callback(hObject, eventdata, handles)
global hshowCard testCard nameStr
nameStr=get(handles.nameEntry,'string');
nStr=numel(nameStr);
testCardParams;
if nStr>21
    set(handles.nameEntry,'string',nameStr(1:21));
    h=mywarndlg(sprintf('(%d Char) Max 21 Character',nStr),'Over Character','modal');
%     warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%     javaFrame    = get(h,'JavaFrame');
%     iconFilePath = 'logoMetaVision.png';
%     javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
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
global hshowCard lahirStr noRegStr nameStr testCard jenisKelamin ageYear...
    tensiStr testDate

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
    h=mywarndlg(sprintf('%s\n%s','Make Sure Format is Right!','Birth Format: ddmmyy!'),'Wrong Format','modal');
%     warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%     javaFrame    = get(h,'JavaFrame');
%     iconFilePath = 'logoMetaVision.png';
%     javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
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
    try
        age = calculateAge([bornDate bornMonth bornYear], testDate);
    catch
        age = calculateAge([bornDate bornMonth bornYear], datestr(testDate,'ddmmyy'));
    end
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
global lahirStr noRegStr testCard hshowCard codeStr blankScreen 

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
    h=mywarndlg(sprintf('%s\n%s','Make Sure Format is Right!','Required 6 Numeric!'),'Wrong Format','modal');
%     warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%     javaFrame    = get(h,'JavaFrame');
%     iconFilePath = 'logoMetaVision.png';
%     javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
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
        getF(hObject, eventdata, handles)
        imshow(blankScreen,'Parent',handles.axes2)
    catch
        sendMsg(handles,'Error while acquiring data...')
        pause(2);
        imshow(blankScreen,'Parent',handles.axes2)
    end
    set(handles.reCapture,'enable','on','BackgroundColor','cyan')
    set(handles.printCard,'enable','on','BackgroundColor','cyan')
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



function ckStatus_Callback(hObject, eventdata, handles)
% hObject    handle to ckStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ckStatus as text
%        str2double(get(hObject,'String')) returns contents of ckStatus as a double


% --- Executes during object creation, after setting all properties.
function ckStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ckStatus (see GCBO)
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




% --- Executes during object creation, after setting all properties.
function opMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function reCapture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reCapture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes just before RegistrantStation is made visible.
function RegistrantStation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegistrantStation (see VARARGIN)

% Choose default command line output for RegistrantStation
handles.output = hObject;
% locker ='1  0  1  1  1  1  1  0  1  0  0  0  0  1  1  0  1  0  1  0  1  0  0  0  1  0  0  0  0  1  0  0  1  0  1  0  0  0  1  0  0  0  0  1  0  0  1  1';
% [~,result] = dos('getmac');
% mac = result(160:176); %ambil string mac address (1)
% macvect=macaddr(mac); %jadikan vektor desimal (2)
% macbin=de2bi(macvect,8,'left-msb'); %jadikan biner (3)
% macbinvect=macbin(:)'; %jadikan vektor biner (4)
% vectorbiner=circshift(macbinvect',3)'; %pergeseran sirkular 3 digit (5)
% keyString=num2str(vectorbiner);
% if ~strcmp(locker,keyString)
%     uiwait(mywarndlg({'This computer is not allowed to run this program';...
%         'Please contact MetaVision Studio!';...
%         'metavisionstudio@gmail.com (62-8112266126)'},'Unauthorized!!'))
%     exit
% end

if ~exist('C:/ProgramData/MetaVision/AppData','dir')
    mkdir('C:/ProgramData/MetaVision/AppData')
    dos('attrib +s +h C:/ProgramData/MetaVision')
    dos('attrib +s +h C:/ProgramData/MetaVision/AppData')
end
% 
% 
if ~exist('C:/ProgramData/MetaVision/AppData/RegLicense.mat','file')
    locker =[];
    save ('C:/ProgramData/MetaVision/AppData/RegLicense.mat', 'locker')
end


drivername = 'mysql-connector-java-5.0.8-bin.jar';
javaaddpath(drivername);

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
javaFrame    = get(gcf,'JavaFrame');
iconFilePath = 'C:\Program Files\MetaVision Studio\RegistrantStation\application\default_icon_48.png';
javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
% addpath('DataAPI');

if ~exist('C:\GConfig\','dir')
    mkdir('C:\GConfig\');
    dos('attrib +h +s C:\GConfig');
end

if ~exist('C:\imgCard\','dir')
    mkdir('C:\imgCard\');
    dos('attrib +h +s C:\imgCard');
end
ipAddr = 'localhost';
CreateServerConf(ipAddr);

global blankScreen testCard templateCard height width camFlag hshowCard nameStr codeStr heightStr...
    jenisKelamin weightStr weight ageYear tensiStr faceDetector zeroPoint beephigh beeplow fs shutter

load('C:/Program Files/MetaVision Studio/RegistrantStation/application/beepcouple.mat')
% load beepcouple
testCardParams;
blankScreen=imread('C:/Program Files/MetaVision Studio/RegistrantStation/application/blankScreen.jpg');
imshow(blankScreen,'Parent',handles.axes2);
templateCard=imread('C:/Program Files/MetaVision Studio/RegistrantStation/application/templateCard.bmp');
testCard=templateCard;
%zeroing height weight
testCard(HSTextPos(2,2)-33:HSTextPos(2,2)+30,HSTextPos(2,1)-85:HSTextPos(2,1)+85,:)=255;
testCard(HSTextPos(1,2)-33:HSTextPos(1,2)+30,HSTextPos(1,1)-85:HSTextPos(1,1)+85,:)=255;
hshowCard=imshow(testCard,'Parent',handles.axes1);
height=480;
width=640;
camFlag=0;
zeroPoint=270;
nameStr ='-';
codeStr ='0123456789128'; 
heightStr ='0.0 cm';
weightStr ='0.0 kg';
weight=0;
ageYear=[];
jenisKelamin='L';
tensiStr=[];
faceDetector = vision.CascadeObjectDetector();



% set(handles.newRegistrant,'enable','inactive')
set(handles.connectDevices,'enable','on','BackgroundColor','cyan')
set(handles.stopProcess,'enable','on','BackgroundColor','cyan')
set(handles.opMode,'enable','inactive')
set(handles.reCapture,'enable','inactive')
set(handles.printCard,'enable','inactive')
try %#ok<TRYNC>
    [listIdTest, listTgl, listTempat, listNama] = GarjasGetListIdTest();
    n = size(listIdTest, 1);
    GroupVal = {};
    ixGroup=1;
    for i=1:n
        if ~isempty(listIdTest{i})
            GroupVal{ixGroup} = [listIdTest{i} '-' listNama{i}];
            ixGroup=ixGroup+1;
        end
    end
    set(handles.groupTest, 'String', GroupVal,'Backgroundcolor','cyan','value',1);
    string_id_test = get(handles.groupTest,'string');
    value_id_test = get(handles.groupTest,'value');
    
    ixStrip = find(string_id_test{value_id_test}=='-');
    id_test=string_id_test{value_id_test}(1:ixStrip-1);
    val = '1';
    GarjasSetStatusTest(id_test, val);
catch
    set(handles.groupTest, 'String', 'Group Available','Backgroundcolor','cyan','value',1);
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RegistrantStation wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Executes on button press in connectDevices.
function connectDevices_Callback(hObject, eventdata, handles)
global blankScreen height width colWebcam
load('C:/ProgramData/MetaVision/AppData/RegLicense.mat')
idVol=getIDVol;
idVol=sprintf('%s-%s-%s-%s-%s-%s',idVol(1:2),idVol(3:4),idVol(6:7),idVol(8:9),...
    [idVol(6) idVol(1)], [idVol(4) idVol(9)]);
idVolVect=macaddr(idVol); %jadikan vektor desimal (2)
idVolBin=de2bi(idVolVect,8,'left-msb'); %jadikan biner (3)
idVolBinVect=idVolBin(:)'; %jadikan vektor biner (4)
vectorbiner=circshift(idVolBinVect',3)'; %pergeseran sirkular 3 digit (5)
keyString=strrep(num2str(vectorbiner),' ','');
randomizer=[28 23 1 17 9 40 16 27 8 32 13 35 36 39 22 4 12 46 7 42 29 48 5 24,...
    6 47 2 38 41 43 10 20 18 37 25 44 14 15 11 19 34 31 30 3 45 26 21 33];
keyString=keyString(randomizer);
if ~strcmp(keyString,locker)
    %prosedur aktivasi
    idVol=fliplr(idVol);
    answer = inputdlg(sprintf('Challenge Code: %s', idVol),'Masukkan Kunci Aktivasi',[1 80]);
    if ~isempty(answer)
        locker=answer{1};
        if strcmp(locker,keyString)
            save ('C:/ProgramData/MetaVision/AppData/RegLicense.mat', 'locker')
            h=mywarndlg('Kunci aktivasi DITERIMA!','Aktivasi Berhasil!', 'modal');
            pause(3)
%             flag=1;
%             t=0;
%             while flag
%                 t=t+1;
%                 if ~ishandle(h) || t==30
%                     flag=0;
%                 end
%                 pause(0.1)
%             end
            try %#ok<TRYNC>
                close(h)
            end
            return
        else
            h=mywarndlg({'Kunci aktivasi DITOLAK!'},'Aktivasi Gagal!', 'modal');
            pause(3)
%             flag=1;
%             t=0;
%             while flag
%                 t=t+1;
%                 if ~ishandle(h) || t==30
%                     flag=0;
%                 end
%                 pause(0.1)
%             end
            try %#ok<TRYNC>
                close(h)
            end
            return
        end
    else
        return
    end
end

imaqreset
set(handles.connectDevices,'BackgroundColor',[0.94 0.94 0.94],'enable','inactive')
set(handles.stopProcess,'BackgroundColor',[0.94 0.94 0.94],'enable','inactive')
set(handles.cfStatus,'BackgroundColor','yellow','ForegroundColor','black');
set(handles.opMode,'enable','inactive','value',1)

%get stream from logitech
try
    sendMsg(handles, 'Connecting Webcam...')
    idCamF=findC920ID;
    colWebcam = videoinput('winvideo',idCamF,sprintf('RGB24_%dx%d',width,height));
    triggerconfig(colWebcam,'manual');
    set(colWebcam, 'FramesPerTrigger', 1,'TriggerRepeat',Inf);
    start(colWebcam);
    set(handles.cfStatus,'BackgroundColor','green','ForegroundColor','red');
    sendMsg(handles, 'Webcam Ready!')
    pause(1)
catch
    sendMsg(handles, 'Webcam Not Ready!')
    colWebcam =[];
    pause(1)
end

if isa(colWebcam,'videoinput')
    if isrunning(colWebcam)
        set(handles.opMode,'enable','on','BackgroundColor','cyan');
    else
        set(handles.connectDevices,'BackgroundColor','cyan','enable','on')
    end
else
    set(handles.connectDevices,'BackgroundColor','cyan','enable','on')
end
set(handles.stopProcess,'enable','on','BackgroundColor','cyan');
imshow(blankScreen,'Parent',handles.axes2);



% --- Executes on selection change in opMode.
function opMode_Callback(hObject, eventdata, handles)
global opVal blankScreen listIdTest listTgl listTempat listNama

opVal=get(handles.opMode,'value');
if opVal==2
    if ~exist('C:\imgCard\','dir')
        mkdir('C:\imgCard\');
        dos('attrib +h +s C:\imgCard');
    end
    sendMsg(handles,'Checking In...')
    pause(1);
    %cek koneksi dan hijaukan status koneksi
    [flag, ~] = GarjasCheckCon();
    if flag == 1 
        set(handles.opMode,'enable','inactive','BackgroundColor',[1 1 1],'ForegroundColor','red')
        set(handles.conStatus,'BackgroundColor','green','ForegroundColor','red');
        set(handles.newRegistrant,'enable','on','BackgroundColor','cyan');
        set(handles.btnGroupTest,'enable', 'on', 'BackgroundColor','cyan');
        sendMsg(handles,'Connected..')
        set(handles.btnActivate,'string','Unlock ActiveGroup')
        set(handles.groupTest,'enable','inactive','Backgroundcolor','white','Foregroundcolor','red')
        pause(1);
        imshow(blankScreen,'Parent',handles.axes2)
    else
        set(handles.opMode,'enable','on','BackgroundColor','cyan', 'ForegroundColor','black','value',1);
        set(handles.conStatus,'BackgroundColor','yellow','ForegroundColor','black');
        sendMsg(handles,'StandAlone Mode Only!')
        pause(2);
        imshow(blankScreen,'Parent',handles.axes2)
%         [listIdTest, listTgl, listTempat, listNama] = GarjasGetListIdTest()
    end
    
elseif opVal==3
    conn = OpenConnection();
    choice = myquestdlg('Apakah Anda yakin akan menghapus seluruh data?', ...
        'Pilihan Reset Data', ...
        'Yes','No','No');
    switch choice
        case 'Yes'
            prompt = {'Masukan Password'};
            dlg_title = 'Password Reset Data';
            password = myinputdlg(prompt,dlg_title,[1 70]);
            if strcmp(password,'170845')
                ClearData(conn);
                try %#ok<TRYNC>
                    rmdir ('C:\imgCard\', 's');
                end
                set(handles.opMode,'value',1);
                try 
                    [listIdTest, listTgl, listTempat, listNama] = GarjasGetListIdTest();
                    n = size(listIdTest, 1);
                    GroupVal = {};
                    ixGroup=1;
                    for i=1:n
                        if ~isempty(listIdTest{i})
                            GroupVal{ixGroup} = [listIdTest{i} '-' listNama{i}];
                            ixGroup=ixGroup+1;
                        end
                    end
                    set(handles.groupTest, 'String', GroupVal,'Backgroundcolor','cyan','value',1);
                    string_id_test = get(handles.groupTest,'string');
                    value_id_test = get(handles.groupTest,'value');
                    
                    ixStrip = find(string_id_test{value_id_test}=='-');
                    id_test=string_id_test{value_id_test}(1:ixStrip-1);
                    val = '1';
                    GarjasSetStatusTest(id_test, val);
                catch
                    set(handles.groupTest, 'String', 'Group Available','Backgroundcolor','cyan','value',1, 'Foregroundcolor','black');
                    h=mywarndlg({'All Data Deleted!'},'Deletion Success!','modal');
                    pause(2);
                    try %#ok<TRYNC>
                        close(h)
                    end
                end
                
                
            else
                set(handles.opMode,'value',1);
                h=mywarndlg({'Please Enter Correct Deleting Password!'},'Wrong Password!!','modal'); 
                pause(2);
                try %#ok<TRYNC>
                    close(h)
                end
                return
            end
                
        case 'No'
            set(handles.opMode,'value',1);
            return;
    end
elseif opVal==4
    [file,path] = uigetfile('C:\imgCard\*.jpg','Select Card Image to Print');
    if file ~=0
        testCard=imread([path file]);
        hFig=figure;
        javaFrame    = get(hFig,'JavaFrame');
        iconFilePath = 'C:\Program Files\MetaVision Studio\RegistrantStation\application\default_icon_48.png';
        javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
        imshow(testCard)
        set(hFig,'Units','centimeters','PaperPositionMode','manual','PaperUnits','centimeters')
        papersize = [15 16];%papersize = [10.5 14.8];
        set(hFig,'PaperSize',papersize)
        width = 15;
        height = 16;
        myfiguresize = [-1.7, -0.2 width, height]; %myfiguresize = [-1.2, -1.1, width, height]; 13 16
        set(hFig, 'PaperPosition', myfiguresize);
        print ('-dwinc',hFig)
        close(hFig)
    end
    set(handles.opMode,'value',1);
    elseif opVal==5
        uiwait(ChangeGroup)
        set(handles.opMode,'value',1);
end




% --- Executes on selection change in reCapture.
function reCapture_Callback(hObject, eventdata, handles)
global testCard camFlag hshowCard nameStr faceDetector...
        colWebcam hshowCam blankScreen...
       shutter fs 
   
testCardParams;
capVal=get(handles.reCapture,'value');
set(handles.reCapture,'enable','inactive')
if capVal==2 %recapture face
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
                    imwrite(testCard,['C:\imgCard\' sprintf('%s.jpg',nameStr)]);
                end
            end
            prevBox=currentBox;
        end
        set(hshowCam,'Cdata',frame)
    end
    
    imshow(blankScreen,'Parent',handles.axes2)
    set(handles.reCapture,'enable','on','value',1)
elseif capVal==3
    set(handles.reCapture,'enable','on')
end



% --- Executes on button press in stopProcess.
function stopProcess_Callback(hObject, eventdata, handles)
global camFlag colWebcam

if camFlag
    camFlag=0;
else
    if isa(colWebcam,'videoinput')
        if isrunning(colWebcam)
            stop(colWebcam);
            set(handles.cfStatus,'BackgroundColor','yellow','ForegroundColor','black');
        end
    end
    set(handles.conStatus,'BackgroundColor','yellow','ForegroundColor','black');
    set(handles.newRegistrant,'enable','inactive','BackgroundColor',[0.94 0.94 0.94])
    set(handles.connectDevices,'enable','on','BackgroundColor','cyan')
    set(handles.stopProcess,'enable','on','BackgroundColor','cyan')
    set(handles.opMode,'enable','inactive','value',1, 'BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')
    set(handles.reCapture,'enable','inactive','BackgroundColor',[0.94 0.94 0.94],'value',1)
    set(handles.printCard,'enable','inactive','BackgroundColor',[0.94 0.94 0.94])
    set(handles.btnGroupTest,'enable', 'inactive', 'BackgroundColor',[0.94 0.94 0.94]);
    
end


% --- Executes on button press in printCard.
function printCard_Callback(hObject, eventdata, handles)
global lahirStr testCard nameStr codeStr...
    jenisKelamin ageYear prevDatCard tensiStr blankScreen

set(handles.nameEntry,'enable', 'inactive');
set(handles.tLahirEntry,'enable', 'inactive');
set(handles.noRegEntry,'enable', 'inactive');
capVal=get(handles.reCapture,'value');
baseFileName = sprintf('%s-%s.jpg',nameStr, codeStr(1:12));

%1. pengiriman data ke server
%2. tulis ke report internal
GarjasSaveOffline(codeStr(1:12), nameStr, '-', '-', ageYear);

opVal=get(handles.opMode,'value');
if opVal==2 % mode integrated
    %     lakukan prosedur pengiriman ke server
    sendMsg(handles,'Registering...')
    pause(0.5)
    [flag, response] = GarjasRegisterUser(codeStr(1:12), nameStr, lahirStr, jenisKelamin, num2str(ageYear));
    if flag == 1
%         display('Insert Sukses!');
        GarjasCreateContainer(codeStr(1:12),handles);
    else
        sendMsg(handles,'Already Registered!')
        pause(0.5)
    end
    load C:\GConfig\firstMemGroup.mat
    if firstMemGroup
        [listIdTest, listTgl, listTempat, listNama] = GarjasGetListIdTest();
        n = size(listIdTest, 1);
        GroupVal = {};
        ixGroup=1;
        for i=1:n
            if ~isempty(listIdTest{i})
                GroupVal{ixGroup} = [listIdTest{i} '-' listNama{i}];
                ixGroup=ixGroup+1;
            end
        end
        val = '1';
        id_test=listIdTest{1};
        GarjasSetStatusTest(id_test, val);
        
        set(handles.groupTest, 'enable', 'inactive', 'String', GroupVal,...
            'Backgroundcolor','white','Foreground','red','value',1);
        set(handles.btnActivate,'string','Unlock ActiveGroup')
        firstMemGroup=0;
        save C:\GConfig\firstMemGroup.mat firstMemGroup
        
        n=length(listIdTest);
        for k=1:n
            dataIdTest=listIdTest{k};
            if dataIdTest==id_test
                folderName=listNama{k};
                break
            end
        end
        mkdir(['C:\imgCard\' folderName]);
        imwrite(testCard,['C:\imgCard\' folderName '\' baseFileName]);
    else
        folderName=GarjasGetFolderName(handles);
        imwrite(testCard,['C:\imgCard\' folderName '\' baseFileName]);
    end
end
pause(0.01)
% DatCard=cat(2,codeStr(1:12), nameStr);
sendMsg(handles,'Sending Data to Printer...')
if capVal==3
    hFig=figure;
    javaFrame    = get(hFig,'JavaFrame');
    iconFilePath = 'C:\Program Files\MetaVision Studio\RegistrantStation\application\default_icon_48.png';
    javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
    imshow(testCard)
    set(hFig,'Units','centimeters','PaperPositionMode','manual','PaperUnits','centimeters')
    papersize = [15 16];%papersize = [10.5 14.8];
    set(hFig,'PaperSize',papersize)
    width = 15;
    height = 16;
    myfiguresize = [-1.7, -0.2 width, height]; %myfiguresize = [-1.2, -1.1, width, height]; 13 16
    set(hFig, 'PaperPosition', myfiguresize,'Name','KARTU TES','NumberTitle','off');
else
    hFig=figure;
    javaFrame    = get(hFig,'JavaFrame');
    iconFilePath = 'C:\Program Files\MetaVision Studio\RegistrantStation\application\default_icon_48.png';
    javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
    imshow(testCard)
    set(hFig,'Units','centimeters','PaperPositionMode','manual','PaperUnits','centimeters')
    papersize = [15 16];%papersize = [10.5 14.8];
    set(hFig,'PaperSize',papersize)
    width = 15;
    height = 16;
    myfiguresize = [-1.7, -0.2 width, height]; %myfiguresize = [-1.2, -1.1, width, height]; 13 16
    set(hFig, 'PaperPosition', myfiguresize);
    print ('-dwinc',hFig)
    close(hFig)
end
imshow(blankScreen,'Parent',handles.axes2)
    

% --- Executes on button press in btnGroupTest.
function btnGroupTest_Callback(hObject, eventdata, handles)
% hObject    handle to btnGroupTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global blankScreen testDate
sendMsg(handles,'Creating Group Test')
pause(0.1)
% tgl = date;
prompt = {'Nama Kegiatan', 'Tempat', 'Waktu Tes' };
dlg_title = 'Create Group Test';
masterTest = myinputdlg(prompt,dlg_title,[1 70; 1 70; 1 70],{''; ''; datestr(today,'ddmmyy')});

if ~isempty(masterTest) 
    testName=masterTest{1};
    testPlace=masterTest{2};
    testDate=masterTest{3};
    if ~isempty(testName) && ~isempty(testPlace) && ~isempty(testDate)
        tgl=datestr(datenum(testDate,'ddmmyy'));
        [flag, ~] = GarjasCreateTest(tgl, masterTest{2}, masterTest{1});
        firstMemGroup=1;
        save C:\GConfig\firstMemGroup.mat firstMemGroup        
        if flag == 1
            sendMsg(handles,'Empty Group Test Created!')
            pause(2)
            imshow(blankScreen,'Parent',handles.axes2)
        else
            sendMsg(handles,'Group Creation Failed!')
            pause(2)
            imshow(blankScreen,'Parent',handles.axes2)
        end
    else
        sendMsg(handles,'Group Test Not Created!')
        pause(1)
        imshow(blankScreen,'Parent',handles.axes2)
        display('Master test not created!');
    end
else
    sendMsg(handles,'Group Test Not Created!')
    pause(1)
    imshow(blankScreen,'Parent',handles.axes2)
    display('Master test not created!');
end

% --- Executes on button press in btnActivate.
function btnActivate_Callback(hObject, eventdata, handles)
strGT=get(handles.groupTest,'string');
if ~strcmp(strGT,'Group Available')
    strVal=get(handles.btnActivate,'string');
    if strcmp(strVal,'Lock ActiveGroup')
        set(handles.btnActivate,'string','Unlock ActiveGroup')
        set(handles.groupTest,'enable','inactive','Backgroundcolor','white','Foregroundcolor','red')
    else
        set(handles.btnActivate,'string','Lock ActiveGroup')
        set(handles.groupTest,'enable','on','Backgroundcolor','cyan','Foregroundcolor','black')
    end
end




% --- Executes on selection change in groupTest.
function groupTest_Callback(hObject, eventdata, handles)
global blankScreen testDate
string_id_test = get(handles.groupTest,'string');
value_id_test = get(handles.groupTest,'value');
ixStrip = find(string_id_test{value_id_test}=='-');
id_test=string_id_test{value_id_test}(1:ixStrip-1);
val = '1';
try
    sendMsg(handles,'Activating Group Test')
    pause(0.01)
    GarjasSetStatusTest(id_test, val);
    sendMsg(handles,sprintf('GroupTest\n%s\nActive!',string_id_test{value_id_test}));
    [listIdTest, listTgl, listTempat, listNama] = GarjasGetListIdTest();
    n=length(listTgl);
    for k=1:n
       dataIdTest=listIdTest{k};
       if dataIdTest==id_test
           testDate=listTgl{k};
           break
       end
    end
    pause(2)
    imshow(blankScreen,'Parent',handles.axes2)
catch
    sendMsg(handles,'Group Activation Failed!')
    pause(2)
    imshow(blankScreen,'Parent',handles.axes2)
end





% --- Executes during object creation, after setting all properties.
function groupTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
