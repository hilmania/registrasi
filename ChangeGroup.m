function varargout = ChangeGroup(varargin)
% CHANGEGROUP MATLAB code for ChangeGroup.fig
%      CHANGEGROUP, by itself, creates a new CHANGEGROUP or raises the existing
%      singleton*.
%
%      H = CHANGEGROUP returns the handle to a new CHANGEGROUP or the handle to
%      the existing singleton*.
%
%      CHANGEGROUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANGEGROUP.M with the given input arguments.
%
%      CHANGEGROUP('Property','Value',...) creates a new CHANGEGROUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChangeGroup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChangeGroup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChangeGroup

% Last Modified by GUIDE v2.5 21-Feb-2018 16:28:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChangeGroup_OpeningFcn, ...
                   'gui_OutputFcn',  @ChangeGroup_OutputFcn, ...
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


% --- Executes just before ChangeGroup is made visible.
function ChangeGroup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChangeGroup (see VARARGIN)

drivername = 'mysql-connector-java-5.0.8-bin.jar';
javaaddpath(drivername);

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
javaFrame    = get(gcf,'JavaFrame');
iconFilePath = 'C:\Program Files\MetaVision Studio\RegistrantStation\application\default_icon_48.png';
javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));

% Choose default command line output for ChangeGroup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChangeGroup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ChangeGroup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pindahkan.
function pindahkan_Callback(hObject, eventdata, handles)
global id_user pathAwal
val=get(handles.groupExist,'value');
str=get(handles.groupExist,'string');
str=str{val};
ixstrip=find(str=='-');
id_test=str(1:ixstrip-1);
folderGroup=str(ixstrip+1:end);
[flag, response] = GarjasEditContainer(id_user, id_test);
if flag
    pathTujuan=sprintf('C:\\imgCard\\%s\\',folderGroup);
    copyfile(pathAwal,pathTujuan)
    delete (pathAwal)
    h=mywarndlg('Pindah Group Berhasil','!! Sukses !!', 'modal');
    pause(3)
    try %#ok<TRYNC>
        close(h)
    end
else
    h=mywarndlg('Pindah Group Gagal','!! Gagal !!', 'modal');
    pause(3)
    try %#ok<TRYNC>
        close(h)
    end
end
set(handles.pindahkan,'Backgroundcolor',[0.94 0.94 0.94],'enable','inactive');

% --- Executes on button press in tutup.
function tutup_Callback(hObject, eventdata, handles)
close(gcf)




function noPeserta_Callback(hObject, eventdata, handles)
global id_user pathAwal
id_user=get(handles.noPeserta,'string');
nama = GarjasGetNama(id_user);
imgName = sprintf('%s-%s.jpg',nama, id_user);
if strcmp(nama,'-')
    h=mywarndlg('Nomor tidak ditemukan','Not Found', 'modal');
    pause(3)
    try %#ok<TRYNC>
        close(h)
    end
    return
end

[~, response] = GarjasGetMasterTest(id_user);
groupTest=response.nama_kegiatan;
pathAwal=sprintf('C:\\imgCard\\%s\\%s',groupTest,imgName);
set(handles.namaPeserta,'string',nama);
set(handles.namaGroup,'string',groupTest);

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
    set(handles.groupExist, 'String', GroupVal,'Backgroundcolor','cyan','value',1);
catch
    set(handles.groupExist, 'String', 'Group Available','Backgroundcolor','cyan','value',1);
end

set(handles.pindahkan,'Backgroundcolor','cyan','enable','on');
uicontrol(handles.groupExist);
% Hints: get(hObject,'String') returns contents of noPeserta as text
%        str2double(get(hObject,'String')) returns contents of noPeserta as a double


% --- Executes during object creation, after setting all properties.
function noPeserta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noPeserta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function namaPeserta_Callback(hObject, eventdata, handles)
% hObject    handle to namaPeserta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of namaPeserta as text
%        str2double(get(hObject,'String')) returns contents of namaPeserta as a double


% --- Executes during object creation, after setting all properties.
function namaPeserta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to namaPeserta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function namaGroup_Callback(hObject, eventdata, handles)
% hObject    handle to namaGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of namaGroup as text
%        str2double(get(hObject,'String')) returns contents of namaGroup as a double


% --- Executes during object creation, after setting all properties.
function namaGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to namaGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in groupExist.
function groupExist_Callback(hObject, eventdata, handles)
% hObject    handle to groupExist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns groupExist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from groupExist


% --- Executes during object creation, after setting all properties.
function groupExist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupExist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
