function varargout = dimensions(varargin)
% DIMENSIONS MATLAB code for dimensions.fig
%      DIMENSIONS, by itself, creates a new DIMENSIONS or raises the existing
%      singleton*.
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

% Last Modified by GUIDE v2.5 11-Jul-2019 09:47:30

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
global Data TData
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dimensions (see VARARGIN)

% Choose default command line output for dimensions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dimensions wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 Data=varargin{1};
 TData=Data;
 if isequal(TData.shape,'c')
    set(handles.uitable1,'Enable','off');
    set(handles.uitable1,'Visible','off');
    set(handles.uitable2,'Enable','on');
    set(handles.uitable2,'Visible','on');
    set(handles.uitable7,'Enable','off');
    set(handles.uitable7,'Visible','off');
    set(handles.uitable6,'Enable','on');
    set(handles.uitable6,'Visible','on');
 else
    set(handles.uitable1,'Enable','on');
    set(handles.uitable1,'Visible','on');
    set(handles.uitable2,'Enable','off');
    set(handles.uitable2,'Visible','off');
    set(handles.uitable6,'Enable','off');
    set(handles.uitable6,'Visible','off');
    set(handles.uitable7,'Enable','on');
    set(handles.uitable7,'Visible','on');
 end
 if isempty(TData.SampleDim)
     if TData.shape=='c'
        table=get(handles.uitable2,'Data');
     else
        table=get(handles.uitable1,'Data');
     end
 else
    table=TData.SampleDim;
    if TData.shape=='c'
        if size(table,2)==3
            table=table(1:12,1:2);
        end
        set(handles.uitable2,'Data',table);
    else
        if size(table,2)==2
            table=[table num2cell(zeros(12,1))];
            for r=1:12
                if isnumeric(table{r,3})
                    table{r,3}=strrep(num2str(table{r,3}),'0','');
                else
                    table{r,3}=strrep(table{r,3},'0','');
                end
            end
        end
        set(handles.uitable1,'Data',table);
    end
 end
 set(handles.uitable6,'Data',zeros(2,2));
 set(handles.uitable7,'Data',zeros(2,3));
 
 p=get(handles.uitable1,'Position');
 e=get(handles.uitable1,'Extent');
 p=p(1:2);
 e=e(3:4);
 set(handles.uitable1,'Position',[p e]);
 p=get(handles.uitable2,'Position');
 e=get(handles.uitable2,'Extent');
 p=p(1:2);
 e=e(3:4);
 set(handles.uitable2,'Position',[p e]);
 p=get(handles.uitable6,'Position');
 e=get(handles.uitable6,'Extent');
 p=p(1:2);
 e=e(3:4);
 set(handles.uitable6,'Position',[p e]);
 p=get(handles.uitable7,'Position');
 e=get(handles.uitable7,'Extent');
 p=p(1:2);
 e=e(3:4);
 set(handles.uitable7,'Position',[p e]);
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dimensions_OutputFcn(hObject, eventdata, handles)
global Data
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = Data;
delete(handles.figure1);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

 


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
global TData
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1,1);
    col = eventdata.Indices(1,2);
end
table=get(handles.uitable2,'Data');
for r=1:10
    for c=1:2
        table{r,c}=strrep(num2str(table{r,c}),',','.');
    end
end
if iscell(table)
    table=str2double(table);
end
average=mean(table(1:10,1:2),'omitnan');
u(1)=std(table(1:10,1),'omitnan')/sqrt(numel(table(1:10,1)));
u(2)=std(table(1:10,2),'omitnan')/sqrt(numel(table(1:10,2)));
u(1)=sqrt(u(1)^2 + 0.02^2);
u(2)=sqrt(u(2)^2 + 0.02^2);
table=num2cell([average;u]);
for r=1:2
    for c=1:2
        if isnumeric(table{r,c})
            table{r,c}=strrep(num2str(table{r,c}),'NaN','');
        else
            table{r,c}=strrep(table{r,c},'NaN','');
        end
    end
end
set(handles.uitable6,'Data',table);
TData.SampleDim=table;



% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
global TData
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1,1);
    col = eventdata.Indices(1,2);
end
table=get(handles.uitable1,'Data');
for r=1:10
    for c=1:3
        table{r,c}=strrep(num2str(table{r,c}),',','.');
    end
end
if iscell(table)
    table=str2double(table);
end
average=mean(table(1:10,1:3),'omitnan');
u(1)=std(table(1:10,1),'omitnan')/sqrt(numel(table(1:10,1)));
u(2)=std(table(1:10,2),'omitnan')/sqrt(snumel(table(1:10,2)));
u(3)=std(table(1:10,3),'omitnan')/sqrt(numel(table(1:10,3)));
u(1)=sqrt(u(1)^2 + 0.02^2);
u(2)=sqrt(u(2)^2 + 0.02^2);
u(3)=sqrt(u(3)^2 + 0.02^2);
table=num2cell([average;u]);
for r=1:2
    for c=1:3
        if isnumeric(table{r,c})
            table{r,c}=strrep(num2str(table{r,c}),'NaN','');
        else
            table{r,c}=strrep(table{r,c},'NaN','');
        end
    end
end
set(handles.uitable7,'Data',table);
TData.SampleDim=table;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global Data TData
if ~isempty(TData.SampleDim)
    if isequal(Data.shape,'c')
        l=get(handles.uitable6,'Data');
        Data.l=str2double(l{1,1});
        lu=get(handles.uitable6,'Data');
        Data.lu=str2double(lu{2,1});
        d=get(handles.uitable6,'Data');
        Data.d=str2double(d{1,2});
        du=get(handles.uitable6,'Data');
        Data.du=str2double(du{2,2});
    else
        l=get(handles.uitable7,'Data');
        Data.l=str2double(l{1,1});
        lu=get(handles.uitable7,'Data');
        Data.lu=str2double(lu{2,1});
        a=get(handles.uitable7,'Data');
        Data.a=str2double(a{1,2});
        au=get(handles.uitable7,'Data');
        Data.au=str2double(au{2,2});
        b=get(handles.uitable7,'Data');
        Data.b=str2double(b{1,3});
        bu=get(handles.uitable7,'Data');
        Data.bu=str2double(bu{2,3});
    end
    Data.SampleDim=TData.SampleDim;
end
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
global Data
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
% The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table=[];
set(handles.uitable1,'Data',table);
