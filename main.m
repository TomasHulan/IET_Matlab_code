function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 17-Jan-2020 14:19:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


function mainTimerFunction(obj,event,hFigure)
    
    handles = guidata(hFigure);
    try
        handles.temperature=sendCommand(handles.s,'AT:',[]);
        
%       zobrazovanie aktuálnej teploty v hlavnom okne
        if isempty(handles.temperature) && strcmp(get(handles.pushbutton2,'String'),'Disconnect')
            set(handles.text11,'String','error');
            set(handles.axes1,'Units','pixels');
%             axes(handles.axes1);
            imshow(handles.oStat, 'Parent', handles.axes1);
        elseif ~isempty(handles.temperature) && strcmp(get(handles.pushbutton2,'String'),'Disconnect')
            set(handles.text11,'String',[handles.temperature ' °C']);
            set(handles.axes1,'Units','pixels');
%             axes(handles.axes1);
            imshow(handles.gStat,'Parent', handles.axes1);
        else
            set(handles.text11,'String','');
            set(handles.axes1,'Units','pixels');
%             axes(handles.axes1);
            imshow(handles.rStat,'Parent', handles.axes1);
        end
%       režimi regulácie
%       handles.reg=0 - regulácia vypnutá
%       handles.reg=1 - normálny režim
%       handles.reg=2 - testovanie pid konštánt (väèšia vzorkovacia frekvencia, len záznam teploty a èasu)
        
        switch handles.reg
            case 0
                
            case 1
                treshold=str2num(get(handles.edit9,'String'));
                Fs=str2num(get(handles.edit2,'String'));
                rec = audiorecorder(Fs,16,1,1);
                y=0;
                while(max(y)<treshold)
                    recordblocking(rec, str2num(get(handles.edit3,'String')));
                    y = getaudiodata(rec);
                    t=toc/60;
                end
                if max(y)>treshold
                    x = linspace(0,str2num(get(handles.edit3,'String')),size(y,1));
                    % ak by bolo potrebné doplni sem výpoèet èasu
                    % úderu aby bolo t presná hodnota
                    % t=t- str2num(get(handles.edit3,'String')) -èas úderu od zaèiatku
                    plot(handles.axes3,x,y);
                    
                    xlabel(handles.axes3,'Time (s)')
                    ylabel(handles.axes3,'Voltage (V)')

                    x1lim=500;
                    x2lim=6000;
%                     x1lim=str2num(get(handles.edit4,'String'));
%                     x2lim=str2num(get(handles.edit5,'String'));
                    [f fftR fr afr ld]=recalculateFFT(y,Fs,x1lim,x2lim);
                    plot(handles.axes4,f,fftR./afr);
                    hold(handles.axes4,'on');
                    xlabel(handles.axes4,'Frequency (Hz)')
                    ylabel(handles.axes4,'|Y(f)|')
                    xlim(handles.axes4,[x1lim x2lim])
                    ylim(handles.axes4,[0 1.1])
                %     [pks,locs,widths,proms] = findpeaks(fftR,f,'SortStr','descend','NPeaks',1);
                    scatter(handles.axes4,fr,1,'v');
                    hold(handles.axes4,'off');
                    handles.ResDataTemp=[handles.ResDataTemp;[str2num(handles.temperature) fr ld]];
                    handles.ResDataTime=[handles.ResDataTime;[t fr ld]];
%                     hold(handles.axes5,'on');
                    if get(handles.radiobutton1,'Value')
                        yyaxis(handles.axes5,'right');
                            scatter(handles.axes5,handles.ResDataTemp(:,1),handles.ResDataTime(:,3),10,'filled');
                            ylabel(handles.axes5,'Log. decrement');
                        yyaxis(handles.axes5,'left');
                            scatter(handles.axes5,handles.ResDataTemp(:,1),handles.ResDataTime(:,2),10,'filled');
                            ylabel(handles.axes5,'Res. frequency (Hz)')
                        xlabel(handles.axes5,'Temperature (°C)');
                    else
                        yyaxis(handles.axes5,'right');
                            scatter(handles.axes5,handles.ResDataTime(:,1),handles.ResDataTime(:,3),10,'filled');
                            ylabel(handles.axes5,'Log. decrement');
                        yyaxis(handles.axes5,'left');
                            scatter(handles.axes5,handles.ResDataTime(:,1),handles.ResDataTime(:,2),10,'filled');
                            ylabel(handles.axes5,'Res. frequency (Hz)')
                        xlabel(handles.axes5,'Time (min)');
                    end
%                     hold(handles.axes5,'off');
                    
                    
                    
                end
            case 2
%                 handles.temperature=sendCommand(handles.s,'AT:',[]);
                if ~isempty(handles.temperature)
                    handles.time=toc/60;
                    handles.setPoint=str2num(sendCommand(handles.s,'SP:',[]));
                    guidata(hFigure, handles);
%                     handles.timeTemp=[handles.timeTemp;[handles.time str2num(handles.temperature)]];
%                     handles.tempProg=[handles.tempProg;[handles.time handles.setPoint]];
                    handles.pidTestData=[handles.pidTestData;[...
                        handles.time str2num(handles.temperature) ...
                        handles.time handles.setPoint]];
                    guidata(hFigure, handles);

%                     yyaxis(handles.axes3,'left')
%                     plot(handles.axes3,handles.timeTemp(:,1),handles.timeTemp(:,2));
%                     yyaxis(handles.axes3,'right')
%                     plot(handles.axes3,handles.tempProg(:,1),handles.tempProg(:,2));
%                     plot(handles.axes3,handles.pidTestData);
                    plot(handles.axes3,handles.pidTestData(:,1),handles.pidTestData(:,2),handles.pidTestData(:,3),handles.pidTestData(:,4));
                    xlabel(handles.axes3,'Time (min)', 'fontSize', handles.fontSize);
                    ylabel(handles.axes3,'Temperature (°C)', 'fontSize', handles.fontSize);
                end
            otherwise
        end
    catch ME
        switch ME.identifier
        case 'MATLAB:serial:fopen:opfailed'
            waitfor(msgbox('V zadanom porte sa nenachádza regulátor', 'Pripojenie','error'));
        case 'MATLAB:serial:fprintf:opfailed'
            waitfor(msgbox('Pripojenie zlyhalo, pokúsi sa opä nadviaza spojenie?', 'Regulator','error'));
            try
                if ~isempty(instrfind)
                    fclose(instrfind);
                    delete(instrfind);
                end
                handles.s = serial(get(handles.edit4,'String'));
                set(handles.s,'DataBits',8);
                set(handles.s,'StopBits',1);
                set(handles.s,'BaudRate',9600);
                set(handles.s,'Parity','even');
                handles.s.Timeout = 5;
                fopen(handles.s);
                guidata(hFigure, handles);
            catch ME
                switch ME.identifier
                    case 'MATLAB:serial:fopen:opfailed'
                        waitfor(msgbox('V zadanom porte sa nenachádza regulátor', 'Pripojenie','error'));
                    case 'MATLAB:serial:fprintf:opfailed'
                        waitfor(msgbox('Pripojenie zlyhalo, pokúsi sa opä nadviaza spojenie?', 'Regulator','error'));
                    otherwise
                        rethrow(ME)
                end
            end
        case 'MATLAB:timer:badcallback'
            waitfor(msgbox('Chyba èasovaèu', 'Timer','error'));
        otherwise
            rethrow(ME)
        end
    end
    guidata(hFigure, handles);
    
function chechConfiguration(hObject, eventdata, handles, check)
    
    if (check==1)
        set(handles.axes2,'Units','pixels');
        axes(handles.axes2);
        imshow(handles.gStat);
        set(handles.axes2,'UserData',1);
    elseif (check==2)
        set(handles.axes2,'Units','pixels');
        axes(handles.axes2);
        imshow(handles.oStat);
        set(handles.axes2,'UserData',2);
    else
        set(handles.axes2,'Units','pixels');
        axes(handles.axes2);
        imshow(handles.rStat);
        set(handles.axes2,'UserData',3);
    end
    guidata(hObject, handles);
        
% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
    

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% zmaže všetky timery a pripojenia
delete(timerfindall);
delete(instrfindall);
% definícia timeru musí by v tejto funkcii, inak by sa nedala prida do handles  

    handles.rStat = imread('img/r.jpg'); % obrátok èerveného krúžku
    handles.oStat = imread('img/o.jpg'); % obrátok oranžového krúžku
    handles.gStat = imread('img/g.jpg'); % obrátok zeleného krúžku
    
    handles.RData=[];
    handles.s=[];
    handles.reg=0;
    handles.timeTemp=[];
    handles.tempProg=[];
    handles.pidTestData=[];
    handles.time=0;
    handles.setPoint=0;
    handles.temperature=[];
    handles.ResDataTemp=[];
    handles.ResDataTime=[];
    handles.SData=struct(... % štruktúra, do ktorej sa ukladajú všetky parametre vzorky a teplotného programu
        'TableT',[],...
        'ProgT',[0 0],...
        'SampleName','',...
        'u',0.25',...
        'fr',NaN,...
        'm',NaN,...
        'mu',0.01,...
        'comm','',...
        'l',NaN,'lu',NaN,...
        'd',NaN,'du',NaN,...
        'a',NaN,'au',NaN,...
        'b',NaN,'bu',NaN,...
        'density',0,'uDensity',0, ...
        'E',0,'Eu',0,...
        'DIL',[],...
        'TG',[],...
        'row',0,...
        'shape','c',...
        'Y',0,...
        'SampleDim',struct(...
            'l',NaN(1,10,'single'),...
            'd',NaN(1,10,'single'),...
            'a',NaN(1,10,'single'),...
            'b',NaN(1,10,'single'),...
            'fa',NaN(1,10,'single'),...
            'deka',NaN(1,10,'single'),...
            'fb',NaN(1,10,'single'),...
            'dekb',NaN(1,10,'single'),...
            'fd',NaN(1,10,'single'),...
            'dekd',NaN(1,10,'single')...
            )...
    );

    % nastavenie poèiatoèného stavu kontroliek:
    % - pripojenie k regulátoru
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imshow(handles.rStat);
    % - nastavenie údajov a teplotného programu
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(handles.rStat);
    set(handles.axes2,'UserData',3);
    
    handles.fontSize=10;
%     guidata(hObject, handles);
    axes(handles.axes3)
    xlabel('Time (s)', 'fontSize', handles.fontSize);
    ylabel('Voltage (V)', 'fontSize', handles.fontSize);
%     xlabel('Time', 'fontSize', handles.fontSize);
%     ylabel('Amplitude', 'fontSize', handles.fontSize);
    
    axes(handles.axes4)
    xlabel('Frequency (Hz)', 'fontSize', handles.fontSize);
    ylabel('|Y(f)|', 'fontSize', handles.fontSize);
    
    axes(handles.axes5)
    hold on
    xlabel('Temperature (°C)', 'fontSize', handles.fontSize);
    yyaxis left
    ylabel('Res. frequency (Hz)', 'fontSize', handles.fontSize);
    yyaxis right
    ylabel('Log. decrement', 'fontSize', handles.fontSize);
    hold off
    guidata(hObject, handles);
% timer, ktorý deteguje pripojenie reguláturu a priebežne èíta teplotu, na zaèiatku každú pol sekundu
% po spustení merania každých x sekúnd
 handles.mainTimer = timer('BusyMode', 'queue', 'ExecutionMode','fixedSpacing', 'Period', 0.5);
 set(handles.mainTimer, 'TimerFcn', {@mainTimerFunction,hObject});
 start(handles.mainTimer)
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton4,'Enable','off');
set(handles.pushbutton5,'Enable','on');
if get(handles.checkbox6,'Value')
    % Test PID konštánt
    stop(handles.mainTimer);
    handles.pidTestData=[];
    sendTemperatureProgram(handles.s,handles.SData);
    if(~strcmp(confirmation(handles.s,handles.SData),'Yes'))
%         datum = date;
%         SampleName = SData.SampleName
%         nazovSuboru = [datum ' - ' SampleName '.txt'];
%         [file,name,path] = uiputfile({'*.iet',...
%  'IET File (*.iet)';
%  '*.txt', 'program files (*.m,*.mlx)';...
%  '*.fig','Figures (*.fig)';...
%  '*.mat','MAT-files (*.mat)';...
%  '*.slx;*.mdl','Models (*.slx,*.mdl)';...
%  '*.*',  'All Files (*.*)'},'Save result as','test.iet');
%         [nazovSuboru,cesta] = uiputfile(nazovSuboru,'Ulozit subor ako',['C:\Documents and Settings\Administrator\Desktop\IET results\resultsall\' nazovSuboru]);

        sendCommand(handles.s,'REGSTOP:',[]);
        start(handles.mainTimer);
        set(handles.pushbutton5,'Enable','off');
        set(handles.pushbutton4,'Enable','on');
        return
    end
    handles.reg=2;
    set(handles.mainTimer, 'Period', 1.0);
    guidata(hObject, handles);
    tic;
    set(handles.checkbox6,'Enable','off');
    sendCommand(handles.s,'REGSTART:',[]);
    start(handles.mainTimer);
else
    % Hlavný program
    stop(handles.mainTimer);
    sendTemperatureProgram(handles.s,handles.SData);
    if(~strcmp(confirmation(handles.s,handles.SData),'Yes'))
        sendCommand(handles.s,'REGSTOP:',[]);
        start(handles.mainTimer);
        set(handles.pushbutton5,'Enable','off');
        set(handles.pushbutton4,'Enable','on');
        return
    end
    handles.reg=1;
    set(handles.mainTimer, 'Period', str2num(get(handles.edit7,'String')));
    guidata(hObject, handles);
    set(handles.checkbox6,'Enable','off');
    sendCommand(handles.s,'REGSTART:',[]);
    tic;
    start(handles.mainTimer);
end




% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
guidata(hObject, handles);


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
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
guidata(hObject, handles);


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
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
guidata(hObject, handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.reg=0;
stop(handles.mainTimer);
set(handles.mainTimer, 'Period', 0.5);
guidata(hObject, handles);  
sendCommand(handles.s,'REGSTOP:',[]);
set(handles.pushbutton4,'Enable','on');
set(handles.pushbutton5,'Enable','off');
set(handles.checkbox6,'Enable','on');
start(handles.mainTimer);

guidata(hObject, handles);


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
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
guidata(hObject, handles);


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
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
guidata(hObject, handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
guidata(hObject, handles);

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
guidata(hObject, handles);

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
%     nameCheck=0; shapeCheck=0; %YCheck=0;
    if isempty(handles.mainTimer) || ~isvalid(handles.mainTimer)
        handles.SData=OpenBox(handles.s,handles.SData);
    else
%         stop(handles.mainTimer);
        handles.SData=OpenBox(handles.s,handles.SData);
%         start(handles.mainTimer);
    end
    if (~isempty(handles.SData.SampleName) ||...
           (~isempty(handles.SData.TableT)) || ...
           (handles.SData.l>0) || ...
           (handles.SData.lu>0) || ...
           (handles.SData.a>0) || ...
           (handles.SData.au>0) || ...
           (handles.SData.b>0) || ...
           (handles.SData.bu>0) || ...
           (handles.SData.d>0) || ...
           (handles.SData.du>0) || ...
           (handles.SData.fr>0) || ...
           (handles.SData.m>0) || ...
            ((handles.SData.Y==1) && ...
            (~isempty(handles.SData.DIL)) && ...
            ~(isempty(handles.SData.TG)))...
           )
        check=2;
    else
        check=3;
    end
    if handles.SData.shape=='c'
        if (~isempty(handles.SData.SampleName) &&...
           (handles.SData.l>0) && ...
           (handles.SData.lu>0) && ...
           (handles.SData.d>0) && ...
           (handles.SData.du>0) && ...
           (handles.SData.fr>0) && ...
           (handles.SData.m>0) && ...
            ((handles.SData.Y==1) && ...
            (~isempty(handles.SData.DIL)) && ...
            ~(isempty(handles.SData.TG)))...
           )
            check=1;
        end
    else
        if (~isempty(handles.SData.SampleName) && ...
           (~isempty(handles.SData.TableT)) && ...
           (handles.SData.l>0) && ...
           (handles.SData.lu>0) && ...
           (handles.SData.a>0) && ...
           (handles.SData.au>0) && ...
           (handles.SData.b>0) && ...
           (handles.SData.bu>0) && ...
           (handles.SData.fr>0) && ...
           (handles.SData.m>0) && ...
            ((handles.SData.Y==1) && ...
            (~isempty(handles.SData.DIL)) && ...
            ~(isempty(handles.SData.TG)))...
           )
            check=1;
        end
    end
    if (~isempty(handles.SData.TableT))
        check=3;
    end
    chechConfiguration(hObject, eventdata, handles, check);
    guidata(hObject, handles);
    
%     if ~isempty(handles.SData.SampleName)
%         nameCheck=1;
%     end
%     if handles.SData.shape=='c'
%         if ~isempty(handles.SData.SampleName) && handles.SData.fr>0 && handles.SData.m>0 && handles.SData.l>0 && handles.SData.d>0
%             shapeCheck=1;
%         end
%     else
%         if ~isempty(handles.SData.SampleName) && handles.SData.fr>0 && handles.SData.m>0 && handles.SData.l>0 && handles.SData.a>0 && handles.SData.b>0
%             shapeCheck=1;
%         end
%     end
%     if handles.SData.Y==1
%         if isempty(handles.SData.DIL) && isempty(handles.SData.TG)
%             YCheck=0;
%             chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
%             set(handles.pushbutton35,'Enable','off');
%             f = msgbox('Missing DIL and TG data', 'Error','warn');
%         elseif isempty(handles.SData.DIL)
%             YCheck=0;
%             chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
%             set(handles.pushbutton35,'Enable','off');
%             f = msgbox('Missing DIL data', 'Error','warn');
%         elseif isempty(handles.SData.TG)
%             YCheck=0;
%             chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
%             set(handles.pushbutton35,'Enable','off');
%             f = msgbox('Missing TG data', 'Error','warn');
%         else     
%             YCheck=1;
%             if ~isempty(s)
%                 set(handles.pushbutton35,'Enable','on');
%             end
%             chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
% 
%         end
%     else
%         YCheck=2;
%         chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
%     end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
if get(hObject,'Value')
    axes(handles.axes3)
    xlabel('Time (min)', 'fontSize', handles.fontSize);
%     yyaxis left
    ylabel('Temperature (°C)', 'fontSize', handles.fontSize);
%     yyaxis right
%     ylabel('Temp. program', 'fontSize', handles.fontSize);
    
    set(handles.axes4,'Visible','off')
    set(handles.axes5,'Visible','off')
    

else
    axes(handles.axes3)
    xlabel('Time (s)', 'fontSize', handles.fontSize);
    ylabel('Voltage (V)', 'fontSize', handles.fontSize);
    
    set(handles.axes4,'Visible','on')
    set(handles.axes5,'Visible','on')
end
guidata(hObject, handles);

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
guidata(hObject, handles);

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
guidata(hObject, handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
guidata(hObject, handles);

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
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(handles.pushbutton2,'String'),'Connect')
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
    end
    port = get(handles.edit4,'String');
    try
        handles.s = serial(port);
        set(handles.s,'DataBits',8);
        set(handles.s,'StopBits',1);
        set(handles.s,'BaudRate',9600);
        set(handles.s,'Parity','even');
        handles.s.Timeout = 5;
        fopen(handles.s);
        sendCommand(handles.s,'REGSTOP:',[]);
        set(handles.pushbutton2,'String','Disconnect');
        set(handles.pushbutton3,'Enable','on');
        set(handles.pushbutton4,'Enable','on');
        set(handles.axes1,'Units','pixels');
        axes(handles.axes1);
        imshow(handles.oStat);
    catch ME
        switch ME.identifier
        case 'MATLAB:serial:fopen:opfailed'
            waitfor(msgbox('V zadanom porte sa nenachádza regulátor', 'Pripojenie','error'));
        otherwise
            rethrow(ME)
        end
    end
elseif isequal(get(handles.pushbutton2,'String'),'Disconnect')
    handles.s=[];
    guidata(hObject, handles);
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
    end
    set(handles.pushbutton2,'String','Connect');
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.axes1,'Units','pixels');
    axes(handles.axes1);
    imshow(handles.rStat);
    set(handles.text11,'String','');
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%     handles.sRData=get(handles.pushbutton3,'UserData');
%     stop(handles.mainTimer);
    handles.RData=RegConfig(handles.s,handles.RData); % nastavenie PID konštánt a parametrov termoèlánku
%     start(handles.mainTimer);
%     set(handles.pushbutton3,'UserData',handles.sRData);
guidata(hObject, handles);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
guidata(hObject, handles);

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
guidata(hObject, handles);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
guidata(hObject, handles);

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
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
guidata(hObject, handles);

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
guidata(hObject, handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
sendCommand(handles.s,'REGSTOP:',[]);
stop(handles.mainTimer);
delete(timerfindall);
delete(instrfindall);
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hold(handles.axes5,'on');
if get(handles.radiobutton1,'Value')
    yyaxis(handles.axes5,'right');
        scatter(handles.axes5,handles.ResDataTemp(:,1),handles.ResDataTime(:,3),10,'filled');
        ylabel(handles.axes5,'Log. decrement');
    yyaxis(handles.axes5,'left');
        scatter(handles.axes5,handles.ResDataTemp(:,1),handles.ResDataTime(:,2),10,'filled');
        ylabel(handles.axes5,'Res. frequency (Hz)')
    xlabel(handles.axes5,'Temperature (°C)');
else
    yyaxis(handles.axes5,'right');
        scatter(handles.axes5,handles.ResDataTime(:,1),handles.ResDataTime(:,3),10,'filled');
        ylabel(handles.axes5,'Log. decrement');
    yyaxis(handles.axes5,'left');
    	scatter(handles.axes5,handles.ResDataTime(:,1),handles.ResDataTime(:,2),10,'filled');
        ylabel(handles.axes5,'Res. frequency (Hz)')
    xlabel(handles.axes5,'Time (min)');
end
% hold(handles.axes5,'off');