function varargout = PcdRegister(varargin)
% PCDREGISTER MATLAB code for PcdRegister.fig
%      PCDREGISTER, by itself, creates a new PCDREGISTER or raises the existing
%      singleton*.
%
%      H = PCDREGISTER returns the handle to a new PCDREGISTER or the handle to
%      the existing singleton*.
%
%      PCDREGISTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCDREGISTER.M with the given input arguments.
%
%      PCDREGISTER('Property','Value',...) creates a new PCDREGISTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PcdRegister_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PcdRegister_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PcdRegister

% Last Modified by GUIDE v2.5 24-Mar-2020 14:20:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PcdRegister_OpeningFcn, ...
                   'gui_OutputFcn',  @PcdRegister_OutputFcn, ...
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


% --- Executes just before PcdRegister is made visible.
function PcdRegister_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PcdRegister (see VARARGIN)

% Choose default command line output for PcdRegister
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PcdRegister wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PcdRegister_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global pcd1;
global TR;
TR=[0.0 0.0 0.0];
pcd1path=get(hObject,'String');
pcd1=pcread(pcd1path{1});
pcd1=pcd1.Location;
pcd1=pcd1+TR;
R=rotx(-90);
pcd1=R*pcd1';
pcd1=pcd1';
pcd1=[pcd1;[0 0 0];[0 0.2 0 ];[0 0.4 0]];
pcd1(pcd1(:,3)>0.05,:)=[];
pcd1(pcd1(:,3)<-0.2,:)=[];


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global pcd2;
global x y rot_x rot_y rot_z TR;
x=0;
y=0;
rot_x=0;
rot_y=0;
rot_z=0;
pcd2path=get(hObject,'String');
pcd2=pcread(pcd2path{1});
pcd2=pcd2.Location;
pcd2=pcd2+TR;
R=rotx(-90);
pcd2=R*pcd2';
pcd2=pcd2';
pcd2=[pcd2;[0 0 0];[0 0.2 0 ];[0 0.4 0]];
pcd2(pcd2(:,3)>0.05,:)=[];
pcd2(pcd2(:,3)<-0.2,:)=[];


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global pcd1 pcd2 x y rot_x rot_y rot_z
rot_x = get(hObject,'Value');
pcd2t=pcd2+[x y 0];
pcd2t = rotx(rot_x)*roty(rot_y)*rotz(rot_z)*pcd2t';
pcd2t=pcd2t';
axesHandle = findobj('Tag', 'axes1');
cla(axesHandle);
pcshowpair(pointCloud(pcd1),pointCloud(pcd2t),'MarkerSize',30);
xlabel('X')
ylabel('Y')
zlabel('Z')
title(['x ' num2str(x) ' y ' num2str(y) ' rot_x ' num2str(rot_x) ' rot_y ' num2str(rot_y) ' rot_z ' num2str(rot_z)]);
view(0,90)


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global pcd1 pcd2 x y rot_x rot_y rot_z
rot_y = get(hObject,'Value');
pcd2t=pcd2+[x y 0];
pcd2t = rotx(rot_x)*roty(rot_y)*rotz(rot_z)*pcd2t';
pcd2t=pcd2t';
axesHandle = findobj('Tag', 'axes1');
cla(axesHandle);
pcshowpair(pointCloud(pcd1),pointCloud(pcd2t),'MarkerSize',30);
xlabel('X')
ylabel('Y')
zlabel('Z')
title(['x ' num2str(x) ' y ' num2str(y) ' rot_x ' num2str(rot_x) ' rot_y ' num2str(rot_y) ' rot_z ' num2str(rot_z)]);
view(0,90)


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global pcd1 pcd2 x y rot_x rot_y rot_z
rot_z = get(hObject,'Value');
pcd2t=pcd2+[x y 0];
pcd2t = rotx(rot_x)*roty(rot_y)*rotz(rot_z)*pcd2t';
pcd2t=pcd2t';
axesHandle = findobj('Tag', 'axes1');
cla(axesHandle);
pcshowpair(pointCloud(pcd1),pointCloud(pcd2t),'MarkerSize',30);
xlabel('X')
ylabel('Y')
zlabel('Z')
title(['x ' num2str(x) ' y ' num2str(y) ' rot_x ' num2str(rot_x) ' rot_y ' num2str(rot_y) ' rot_z ' num2str(rot_z)]);
view(0,90)


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global pcd1 pcd2 x y rot_x rot_y rot_z
y = get(hObject,'Value');
pcd2t=pcd2+[x y 0];
pcd2t = rotx(rot_x)*roty(rot_y)*rotz(rot_z)*pcd2t';
pcd2t=pcd2t';
axesHandle = findobj('Tag', 'axes1');
cla(axesHandle);
pcshowpair(pointCloud(pcd1),pointCloud(pcd2t),'MarkerSize',30);
xlabel('X')
ylabel('Y')
zlabel('Z')
title(['x ' num2str(x) ' y ' num2str(y) ' rot_x ' num2str(rot_x) ' rot_y ' num2str(rot_y) ' rot_z ' num2str(rot_z)]);
view(0,90)


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global pcd1 pcd2 x y rot_x rot_y rot_z
x = get(hObject,'Value');
pcd2t=pcd2+[x y 0];
pcd2t = rotx(rot_x)*roty(rot_y)*rotz(rot_z)*pcd2t';
pcd2t=pcd2t';
axesHandle = findobj('Tag', 'axes1');
cla(axesHandle);
pcshowpair(pointCloud(pcd1),pointCloud(pcd2t),'MarkerSize',30);
xlabel('X')
ylabel('Y')
zlabel('Z')
title(['x ' num2str(x) ' y ' num2str(y) ' rot_x ' num2str(rot_x) ' rot_y ' num2str(rot_y) ' rot_z ' num2str(rot_z)]);
view(0,90)



% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
