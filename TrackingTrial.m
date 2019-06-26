function varargout = TrackingTrial(varargin)
% TRACKINGTRIAL MATLAB code for TrackingTrial.fig
%      TRACKINGTRIAL, by itself, creates a new TRACKINGTRIAL or raises the existing
%      singleton*.
%
%      H = TRACKINGTRIAL returns the handle to a new TRACKINGTRIAL or the handle to
%      the existing singleton*.
%
%      TRACKINGTRIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKINGTRIAL.M with the given input arguments.
%
%      TRACKINGTRIAL('Property','Value',...) creates a new TRACKINGTRIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrackingTrial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrackingTrial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrackingTrial

% Last Modified by GUIDE v2.5 02-Oct-2015 09:14:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TrackingTrial_OpeningFcn, ...
    'gui_OutputFcn',  @TrackingTrial_OutputFcn, ...
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


% --- Executes just before TrackingTrial is made visible.
function TrackingTrial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrackingTrial (see VARARGIN)

% Choose default command line output for TrackingTrial
handles.output = hObject;
javaFrame    = get(gcf,'JavaFrame');
iconFilePath = 'metavision.png';
javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrackingTrial wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrackingTrial_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in starting.
function starting_Callback(hObject, eventdata, handles)
global flag p1xval p1yval p2xval p2yval
p1xval=get(handles.p1x,'value');
p1yval=get(handles.p1y,'value');
p2xval=get(handles.p2x,'value');
p2yval=get(handles.p2y,'value');
imaqreset;
flag=true;
load audiodata
bh = audioplayer(beephigh, fs);
fgd = vision.ForegroundDetector(...
    'NumTrainingFrames', 200, ... % 5 because of short video
    'InitialVariance', 30*30); % initial standard deviation of 30
csc = vision.ColorSpaceConverter('Conversion', 'RGB to intensity');
width1=320;
height1=180;
width2=640;
height2=480;
width3=640;
height3=480;
imaqreset;
vid1 = videoinput('winvideo',1,sprintf('RGB24_%dx%d',width1,height1));
triggerconfig(vid1, 'Manual');
set(vid1,'TriggerRepeat',Inf);
set(vid1,'FramesPerTrigger',1);
% src1=getselectedsource(vid1);
% set(src1,'BacklightCompensation','on', 'ExposureMode', 'manual',...
%     'FocusMode','manual','WhiteBalanceMode','manual',...
%     'Exposure',-4,'Focus', 0, 'WhiteBalance', 4000);

vid2 = videoinput('winvideo',2,sprintf('RGB24_%dx%d',width2,height2));
triggerconfig(vid2, 'Manual');
set(vid2,'TriggerRepeat',Inf);
set(vid2,'FramesPerTrigger',1);
% src2=getselectedsource(vid2);
% set(src2,'BacklightCompensation','on', 'ExposureMode', 'manual',...
%     'FocusMode','manual','WhiteBalanceMode','manual',...
%     'Exposure',-7,'Focus', 0, 'WhiteBalance', 4000);

vid3 = videoinput('winvideo',3,sprintf('RGB24_%dx%d',width3,height3));
triggerconfig(vid3, 'Manual');
set(vid3,'TriggerRepeat',Inf);
set(vid3,'FramesPerTrigger',1);
% src3=getselectedsource(vid3);
% set(src3,'BacklightCompensation','on', 'ExposureMode', 'manual',...
%     'FocusMode','manual','WhiteBalanceMode','manual',...
%     'Exposure',-7,'Focus', 0, 'WhiteBalance', 4000);

start([vid1 vid2 vid3]);
trigger([vid1 vid2 vid3]);
frame1=getdata(vid1,1);
hshow1=imshow(imrotate(frame1,-90),'Parent',handles.axes1);
set(hshow1,'EraseMode','none');

frame2=getdata(vid2,1);frame3=getdata(vid3,1);
hshow2=imshow([frame2; frame3],'Parent',handles.axes2);
set(hshow2,'EraseMode','none');

maxf=20;
ixf=1;
imbuf=cell(1);
shotbuf=cell(1);
ixb=1;
flagshot=0;
while flag
    trigger([vid1 vid2 vid3]);
    frame1=imrotate(getdata(vid1,1),-90);
    frame2=getdata(vid2,1);
    frame3=getdata(vid3,1);
    gray=step(csc,frame1);
    
    mask = step(fgd,gray);
    mask=bwareaopen(mask,200);
    line=mask(:,width1/2);
    if sum(line)~=0 
        if ~isplaying(bh)
            play(bh);
        end
        flagshot=1;
    end
    if flagshot==1 && ixf<=maxf
        imbuf{ixf}=frame2;
        ixf=ixf+1;
    elseif flagshot==1 && ixf==maxf+1
        shotbuf{ixb}=imbuf;
        ixb=ixb+1;
        ixf=1;
        flagshot=0;
    end
    frame1=insertShape(frame1,'Line', [p1xval p1yval p2xval p2yval], 'LineWidth', 2, 'Color','green');
    frame1 = insertText(frame1,[p1xval p1yval; p2xval p2yval],...
            {'P1'; 'P2'},'TextColor','blue',...
            'FontSize',12,'AnchorPoint','Center');
    set(hshow1,'CData',frame1)
    set(hshow2,'CData',[frame2; frame3])
    drawnow
end
save shotdat.mat shotbuf



function numtracked_Callback(hObject, eventdata, handles)
% hObject    handle to numtracked (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numtracked as text
%        str2double(get(hObject,'String')) returns contents of numtracked as a double


% --- Executes during object creation, after setting all properties.
function numtracked_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numtracked (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stoping.
function stoping_Callback(hObject, eventdata, handles)
global flag
flag=false;


% --- Executes on selection change in det_id.
function det_id_Callback(hObject, eventdata, handles)
% hObject    handle to det_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns det_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from det_id


% --- Executes during object creation, after setting all properties.
function det_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to det_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function p1x_Callback(hObject, eventdata, handles)
global p1xval
p1xval=round(get(handles.p1x,'value'));
set(handles.p1x,'value',p1xval);
set(handles.p1xstring,'string',num2str(p1xval))

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function p1x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function p1xstring_Callback(hObject, eventdata, handles)
% hObject    handle to p1xstring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1xstring as text
%        str2double(get(hObject,'String')) returns contents of p1xstring as a double


% --- Executes during object creation, after setting all properties.
function p1xstring_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1xstring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function p1y_Callback(hObject, eventdata, handles)
global p1yval
p1yval=round(get(handles.p1y,'value'));
set(handles.p1y,'value',p1yval);
set(handles.p1ystring,'string',num2str(p1yval))

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function p1y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function p1ystring_Callback(hObject, eventdata, handles)
% hObject    handle to p1ystring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1ystring as text
%        str2double(get(hObject,'String')) returns contents of p1ystring as a double


% --- Executes during object creation, after setting all properties.
function p1ystring_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1ystring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function p2x_Callback(hObject, eventdata, handles)
global p2xval
p2xval=round(get(handles.p2x,'value'));
set(handles.p2x,'value',p2xval);
set(handles.p2xstring,'string',num2str(p2xval))

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function p2x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function p2xstring_Callback(hObject, eventdata, handles)
% hObject    handle to p2xstring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2xstring as text
%        str2double(get(hObject,'String')) returns contents of p2xstring as a double


% --- Executes during object creation, after setting all properties.
function p2xstring_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2xstring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function p2y_Callback(hObject, eventdata, handles)
global p2yval
p2yval=round(get(handles.p2y,'value'));
set(handles.p2y,'value',p2yval);
set(handles.p2ystring,'string',num2str(p2yval))

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function p2y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function p2ystring_Callback(hObject, eventdata, handles)
% hObject    handle to p2ystring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2ystring as text
%        str2double(get(hObject,'String')) returns contents of p2ystring as a double


% --- Executes during object creation, after setting all properties.
function p2ystring_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2ystring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in view_a_id.
function view_a_id_Callback(hObject, eventdata, handles)
% hObject    handle to view_a_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns view_a_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from view_a_id


% --- Executes during object creation, after setting all properties.
function view_a_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view_a_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in view_b_id.
function view_b_id_Callback(hObject, eventdata, handles)
% hObject    handle to view_b_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns view_b_id contents as cell array
%        contents{get(hObject,'Value')} returns selected item from view_b_id


% --- Executes during object creation, after setting all properties.
function view_b_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view_b_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetline.
function resetline_Callback(hObject, eventdata, handles)
global p1xval p1yval p2xval p2yval
p1xval=60;
set(handles.p1x,'value',p1xval);
set(handles.p1xstring,'string',num2str(p1xval))

p1yval=160;
set(handles.p1y,'value',p1yval);
set(handles.p2ystring,'string',num2str(p1yval))

p2xval=120;
set(handles.p2x,'value',p2xval);
set(handles.p2xstring,'string',num2str(p2xval))

p2yval=160;
set(handles.p2y,'value',p2yval);
set(handles.p2ystring,'string',num2str(p2yval))


% --- Executes on button press in test_capture.
function test_capture_Callback(hObject, eventdata, handles)
if strcmp(get(handles.test_capture,'string'),'Test Capture')
    frame1=255*ones(960,640,3,'uint8');
    frame2=255*ones(960,640,3,'uint8');
    frame1 = insertText(frame1,[320 480],...
            'Capturing...','TextColor','blue',...
            'FontSize',72,'AnchorPoint','Center');
    frame2 = insertText(frame2,[320 480],...
            'Capturing...','TextColor','blue',...
            'FontSize',72,'AnchorPoint','Center');
    imshow(frame1,'Parent',handles.axes1);
    imshow(frame2,'Parent',handles.axes2);
    imaqreset;
    info=imaqhwinfo('winvideo');
    id=cell2mat(info.DeviceIDs);
    N=length(id);
    allframe=cell(1,N);
    for k=1:N
        info=imaqhwinfo('winvideo',k);
        eval(sprintf('vid%d=%s;',id(k),info.VideoInputConstructor));
        eval(sprintf('im=getsnapshot(vid%d);',id(k)));
        im=imresize(im,[480 640]);
        im = insertText(im,[320 240],...
            sprintf('CamID: %d',k),'TextColor','blue',...
            'FontSize',72,'AnchorPoint','Center');
        allframe{k}=im;
        eval(sprintf('delete (vid%d);',id(k)));
    end

    if N==1
        frame=allframe{1};
        imshow([frame; zeros(size(frame))],'parent',handles.axes1);
        imshow([zeros(size(frame)); zeros(size(frame))],'parent',handles.axes2);
    elseif N==2
        frame1=allframe{1};
        frame2=allframe{2};
        imshow([frame1; zeros(size(frame1))],'parent',handles.axes1);
        imshow([frame2; zeros(size(frame2))],'parent',handles.axes2);
    elseif N==3
        frame1=allframe{1};
        frame2=allframe{2};
        frame3=allframe{3};
        imshow([frame1; frame2],'parent',handles.axes1);
        imshow([frame3; zeros(size(frame2))],'parent',handles.axes2);
    elseif N==4
        frame1=allframe{1};
        frame2=allframe{2};
        frame3=allframe{3};
        frame4=allframe{4};
        imshow([frame1; frame2],'parent',handles.axes1);
        imshow([frame3; frame4],'parent',handles.axes2);
    else
        frame1=allframe{1};
        frame2=allframe{2};
        frame3=allframe{3};
        frame4=allframe{4};
        frame5=allframe{5};
        imshow([frame1; frame2],'parent',handles.axes1);
        imshow([frame3; frame4; frame5],'parent',handles.axes2);
    end
    pause(1);
    set(handles.test_capture,'string', 'Lock ID')
elseif strcmp(get(handles.test_capture,'string'),'Lock ID')
    val1=str2double(get(handles.det_id,'string'));
    val2=str2double(get(handles.view_a_id,'string'));
    val3=str2double(get(handles.view_b_id,'string'));
    val4=str2double(get(handles.reg_id,'string'));
    if numel(unique([val1 val2 val3 val4]))<4 || val1==0 || val2==0 || val3==0 || val4==0
        errordlg('Berikan ID sesuai gambar hasil capture!','Potensi Kesalahan ID');
    elseif numel(unique([val1 val2 val3 val4]))==4
        set(handles.det_id,'enable','inactive','BackgroundColor','green');
        set(handles.view_a_id,'enable','inactive','BackgroundColor','green');
        set(handles.view_b_id,'enable','inactive','BackgroundColor','green');
        set(handles.reg_id,'enable','inactive','BackgroundColor','green');
        pause(1);
        reset_axes(hObject, eventdata, handles)
        set(handles.test_capture,'string', 'Unlock ID')
    end
elseif strcmp(get(handles.test_capture,'string'),'Unlock ID')
    set(handles.test_capture,'string', 'Test Capture')
    set(handles.det_id,'enable','on','BackgroundColor','yellow','string','0');
    set(handles.view_a_id,'enable','on','BackgroundColor','yellow','string','0');
    set(handles.view_b_id,'enable','on','BackgroundColor','yellow','string','0');
    set(handles.reg_id,'enable','on','BackgroundColor','yellow','string','0');
end



function reset_axes(hObject, eventdata, handles)
cla(handles.axes1,'reset')
set(handles.axes1,'XTick',[],'YTick',[],'ZTick',[],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1])
cla(handles.axes2,'reset')
set(handles.axes2,'XTick',[],'YTick',[],'ZTick',[],'XColor',[1 1 1],'YColor',[1 1 1],'ZColor',[1 1 1])



function reg_id_Callback(hObject, eventdata, handles)
% hObject    handle to reg_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reg_id as text
%        str2double(get(hObject,'String')) returns contents of reg_id as a double


% --- Executes during object creation, after setting all properties.
function reg_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reg_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nama_Callback(hObject, eventdata, handles)
% hObject    handle to nama (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nama as text
%        str2double(get(hObject,'String')) returns contents of nama as a double


% --- Executes during object creation, after setting all properties.
function nama_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nama (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numtes_Callback(hObject, eventdata, handles)
% hObject    handle to numtes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numtes as text
%        str2double(get(hObject,'String')) returns contents of numtes as a double


% --- Executes during object creation, after setting all properties.
function numtes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numtes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_reg.
function start_reg_Callback(hObject, eventdata, handles)
global top_mark_val bottom_mark_val reg_flag
top_mark_val=round(get(handles.top_mark,'value'));
bottom_mark_val=round(get(handles.bottom_mark,'value'));
camID=str2double(get(handles.reg_id,'string'));
width=640;
height=480;
imaqreset;
vid = videoinput('winvideo',camID,sprintf('RGB24_%dx%d',width,height));
triggerconfig(vid, 'Manual');
set(vid,'TriggerRepeat',Inf);
set(vid,'FramesPerTrigger',1);

start(vid);
trigger(vid);
frame=getdata(vid,1);
hshow=imshow(frame,'Parent',handles.axes1);
set(hshow,'EraseMode','none');
reg_flag=1;
while reg_flag
    trigger(vid);
    frame=getdata(vid,1);
    frame=insertShape(frame,'FilledCircle', [[320 top_mark_val 20];...
            [320 bottom_mark_val 20]],...
            'LineWidth', 2, 'Color','white');
    
    frame = insertText(frame,[320 top_mark_val; 320 bottom_mark_val],...
            {'Top'; 'Bottom'},'TextColor','blue',...
            'FontSize',12,'AnchorPoint','Center');
    set(hshow,'CData',frame)
    drawnow
end







% --- Executes on button press in capture_reg.
function capture_reg_Callback(hObject, eventdata, handles)
global reg_flag
reg_flag=0;


% --- Executes on button press in save_reg.
function save_reg_Callback(hObject, eventdata, handles)
% hObject    handle to save_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in view_reg.
function view_reg_Callback(hObject, eventdata, handles)
% hObject    handle to view_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function top_mark_Callback(hObject, eventdata, handles)
global top_mark_val
top_mark_val=round(get(handles.top_mark,'value'));
set(handles.top_mark,'value',top_mark_val);
set(handles.top_mark_string,'string',num2str(top_mark_val))

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function top_mark_CreateFcn(hObject, eventdata, handles)
% hObject    handle to top_mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function top_mark_string_Callback(hObject, eventdata, handles)
% hObject    handle to top_mark_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of top_mark_string as text
%        str2double(get(hObject,'String')) returns contents of top_mark_string as a double


% --- Executes during object creation, after setting all properties.
function top_mark_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to top_mark_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function bottom_mark_Callback(hObject, eventdata, handles)
global bottom_mark_val
bottom_mark_val=round(get(handles.bottom_mark,'value'));
set(handles.bottom_mark,'value',bottom_mark_val);
set(handles.bottom_mark_string,'string',num2str(bottom_mark_val))

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function bottom_mark_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottom_mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bottom_mark_string_Callback(hObject, eventdata, handles)
% hObject    handle to bottom_mark_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bottom_mark_string as text
%        str2double(get(hObject,'String')) returns contents of bottom_mark_string as a double


% --- Executes during object creation, after setting all properties.
function bottom_mark_string_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottom_mark_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function no_reg_Callback(hObject, eventdata, handles)
% hObject    handle to no_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_reg as text
%        str2double(get(hObject,'String')) returns contents of no_reg as a double


% --- Executes during object creation, after setting all properties.
function no_reg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
