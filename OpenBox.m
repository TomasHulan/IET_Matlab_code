function varargout = OpenBox(varargin)
% OpenBox MATLAB code for OpenBox.fig
%      OpenBox, by itself, creates a new OpenBox or raises the existing
%      singleton*.
%
%      H = OpenBox returns the handle to a new OpenBox or the handle to
%      the existing singleton*.
%
%      OpenBox('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OpenBox.M with the given input arguments.
%
%      OpenBox('Property','Value',...) creates a new OpenBox or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OpenBox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OpenBox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OpenBox

% Last Modified by GUIDE v2.5 10-Jul-2019 13:06:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OpenBox_OpeningFcn, ...
                   'gui_OutputFcn',  @OpenBox_OutputFcn, ...
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
    
% --- Executes just before OpenBox is made visible.
function OpenBox_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OpenBox (see VARARGIN)

% Choose default command line output for OpenBox
handles.output = hObject;

% funkcia na inicializ·ciu
handles.s=varargin{1};
handles.SData=varargin{2};

if ~isempty(handles.SData)
        set(handles.edit1,'String',handles.SData.SampleName);
        if ~isnan(handles.SData.m)
            set(handles.edit9,'String',handles.SData.m);
        end
        if ~isnan(handles.SData.fr)
            set(handles.edit10,'String',handles.SData.fr);
        end
        if ~isnan(handles.SData.l)
            set(handles.edit6,'String',handles.SData.l);
        end
        if ~isnan(handles.SData.lu)
            set(handles.edit14,'String',handles.SData.lu);
        end
        set(handles.edit5,'String',handles.SData.comm);
        if ~isnan(handles.SData.b)
            set(handles.edit8,'String',handles.SData.b);
        end
        if ~isnan(handles.SData.bu)
            set(handles.edit16,'String',handles.SData.bu);
        end
        set(handles.checkbox1,'Value',handles.SData.Y);
        if handles.SData.shape=='c'
            if ~isnan(handles.SData.d)
                set(handles.edit7,'String',handles.SData.d);
            end
            if ~isnan(handles.SData.du)
                set(handles.edit15,'String',handles.SData.du);
            end
            set(handles.radiobutton3,'Value',1);
            set(handles.radiobutton4,'Value',0);
            circle = imread('img/circle.jpg');
            set(handles.axes3,'Units','pixels');
            axes(handles.axes3);
            imshow(circle);
    %         set(handles.axes3,'Visible','on');
         else
            if ~isnan(handles.SData.a)
                set(handles.edit7,'String',handles.SData.a);
            end
            if ~isnan(handles.SData.au)
                set(handles.edit15,'String',handles.SData.au);
            end
            set(handles.text9,'Visible','on');
            set(handles.edit8,'Visible','on');
            set(handles.edit16,'Visible','on');
            set(handles.text14,'Visible','on');
            set(handles.radiobutton3,'Value',0);
            set(handles.radiobutton4,'Value',1);
            rectangle = imread('img/rectangle.jpg');
            set(handles.axes3,'Units','pixels');
            axes(handles.axes3);
            imshow(rectangle);
    %         set(handles.axes3,'Visible','on');
        end
        if isequal(handles.SData.Y,1)
            set(handles.pushbutton6,'Enable','on');
            set(handles.pushbutton7,'Enable','on');
        else
            set(handles.pushbutton6,'Enable','off');
            set(handles.pushbutton7,'Enable','off');
        end
        TempProgPlot(handles,handles.SData.ProgT);
    end
        set(handles.uitable1,'Data',handles.SData.TableT);
        checkTable(hObject, eventdata, handles);
    % Initialise tabs
    handles.tabManager = TabManager( hObject );

    % Set-up a selection changed function on the create tab groups
    tabGroups = handles.tabManager.TabGroups;
    for tgi=1:length(tabGroups)
        set(tabGroups(tgi),'SelectionChangedFcn',@tabChangedCB)
    end
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OpenBox wait for user response (see UIRESUME)
uiwait(handles.mainFigure);


% Called when a user clicks on a tab

% --- Executes during object creation, after setting all properties.
function mainFigure_CreateFcn(hObject, eventdata, handles)


% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% h = findobj('Tag','okno');
% gOdata = guidata(h);
% set(handles.text1,'String',get(g1data.edit1,'String'));


function tabChangedCB(src, eventdata)

% disp(['Changing tab from ' eventdata.OldValue.Title ' to ' eventdata.NewValue.Title ] );




% --- Outputs from this function are returned to the command line.
function varargout = OpenBox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.SData;
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
function buttonSelectMain_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSelectMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabMan = handles.tabManager;
tabMan.Handles.TabA.SelectedTab = tabMan.Handles.TabA01Sample;
guidata(hObject, handles);


% --- Executes on button press in buttonSelectSupplementary.
function buttonSelectSupplementary_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSelectSupplementary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabMan = handles.tabManager;
tabMan.Handles.TabA.SelectedTab = tabMan.Handles.TabA02TemperatureProgram;
guidata(hObject, handles);





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Rage=str2num(get(handles.edit3,'String'));
Temp=str2num(get(handles.edit2,'String'));
Time=str2num(get(handles.edit4,'String'));
% vektor r˝chlost, teplota, Ëas pre uloûenie do s˙boru
FData=[Rage,Temp,Time];
if (Rage~=0)
    if isequal(get(get(handles.uibuttongroup1,'SelectedObject'),'String'),'Dynamic')
% ak dynamick˝ reûim, Ëas je rovn˝ 0
        FData(3)=0;
    else
% ak izorema, r˝chlosù a teplota je rovn· 0
        FData(1)=0;
        FData(2)=0;
    end
% matica teplotnÈho reûimu pre tabuæku  
    handles.SData.TableT=[handles.SData.TableT; FData];
    set(handles.uitable1,'Data',handles.SData.TableT);
    getProgT(hObject, eventdata, handles);
end
guidata(hObject, handles);

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
saveDataFromEdit(NaN,handles.edit2);

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
saveDataFromEdit(NaN,handles.edit3);

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
saveDataFromEdit(NaN,handles.edit4);

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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SData.TableT(handles.SData.row,:)=[];
set(handles.uitable1,'Data',handles.SData.TableT);
getProgT(hObject,eventdata,handles);
guidata(hObject, handles);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


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
handles.SData.l=saveDataFromEdit(handles.SData.l,handles.edit6);
guidata(hObject, handles);

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
if handles.SData.shape=='c'
    handles.SData.d=saveDataFromEdit(handles.SData.d,handles.edit7);
else
    handles.SData.a=saveDataFromEdit(handles.SData.a,handles.edit7);
end
guidata(hObject, handles);

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
handles.SData.b=saveDataFromEdit(handles.SData.b,handles.edit8);
guidata(hObject, handles);

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
handles.SData.m=saveDataFromEdit(handles.SData.m,handles.edit9);
guidata(hObject, handles);

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
handles.SData.fr=saveDataFromEdit(handles.SData.fr,handles.edit10);
guidata(hObject, handles);

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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SData.DIL=uiimport();
guidata(hObject, handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SData.TG=uiimport();
guidata(hObject, handles);


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(get(handles.uibuttongroup2,'SelectedObject'),'String'),'circle')
    set(handles.text11,'String','r =');
    set(handles.text9,'Visible','off');
    set(handles.edit8,'Visible','off');
    set(handles.edit16,'Visible','off');
    set(handles.text14,'Visible','off');
    if ~isnan(handles.SData.d)
        set(handles.edit7,'String',handles.SData.d);
    end
    if ~isnan(handles.SData.du)
        set(handles.edit15,'String',handles.SData.du);
    end
    circle = imread('img/circle.jpg');
    set(handles.axes3,'Units','pixels');
    axes(handles.axes3);
    imshow(circle);
    handles.SData.shape='c';
else
    set(handles.text11,'String','a =');
    set(handles.text9,'Visible','on');
    set(handles.edit8,'Visible','on');
    set(handles.edit16,'Visible','on');
    set(handles.text14,'Visible','on');
    if ~isnan(handles.SData.a)
        set(handles.edit7,'String',handles.SData.a);
    else
        set(handles.edit7,'String','');
    end
    if ~isnan(handles.SData.au)
        set(handles.edit15,'String',handles.SData.au);
    else
        set(handles.edit15,'String','');
    end
    rectangle = imread('img/rectangle.jpg');
    set(handles.axes3,'Units','pixels');
    axes(handles.axes3);
    imshow(rectangle);
    handles.SData.shape='r';
end
guidata(hObject, handles);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(get(handles.uibuttongroup1,'SelectedObject'),'String'),'Dynamic')
    set(handles.edit4,'Enable','off');
    set(handles.edit2,'Enable','on');
    set(handles.edit3,'Enable','on');
else
    set(handles.edit4,'Enable','on');
    set(handles.edit2,'Enable','off');
    set(handles.edit3,'Enable','off');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TabA02TemperatureProgram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TabA02TemperatureProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Name=get(handles.edit11,'String');
if (Name~=0)
    Name=[Name '.tpr'];
    dlmwrite(Name, handles.SData.TableT);
    msgbox(['File "' Name '" was successfully saved'])
end
guidata(hObject, handles);




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% keyboard
handles.SData.TableT=[];
handles.SData.ProgT=[0,0];
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.tpr','Temperature Program');
if (filename~=0)
    [handles.SData.TableT]=importdata(filename);
    set(handles.uitable1,'Data',handles.SData.TableT);
    getProgT(hObject,eventdata,handles);
end
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    handles.SData.row = eventdata.Indices(1,1);
    handles.SData.col = eventdata.Indices(1,2);
end
guidata(hObject, handles);


% --- Executes when user attempts to close mainFigure.
function mainFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(handles.axes2,'Color'),[1 0.4902 0.4902])
    f = msgbox('Invalid temperature program', 'Error','warn');
else

saveData(hObject, eventdata, handles);
% Hint: delete(hObject) closes the figure
% handles.SData.SampleName=get(handles.edit1,'String');
% handles.SData.m=str2num(get(handles.edit9,'String'));
% handles.SData.l=str2num(get(handles.edit6,'String'));
% handles.SData.lu=str2num(get(handles.edit14,'String'));
% handles.SData.fr=str2num(get(handles.edit10,'String'));
% handles.SData.comm=get(handles.edit5,'String');
% if isequal(get(get(handles.uibuttongroup2,'SelectedObject'),'String'),'circle')
%     handles.SData.d=str2num(get(handles.edit7,'String'));
%     handles.SData.du=str2num(get(handles.edit15,'String'));
%     handles.SData.shape='c';
% else
%     handles.SData.a=str2num(get(handles.edit7,'String'));
%     handles.SData.au=str2num(get(handles.edit15,'String'));
%     handles.SData.b=str2num(get(handles.edit8,'String'));
%     handles.SData.bu=str2num(get(handles.edit16,'String'));
%     handles.SData.shape='r';
% end
handles.SData.Y=get(handles.checkbox1,'Value');
guidata(hObject, handles);

if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
% The GUI is no longer waiting, just close it
    delete(hObject);
end
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
YM=get(handles.checkbox1,'Value');
if YM==1
    set(handles.pushbutton6,'Enable','on');
    set(handles.pushbutton7,'Enable','on');
else
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton7,'Enable','off');
end
guidata(hObject, handles);

function checkTable(hObject, eventdata, handles)
TableT=get(handles.uitable1,'Data');
for r=1:size(TableT,1)
    for c=1:3
        if (TableT(r,c)<0)
            TableT(r,c)=-1*TableT(r,c);
        end
        if (c==2 && (TableT(r,c)>1200))
            TableT(r,c)=1200;
        end
        if (c==1 && TableT(r,c)>50)
            TableT(r,c)=50;
        end
    
        if TableT(r,c)<0 || isempty(TableT(r,c))
            set(handles.axes2,'Color',[1 0.4902 0.4902]);
            return
        end
    end
    if (TableT(r,1)>0 && TableT(r,3)>0) || (isequal(TableT(r,1),0) && isequal(TableT(r,3),0))
        set(handles.axes2,'Color',[1 0.4902 0.4902]);
        return
    elseif (TableT(r,2)>0 && TableT(r,3)>0) || (isequal(TableT(r,2),0) && isequal(TableT(r,3),0))
        set(handles.axes2,'Color',[1 0.4902 0.4902]);
        return
    end
end
set(handles.uitable1,'Data',TableT);
% if ~isempty(TableT)
%     getProgT(hObject,eventdata,handles);
% end
set(handles.axes2,'Color',[0.7412 0.9373 0.6941]);
guidata(hObject, handles);
return

function getProgT(hObject, eventdata, handles)
TableT=get(handles.uitable1,'Data');
handles.SData.TableT=TableT;
checkTable(hObject, eventdata, handles);
if isequal(get(handles.axes2,'Color'),[1 0.4902 0.4902])
    return
end
if ~isempty(handles.s)
    ProgT=[0 str2num(sendCommand(handles.s,'AT:',[]))]; % doplniù aktu·lnu teplotu
    startT=[0 str2num(sendCommand(handles.s,'AT:',[])) 0];
else
    ProgT=[0 25];
    startT=[0 25 0];
end
TableT=[startT;TableT];
for i=2:size(TableT,1)
    if isequal(TableT(i,1),0) && isequal(TableT(i,2),0)
        ProgTemp=[ProgT(i-1,1) + TableT(i,3) ProgT(i-1,2)];
    elseif isequal(TableT(i,1),0)
        continue;
    else
        ProgTemp=[(ProgT(i-1,1)+abs((abs(TableT(i,2))-abs(ProgT(i-1,2)))/TableT(i,1))), TableT(i,2)];
    end
    ProgT=[ProgT; ProgTemp];
end
handles.SData.ProgT=ProgT;
% guidata(hObject, handles);
TempProgPlot(handles,handles.SData.ProgT);
checkTable(hObject, eventdata, handles);
% guidata(hObject, handles);

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	Previouhandles.SData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
getProgT(hObject, eventdata, handles);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function TabA01Sample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TabA01Sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableT=get(handles.uitable1,'Data');
if handles.SData.row>1
    m=TableT(handles.SData.row,:);
    TableT(handles.SData.row,:)=TableT(handles.SData.row-1,:);
    TableT(handles.SData.row-1,:)=m;
    handles.SData.row=handles.SData.row-1;
    set(handles.uitable1,'Data',TableT);
    handles.SData.TableT=TableT;
end
getProgT(hObject, eventdata, handles);
% guidata(hObject, handles);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TableT=get(handles.uitable1,'Data');
if handles.SData.row<size(TableT,1)
    m=TableT(handles.SData.row,:);
    TableT(handles.SData.row,:)=TableT(handles.SData.row+1,:);
    TableT(handles.SData.row+1,:)=m;
    handles.SData.row=handles.SData.row+1;
    set(handles.uitable1,'Data',TableT);
    handles.SData.TableT=TableT;
end
getProgT(hObject, eventdata, handles);
% guidata(hObject, handles);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SData=dimensions(handles);
guidata(hObject, handles);
set(handles.edit6,'String',handles.SData.l);
set(handles.edit14,'String',handles.SData.lu);
set(handles.edit8,'String',handles.SData.b);
set(handles.edit16,'String',handles.SData.bu);
if handles.SData.shape=='c'
	set(handles.edit7,'String',handles.SData.d);
    set(handles.edit15,'String',handles.SData.du);
else
	set(handles.edit7,'String',handles.SData.a);
    set(handles.edit15,'String',handles.SData.au);
end
guidata(hObject, handles);




function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double

handles.SData.lu=saveDataFromEdit(handles.SData.lu,handles.edit14);
guidata(hObject, handles);


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
if handles.SData.shape=='c'
    handles.SData.du=saveDataFromEdit(handles.SData.du,handles.edit15);
else
    handles.SData.au=saveDataFromEdit(handles.SData.au,handles.edit15);
end
guidata(hObject, handles);

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
handles.SData.bu=saveDataFromEdit(handles.SData.bu,handles.edit16);
guidata(hObject, handles);

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
guidata(hObject, handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if isequal(get(handles.checkbox2,'Value'),1)
   autocomment(hObject, eventdata, handles); 
end
guidata(hObject, handles);

function autocomment(hObject, eventdata, handles)
saveData(hObject,eventdata,handles);
handles.SData=recalculateData(handles.SData);
% [handles.SData.density handles.SData.uDensity]=getDensity(handles.SData.shape,handles.SData.m,handles.SData.mu,handles.SData.a,handles.SData.au,handles.SData.b,handles.SData.bu,handles.SData.l,handles.SData.lu);
if handles.SData.shape=='c'
    comText=[...
    getCNumber('l0=',handles.SData.l,handles.SData.lu,2,'mm',1),...
    getCNumber('d0=',handles.SData.d,handles.SData.du,2,'mm',0),...
    getCNumber('m0=',handles.SData.m,handles.SData.mu,2,'mm',0),...
    getCNumber('f0=',handles.SData.fr,1,0,'Hz',0)...
    getCNumber('rho0=',handles.SData.density,handles.SData.uDensity,2,'g/cm^3',0)...
    ];
else
    comText=[...
    getCNumber('l0=',handles.SData.l,handles.SData.lu,2,'mm',1),...
    getCNumber('a0=',handles.SData.a,handles.SData.au,2,'mm',0),...
    getCNumber('b0=',handles.SData.b,handles.SData.bu,2,'mm',0),...
    getCNumber('m0=',handles.SData.m,handles.SData.mu,2,'mm',0),...
    getCNumber('f0=',handles.SData.fr,1,0,'Hz',0),...
    getCNumber('rho0=',handles.SData.density,handles.SData.uDensity,2,'g/cm^3',0)...
    ];
end
if ~isempty(handles.SData.SampleName)
    comText=[handles.SData.SampleName ': ' comText];
end
comText=[datestr(datetime('now')) ' - ' comText];
set(handles.edit5,'String',comText);
guidata(hObject, handles);

function n=getCNumber(str,v,num,dig,unit,s)
if v~=0
    if num~=0
        i=0;
        n=0;
        if num<1
            while 10^(dig-1)>n
                n=num*(10^i);
                i=i+1;
            end
            val=round(v,i-1);
            unc=round(n,0);
            n=sprintf('%s %.*f(%d) %s',str,i-1,val,unc,unit);
        else
            while 10^(dig-1)>n
                n=num*(10^i);
                i=i+1;
            end
            val=round(v,i);
            unc=round(n,0)/10^(i-1);
            r=i-1;
            val=sprintf('%.*f',r,val);
            unc=sprintf('%.*f',r,unc);
            n=[str '(' val '±' unc ') ' unit];
        end
        if s==0
        	n=[', ' n];
        end
    else
        n=[str num2str(round(v,dig)) ' ' unit];
        if s==0
            n=[', ' n];
        end
    end
else
    if s==0
        n=[', ' str 'NotSet'];
    else
        n=[str 'NotSet'];
    end
end

function [density uD]=getDensity(type,m,mu,a,au,b,bu,l,lu)
if ~isempty(m) && ~isempty(a) && ~isempty(au) && ~isempty(l) && ~isempty(lu)
    if type=='c'
        density=m*4/(l*pi()*a^2*0.001); %g/cm^3
        uD=density*sqrt((mu^2/m^2)+(lu^2/l^2)+(4*au^2/a^2));
    else
        if ~isempty(b) && ~isempty(bu)
            density=m/(a*b*l*0.001); %g/cm^3
            uD=sqrt((a*b/m)^2*lu^2+(l*b/m)^2*au^2+(l*a/m)^2*bu^2+(-l*a*b/m^2)^2*mu^2)*0.001;
        else
            density=0;
            uD=0;
        end
    end
else
    density=0;
    uD=0;
end
guidata(hObject, handles);

function saveData(hObject, eventdata, handles)
handles.SData.SampleName=get(handles.edit1,'String');
if isempty(get(handles.edit9,'String'))
    handles.SData.m=NaN;
else
    handles.SData.m=str2num(get(handles.edit9,'String'));
end
if isempty(get(handles.edit6,'String'))
    handles.SData.l=NaN;
else
    handles.SData.l=str2num(get(handles.edit6,'String'));
end
if isempty(get(handles.edit14,'String'))
    handles.SData.lu=NaN;
else
    handles.SData.lu=str2num(get(handles.edit14,'String'));
end
if isempty(get(handles.edit10,'String'))
    handles.SData.fr=NaN;
else
    handles.SData.fr=str2num(get(handles.edit10,'String'));
end
handles.SData.comm=get(handles.edit5,'String');
if isequal(get(get(handles.uibuttongroup2,'SelectedObject'),'String'),'circle')
    if isempty(get(handles.edit7,'String'))
        handles.SData.d=NaN;
    else
        handles.SData.d=str2num(get(handles.edit7,'String'));
    end
    if isempty(get(handles.edit15,'String'))
        handles.SData.du=NaN;
    else
        handles.SData.du=str2num(get(handles.edit15,'String'));
    end
    handles.SData.shape='c';
else
    if isempty(get(handles.edit7,'String'))
        handles.SData.a=NaN;
    else
        handles.SData.a=str2num(get(handles.edit7,'String'));
    end
    if isempty(get(handles.edit15,'String'))
        handles.SData.au=NaN;
    else
        handles.SData.au=str2num(get(handles.edit15,'String'));
    end
    if isempty(get(handles.edit8,'String'))
        handles.SData.b=NaN;
    else
        handles.SData.b=str2num(get(handles.edit8,'String'));
    end
    if isempty(get(handles.edit16,'String'))
        handles.SData.bu=NaN;
    else
        handles.SData.bu=str2num(get(handles.edit16,'String'));
    end
    handles.SData.shape='r';
end
handles.SData.Y=get(handles.checkbox1,'Value');
guidata(hObject, handles);