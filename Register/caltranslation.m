function varargout = caltranslation(varargin)
% caltranslation MATLAB code for caltranslation.fig
%      caltranslation, by itself, creates a new caltranslation or raises the existing
%      singleton*.
%
%      H = caltranslation returns the handle to a new caltranslation or the handle to
%      the existing singleton*.
%
%      caltranslation('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in caltranslation.M with the given input arguments.
%
%      caltranslation('Property','Value',...) creates a new caltranslation or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before caltranslation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to caltranslation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help caltranslation

% Last Modified by GUIDE v2.5 23-Mar-2020 11:38:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @caltranslation_OpeningFcn, ...
                   'gui_OutputFcn',  @caltranslation_OutputFcn, ...
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


% --- Executes just before caltranslation is made visible.
function caltranslation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to caltranslation (see VARARGIN)

% Choose default command line output for caltranslation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes caltranslation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = caltranslation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


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
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


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
global num1;
global num2;
global x;
global y;
global theta;
global thetax;
global thetay;
x = get(hObject,'Value');
% set(handels.text8,'String',['x ' num2str(x) ' y ' num2str(x) ' theta ' num2str(theta)]);
path = '/home/yaoshw/Downloads';
if(num1~=0&&num2~=0)
    axesHandle = findobj('Tag', 'axes1');
    cla(axesHandle);
    deg = [thetax thetay theta]; % 角度制
    trans = [x y 0];
    deg = deg*pi/180;
    R = eul2rotm(fliplr(deg),'ZYX');
    label_pose = importdata([path '/pose info.txt']);
    submap = importdata([path '/points/pcd_' num2str(num1) '.txt']);
    submap_poseT = label_pose(num1+1,1:3);
    submap_poseR = quat2rotm(label_pose(num1+1,4:7));
    submap = [submap;[0 0 0];[0 0.2 0];[0 0.4 0]];
    submap = submap + trans;
    submap = submap_poseR*R*submap' + submap_poseT';
    submap = submap';
    
    scan = importdata([path '/points/pcd_' num2str(num2) '.txt']);
    scan_poseT = label_pose(num2+1,1:3);
    scan_poseR = quat2rotm(label_pose(num2+1,4:7));
    scan = [scan;[0 0 0];[0 0.2 0];[0 0.4 0]];
    scan = scan + trans;
    
    degt = [0 0 0];
    degt = degt*pi/180;
    Rt = eul2rotm(fliplr(degt),'ZYX');
    transt = [-0.00 0.0 0];
    scan = Rt*scan_poseR*R*scan' + scan_poseT' + transt';
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,'g','filled','MarkerFaceAlpha',1.0);
    hold on;
    scatter3(scan(1,:),scan(2,:),scan(3,:),8,'r','filled');
    title(['x ' num2str(x) ' y ' num2str(y) ' theta ' num2str(theta) ' thetax ' num2str(thetax) ' thetay ' num2str(thetay)]);
    view(0,90)
end



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
global num1;
global num2;
global x;
global y;
global theta;
global thetax;
global thetay;
y = get(hObject,'Value');
path = '/home/yaoshw/Downloads';
if(num1~=0&&num2~=0)
    axesHandle = findobj('Tag', 'axes1');
    cla(axesHandle);
    deg = [thetax thetay theta]; % 角度制
    trans = [x y 0];
    deg = deg*pi/180;
    R = eul2rotm(fliplr(deg),'ZYX');
    label_pose = importdata([path '/pose info.txt']);
    submap = importdata([path '/points/pcd_' num2str(num1) '.txt']);
    submap_poseT = label_pose(num1+1,1:3);
    submap_poseR = quat2rotm(label_pose(num1+1,4:7));
    submap = [submap;[0 0 0];[0 0.2 0];[0 0.4 0]];
    submap = submap + trans;
    submap = submap_poseR*R*submap' + submap_poseT';
    submap = submap';
    
    scan = importdata([path '/points/pcd_' num2str(num2) '.txt']);
    scan_poseT = label_pose(num2+1,1:3);
    scan_poseR = quat2rotm(label_pose(num2+1,4:7));
    scan = [scan;[0 0 0];[0 0.2 0];[0 0.4 0]];
    scan = scan + trans;
    
    degt = [0 0 0];
    degt = degt*pi/180;
    Rt = eul2rotm(fliplr(degt),'ZYX');
    transt = [-0.00 0.0 0];
    scan = Rt*scan_poseR*R*scan' + scan_poseT' + transt';
    
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,'g','filled','MarkerFaceAlpha',1.0);
    hold on;
    scatter3(scan(1,:),scan(2,:),scan(3,:),8,'r','filled');
    title(['x ' num2str(x) ' y ' num2str(y) ' theta ' num2str(theta) ' thetax ' num2str(thetax) ' thetay ' num2str(thetay)]);
    view(0,90)
end


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global num1;
num1 = str2double(get(hObject,'String'));



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
global num2;
global x;
global y;
global theta;
global thetax;
global thetay;
num2 = str2double(get(hObject,'String'));
x=0;
y=0;
theta=0;
thetax=0;
thetay=0;


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
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global num1;
global num2;
global x;
global y;
global theta;
global thetax;
global thetay;
theta = get(hObject,'Value');
path = '/home/yaoshw/Downloads';
if(num1~=0&&num2~=0)
    axesHandle = findobj('Tag', 'axes1');
    cla(axesHandle);
    deg = [thetax thetay theta]; % 角度制
    trans = [x y 0];
    deg = deg*pi/180;
    R = eul2rotm(fliplr(deg),'ZYX');
    label_pose = importdata([path '/pose info.txt']);
    submap = importdata([path '/points/pcd_' num2str(num1) '.txt']);
    submap_poseT = label_pose(num1+1,1:3);
    submap_poseR = quat2rotm(label_pose(num1+1,4:7));
    submap = [submap;[0 0 0];[0 0.2 0];[0 0.4 0]];
    submap = submap + trans;
    submap = submap_poseR*R*submap' + submap_poseT';
    submap = submap';
    
    scan = importdata([path '/points/pcd_' num2str(num2) '.txt']);
    scan_poseT = label_pose(num2+1,1:3);
    scan_poseR = quat2rotm(label_pose(num2+1,4:7));
    scan = [scan;[0 0 0];[0 0.2 0];[0 0.4 0]];
    scan = scan + trans;
    
    degt = [0 0 0];
    degt = degt*pi/180;
    Rt = eul2rotm(fliplr(degt),'ZYX');
    transt = [-0.00 0.0 0];
    scan = Rt*scan_poseR*R*scan' + scan_poseT' + transt';
    
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,'g','filled','MarkerFaceAlpha',1.0);
    hold on;
    scatter3(scan(1,:),scan(2,:),scan(3,:),8,'r','filled');
    title(['x ' num2str(x) ' y ' num2str(y) ' theta ' num2str(theta) ' thetax ' num2str(thetax) ' thetay ' num2str(thetay)]);
    view(0,90)
end


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global num1;
global num2;
global x;
global y;
global theta;
global thetax;
global thetay;
thetax = get(hObject,'Value');
path = '/home/yaoshw/Downloads';
if(num1~=0&&num2~=0)
    axesHandle = findobj('Tag', 'axes1');
    cla(axesHandle);
    deg = [thetax thetay theta]; % 角度制
    trans = [x y 0];
    deg = deg*pi/180;
    R = eul2rotm(fliplr(deg),'ZYX');
    label_pose = importdata([path '/pose info.txt']);
    submap = importdata([path '/points/pcd_' num2str(num1) '.txt']);
    submap_poseT = label_pose(num1+1,1:3);
    submap_poseR = quat2rotm(label_pose(num1+1,4:7));
    submap = [submap;[0 0 0];[0 0.2 0];[0 0.4 0]];
    submap = submap + trans;
    submap = submap_poseR*R*submap' + submap_poseT';
    submap = submap';
    
    scan = importdata([path '/points/pcd_' num2str(num2) '.txt']);
    scan_poseT = label_pose(num2+1,1:3);
    scan_poseR = quat2rotm(label_pose(num2+1,4:7));
    scan = [scan;[0 0 0];[0 0.2 0];[0 0.4 0]];
    scan = scan + trans;
    
    degt = [0 0 0];
    degt = degt*pi/180;
    Rt = eul2rotm(fliplr(degt),'ZYX');
    transt = [-0.00 0.0 0];
    scan = Rt*scan_poseR*R*scan' + scan_poseT' + transt';
    
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,'g','filled','MarkerFaceAlpha',1.0);
    hold on;
    scatter3(scan(1,:),scan(2,:),scan(3,:),8,'r','filled');
    title(['x ' num2str(x) ' y ' num2str(y) ' theta ' num2str(theta) ' thetax ' num2str(thetax) ' thetay ' num2str(thetay)]);
    view(0,90)
end


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global num1;
global num2;
global x;
global y;
global theta;
global thetax;
global thetay;
thetay = get(hObject,'Value');
path = '/home/yaoshw/Downloads';
if(num1~=0&&num2~=0)
    axesHandle = findobj('Tag', 'axes1');
    cla(axesHandle);
    deg = [thetax thetay theta]; % 角度制
    trans = [x y 0];
    deg = deg*pi/180;
    R = eul2rotm(fliplr(deg),'ZYX');
    label_pose = importdata([path '/pose info.txt']);
    submap = importdata([path '/points/pcd_' num2str(num1) '.txt']);
    submap_poseT = label_pose(num1+1,1:3);
    submap_poseR = quat2rotm(label_pose(num1+1,4:7));
    submap = [submap;[0 0 0];[0 0.2 0];[0 0.4 0]];
    submap = submap + trans;
    submap = submap_poseR*R*submap' + submap_poseT';
    submap = submap';
    
    scan = importdata([path '/points/pcd_' num2str(num2) '.txt']);
    scan_poseT = label_pose(num2+1,1:3);
    scan_poseR = quat2rotm(label_pose(num2+1,4:7));
    scan = [scan;[0 0 0];[0 0.2 0];[0 0.4 0]];
    scan = scan + trans;
    
    degt = [0 0 0];
    degt = degt*pi/180;
    Rt = eul2rotm(fliplr(degt),'ZYX');
    transt = [-0.00 0.0 0];
    scan = Rt*scan_poseR*R*scan' + scan_poseT' + transt';
    
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,'g','filled','MarkerFaceAlpha',1.0);
    hold on;
    scatter3(scan(1,:),scan(2,:),scan(3,:),8,'r','filled');
    title(['x ' num2str(x) ' y ' num2str(y) ' theta ' num2str(theta) ' thetax ' num2str(thetax) ' thetay ' num2str(thetay)]);
    view(0,90)
end


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
