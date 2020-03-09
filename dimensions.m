function varargout = dimensions(varargin)
% DIMENSIONS MATLAB code for dimensions.fig
%      DIMENSIONS, by itself, creates a new DIMENSIONS or raises the existing
%      singleton*.
%      
%      dek=pi*half/sqrt(3);
% 
%      H = DIMENSIONS returns the handle to a new DIMENSIONS or the handle to
%      the existing singleton*.
%
%      DIMENSIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIMENSIONS.M with the given input arguments.
%
%      DIMENSIONS('Property','Value',...) creates a new DIMENSIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dimensions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dimensions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dimensions

% Last Modified by GUIDE v2.5 26-Nov-2019 12:54:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dimensions_OpeningFcn, ...
                   'gui_OutputFcn',  @dimensions_OutputFcn, ...
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


% --- Executes just before dimensions is made visible.
function dimensions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dimensions (see VARARGIN)

% Choose default command line output for dimensions
handles.pHandles=varargin{1};
handles.SData=handles.pHandles.SData;
% handles.SData=handles.pHandles.SData;


loadAll(hObject,eventdata, handles);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dimensions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dimensions_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

set(handles.pHandles.edit6,'String',handles.SData.l);
set(handles.pHandles.edit14,'String',handles.SData.lu);
set(handles.pHandles.edit8,'String',handles.SData.b);
set(handles.pHandles.edit16,'String',handles.SData.bu);
if handles.SData.shape=='c'
    if ~isnan(handles.SData.d)
        set(handles.pHandles.edit7,'String',handles.SData.d);
    else
        set(handles.edit7,'String','');
    end
    if ~isnan(handles.SData.du)
        set(handles.pHandles.edit15,'String',handles.SData.du);
    else
        set(handles.edit15,'String','');
    end
else
    if ~isnan(handles.SData.a)
        set(handles.pHandles.edit7,'String',handles.SData.a);
    else
        set(handles.edit7,'String','');
    end
    if ~isnan(handles.SData.au)
        set(handles.pHandles.edit15,'String',handles.SData.au);
    else
        set(handles.edit15,'String','');
    end
end
varargout{1} = handles.SData;

function loadAll(hObject, eventdata, handles)
if ~isempty(handles.SData)
    if handles.SData.shape=='c'
        load(handles.SData.SampleDim.l(1),handles.edit1);
        load(handles.SData.SampleDim.l(2),handles.edit2);
        load(handles.SData.SampleDim.l(3),handles.edit3);
        load(handles.SData.SampleDim.l(4),handles.edit4);
        load(handles.SData.SampleDim.l(5),handles.edit5);
        load(handles.SData.SampleDim.l(6),handles.edit6);
        load(handles.SData.SampleDim.l(7),handles.edit7);
        load(handles.SData.SampleDim.l(8),handles.edit8);
        load(handles.SData.SampleDim.l(9),handles.edit9);
        load(handles.SData.SampleDim.l(10),handles.edit10);
        
        load(handles.SData.SampleDim.d(1),handles.edit11);
        load(handles.SData.SampleDim.d(2),handles.edit12);
        load(handles.SData.SampleDim.d(3),handles.edit13);
        load(handles.SData.SampleDim.d(4),handles.edit14);
        load(handles.SData.SampleDim.d(5),handles.edit15);
        load(handles.SData.SampleDim.d(6),handles.edit16);
        load(handles.SData.SampleDim.d(7),handles.edit17);
        load(handles.SData.SampleDim.d(8),handles.edit18);
        load(handles.SData.SampleDim.d(9),handles.edit19);
        load(handles.SData.SampleDim.d(10),handles.edit20);

        set(handles.text13,'String','d [mm]');
        set(handles.text14,'Visible','off');
    
        set(handles.edit21,'Visible','off');
        set(handles.edit22,'Visible','off');
        set(handles.edit23,'Visible','off');
        set(handles.edit24,'Visible','off');
        set(handles.edit25,'Visible','off');
        set(handles.edit26,'Visible','off');
        set(handles.edit27,'Visible','off');
        set(handles.edit28,'Visible','off');
        set(handles.edit29,'Visible','off');
        set(handles.edit30,'Visible','off');
    else
        load(handles.SData.SampleDim.l(1),handles.edit1);
        load(handles.SData.SampleDim.l(2),handles.edit2);
        load(handles.SData.SampleDim.l(3),handles.edit3);
        load(handles.SData.SampleDim.l(4),handles.edit4);
        load(handles.SData.SampleDim.l(5),handles.edit5);
        load(handles.SData.SampleDim.l(6),handles.edit6);
        load(handles.SData.SampleDim.l(7),handles.edit7);
        load(handles.SData.SampleDim.l(8),handles.edit8);
        load(handles.SData.SampleDim.l(9),handles.edit9);
        load(handles.SData.SampleDim.l(10),handles.edit10);
        
        load(handles.SData.SampleDim.a(1),handles.edit11);
        load(handles.SData.SampleDim.a(2),handles.edit12);
        load(handles.SData.SampleDim.a(3),handles.edit13);
        load(handles.SData.SampleDim.a(4),handles.edit14);
        load(handles.SData.SampleDim.a(5),handles.edit15);
        load(handles.SData.SampleDim.a(6),handles.edit16);
        load(handles.SData.SampleDim.a(7),handles.edit17);
        load(handles.SData.SampleDim.a(8),handles.edit18);
        load(handles.SData.SampleDim.a(9),handles.edit19);
        load(handles.SData.SampleDim.a(10),handles.edit20);
        
        load(handles.SData.SampleDim.b(1),handles.edit21);
        load(handles.SData.SampleDim.b(2),handles.edit22);
        load(handles.SData.SampleDim.b(3),handles.edit23);
        load(handles.SData.SampleDim.b(4),handles.edit24);
        load(handles.SData.SampleDim.b(5),handles.edit25);
        load(handles.SData.SampleDim.b(6),handles.edit26);
        load(handles.SData.SampleDim.b(7),handles.edit27);
        load(handles.SData.SampleDim.b(8),handles.edit28);
        load(handles.SData.SampleDim.b(9),handles.edit29);
        load(handles.SData.SampleDim.b(10),handles.edit30);

        set(handles.text13,'String','a [mm]');
        set(handles.text14,'Visible','on');
    
        set(handles.edit21,'Visible','on');
        set(handles.edit22,'Visible','on');
        set(handles.edit23,'Visible','on');
        set(handles.edit24,'Visible','on');
        set(handles.edit25,'Visible','on');
        set(handles.edit26,'Visible','on');
        set(handles.edit27,'Visible','on');
        set(handles.edit28,'Visible','on');
        set(handles.edit29,'Visible','on');
        set(handles.edit30,'Visible','on');
    end
end

function load(data, edit)

if (isnan(data))
    set(edit,'String','');
else
    set(edit,'String',num2str(data));
end
    
function recalculate(hObject, eventdata, handles)
    handles.SData.SampleDim.l(1)=saveDataFromEdit(handles.SData.SampleDim.l(1),handles.edit1);
    handles.SData.SampleDim.l(2)=saveDataFromEdit(handles.SData.SampleDim.l(2),handles.edit2);
    handles.SData.SampleDim.l(3)=saveDataFromEdit(handles.SData.SampleDim.l(3),handles.edit3);
    handles.SData.SampleDim.l(4)=saveDataFromEdit(handles.SData.SampleDim.l(4),handles.edit4);
    handles.SData.SampleDim.l(5)=saveDataFromEdit(handles.SData.SampleDim.l(5),handles.edit5);
    handles.SData.SampleDim.l(6)=saveDataFromEdit(handles.SData.SampleDim.l(6),handles.edit6);
    handles.SData.SampleDim.l(7)=saveDataFromEdit(handles.SData.SampleDim.l(7),handles.edit7);
    handles.SData.SampleDim.l(8)=saveDataFromEdit(handles.SData.SampleDim.l(8),handles.edit8);
    handles.SData.SampleDim.l(9)=saveDataFromEdit(handles.SData.SampleDim.l(9),handles.edit9);
    handles.SData.SampleDim.l(10)=saveDataFromEdit(handles.SData.SampleDim.l(10),handles.edit10);
    
if (isequal(handles.SData.shape,'c'))    
    handles.SData.SampleDim.d(1)=saveDataFromEdit(handles.SData.SampleDim.d(1),handles.edit11);
    handles.SData.SampleDim.d(2)=saveDataFromEdit(handles.SData.SampleDim.d(2),handles.edit12);
    handles.SData.SampleDim.d(3)=saveDataFromEdit(handles.SData.SampleDim.d(3),handles.edit13);
    handles.SData.SampleDim.d(4)=saveDataFromEdit(handles.SData.SampleDim.d(4),handles.edit14);
    handles.SData.SampleDim.d(5)=saveDataFromEdit(handles.SData.SampleDim.d(5),handles.edit15);
    handles.SData.SampleDim.d(6)=saveDataFromEdit(handles.SData.SampleDim.d(6),handles.edit16);
    handles.SData.SampleDim.d(7)=saveDataFromEdit(handles.SData.SampleDim.d(7),handles.edit17);
    handles.SData.SampleDim.d(8)=saveDataFromEdit(handles.SData.SampleDim.d(8),handles.edit18);
    handles.SData.SampleDim.d(9)=saveDataFromEdit(handles.SData.SampleDim.d(9),handles.edit19);
    handles.SData.SampleDim.d(10)=saveDataFromEdit(handles.SData.SampleDim.d(10),handles.edit20);
else
    handles.SData.SampleDim.a(1)=saveDataFromEdit(handles.SData.SampleDim.a(1),handles.edit11);
    handles.SData.SampleDim.a(2)=saveDataFromEdit(handles.SData.SampleDim.a(2),handles.edit12);
    handles.SData.SampleDim.a(3)=saveDataFromEdit(handles.SData.SampleDim.a(3),handles.edit13);
    handles.SData.SampleDim.a(4)=saveDataFromEdit(handles.SData.SampleDim.a(4),handles.edit14);
    handles.SData.SampleDim.a(5)=saveDataFromEdit(handles.SData.SampleDim.a(5),handles.edit15);
    handles.SData.SampleDim.a(6)=saveDataFromEdit(handles.SData.SampleDim.a(6),handles.edit16);
    handles.SData.SampleDim.a(7)=saveDataFromEdit(handles.SData.SampleDim.a(7),handles.edit17);
    handles.SData.SampleDim.a(8)=saveDataFromEdit(handles.SData.SampleDim.a(8),handles.edit18);
    handles.SData.SampleDim.a(9)=saveDataFromEdit(handles.SData.SampleDim.a(9),handles.edit19);
    handles.SData.SampleDim.a(10)=saveDataFromEdit(handles.SData.SampleDim.a(10),handles.edit20);
    
    
    handles.SData.SampleDim.b(1)=saveDataFromEdit(handles.SData.SampleDim.b(1),handles.edit21);
    handles.SData.SampleDim.b(2)=saveDataFromEdit(handles.SData.SampleDim.b(2),handles.edit22);
    handles.SData.SampleDim.b(3)=saveDataFromEdit(handles.SData.SampleDim.b(3),handles.edit23);
    handles.SData.SampleDim.b(4)=saveDataFromEdit(handles.SData.SampleDim.b(4),handles.edit24);
    handles.SData.SampleDim.b(5)=saveDataFromEdit(handles.SData.SampleDim.b(5),handles.edit25);
    handles.SData.SampleDim.b(6)=saveDataFromEdit(handles.SData.SampleDim.b(6),handles.edit26);
    handles.SData.SampleDim.b(7)=saveDataFromEdit(handles.SData.SampleDim.b(7),handles.edit27);
    handles.SData.SampleDim.b(8)=saveDataFromEdit(handles.SData.SampleDim.b(8),handles.edit28);
    handles.SData.SampleDim.b(9)=saveDataFromEdit(handles.SData.SampleDim.b(9),handles.edit29);
    handles.SData.SampleDim.b(10)=saveDataFromEdit(handles.SData.SampleDim.b(10),handles.edit30);
    
end
guidata(hObject, handles);
handles.SData=recalculateData(handles.SData);
guidata(hObject, handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
recalculate(hObject, eventdata, handles)

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
recalculate(hObject, eventdata, handles);

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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
recalculate(hObject, eventdata, handles);

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
recalculate(hObject, eventdata, handles);

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
recalculate(hObject, eventdata, handles);

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
recalculate(hObject, eventdata, handles);

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
recalculate(hObject, eventdata, handles);

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
recalculate(hObject, eventdata, handles);

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
recalculate(hObject, eventdata, handles);

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
recalculate(hObject, eventdata, handles);

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



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double
recalculate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(get(handles.uibuttongroup1,'SelectedObject'),'String'),'Circle')
    set(handles.text13,'String','d [mm]');
    set(handles.text14,'Visible','off');
    
    set(handles.edit21,'Visible','off');
    set(handles.edit22,'Visible','off');
    set(handles.edit23,'Visible','off');
    set(handles.edit24,'Visible','off');
    set(handles.edit25,'Visible','off');
    set(handles.edit26,'Visible','off');
    set(handles.edit27,'Visible','off');
    set(handles.edit28,'Visible','off');
    set(handles.edit29,'Visible','off');
    set(handles.edit30,'Visible','off');
   
    handles.SData.shape='c';
else
    set(handles.text13,'String','a [mm]');
    set(handles.text14,'Visible','on');
    
    set(handles.edit21,'Visible','on');
    set(handles.edit22,'Visible','on');
    set(handles.edit23,'Visible','on');
    set(handles.edit24,'Visible','on');
    set(handles.edit25,'Visible','on');
    set(handles.edit26,'Visible','on');
    set(handles.edit27,'Visible','on');
    set(handles.edit28,'Visible','on');
    set(handles.edit29,'Visible','on');
    set(handles.edit30,'Visible','on');
    
    
    handles.SData.shape='r';
end
loadAll(hObject, eventdata, handles);
