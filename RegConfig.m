function varargout = RegConfig(varargin)
% RegConfig MATLAB code for RegConfig.fig
%      RegConfig, by itself, creates a new RegConfig or raises the existing
%      singleton*.
%
%      H = RegConfig returns the handle to a new RegConfig or the handle to
%      the existing singleton*.
%
%      RegConfig('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RegConfig.M with the given input arguments.
%
%      RegConfig('Property','Value',...) creates a new RegConfig or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RegConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RegConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RegConfig

% Last Modified by GUIDE v2.5 23-Jan-2018 14:05:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RegConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @RegConfig_OutputFcn, ...
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


% --- Executes just before RegConfig is made visible.
function RegConfig_OpeningFcn(hObject, eventdata, handles, varargin)
global s RData checkStimer
checkStimer = timer('Period', 0.5,'ExecutionMode','fixedSpacing');
set(checkStimer, 'TimerFcn', {@checkSerial, hObject, eventdata, handles});
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegConfig (see VARARGIN)

% Choose default command line output for RegConfig
set(handles.text26, 'style', 'push', 'enable', 'off','string','<HTML>k<sub>3</sub></HTML>')
set(handles.text27, 'style', 'push', 'enable', 'off','string','<HTML>k<sub>2</sub></HTML>')
set(handles.text28, 'style', 'push', 'enable', 'off','string','<HTML>k<sub>0</sub></HTML>')
set(handles.text29, 'style', 'push', 'enable', 'off','string','<HTML>k<sub>4</sub></HTML>')
set(handles.text30, 'style', 'push', 'enable', 'off','string','<HTML>k<sub>1</sub></HTML>')
set(handles.text31, 'style', 'push', 'enable', 'off','string','<HTML>T<sub>C</sub> = T<sub>M</sub>+k<sub>0</sub>+k<sub>1</sub>*T<sub>M</sub>+k<sub>2</sub>*T<sub>M</sub><sup>2</sup>+k<sub>3</sub>*T<sub>M</sub><sup>3</sup>+k<sub>4</sub>*T<sub>M</sub><sup>4</sup></HTML>')
handles.output = hObject;
s=varargin{1};

[RData.Prop flag]=sendCommand(s,'KPR:',[]);
[RData.Int flag]=sendCommand(s,'KIR:',[]);
[RData.Der flag]=sendCommand(s,'KDR:',[]);
[RData.k0 flag]=sendCommand(s,'K0R:',[]);
[RData.k1 flag]=sendCommand(s,'K1R:',[]);
[RData.k2 flag]=sendCommand(s,'K2R:',[]);
[RData.k3 flag]=sendCommand(s,'K3R:',[]);
[RData.k4 flag]=sendCommand(s,'K4R:',[]);

if ~isempty(RData)
    set(handles.edit20,'String',num2str(RData.Prop));
    set(handles.edit21,'String',num2str(RData.Int));
    set(handles.edit22,'String',num2str(RData.Der));
    set(handles.edit15,'String',num2str(RData.k0));
    set(handles.edit16,'String',num2str(RData.k1));
    set(handles.edit17,'String',num2str(RData.k2));
    set(handles.edit18,'String',num2str(RData.k3));
    set(handles.edit19,'String',num2str(RData.k4));
end
%     set(handles.mainFigure,'UserData',RData);
% Initialise tabs

% Set-up a selection changed function on the create tab groups

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RegConfig wait for user response (see UIRESUME)
uiwait(handles.mainFigure);


function checkSerial(hob, evdat, hObject, eventdata, handles)
    global s
    handles = guidata(hObject);
    if isempty(s)
        RegConfig_OutputFcn(hObject, eventdata, handles);
    end
% Called when a user clicks on a tab

% --- Executes during object creation, after setting all properties.
function mainFigure_CreateFcn(hObject, eventdata, handles)
global s RData

% udata = get(handles.uipanel21,'UserData');
% s=udata{7};
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% h = findobj('Tag','okno');
% gOdata = guidata(h);
% set(handles.text1,'String',get(g1data.edit1,'String'));
% set(handles.mainFigure,'UserData',RData);

% --- Outputs from this function are returned to the command line.
function varargout = RegConfig_OutputFcn(hObject, eventdata, handles) 
% RData=get(handles.mainFigure,'UserData');
global RData
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = RData;
delete(handles.mainFigure);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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

% --- Executes on button press in buttonSelectMain.
% --- Executes when user attempts to close mainFigure.
function mainFigure_CloseRequestFcn(hObject, eventdata, handles)
global RData
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

RData.Prop=str2num(get(handles.edit20,'String'));
RData.Int=str2num(get(handles.edit21,'String'));
RData.Der=str2num(get(handles.edit22,'String'));
RData.k0=str2num(get(handles.edit15,'String'));
RData.k1=str2num(get(handles.edit16,'String'));
RData.k2=str2num(get(handles.edit17,'String'));
RData.k3=str2num(get(handles.edit18,'String'));
RData.k4=str2num(get(handles.edit19,'String'));
% set(handles.mainFigure,'UserData',RData);
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
% The GUI is no longer waiting, just close it
    delete(hObject);
end

function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global s RData
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% udata = get(handles.uipanel21,'UserData');
% s=udata{7};
RData.Prop=str2num(get(handles.edit20,'String'));
RData.Int=str2num(get(handles.edit21,'String'));
RData.Der=str2num(get(handles.edit22,'String'));
RData.k0=str2num(get(handles.edit15,'String'));
RData.k1=str2num(get(handles.edit16,'String'));
RData.k2=str2num(get(handles.edit17,'String'));
RData.k3=str2num(get(handles.edit18,'String'));
RData.k4=str2num(get(handles.edit19,'String'));
flag=0;
w = waitbar(0,'Proportional','Name','Save');
while flag~=1
    [req flag]=sendCommand(s,'KP:%.2f',RData.Prop);
end
flag=0;
waitbar(1/8,w,'Integral');
while flag~=1
    [req flag]=sendCommand(s,'KI:%.2f',RData.Int);
end
flag=0;
waitbar(2/8,w,'Derivative');
while flag~=1
    [req flag]=sendCommand(s,'KD:%.2f',RData.Der);
end
flag=0;
waitbar(3/8,w,'K_{0}');
while flag~=1
    [req flag]=sendCommand(s,'K0:%.2f',RData.k0);
end
flag=0;
waitbar(4/8,w,'K_{1}');
while flag~=1
    [req flag]=sendCommand(s,'K1:%.2f',RData.k1);
end
flag=0;
waitbar(5/8,w,'K_{2}');
while flag~=1
    [req flag]=sendCommand(s,'K2:%.2f',RData.k2);
end
flag=0;
waitbar(6/8,w,'K_{3}');
while flag~=1
    [req flag]=sendCommand(s,'K3:%.2f',RData.k3);
end
flag=0;
waitbar(7/8,w,'K_{4}');
while flag~=1
    [req flag]=sendCommand(s,'K4:%.2f',RData.k4);
end
waitbar(1,w,'Complete');
close(w)
close(handles.mainFigure);
