%pridat do programu:

%3.)pridat moznost, aby sa pocas merania bral pik blizsie k
%predchadzajucemu, v pripade ak je v prehladavanej oblasti viacej ako
%jeden pik

%5.) vylepsenie algoritmu na zaznam tlmenia - ak su spojene piky moc blizko
%pocitat utlm zo svahu rezonanceho piku, ktory je na opacnej strane ako
%parazitny pik. Popripade zistit, do akej miery je pik asymetricky a ak je
%asymetria nad istu hranicu, nepocitat dekrement z polsirky ale zo svahu
%blizsie k polohe vrcholu piku

%7.) Skontrolovat, ci prave namerana hodnota frekvencie alebo dekrementu
%nevybocuje prilis z trendu zmeny, ak ano, neakceptovat merania a zopakovat
%ho ihned (teda po 7 s)

function varargout = okno(varargin)
% OKNO M-file for okno.fig
%      OKNO, by itself, creates a new OKNO or raises the existing
%      singleton*.
%
%      H = OKNO returns the handle to a new OKNO or the handle to
%      the existing singleton*.
%
%      OKNO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OKNO.M with the given input arguments.
%
%      OKNO('Property','Value',...) creates a new OKNO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before okno_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to okno_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help okno

% Last Modified by GUIDE v2.5 16-May-2019 15:17:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @okno_OpeningFcn, ...
                   'gui_OutputFcn',  @okno_OutputFcn, ...
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
end

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%Release notes
%26.2.2015 fixed bug in the function 'vystupFlast5' in condition for
%finding maximum on frequency specturm in the given boundaries
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% --- Executes just before okno is made visible.
function okno_OpeningFcn(hObject, eventdata, handles, varargin)
global rStat oStat gStat SData
rStat = imread('img/r.jpg'); % obrátok èerveného krúžku
oStat = imread('img/o.jpg'); % obrátok oranžového krúžku
gStat = imread('img/g.jpg'); % obrátok zeleného krúžku
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to okno (see VARARGIN)

% Choose default command line output for okno
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

SData=struct(... % štruktúra, do ktorej sa ukladajú všetky veci programu
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
% set(handles.pushbutton41,'UserData',SData);

% nastavenie poèiatoèného stavu kontroliek:
% - pripojenie k regulátoru
set(handles.axes7,'Units','pixels');
axes(handles.axes7);
imshow(rStat);
% - nastavenie údajov a teplotného programu
set(handles.axes8,'Units','pixels');
axes(handles.axes8);
imshow(rStat);
set(handles.axes8,'UserData',3);


end

% UIWAIT makes okno wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = okno_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%funkcia, kde sa spracuváva nameraný signál, hladá sa dekrement a
%vykreslujú sa údaje:
function spracuj(y,t,hObject, eventdata, handles)
%y - nameraný signál
%t - trvanie nahrávania
%hObject,eventdata, handles - skopírova? z argumentu nadradenej funkcie
y = y-mean(y);%posunutie priemeru na nulu

data(:,2) = y;%uloženie dat do tabu¾ky
data(:,1) = linspace(0,t,length(data));


N = length(data);
NFFT = 2^nextpow2(N);
Y = fft(data(:,2),NFFT);%výpoèet fft, 
if get(handles.radiobutton1,'Value')
    spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum,delenie N je kvôli normovaniu asi len
else
    spektrum = 2*(abs(Y(1:NFFT/2+1))/N).^2;%power spectrum
end
Fs = N/data(end,1);%vzorkovacia frekvencia(èasovanie musí zaèína? od nuly)
f = Fs/2*linspace(0,1,NFFT/2+1);%priestor príslušných frekvencií

SlopeTreshold=str2double(get(handles.edit73,'String'));
AmpThreshold=str2double(get(handles.edit74,'String'));
SmothWidth=str2double(get(handles.edit75,'String'));
FitWidth=str2double(get(handles.edit76,'String')); % našíta vstupné paraetre pre h¾adnie peakov
Peaks=findPeaks(f,Y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,3,handles); % nájde peaky v spekre pod¾a zadaných kriterií
text(Peaks(:,2),Peaks(:,3),num2str(Peaks(:,1)),handles.axes4)  % oèísluje nájdene peaky v grafe spektra

set(handles.pushbutton6,'UserData',{Y NFFT Fs data(:,1) data(:,2)});%uloženie fourierovho obrazu pre pásmovú zádrž
% [A P] = ampCheck(spektrum);%hodnoty a polohy lokálnych maxím
% [M m] = sort(A,'descend');%triedenie maxim zostupne
% I = P(m);%pozicie maxim zostupne
% index = 1;%pozicia konkrétneho maxima v postupností maxím
% rezFrek = f(I(index));

%nájdenie log. dekrementu z útlmu kmitania:
% [Z,X] = ampCheck(data(:,2));
% cufit = fit(data(X,1),Z','exp1');%fitovamie exponencialov
% koeficienty = coeffvalues(cufit);
% set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
% logDek = -koeficienty(2)/rezFrek;


% %% urèenie log. dekrementu s polšírky spekrálnej krivky:
%     %lavý svah:
%     peakleft = [];
%     konec = 1;
%     i = I(index);%index rez frekvencie
%     while konec
%         peakleft(end+1,1) = spektrum(i);
%         peakleft(end,2) = f(i);
%         %ukonèi? ak prejdem polvýškou:
%         if spektrum(i)<M(index)/2
%             konec = 0;
%         end
%         i = i-1;
%     end
%     %pravý svah:
%     peakright = [];
%     konec = 1;
%     i = I(index);%index rez frekvencie
%     while konec
%         peakright(end+1,1) = spektrum(i);
%         peakright(end,2) = f(i);
%         %ukonèi? ak prejdem polvýškou:
%         if spektrum(i)<M(index)/2
%             konec = 0;
%         end
%         i = i+1;
%     end
%     if size(peakleft,1)>1 && size(peakright,1)>1
%         fl = interp1(peakleft(:,1),peakleft(:,2),M(index)/2);%frekvencia na lavom svahu frek krivky v polovyške
%         fr = interp1(peakright(:,1),peakright(:,2),M(index)/2);%frekvencia na pravom svahu frek krivky v polovyške
%         h = fr-fl;%šírka krivky v polvýške
%         logDek2 = h*pi/(sqrt(3)*rezFrek);
%         set(handles.edit22,'String',num2str(logDek2));
%         %iba z ¾avého svahu:
%             h = 2*(rezFrek-fl);%predpokladá sa symetria
%             logDekL = h*pi/(sqrt(3)*rezFrek);
%             set(handles.edit23,'String',num2str(logDekL));
%         %iba z pravého svahu:
%             h = 2*(fr-rezFrek);
%             logDekR = h*pi/(sqrt(3)*rezFrek);
%             set(handles.edit24,'String',num2str(logDekR));
%     end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
set(handles.text11,'String',num2str(logDek));
set(handles.edit42,'String',num2str(rezFrek));
%zobrazenie výstupu:
hold(handles.axes3,'off')
sigdek = plot(handles.axes3,data(:,1),data(:,2),data(:,1),cufit(data(:,1)));%plotovanie aj s dekrementom
set(sigdek(2),'Color','green','LineWidth',1.5)%farba èiary fitovania
title(handles.axes3,'Signal y(t)')
xlabel(handles.axes3,'Time (s)')
ylabel(handles.axes3,'Voltage (V)')
set(handles.axes3,'UserData',{sigdek});

hold(handles.axes4,'off');
plot(handles.axes4,f,spektrum);
hold(handles.axes4, 'on')
plot(handles.axes4,f(I(index)),M(index),'*','Color','red');%vykreslennie hviezdièky na maxime
text('Parent',handles.axes4,'Position',[f(I(index))+30,M(index)-0.1*M(index)],...
    'String',[num2str(rezFrek,'%5.0f') ' Hz']);%vykreslenie frekvencie v grafe
if size(peakleft,1)>1 && size(peakright,1)>1 %ak bol schopný nájs? polovýšku
    plot(handles.axes4,[fr fl],[M(index)/2 M(index)/2],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky v polovici svahov
else
    plot(handles.axes4,[0 0],[0 0],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky na zaèiatku sústavy
end
hold(handles.axes4,'off');
rozlisenie = f(2)-f(1);
if get(handles.radiobutton1,'Value')
    title(handles.axes4,['Single-Sided Amplitude Spetrum of y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'|Y(f)|')
else
    title(handles.axes4,['Power Spectrum of signalu y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'Power')
end
%limity frekvnèného grafu:
if get(handles.checkbox2,'Value')
    pushbutton3_Callback(hObject, eventdata, handles)
end
end


function edit1_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo>str2double(get(handles.edit2,'String'))) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end


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
set(hObject,'UserData',get(hObject,'String'))
end



function edit2_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<str2double(get(handles.edit1,'String'))) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end


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
set(hObject,'UserData',get(hObject,'String'))
end


%rozsah spektra:
function pushbutton3_Callback(hObject, eventdata, handles)
%nastavý rozsah grafu
xmin = str2num(get(handles.edit1,'String'));
xmax = str2num(get(handles.edit2,'String'));
xlim(handles.axes4,[xmin xmax])
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
end

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
end



function edit4_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end


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
set(hObject,'UserData',get(hObject,'String'))
end


%posun rez frek dopredu pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
%set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
userData = get(handles.figure1,'UserData');
index = userData{2};
index = index+1;
f = userData{3};
I = userData{1};
M = userData{5};
rezFrek = f(I(index));
set(handles.edit42,'String',num2str(rezFrek))
koeficienty = userData{4};
logDek = -koeficienty(2)/rezFrek;


    %urèenie log. dekrementu s polšírky spekrálnej krivky:
        %set(handles.pushbutton6,'UserData',{Y NFFT Fs data1 data});%uloženie fourierovho obrazu pre pásmovú zádrž
        userdata = get(handles.pushbutton6,'UserData');
        Y = userdata{1};
        NFFT = userdata{2};
        N = userdata{4};
        N = length(N);
        spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum
        
    %% urèenie log. dekrementu s polšírky spekrálnej krivky:
    %lavý svah:
    peakleft = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        peakleft(end+1,1) = spektrum(i);
        peakleft(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
        i = i-1;
    end
    %pravý svah:
    peakright = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        peakright(end+1,1) = spektrum(i);
        peakright(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
        i = i+1;
    end
    if size(peakleft,1)>1 && size(peakright,1)>1
        fl = interp1(peakleft(:,1),peakleft(:,2),M(index)/2);%frekvencia na lavom svahu frek krivky v polovyške
        fr = interp1(peakright(:,1),peakright(:,2),M(index)/2);%frekvencia na pravom svahu frek krivky v polovyške
        h = fr-fl;%šírka krivky v polvýške
        logDek2 = h*pi/(sqrt(3)*rezFrek);
        set(handles.edit22,'String',num2str(logDek2));
        %iba z ¾avého svahu:
            h = 2*(rezFrek-fl);%predpokladá sa symetria
            logDekL = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit23,'String',num2str(logDekL));
        %iba z pravého svahu:
            h = 2*(fr-rezFrek);
            logDekR = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit24,'String',num2str(logDekR));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
hold(handles.axes4,'off');
plot(handles.axes4,f,spektrum);
hold(handles.axes4, 'on')
plot(handles.axes4,f(I(index)),M(index),'*','Color','red');%vykreslennie hviezdièky na maxime
if size(peakleft,1)>1 && size(peakright,1)>1 %ak bol schopný nájs? polovýšku
    plot(handles.axes4,[fr fl],[M(index)/2 M(index)/2],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky v polovici svahov
else
    plot(handles.axes4,[0 0],[0 0],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky na zaèiatku sústavy
end
hold(handles.axes4,'off');
%limity frekvnèného grafu:
if get(handles.checkbox2,'Value')
    pushbutton3_Callback(hObject, eventdata, handles)
end
rozlisenie = f(2)-f(1);
if get(handles.radiobutton1,'Value')
    title(handles.axes4,['Single-Sided Amplitude Spetrum of y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'|Y(f)|')
else
    title(handles.axes4,['Power Spectrum of signalu y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'Power')
end
end


%dozadu:
function pushbutton5_Callback(hObject, eventdata, handles)
%set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
userData = get(handles.figure1,'UserData');
index = userData{2};
if index>1%ak som neni na zaèiatku
index = index-1;
f = userData{3};
I = userData{1};
M = userData{5};
rezFrek = f(I(index));
set(handles.edit42,'String',num2str(rezFrek))
koeficienty = userData{4};
logDek = -koeficienty(2)/rezFrek;
    %urèenie log. dekrementu s polšírky spekrálnej krivky:
        %set(handles.pushbutton6,'UserData',{Y NFFT Fs data1 data});%uloženie fourierovho obrazu pre pásmovú zádrž
        userdata = get(handles.pushbutton6,'UserData');
        Y = userdata{1};
        NFFT = userdata{2};
        N = userdata{4};
        N = length(N);
        spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum
        
    %% urèenie log. dekrementu s polšírky spekrálnej krivky:
    %lavý svah:
    peakleft = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        peakleft(end+1,1) = spektrum(i);
        peakleft(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
        i = i-1;
    end
    %pravý svah:
    peakright = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        peakright(end+1,1) = spektrum(i);
        peakright(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
        i = i+1;
    end
    if size(peakleft,1)>1 && size(peakright,1)>1
        fl = interp1(peakleft(:,1),peakleft(:,2),M(index)/2);%frekvencia na lavom svahu frek krivky v polovyške
        fr = interp1(peakright(:,1),peakright(:,2),M(index)/2);%frekvencia na pravom svahu frek krivky v polovyške
        h = fr-fl;%šírka krivky v polvýške
        logDek2 = h*pi/(sqrt(3)*rezFrek);
        set(handles.edit22,'String',num2str(logDek2));
        %iba z ¾avého svahu:
            h = 2*(rezFrek-fl);%predpokladá sa symetria
            logDekL = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit23,'String',num2str(logDekL));
        %iba z pravého svahu:
            h = 2*(fr-rezFrek);
            logDekR = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit24,'String',num2str(logDekR));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
hold(handles.axes4,'off');
plot(handles.axes4,f,spektrum);
hold(handles.axes4, 'on')
plot(handles.axes4,f(I(index)),M(index),'*','Color','red');%vykreslennie hviezdièky na maxime
if size(peakleft,1)>1 && size(peakright,1)>1 %ak bol schopný nájs? polovýšku
    plot(handles.axes4,[fr fl],[M(index)/2 M(index)/2],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky v polovici svahov
else
    plot(handles.axes4,[0 0],[0 0],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky na zaèiatku sústavy
end
hold(handles.axes4,'off');
rozlisenie = f(2)-f(1);
if get(handles.radiobutton1,'Value')
    title(handles.axes4,['Single-Sided Amplitude Spetrum of y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'|Y(f)|')
else
    title(handles.axes4,['Power Spectrum of signalu y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'Power')
end
%limity frekvnèného grafu:
if get(handles.checkbox2,'Value')
    pushbutton3_Callback(hObject, eventdata, handles)
end
end
end



function edit5_Callback(hObject, eventdata, handles)
%nic
end

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
end



function edit6_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo>str2double(get(handles.edit7,'String'))) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

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
set(hObject,'UserData',get(hObject,'String'))
end



function edit7_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<str2double(get(handles.edit6,'String'))) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

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
set(hObject,'UserData',get(hObject,'String'))
end


%tlaèidlo, kde sú uložené userData:
function pushbutton6_Callback(hObject, eventdata, handles)
%user data
end


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
end

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
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
end

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
end



function edit10_Callback(hObject, eventdata, handles)
end

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
end


function edit11_Callback(hObject, eventdata, handles)
%do nothing
end

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
end

% Tlaèidlo na orezávanie:
function pushbutton8_Callback(hObject, eventdata, handles)
userData = get(handles.pushbutton6,'UserData');%naèitanie dat
data(:,1) = userData{4};
data(:,2) = userData{5};
od = str2num(get(handles.edit10,'String'));%odreza? od (v sekundách)
do = str2num(get(handles.edit11,'String'));%odreza? do (v sekundách)
if do > data(end,1)%ak je horna hranica mimo nastavý sa najvyšší èas
   do = data(end,1); 
end
%najdenie inexov na odrezanie:
interval = (data(2,1)-data(1,1))/2;
iod = find(data(:,1)>=od-interval,1,'first');
ido = find(data(:,1)>=do-interval,1,'first');
data1(:,1) = data(iod:ido,1)-data(iod,1);%naèitanie x-ovych dat a posunutie na nulu
data1(:,2) = data(iod:ido,2);
data1(:,2) = data1(:,2)-mean(data1(:,2));%posunutie priemeru na nulu
data = data1;
%spracovanie a zobrazenie:
spracuj(data(:,2),data(end,1),hObject, eventdata, handles)
%aplikácia pásmovej priepuste:
if get(handles.checkbox5,'Value')
    pushbutton11_Callback(hObject, eventdata, handles)
end
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

%oreza? z¾ava:
function pushbutton10_Callback(hObject, eventdata, handles)
userData = get(handles.pushbutton6,'UserData');%naèitanie dat
data(:,1) = userData{4};
data(:,2) = userData{5};
krok = str2num(get(handles.edit12,'String'));
%orezanie z¾ava o "krok" udajov:
data1(:,1) = data(krok+1:end,1)-data(krok+1,1);
data1(:,2) = data(krok+1:end,2);
data1(:,2) = data1(:,2)-mean(data1(:,2));%posunutie priemeru na nulu
%spracovanie a zobrazenie dát
spracuj(data1(:,2),data1(end,1),hObject, eventdata, handles)
%aplikácia pásmovej priepuste:
if get(handles.checkbox5,'Value')
    pushbutton11_Callback(hObject, eventdata, handles)
end
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
end

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
end



%pásmová priepus?:
function pushbutton11_Callback(hObject, eventdata, handles)
userdata = get(handles.pushbutton6,'UserData');
Y = userdata{1};
NFFT = userdata{2};
Fs = userdata{3};
cas = userdata{4};
od = str2num(get(handles.edit15,'String'));
do = str2num(get(handles.edit16,'String'));
nh = round(do*NFFT/Fs);%najvyšší index
nd = round(od*NFFT/Fs);%najnižší index
maska = [zeros(nd,1); ones(nh-nd,1); zeros(NFFT-2*nh,1);...
    ones(nh-nd,1); zeros(nd,1)];
Y = Y.*maska;%aplikácia pásmovej priepuste
data = ifft(Y,NFFT);
data = real(data(1:length(cas)));%vybranie realneho priebehu po filtrovani
spracuj(data,cas(end),hObject, eventdata, handles)
end



function edit16_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<str2double(get(handles.edit15,'String'))) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

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
set(hObject,'UserData',get(hObject,'String'))
end


function edit15_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo>str2double(get(handles.edit16,'String'))) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

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
set(hObject,'UserData',get(hObject,'String'))
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double
end

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
end

function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double
end

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
end

function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double
end

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
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double
end

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
end


function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double
end

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
end

% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
axes(handles.axes3) %nastavenie axes4 ako aktualnej
if strcmp(get(gca,'YGrid'),'off')
    set(gca,'YGrid','on')
else
    set(gca,'YGrid','off')
end
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double
end

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
end

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
%set(handles.pushbutton6,'UserData',{Y NFFT Fs data(:,1) data(:,2)});%uloženie fourierovho obrazu pre pásmovú zádrž
userdata = get(handles.pushbutton6,'UserData');
data(:,1) = userdata{4};
data(:,2) = userdata{5};
%uloži? do špecifického miesta:
subor = get(handles.edit29,'String');
cesta = get(handles.edit30,'String');
save([cesta subor '.mat'],'data');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double
end

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
end


function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double
end

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
end


function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double
end

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
end


function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double
end

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
end


function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double
end

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
end


%Nahra?
function pushbutton19_Callback(hObject, eventdata, handles)
%naèítanie dát zo súboru:
    subor = get(handles.edit28,'String');
    cesta = get(handles.edit30,'String');
    y = load([cesta subor '.mat']);
    y = y.data;%vybra? data zo štruktúry
%%%%%%%%%%%%%%%%%%%%%%%%%
%spracovanie a vykreslenie:
spracuj(y(:,2),y(end,1)-y(1,1),hObject, eventdata, handles)
end


function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double
end

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
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double
end

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
end


function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double
end

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
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double
end

% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double
end

% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
%set(handles.pushbutton6,'UserData',{Y NFFT Fs data(:,1) data(:,2)});%uloženie fourierovho obrazu pre pásmovú zádrž
userdata = get(handles.pushbutton6,'UserData');
Y = userdata{1};
NFFT = userdata{2};
Fs = userdata{3};
data(:,1) = userdata{4};
data(:,2) = userdata{5};

%nájdenie frekvencií:
N = length(data);
spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum,delenie N je kôly normovaniu asi len
f = Fs/2*linspace(0,1,NFFT/2+1);%priestor príslušných frekvencií
[Z,X] = ampCheck(spektrum);
[M,I] = sort(Z,'descend');%triedenie maxim zostupne
A1 = M(1);
A2 = M(2);
f1 = f(X(I(1)));
f2 = f(X(I(2)));
%f1 musí by? menšie ako f2 ak nie tak sa vymenia:
if f1>f2
    pom = f1;
    f1 = f2;
    f2 = pom;
    pom = A1;
    A1 = A2;
    A2 = pom;
end
set(handles.edit31,'String',num2str(f1));
set(handles.edit32,'String',num2str(f2));

%nájdenie maxím signálu:
[Z,X] = localMax(data(:,2),3);
%nájdenie minimá z maxím (uzly signálu):
Z = smooth(Z);
[Zmin,Xmin] = localMin(Z,10);
% [M,I] = sort(Z,'descend');%triedenie maxim zostupne
indNearMax = round((X(Xmin(2))+X(Xmin(1)))/2);%index blízko maxima - prvé maximum napravo je to, v stred rázu
[Zmax,Xmax] = localMax(data(indNearMax:end,2),3);%haldám maximá už len zo zvyšku
indMax = Xmax(1)+indNearMax-1;%èasový index maxima najvyššieho rázu
T = Zmax(1);%suèet amplitúd v modeli, T = B1+B2; aj ked nie presne, lebo je závislé od dekremntu -> nelinearita
hold(handles.axes3,'on')
plot(handles.axes3,[data(X(Xmin(1)),1) data(X(Xmin(2)),1)], [Zmin(1) Zmin(2)],'diamond','Color','red')
plot(handles.axes3,data(indMax,1),data(indMax,2),'*','Color','red');



%set(handles.axes4,'UserData',{gspektrum greddot ggreendot});%uloženie handle na grafy
userdata = get(handles.axes4,'UserData');
greddot = userdata{2};
delete(greddot)
hold(handles.axes4,'on');
greddot = plot(handles.axes4,[f1 f2],[A1 A2],'*','Color','red');
userdata{2} = greddot;
set(handles.axes4,'UserData',userdata);%uloženie handle na grafy
hold(handles.axes4,'off')

matica = [1 -A1*f1/(A2*f2);1 1];
vektor = [0;T];
B = inv(matica)*vektor;
set(handles.edit33,'String',num2str(B(1)));
set(handles.edit34,'String',num2str(B(2)));
set(handles.edit36,'String',num2str(B(1)/B(2)));


%nájdenie bodu napravo od maxima, ktorý má nulovú výchylku:
i = 0;
konec = 1;
while konec
    i = i+1;
    if data(indMax-i,2) <= 0
        indZero = indMax-i;%index bodu, ktorý  prešiel nulou
        konec = 0;
    end
end
%cas, ktorému prislúcha nulová výchylka (aby fitovanie zaèínalo s bodom s
%nulovou výchylkou):
zeroPoint = interp1([data(indZero,2) data(indZero+1,2)], [data(indZero,1) data(indZero+1,1)], 0);
cas = [zeroPoint; data(indZero:end,1)];
cas = cas-zeroPoint;%aby zaèínal od nuly(kôly fitovaniu)
vychylky = [0; data(indZero:end,2)];
[Z,X] = localMax(data(:,2),1);
maxAmp = max(Z);%maximálna amplitúda dosiahnutá v nahratom signále
%nájdenie bodu, ktorý dosihol hornú hranicu rozsahu zaznamenaného signálu
%(pri nahrávaní mikrofónom je max amplitúda 1), alebo ma maximálnu výchylku:
for i = indZero:-1:1
    if (data(i,2))>=maxAmp
        firstPoint = i;
        break
    end
end
minuscas = data(firstPoint:indZero,1)-zeroPoint;%casy pred nulou
minuleVychylky = data(firstPoint:indZero,2);%vychylky prisluchajuce casom pred t=0s.
cas = [minuscas; cas];
vychylky = [minuleVychylky; vychylky];

%fitovanie ja zadam amplitudy::    
s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',0,...
               'Upper',1,...
               'Startpoint',0.362);
%odhaduje sa parameter "a" èo je logartimický dekrement
g = fittype('B1*exp(-a*f1.*x).*sin(2*pi*f1.*x)+B2*exp(-a*f2.*x).*sin(2*pi*f2.*x)','problem',{'B1' 'f1' 'B2' 'f2'},'options',s);
[c1,gof1] = fit(cas,vychylky,g,'problem',{B(1) f1 B(2) f2});
coef = coeffvalues(c1);%vypèítaný(odhadnutý parameter) dekrement útlmu
set(handles.edit41,'String',num2str(coef(1)))
set(handles.edit50,'String',num2str(coef(1)))
set(handles.text49,'String',num2str(gof1.rsquare));
y = c1(cas);
hold(handles.axes3,'on')
[upy iupy] = localMax(y,1);
[downy idowny] = localMin(y,1);
plot(handles.axes3,cas(iupy)+zeroPoint,upy,'Color','yellow');
plot(handles.axes3,cas(idowny)+zeroPoint,downy,'Color','yellow');
hold(handles.axes3,'off')


%fitovanie fitujú sa aj amilitúdy:
s = fitoptions('Method','NonlinearLeastSquares');
s.Lower = [0 0 0];
s.Upper = [1 100 100];
s.Startpoint = [0.687 0.511 0.911];
s.Robust = 'Off';
s.Algorithm = 'Trust-Region';
s.DiffMinChange = 1e-8;
s.DiffMaxChange = 0.1;
s.MaxFunEvals = 600;
s.MaxIter = 400;
s.TolFun = 1e-6;
s.TolX = 1e-6;
g = fittype('b*exp(-a*f1.*x).*sin(2*pi*f1.*x)+c*exp(-a*f2.*x).*sin(2*pi*f2.*x)','problem',{'f1' 'f2'},'options',s);

[c2,gof2] = fit(cas,vychylky,g,'problem',{f1 f2});
coef = coeffvalues(c2);%vypèítaný(odhadnutý parameter) dekrement útlmu
d = coef(1);%dekrement
set(handles.edit38,'String',num2str(coef(2)))
set(handles.edit39,'String',num2str(coef(3)))
set(handles.edit40,'String',num2str(coef(2)/coef(3)))
set(handles.edit35,'String',num2str(d))
set(handles.edit51,'String',num2str(d))
set(handles.text42,'String',num2str(gof2.rsquare));
y = c2(cas);
hold(handles.axes3,'on')
[upy iupy] = localMax(y,1);
[downy idowny] = localMin(y,1);
plot(handles.axes3,cas(iupy)+zeroPoint,upy,'Color','red');
plot(handles.axes3,cas(idowny)+zeroPoint,downy,'Color','red');
hold(handles.axes3,'off')

grafy = get(handles.axes3,'Children');
for i = 1:length(grafy)
    xudaje = get(grafy(i),'XData');
    set(grafy(i),'Xdata',xudaje-zeroPoint)
end
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double
end

% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double
end

% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double
end

% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double
end

% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double
end

% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double
end

% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double
end

% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double
end

% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double
end

% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


%new fig
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
%po kliknutí na toto tlaèidlo sa objavý nová figúra s dvoma grafmi
chax3 = get(handles.axes3,'Children');
chax4 = get(handles.axes4,'Children');
nchax3 = length(chax3);
nchax4 = length(chax4);

figure
%
subplot(2,1,1)
xpopis = (get(handles.axes3,'XLabel'));
xlabel(get(xpopis,'String'))
ypopis = (get(handles.axes3,'YLabel'));
ylabel(get(ypopis,'String'))
titul = (get(handles.axes3,'Title'));
title(get(titul,'String'))
hold on
for i = nchax3:-1:1
    xdata = get(chax3(i),'XData');
    ydata = get(chax3(i),'YData');
    linestyle = get(chax3(i),'LineStyle');
    linewidth = get(chax3(i),'LineWidth');
    marker = get(chax3(i),'Marker');
    color = get(chax3(i),'Color');  
    plot(xdata,ydata,'LineStyle',linestyle,'LineWidth',linewidth...
        ,'Marker',marker,'Color',color);
end
hold off
%
subplot(2,1,2)
xpopis = (get(handles.axes4,'XLabel'));
xlabel(get(xpopis,'String'))
ypopis = (get(handles.axes4,'YLabel'));
ylabel(get(ypopis,'String'))
titul = (get(handles.axes4,'Title'));
title(get(titul,'String'))
hold on
for i = nchax4:-1:1
    xdata = get(chax4(i),'XData');
    ydata = get(chax4(i),'YData');
    linestyle = get(chax4(i),'LineStyle');
    linewidth = get(chax4(i),'LineWidth');
    marker = get(chax4(i),'Marker');
    color = get(chax4(i),'Color');  
    plot(xdata,ydata,'LineStyle',linestyle,'LineWidth',linewidth...
        ,'Marker',marker,'Color',color);
end
xlim(get(handles.axes4,'XLim'))
hold off
%
end


function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit43 as text
%        str2double(get(hObject,'String')) returns contents of edit43 as a double
end

% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function pushbutton15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


% --- Executes during object creation, after setting all properties.
function pushbutton8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end



function radiobutton1_ButtonDownFcn(hObject, eventdata, handles)
%do nothing
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
userdata = get(handles.pushbutton6,'UserData');
data(:,1) = userdata{4};
data(:,2) = userdata{5};

[Z,X] = ampCheck(data(:,2));
cufit = fit(data(X,1),Z','exp1');%fitovamie exponencialov
koeficienty = coeffvalues(cufit);
N = length(data);
NFFT = 2^nextpow2(N);
Y = fft(data(:,2),NFFT);%výpoèet fft, 
if get(handles.radiobutton1,'Value')
    spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum,delenie N je kôly normovaniu asi len
else
    spektrum = 2*(abs(Y(1:NFFT/2+1))/N).^2;%power spectrum
end
Fs = N/data(end,1);%vzorkovacia frekvencia(èasovanie musí zaèína? od nuly)
f = Fs/2*linspace(0,1,NFFT/2+1);%priestor príslušných frekvencií
[M,I] = sort(spektrum,'descend');%triedenie maxim zostupne
index = 1;%pozicia konkrétneho maxima v postupností maxím
rezFrek = f(I(index));
set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
logDek = -koeficienty(2)/rezFrek;

%urèenie log. dekrementu s polšírky spekrálnej krivky:
    %lavý svah:
    peakleft = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        i = i-1;
        peakleft(end+1,1) = spektrum(i);
        peakleft(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
    end
    %pravý svah:
    peakright = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        i = i+1;
        peakright(end+1,1) = spektrum(i);
        peakright(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
    end
    if size(peakleft,1)>1 && size(peakright,1)>1
        fl = interp1(peakleft(:,1),peakleft(:,2),M(index)/2);%frekvencia na lavom svahu frek krivky v polovyške
        fr = interp1(peakright(:,1),peakright(:,2),M(index)/2);%frekvencia na pravom svahu frek krivky v polovyške
        h = fr-fl;%šírka krivky v polvýške
        logDek2 = h*pi/(sqrt(3)*rezFrek);
        set(handles.edit22,'String',num2str(logDek2));
        %iba z ¾avého svahu:
            h = 2*(rezFrek-fl);%predpokladá sa symetria
            logDekL = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit23,'String',num2str(logDekL));
        %iba z pravého svahu:
            h = 2*(fr-rezFrek);
            logDekR = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit24,'String',num2str(logDekR));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.text11,'String',num2str(logDek));
set(handles.edit42,'String',num2str(rezFrek));
%zobrazenie výstupu:
hold(handles.axes3,'off')
sigdek = plot(handles.axes3,data(:,1),data(:,2),data(:,1),cufit(data(:,1)));%plotovanie aj s dekrementom
title(handles.axes3,'Signal y(t)')
xlabel(handles.axes3,'Time (s)')
ylabel(handles.axes3,'Voltage (V)')
set(handles.axes3,'UserData',{sigdek});

        hold(handles.axes4,'off');
        gspektrum = plot(handles.axes4,f,spektrum);
        hold(handles.axes4, 'on')
        greddot = plot(handles.axes4,f(I(index)),M(index),'*','Color','red');%vykreslennie hviezdièky na maxime
        if size(peakleft,1)>1 && size(peakright,1)>1 %ak bol schopný nájs? polovýšku
            ggreendot = plot(handles.axes4,[fr fl],[M(index)/2 M(index)/2],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky v polovici svahov
        else
            ggreendot = plot(handles.axes4,[0 0],[0 0],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky na zaèiatku sústavy
        end
        hold(handles.axes4,'off');
        set(handles.axes4,'UserData',{gspektrum greddot ggreendot});%uloženie handle na grafy
        %xlim([0 Fs*t1])%zobrazi? frekvencie iba do 10000 Hz
        rozlisenie = f(2)-f(1);
        if get(handles.radiobutton1,'Value')
            title(handles.axes4,['Single-Sided Amplitude Spetrum of y(t), resolution: ' num2str(rozlisenie) ' Hz'])
            xlabel(handles.axes4,'Frequency (Hz)')
            ylabel(handles.axes4,'|Y(f)|')
        else
            title(handles.axes4,['Power Spectrum of signalu y(t), resolution: ' num2str(rozlisenie) ' Hz'])
            xlabel(handles.axes4,'Frequency (Hz)')
            ylabel(handles.axes4,'Power')
        end
set(handles.text5,'Visible','off')%vypnutie textu "runing"
%aplikácia pásmovej priepuste:
if get(handles.checkbox5,'Value')
    pushbutton11_Callback(hObject, eventdata, handles)
end
%limity frekvnèného grafu:
if get(handles.checkbox2,'Value')
    pushbutton3_Callback(hObject, eventdata, handles)
end
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
userdata = get(handles.pushbutton6,'UserData');
data(:,1) = userdata{4};
data(:,2) = userdata{5};

[Z,X] = ampCheck(data(:,2));
cufit = fit(data(X,1),Z','exp1');%fitovamie exponencialov
koeficienty = coeffvalues(cufit);
N = length(data);
NFFT = 2^nextpow2(N);
Y = fft(data(:,2),NFFT);%výpoèet fft, 
if get(handles.radiobutton1,'Value')
    spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum,delenie N je kôly normovaniu asi len
else
    spektrum = 2*(abs(Y(1:NFFT/2+1))/N).^2;%power spectrum
end
Fs = N/data(end,1);%vzorkovacia frekvencia(èasovanie musí zaèína? od nuly)
f = Fs/2*linspace(0,1,NFFT/2+1);%priestor príslušných frekvencií
[M,I] = sort(spektrum,'descend');%triedenie maxim zostupne
index = 1;%pozicia konkrétneho maxima v postupností maxím
rezFrek = f(I(index));
set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
logDek = -koeficienty(2)/rezFrek;

%urèenie log. dekrementu s polšírky spekrálnej krivky:
    %lavý svah:
    peakleft = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        i = i-1;
        peakleft(end+1,1) = spektrum(i);
        peakleft(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
    end
    %pravý svah:
    peakright = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        i = i+1;
        peakright(end+1,1) = spektrum(i);
        peakright(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
    end
    if size(peakleft,1)>1 && size(peakright,1)>1
        fl = interp1(peakleft(:,1),peakleft(:,2),M(index)/2);%frekvencia na lavom svahu frek krivky v polovyške
        fr = interp1(peakright(:,1),peakright(:,2),M(index)/2);%frekvencia na pravom svahu frek krivky v polovyške
        h = fr-fl;%šírka krivky v polvýške
        logDek2 = h*pi/(sqrt(3)*rezFrek);
        set(handles.edit22,'String',num2str(logDek2));
        %iba z ¾avého svahu:
            h = 2*(rezFrek-fl);%predpokladá sa symetria
            logDekL = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit23,'String',num2str(logDekL));
        %iba z pravého svahu:
            h = 2*(fr-rezFrek);
            logDekR = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit24,'String',num2str(logDekR));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.text11,'String',num2str(logDek));
set(handles.edit42,'String',num2str(rezFrek));
%zobrazenie výstupu:
hold(handles.axes3,'off')
sigdek = plot(handles.axes3,data(:,1),data(:,2),data(:,1),cufit(data(:,1)));%plotovanie aj s dekrementom
title(handles.axes3,'Signal y(t)')
xlabel(handles.axes3,'Time (s)')
ylabel(handles.axes3,'Voltage (V)')
set(handles.axes3,'UserData',{sigdek});

hold(handles.axes4,'off');
gspektrum = plot(handles.axes4,f,spektrum);
hold(handles.axes4, 'on')
greddot = plot(handles.axes4,f(I(index)),M(index),'*','Color','red');%vykreslennie hviezdièky na maxime
if size(peakleft,1)>1 && size(peakright,1)>1 %ak bol schopný nájs? polovýšku
    ggreendot = plot(handles.axes4,[fr fl],[M(index)/2 M(index)/2],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky v polovici svahov
else
    ggreendot = plot(handles.axes4,[0 0],[0 0],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky na zaèiatku sústavy
end
hold(handles.axes4,'off');
set(handles.axes4,'UserData',{gspektrum greddot ggreendot});%uloženie handle na grafy
%xlim([0 Fs*t1])%zobrazi? frekvencie iba do 10000 Hz
rozlisenie = f(2)-f(1);
if get(handles.radiobutton1,'Value')
    title(handles.axes4,['Single-Sided Amplitude Spetrum of y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'|Y(f)|')
else
    title(handles.axes4,['Power Spectrum of signalu y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'Power')
end
set(handles.text5,'Visible','off')%vypnutie textu "runing"
%aplikácia pásmovej priepuste:
if get(handles.checkbox5,'Value')
    pushbutton11_Callback(hObject, eventdata, handles)
end
%limity frekvnèného grafu:
if get(handles.checkbox2,'Value')
    pushbutton3_Callback(hObject, eventdata, handles)
end
end


%urèenie dekrementu z amplitúdy rázov
function pushbutton25_Callback(hObject, eventdata, handles)
E1 = str2num(get(handles.edit46,'String'));
E2 = str2num(get(handles.edit47,'String'));
f1 = str2num(get(handles.edit44,'String'));
f2 = str2num(get(handles.edit45,'String'));
%výpoèet dekrementu (podla Nakutis, 2010):
d = (f2-f1)/mean([f1 f2])*log(E1/E2);
set(handles.edit48,'String',num2str(d));
end


function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double
end

% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double
end

% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double
end

% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit47 as text
%        str2double(get(hObject,'String')) returns contents of edit47 as a double
end

% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit48 as text
%        str2double(get(hObject,'String')) returns contents of edit48 as a double
end

% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
userdata = get(handles.pushbutton6,'UserData');
Y = userdata{1};
NFFT = userdata{2};
Fs = userdata{3};
data(:,1) = userdata{4};
data(:,2) = userdata{5};

%nájdenie frekvencií:
N = length(data);
spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum,delenie N je kôly normovaniu asi len
f = Fs/2*linspace(0,1,NFFT/2+1);%priestor príslušných frekvencií
[Z,X] = ampCheck(spektrum);
[M,I] = sort(Z,'descend');%triedenie maxim zostupne
A1 = M(1);
A2 = M(2);
f1 = f(X(I(1)));
f2 = f(X(I(2)));

set(handles.edit44,'String',num2str(f1));
set(handles.edit45,'String',num2str(f2));

%%%%
userdata = get(handles.axes4,'UserData');
greddot = userdata{2};
delete(greddot)
hold(handles.axes4,'on');
greddot = plot(handles.axes4,[f1 f2],[A1 A2],'*','Color','red');
userdata{2} = greddot;
set(handles.axes4,'UserData',userdata);%uloženie handle na grafy
hold(handles.axes4,'off')
%%%%
posun = str2num(get(handles.edit49,'String'));
perioda = 1/abs(f1-f2);%perioda rázov
br = round(perioda*Fs);%nameraných bodov na jeden ráz
hold(handles.axes3,'on')
userdata = get(handles.pushbutton24,'UserData');
if isempty(userdata)==0
    p1 = userdata{1};
    p2 = userdata{2};
    p3 = userdata{3};
    u1 = userdata{4};
    u2 = userdata{5};
end
if isempty(userdata)
    p1=plot(handles.axes3,[0.1 0.1], [-1 1],'Color','black');
    p2=plot(handles.axes3,[0.1+perioda 0.1+perioda], [-1 1],'Color','black');
    p3=plot(handles.axes3,[0.1+2*perioda 0.1+2*perioda], [-1 1],'Color','black');
    u1 = 0.1*Fs;
    u2 = u1+br;
    set(handles.pushbutton24,'UserData',{p1 p2 p3 u1 u2});
    indNearMax = round((u1+u2)/2);%index blízko maxima - prvé maximum napravo je to, v stred rázu
    [Zmax,Xmax] = localMax(data(indNearMax:end,2),1);%haldám maximá už len zo zvyšku    
    indMax = Xmax(1)+indNearMax-1;%èasový index maxima najvyššieho rázu
    set(handles.edit46,'Strin',num2str(data(indMax,2)));
    %%%%%%%%%%%%%%%%%%%
        [Zmax2,Xmax2] = localMax(data(indNearMax+br:end,2),1);%hladam max druheho razu
        indMax2 = Xmax2(1)+indNearMax+br-1;%èasový index maxima druhého rázu
        set(handles.edit47,'Strin',num2str(data(indMax2,2)));
    %%%%%%%%%%%%%%%%%%%
    hold(handles.axes3,'on')
    userdata = get(handles.axes3,'UserData');
    if length(userdata)>1
        delete(userdata{2})%vymazanie bodky v strede rázu
    end
    greddot=plot(handles.axes3,data(indMax,1),data(indMax,2),'*','Color','red');
    set(handles.axes3,'UserData',{userdata{1} greddot})
else  
    if u1-posun >0
        u1 = u1-posun;
        u2 = u2-posun;
        if ishandle(p1)
            delete(p1);delete(p2);delete(p3);
        end
        p1=plot(handles.axes3,[u1/Fs u1/Fs], [-1 1],'Color','black');
        p2=plot(handles.axes3,[u1/Fs+perioda u1/Fs+perioda], [-1 1],'Color','black');
        p3=plot(handles.axes3,[u1/Fs+2*perioda u1/Fs+2*perioda], [-1 1],'Color','black');
        set(handles.pushbutton24,'UserData',{p1 p2 p3 u1 u2});
            indNearMax = round((u1+u2)/2);%index blízko maxima - prvé maximum napravo je to, v stred rázu
        [Zmax,Xmax] = localMax(data(indNearMax:end,2),1);%haldám maximá už len zo zvyšku
        indMax = Xmax(1)+indNearMax-1;%èasový index maxima najvyššieho rázu
        set(handles.edit46,'Strin',num2str(data(indMax,2)));
        %%%%%%%%%%%%%%%%%%%
            [Zmax2,Xmax2] = localMax(data(indNearMax+br:end,2),1);%hladam max druheho razu
            indMax2 = Xmax2(1)+indNearMax+br-1;%èasový index maxima druhého rázu
            set(handles.edit47,'Strin',num2str(data(indMax2,2)));
        %%%%%%%%%%%%%%%%%%%
        hold(handles.axes3,'on')
        userdata = get(handles.axes3,'UserData');
        if length(userdata)>1
            delete(userdata{2})%vymazanie bodky v strede rázu
        end
        greddot=plot(handles.axes3,data(indMax,1),data(indMax,2),'*','Color','red');
        set(handles.axes3,'UserData',{userdata{1} greddot})
    end
end
end

% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
userdata = get(handles.pushbutton6,'UserData');
Y = userdata{1};
NFFT = userdata{2};
Fs = userdata{3};
data(:,1) = userdata{4};
data(:,2) = userdata{5};

%nájdenie frekvencií:
N = length(data);
spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum,delenie N je kôly normovaniu asi len
f = Fs/2*linspace(0,1,NFFT/2+1);%priestor príslušných frekvencií
[Z,X] = ampCheck(spektrum);
[M,I] = sort(Z,'descend');%triedenie maxim zostupne
A1 = M(1);
A2 = M(2);
f1 = f(X(I(1)));
f2 = f(X(I(2)));
userdata = get(handles.pushbutton24,'UserData');
if isempty(userdata)==0
    p1 = userdata{1};
    p2 = userdata{2};
    p3 = userdata{3};
    u1 = userdata{4};
    u2 = userdata{5};
end
posun = str2num(get(handles.edit49,'String'));
perioda = 1/abs(f1-f2);%perioda rázov
br = round(perioda*Fs);%nameraných bodov na jeden ráz
hold(handles.axes3,'on')
if isempty(userdata)
    p1=plot(handles.axes3,[0.1 0.1], [-1 1],'Color','black');
    p2=plot(handles.axes3,[0.1+perioda 0.1+perioda], [-1 1],'Color','black');
    p3=plot(handles.axes3,[0.1+2*perioda 0.1+2*perioda], [-1 1],'Color','black');
    u1 = 0.1*Fs;
    u2 = u1+br;
    set(handles.pushbutton24,'UserData',{p1 p2 p3 u1 u2});
    indNearMax = round((u1+u2)/2);%index blízko maxima - prvé maximum napravo je to, v stred rázu
    [Zmax,Xmax] = localMax(data(indNearMax:end,2),1);%haldám maximá už len zo zvyšku
    indMax = Xmax(1)+indNearMax-1;%èasový index maxima najvyššieho rázu
    set(handles.edit46,'Strin',num2str(data(indMax,2)));
    %%%%%%%%%%%%%%%%%%%
        [Zmax2,Xmax2] = localMax(data(indNearMax+br:end,2),1);%hladam max druheho razu
        indMax2 = Xmax2(1)+indNearMax+br-1;%èasový index maxima druhého rázu
        set(handles.edit47,'Strin',num2str(data(indMax2,2)));
    %%%%%%%%%%%%%%%%%%%
    hold(handles.axes3,'on')
    userdata = get(handles.axes3,'UserData');
    if length(userdata)>1
        delete(userdata{2})%vymazanie bodky v strede rázu
    end
    greddot=plot(handles.axes3,data(indMax,1),data(indMax,2),'*','Color','red');
    set(handles.axes3,'UserData',{userdata{1} greddot})
else  
    if u1-posun >0
        u1 = u1+posun;
        u2 = u2+posun;
        if ishandle(p1)
            delete(p1);delete(p2);delete(p3);
        end
        p1=plot(handles.axes3,[u1/Fs u1/Fs], [-1 1],'Color','black');
        p2=plot(handles.axes3,[u1/Fs+perioda u1/Fs+perioda], [-1 1],'Color','black');
        p3=plot(handles.axes3,[u1/Fs+2*perioda u1/Fs+2*perioda], [-1 1],'Color','black');
        set(handles.pushbutton24,'UserData',{p1 p2 p3 u1 u2});
        indNearMax = round((u1+u2)/2);%index blízko maxima - prvé maximum napravo je to, v stred rázu
        [Zmax,Xmax] = localMax(data(indNearMax:end,2),1);%haldám maximá už len zo zvyšku
        indMax = Xmax(1)+indNearMax-1;%èasový index maxima najvyššieho rázu
        set(handles.edit46,'Strin',num2str(data(indMax,2)));
        %%%%%%%%%%%%%%%%%%%
            [Zmax2,Xmax2] = localMax(data(indNearMax+br:end,2),1);%hladam max druheho razu
            indMax2 = Xmax2(1)+indNearMax+br-1;%èasový index maxima druhého rázu
            set(handles.edit47,'Strin',num2str(data(indMax2,2)));
        %%%%%%%%%%%%%%%%%%%
        hold(handles.axes3,'on')
        userdata = get(handles.axes3,'UserData');
        if length(userdata)>1
            delete(userdata{2})%vymazanie bodky v strede rázu
        end
        greddot=plot(handles.axes3,data(indMax,1),data(indMax,2),'*','Color','red');
        set(handles.axes3,'UserData',{userdata{1} greddot})
    end
end
end


function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit49 as text
%        str2double(get(hObject,'String')) returns contents of edit49 as a double
end

% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
end


% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function uitoggletool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('fdsaf')
end


% zobrazene--- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
lim = get(handles.axes3,'XLim');
od = lim(1);%oreza? od
do = lim(2);%oreza? do
userData = get(handles.pushbutton6,'UserData');%naèitanie dat
data(:,1) = userData{4};
data(:,2) = userData{5};
if do > data(end,1)%ak je horna hranica mimo nastavý sa najvyšší èas
   do = data(end,1); 
end
%najdenie inexov na odrezanie:
interval = (data(2,1)-data(1,1))/2;
iod = find(data(:,1)>=od-interval,1,'first');
ido = find(data(:,1)>=do-interval,1,'first');
data1(:,1) = data(iod:ido,1)-data(iod,1);%naèitanie x-ovych dat a posunutie na nulu
data1(:,2) = data(iod:ido,2);
data1(:,2) = data1(:,2)-mean(data1(:,2));%posunutie priemeru na nulu
%spracovanie a zobrazenie:
spracuj(data1(:,2),data1(end,1),hObject, eventdata, handles)
%aplikácia pásmovej priepuste:
if get(handles.checkbox5,'Value')
    pushbutton11_Callback(hObject, eventdata, handles)
end
end

function y = nacuvac(handles)
%funkcia na "naèúvanie" kde sa vykonáva sluèka
set(handles.pushbutton29,'String','Stop')%zmena tlaèidla na "stop"
set(handles.pushbutton29,'BackgroundColor','red')
th = str2num(get(handles.edit3,'String'));%treshold
Fs = str2num(get(handles.edit5,'String'));%vzorkovacia frekvencia
t1 = str2num(get(handles.edit4,'String'));%èas v sekundách kolko nahrávam po klepnutí

yes = 0;%podmienka ukonèenia cyklu
while ~yes
    y = wavrecord(t1*Fs,Fs);%nahra? zvuk
    y = y-mean(y);%posunutie priemeru na nulu
    [Z,X] = ampCheck(y);
    n = length(find(Z>th));%celkový poèet prekmitov cez prahovú hodnotu th
    if n>3%ak je poèet prekmitov viacej ako tri
        yes = 1;
    end
    stop = get(handles.pushbutton29,'UserData');
    if ~stop %ukonèenie pomocou tlaèidla
        return
    end
    set(handles.text2,'String',num2str(max(Z)))
    pause(0.0001)
end
end

function y = nacuvac1(handles)
%funkcia na "naèúvanie" kde sa vykonáva sluèka
th = str2num(get(handles.edit3,'String'));%treshold
Fs = str2num(get(handles.edit5,'String'));%vzorkovacia frekvencia
t1 = str2num(get(handles.edit4,'String'));%èas v sekundách kolko nahrávam po klepnutí

yes = 0;%podmienka ukonèenia cyklu
while ~yes
    y = wavrecord(t1*Fs,Fs);%nahra? zvuk
    y = y-mean(y);%posunutie priemeru na nulu
    [Z,X] = ampCheck(y);
    big = find(Z>th);
    n = length(big);%celkový poèet prekmitov cez prahovú hodnotu th
    if n>3 
        if X(big(1))<(length(y)-length(y)/6)%ak je poèet prekmitov viacej ako tri a zarove? prekrocenie tresholdu nebolo na konci moc
            yes = 1;
            if X(big(1))>70
                y = y(X(big(1))-70:end);%posunutie na za?iatok udalosti
            end
            y(length(y):t1*Fs) = 0;%doplneni nulami
        end
    end
    set(handles.text61,'String',num2str(max(Z)))
    pause(0.0001)
end
end

%Trigger - pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
stop = get(handles.pushbutton29,'UserData');
if isempty(stop)|| ~stop
    stop = 1;
else
    stop = 0;
end
set(handles.pushbutton29,'UserData',stop);%nastavenie príznaku na "aktívny"
if ~stop%ukonèi? tlaèidlom
    set(handles.pushbutton29,'String','Start')
    set(handles.pushbutton29,'BackgroundColor',[0.941 0.941 0.941])
    return
end
y = nacuvac(handles);
stop = get(handles.pushbutton29,'UserData');
if ~stop%ukonèi? tlaèidlom
    return
end
set(handles.pushbutton29,'UserData',0);%nastavenie príznaku na "neaktívny"
set(handles.pushbutton29,'String','Start')
set(handles.pushbutton29,'BackgroundColor',[0.941 0.941 0.941])

t1 = str2double(get(handles.edit4,'String'));%èas v sekundách kolko nahrávam po klepnutí
spracuj(y,t1,hObject, eventdata, handles)%spracovanie a vystup
%aplikácia pásmovej priepuste:
if get(handles.checkbox5,'Value')
    pushbutton11_Callback(hObject, eventdata, handles)
end
%stále naèúvanie:
if get(handles.checkbox3,'Value')
    pushbutton29_Callback(hObject, eventdata, handles)
end
end


%save - uloženie údajov do tabulky
function pushbutton31_Callback(hObject, eventdata, handles)
rezF = str2double(get(handles.edit42,'String'));%rezonanèná frekvencia
rezF = sprintf('%.1f', rezF);
rezF(rezF=='.') = ',';
if get(handles.radiobutton3,'Value')==1
    dekr = get(handles.text11,'String');
    dekr(dekr=='.')=',';
end
if get(handles.radiobutton4,'Value')==1
    dekr = get(handles.edit22,'String');
    dekr(dekr=='.')=',';
end
if get(handles.radiobutton5,'Value')==1
    dekr = get(handles.edit23,'String');
    dekr(dekr=='.')=',';
end
if get(handles.radiobutton6,'Value')==1
    dekr = get(handles.edit24,'String');
    dekr(dekr=='.')=',';
end
data = get(handles.uitable2,'Data');
data{end+1,1}=rezF;
data{end,2} = dekr;
set(handles.uitable2,'Data',data);
end


%clear - vymaže tabu¾ku
function pushbutton32_Callback(hObject, eventdata, handles)
data = {};
set(handles.uitable2,'Data',data);
end


function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double
end

% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double
end

% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%Del - pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
%vymaže posledný riadok tabu¾ky
data = get(handles.uitable2,'Data');
data=data(1:end-1,:);
set(handles.uitable2,'Data',data);
end

% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
%do nothing
end


%pásmová zádrž pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
userdata = get(handles.pushbutton6,'UserData');
Y = userdata{1};
NFFT = userdata{2};
Fs = userdata{3};
cas = userdata{4};
N = length(cas);
od = str2num(get(handles.edit6,'String'));
do = str2num(get(handles.edit7,'String'));
nh = round(do*NFFT/Fs);%najvyšší index
nd = round(od*NFFT/Fs);%najnižší index
Y(nd+1:nh) = 0;%aplikácia pasmovej zádrže
Y(end-nh:end-nd) = 0;
data = ifft(Y,NFFT);
data = real(data(1:length(cas)));%vybranie realneho priebehu po filtrovani
spracuj(data,cas(end),hObject, eventdata, handles)
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
end

%funkcia, kde sa spracuváva nameraný signál, hladá sa dekrement a
%vykreslujú sa údaje, rezonancnu frekvenciu hlada v danom intervale:
function vystupFlast5 = spracuj1(y,t,fmin,fmax,hObject, eventdata, handles)
%y - nameraný signál
%t - trvanie nahrávania
%fmin - dolna hranica spektra
%fmax - horna hranica spektra
%hObject,eventdata, handles - skopírova? z argumentu nadradenej funkcie
%ch - ak nastala chyba vráti 1 ak nenastala chyba vráti 0

vystupFlast5 = [];
%all data
dataAll(:,2) = y;%displacement(voltage) vector
N=length(dataAll);
dataAll(:,1) = linspace(0,t,N);%time vector
%used data-----------------------------------------------------------------
%hodnotenie parcialneho signalu
if get(handles.checkbox12,'Value')
    [Z,X] = ampCheck(dataAll(:,2));%finding for the local maxims
    lastlogDek=str2double(get(handles.edit22,'String'));%predosli log.dekrement
    lastFRez = str2double(get(handles.edit42,'String'));%predosla rezon frek
    tAmpDamp=3.91/(eps+lastlogDek*lastFRez)*1.3+0.1;%time to drop the amplitude on 1/50 of its original value plus 30 percent and 0.1 s
    AmpDampIndex = find(dataAll(:,1)>tAmpDamp,1,'first');
    if isempty(AmpDampIndex) || AmpDampIndex>N*0.9
        AmpDampIndex = round(N*0.9);
    end
    noise = max(y(AmpDampIndex:end))*1.5;%noise max amplitude determined from the end of the signal
    if noise>str2double(get(handles.edit62,'String'))
        noise = str2double(get(handles.edit62,'String'));
    end
    
    zacInd = X(find(Z>0.49,10,'last'));%indexes of ten last peaks whose overshoot treshold
    if ~isempty(zacInd) && lastlogDek < 0.05    
        if length(zacInd)==10
            zacInd = zacInd(end);
        else
          zacInd = find(y>noise,1,'first');%idex of the impulse begining
        end 
    else
        zacInd = find(y>noise,1,'first');%idex of the impulse begining
    end
    konInd = find(y>noise,1,'last');%index of the signal end
    if isempty(konInd)
        konInd = length(y);
    end
    %to be at least 100 points
    if konInd-zacInd<100
        konInd=zacInd+100;
    end
    data(:,2) = y(zacInd:konInd);%displacement(voltage) vector
    data(end+1:N,2)=0;%fulfil with zeros
    data(:,1) = dataAll(:,1);%time vector
else %analyzovat celu nahravku
    data = dataAll;
    zacInd = 1;
    konInd = N;
end
%--------------------------------------------------------------------------

NFFT = 2^nextpow2(N);
% NFFT = 32768;%napevno dane
Y = fft(data(:,2),NFFT);%výpoèet fft, 
if get(handles.radiobutton1,'Value')
    spektrum = 2*abs(Y(1:NFFT/2+1)/N);%jednostranné spektrum,delenie N je kvôli normovaniu asi len
else
    spektrum = 2*(abs(Y(1:NFFT/2+1))/N).^2;%power spectrum
end



Fs = N/data(end,1);%vzorkovacia frekvencia(èasovanie musí zaèína? od nuly)
f = Fs/2*linspace(0,1,NFFT/2+1);%priestor príslušných frekvencií
set(handles.pushbutton6,'UserData',{Y NFFT Fs data(:,1) data(:,2)});%uloženie fourierovho obrazu pre pásmovú zádrž

            %vymedzenie spektra
            indexy = (f>=fmin).*(f<=fmax);
            % bodovMedzi = length(find(indexy==1));%pocet bodov kde sa hlada rez frekvencia
            spektrumReduc = spektrum.*indexy';%aplikovanie masky, ostanu iba hodnoty medzi fmin a fmax

[A, P] = ampCheck(spektrumReduc);%hodnoty a polohy lokálnych maxím
if isempty(A)%ak sa nenašlo maximum v danom intervale
    display('No maximum finded in the given boundaries.')
    rezFrek=NaN;
    set(handles.edit42,'String',num2str(rezFrek));
    
    hold(handles.axes3,'off')
    delete(get(handles.axes3,'Children'))
    hold(handles.axes4,'on');
    plot(handles.axes4,f,spektrum);
    return
end
[M m] = sort(A,'descend');%triedenie maxim zostupne
I = P(m);%pozicie maxim zostupne
index = 1;%pozicia konkrétneho maxima v postupností maxím

if get(handles.checkbox6,'Value')
    klesa = mean(spektrum(I(index)-1:-1:I(index)-15))<spektrum(I(index)).*mean(spektrum(I(index)+1:I(index)+15))<spektrum(I(index));
    if (length(I)<3 || spektrumReduc(I(index))>mean(spektrumReduc(I(3:end)))*3) && klesa
        rezFrek = f(I(index));
    else
        rezFrek = NaN;
    end
else
    rezFrek = f(I(index));
end

[Z,X] = ampCheck(data(:,2));

%nájdenie log. dekrementu z útlmu kmitania:
if length(X)>2
    cufit = fit(data(X,1),Z','exp1');%fitovamie exponencialov
    koeficienty = coeffvalues(cufit);
else
    koeficienty = [NaN NaN];
    display('Malo bodov na fitovanie exponencialov. funkcia spracuj1')
end
set(handles.figure1,'UserData',{I index f koeficienty M});%uloženie triedených frekvencií I, index - konkrétne maximum
logDek = -koeficienty(2)/rezFrek;

%% urèenie log. dekrementu s polšírky spekrálnej krivky:
    %lavý svah:
    peakleft = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        peakleft(end+1,1) = spektrum(i);
        peakleft(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
        i = i-1;
    end
    %pravý svah:
    peakright = [];
    konec = 1;
    i = I(index);%index rez frekvencie
    while konec
        peakright(end+1,1) = spektrum(i);
        peakright(end,2) = f(i);
        %ukonèi? ak prejdem polvýškou:
        if spektrum(i)<M(index)/2
            konec = 0;
        end
        i = i+1;
    end
    if size(peakleft,1)>1 && size(peakright,1)>1
        fl = interp1(peakleft(:,1),peakleft(:,2),M(index)/2);%frekvencia na lavom svahu frek krivky v polovyške
        fr = interp1(peakright(:,1),peakright(:,2),M(index)/2);%frekvencia na pravom svahu frek krivky v polovyške
        h = fr-fl;%šírka krivky v polvýške
        logDek2 = h*pi/(sqrt(3)*rezFrek);
        set(handles.edit22,'String',num2str(logDek2));
        %iba z ¾avého svahu:
            h = 2*(rezFrek-fl);%predpokladá sa symetria
            logDekL = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit23,'String',num2str(logDekL));
        %iba z pravého svahu:
            h = 2*(fr-rezFrek);
            logDekR = h*pi/(sqrt(3)*rezFrek);
            set(handles.edit24,'String',num2str(logDekR));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
set(handles.text11,'String',num2str(logDek));
set(handles.edit42,'String',num2str(rezFrek));
%zobrazenie výstupu:
hold(handles.axes3,'off')
sigdek = plot(handles.axes3,dataAll(:,1),dataAll(:,2),...
    data(1:(konInd-zacInd+1),1)+dataAll(zacInd,1),cufit(data(1:(konInd-zacInd+1),1)),...
    [dataAll(zacInd) dataAll(zacInd)], [-0.5 0.5],...
    [dataAll(konInd) dataAll(konInd)], [-0.5 0.5]);%plotovanie aj s dekrementom
set(sigdek(2),'Color','green','LineWidth',1.5)%farba èiary fitovania
set(sigdek(3),'Color','red')
set(sigdek(4),'Color','red')
title(handles.axes3,'Signal y(t)')
xlabel(handles.axes3,'Time (s)')
ylabel(handles.axes3,'Voltage (V)')
set(handles.axes3,'UserData',{sigdek});

axes4Children=get(handles.axes4,'Children');%objekty v axes
if ~isempty(axes4Children)%ak su tam nejake objekty
    oldSpec(:,1)=get(axes4Children(end-1),'XData');
    oldSpec(:,2)=get(axes4Children(end-1),'YData');
    hold(handles.axes4,'off');
    plot(handles.axes4,oldSpec(:,1),oldSpec(:,2),'Color',[0.8 0.8 0.8],'LineWidth',2);
end
hold(handles.axes4,'on');
plot(handles.axes4,f,spektrum);
plot(handles.axes4,f(I(index)),M(index),'*','Color','red');%vykreslennie hviezdièky na maxime
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%vykreslenie a posun hranic rezonanènenj frekvencie
lineMin=plot(handles.axes4,[fmin fmin], [0 10],'Color','red');%vykreslenie ohranicenia frekvencie
lineMax=plot(handles.axes4,[fmax fmax], [0 10],'Color','red');%vykreslenie ohranicenia frekvencie

set(lineMin,'ButtonDownFcn',@startDragFcnMin);
set(lineMax,'ButtonDownFcn',@startDragFcnMax);

set(handles.figure1,'WindowButtonUpFcn', @stopDragFcn);

function startDragFcnMin(varargin)
%hObject - figure
set(handles.figure1, 'WindowButtonMotionFcn', @draggingFcnMin);
set(handles.axes4,'UserData',get(handles.axes4,'CurrentPoint'));%východzia pozicia
set(lineMin,'UserData',get(lineMin,'XData'));
end

function draggingFcnMin(varargin)
pt = get(handles.axes4,'CurrentPoint');
ptold=get(handles.axes4,'UserData');
fmin = get(lineMin,'UserData')+pt(1)-ptold(1);
if fmin>=fmax-1
    fmin = fmax-2;
else
    if fmin<0
        fmin=0;
    else
    set(lineMin, 'XData', fmin);
    fmin=fmin(1);
    set(handles.edit58,'String',num2str(round((fmax-fmin)/2)));
    end
end
end

function startDragFcnMax(varargin)
%hObject - figure
set(handles.figure1, 'WindowButtonMotionFcn', @draggingFcnMax);
set(handles.axes4,'UserData',get(handles.axes4,'CurrentPoint'));%východzia pozicia
set(lineMax,'UserData',get(lineMax,'XData'));
end

function draggingFcnMax(varargin)
pt = get(handles.axes4,'CurrentPoint');
ptold=get(handles.axes4,'UserData');
fmax = get(lineMax,'UserData')+pt(1)-ptold(1);
if fmax<=fmin+1
    fmax = fmin+2;
else
    set(lineMax, 'XData', fmax);
    fmax=fmax(1);
    set(handles.edit58,'String',num2str(round((fmax-fmin)/2)));
end
end
udata=get(handles.uipanel21,'UserData');
function stopDragFcn(varargin)
    set(handles.figure1, 'WindowButtonMotionFcn','');
    set(handles.axes4,'UserData',[]);%východzia pozicia
    vystupFlast5 = ones(1,5).*(fmax+fmin)/2;%poslednych 5 rez. frekvencii
    udata{8}=vystupFlast5;
    set(handles.uipanel21,'UserData',udata);
end
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
text('Parent',handles.axes4,'Position',[f(I(index))+30,M(index)-0.1*M(index)],...
    'String',[num2str(rezFrek,'%5.0f') ' Hz']);%vykreslenie frekvencie v grafe
% plot(handles.axes4,[fmin fmin], [0 N(index)*2],'Color','red');%vykreslenie ohranicenia frekvencie
% plot(handles.axes4,[fmax fmax], [0 N(index)*2],'Color','red');%vykreslenie ohranicenia frekvencie
set(handles.axes4,'YLim',[0 max(spektrum*(1+0.05))]);%nastavenie limitu zobrezenia
if size(peakleft,1)>1 && size(peakright,1)>1 %ak bol schopný nájs? polovýšku
    plot(handles.axes4,[fr fl],[M(index)/2 M(index)/2],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky v polovici svahov
else
    plot(handles.axes4,[0 0],[0 0],'*','Color',[0.582 0.3867 0.3867]);%vykreslenie hviezdièky na zaèiatku sústavy
end
hold(handles.axes4,'off');
rozlisenie = f(2)-f(1);
if get(handles.radiobutton1,'Value')
    title(handles.axes4,['Single-Sided Amplitude Spetrum of y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'|Y(f)|')
else
    title(handles.axes4,['Power Spectrum of signalu y(t), resolution: ' num2str(rozlisenie) ' Hz'])
    xlabel(handles.axes4,'Frequency (Hz)')
    ylabel(handles.axes4,'Power')
end
%limity frekvnèného grafu:
if get(handles.checkbox2,'Value')
    pushbutton3_Callback(hObject, eventdata, handles)
end

%ukladanie spektier--------------------------------------------------------
% %ukladaju sa v pushbutton38 callback
% udata = get(handles.checkbox2,'UserData');
% if isempty(udata)
%     spe = spektrum;
%     fre = f';
%     i=1;
%     set(handles.checkbox2,'UserData',{spe fre i})
% else
%     i = udata{3};
%     spe = udata{1};
%     fre = udata{2};
%     if i==20%uloži? každé dvadsiate
%         spe(:,end+1)=spektrum;
%         fre(:,end+1) =f'; 
%         i=0;
%     end
%     i=i+1;
%     set(handles.checkbox2,'UserData',{spe fre i})
% end
%--------------------------------------------------------------------------
end

%vytvorenie timeru
function pushbutton35_Callback(hObject, eventdata, handles)
global s
SData=get(handles.pushbutton41,'UserData');
sendTemperatureProgram(s,SData);
if(~strcmp(confirmation(s,SData),'Yes'))
    return
end
sendCommand(s,'REGSTART:',[]);
delete(timerfindall);
delete(instrfindall);
rec = audiorecorder(str2num(get(handles.edit5,'String')),16,1);
% arduino = serial('COM3','BaudRate',9600);
% fopen(arduino);

% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

datum = date %nacitanie aktualneho datumu
SampleName = SData.SampleName
%nacitanie cesty ulozenia suboru, defaultne C:\Documents and
%Settings\Administrator\Desktop\IET results\resultsall\ :
nazovSuboru = [datum ' - ' SampleName '.txt'];

[nazovSuboru,cesta] = uiputfile(nazovSuboru,'Ulozit subor ako',['C:\Documents and Settings\Administrator\Desktop\IET results\resultsall\' nazovSuboru]);



%(de)aktivacia tlacidiel:
set(handles.pushbutton35,'Enable','off')
set(handles.pushbutton38,'Enable','on')
% set(handles.edit52,'Enable','off')
% set(handles.edit54,'Enable','off')
% set(handles.edit53,'Enable','off')
% set(handles.edit59,'Enable','off')
% set(handles.edit61,'Enable','off')
% set(handles.edit60,'Enable','off')
% set(handles.edit55,'Enable','off')
% set(handles.edit67,'Enable','off')
% set(handles.edit68,'Enable','off')
% set(handles.edit69,'Enable','off')
% set(handles.edit71,'Enable','off')
% set(handles.edit72,'Enable','off')
set(handles.pushbutton41,'Enable','off')
% set(handles.pushbutton39,'Enable','off')
% set(handles.pushbutton40,'Enable','off')
% set(handles.checkbox10,'Enable','off')
set(hObject,'UserData',date)


% if isempty(t)
    t = timer('Period', str2double(get(handles.edit57,'String')),'ExecutionMode','fixedSpacing');
    t.TimerFcn = {@pulzSynchro, hObject, eventdata, handles};
    t.ErrorFcn = {@myerrorfunction,hObject,eventdata,handles};%?o sa ma sta? pri chybe
    start(t)
% else
%     delete(t)
% end

tt = timer('Period', 1,'ExecutionMode','fixedSpacing');
tt.TimerFcn = {@dispTemp, hObject, eventdata, handles};
tt.ErrorFcn = {@myerrorfunction,hObject,eventdata,handles};%?o sa ma sta? pri chybe
start(tt)

end

%funkcia, ktora sa vykona pri zlihani timeru
function myerrorfunction(hob, evdat, hObject, eventdata, handles)
if ~isempty(daqfind)
    putsample(daqfind,0)%nasvi? výstupné napätie na nulu
    delete(daqfind)%vymaza? komunikáciu s kartou
end
pushbutton38_Callback(hObject, eventdata, handles)%zapis dat do suboru
display('Ukoncene s chybou')
end

function dispTemp(hob, evdat, hObject, eventdata, handles)
%     naèíta údaj teploty z arduina
%     FTemp=['Temperature: ' AFTemp];
%     set(handles.Text84,'String',FTemp);
end

%funkcia ktora as vola v timery:
function pulzSynchro(hob, evdat, hObject, eventdata, handles)
%úder impulzoru je riadený programom
SData=get(handles.pushbutton41,'UserData');
S=max(SData.ProgT(:,1))*60;
formatOut='dd.mm.yyyy HH:MM';
T=datenum(datestr(S/86400,formatOut),formatOut);
Tt=datenum(now);
Tc=datestr(Tt+T,formatOut);
Tc=['End of measurement: ' Tc];
set(handles.text85,'String',Tc)

udata = get(handles.uipanel21,'UserData');
if isempty(udata)%na za?iatku
    delete(daqfind)%vymazanie existujúcich komunikácii s advantech ak sú
    cas0 = clock;
    cas = [];
    teplota = [];
    frez = [];
    dek = [];
    flast5=[];
    %vytvorenie komunikacneho kanalu s karotu advantech (vystup):
    ao = analogoutput('advantech');
    addchannel(ao,0);
    set(ao,'TriggerType','Immediate');
    set(ao,'SampleRate',1);
    putsample(ao,0)
    %nastavenie Analogoveho vstupu----------------------------------------
    AI = visa('agilent', 'USB0::0x0957::0x2007::MY49009376::0::INSTR');
    fopen(AI);
    %----------------------------------------------------------------------
    set(handles.uipanel21,'UserData',{cas0 cas teplota frez dek ao AI flast5})
    %nastevenie grafu pre tlmenie a frekvenciu:
    set(handles.axes6,'Color','none')
    set(handles.axes6,'YAxisLocation','right')
    set(handles.axes6,'YColor','green')
    xlabel(handles.axes5,'Teplota [°C]')
    ylabel(handles.axes5,'Rez. frekven. [Hz]')
    ylabel(handles.axes6,'Log. dek. [-]')
    udata = get(handles.uipanel21,'UserData');
end

opakovanie = 0;%pocet opakovani s aktualnou amplitudou
zlySignal = 1;%1-zly signal, 0-dobry signal
while zlySignal%pokial sa nezaznamena kvalitny signal ak to pozadujeme
    cas0 = udata{1};
    cas = etime(clock,cas0);%uplynulý èas v sekundách

    %výpo?et aktuálnej teploty (programovanej):--------------------------------
%     Tstart = str2double(get(handles.edit52,'String'));%zac. teplota programu
%     ramp1 = str2double(get(handles.edit54,'String'));%rychlost ohrevu
%     Tmax = str2double(get(handles.edit53,'String'));%max. teplota programu
%     vydrz = str2double(get(handles.edit59,'String'));%izotermicka vydrz
%     ramp2 = str2double(get(handles.edit61,'String'));%rychl. chladenia
%     Tend = str2double(get(handles.edit60,'String'));%finalna teplota
    
%     fwrite(arduino,Tstart);
%     fclose(arduino);
%     seg1 = (Tmax-Tstart)/ramp1;%[min] cas konca prveho segmentu (ohrevu)
%     seg2 = seg1+vydrz;%[min] cas konca druheho segmentu (vydrze)
%     seg3 = seg2+(Tmax-Tend)/ramp2;%[min] koniec tretieho segmentu (chladenia)
%     if cas/60<=seg1
%         display('ohrev')
%         %teplotaV = cas/60*ramp1+Tstart
%     elseif cas/60 > seg1 && cas/60<=seg2
%         display('vydrz')
%         %teplotaV = Tmax
%     elseif cas/60 > seg2 && cas/60 < seg3
%         display('chladenie')
%         %teplotaV = Tmax-ramp2*(cas/60-seg2)
%     else %ukon?enie
%     %     pushbutton38_Callback(hObject, eventdata, handles)
%     %     return
%     %aby sa meralo stále, treba ukoncit manualne
%         display('chladenie')
%         %teplotaV = Tmax-ramp2*(cas/60-seg2)
%     end
    %--------------------------------------------------------------------------

    %nameraná teplota----------------------------------------------------------
    
    
    
%     PREROBI
    AI=udata{7};
    fprintf(AI,'MEAS:VOLT:DC? (@101)')%jednosmerne napätie na porte 101, autorozsah
    Um=str2double(fscanf(AI))*1e6; %napätie na termo?lánku [uV]
    fprintf(AI,'MEAS:VOLT:DC? (@102)')
    Tc = str2double(fscanf(AI))*100 %teplota studených koncov v °C
    Uc = thermocoupleS_T2U(Tc);%napätie pre kompenzaciu
    Ucor = Um+Uc;%korigovane napetie o teplotu studenych koncov
    teplota = thermocoupleS_U2T(Ucor)%aktuálna teplota v peci aj skorekciou studenych koncov
    %-------------------------------------------------------------------------
    %%%%%
    %zostavajuci cas:
    set(handles.text72,'String',['Zostava[min]: ' num2str(seg3-cas/60)])
    %--------------------------------------------------------------------------
    %if cas/60>seg2 %ak sa už chladí (ak chceme mera? iba chladenie)

    %impulz:
    ao = udata{6};%premenna v ktorej je ulozeny odkaz na kanal karty advantech
    Fs = str2double(get(handles.edit5,'String'));%vzorkovacia frekvencia
    t1 = str2double(get(handles.edit4,'String'));%èas v sekundách kolko nahrávam po klepnutí
    U = str2double(get(handles.edit56,'String'));%napätie bázy
    putsample(ao,U)%impulz
%     pause(0.09)
    %nahratie dát:    
    record(rec,str2num(get(handles.edit4,'String')));%nahrat zvuk
    y = getaudiodata(rec);
    %položenie kladivka--------------------------------------------------------
    putsample(ao,U-U/10)
    pause(0.1)
    putsample(ao,U-2*U/10)
    pause(0.1)
    putsample(ao,U-3*U/10)
    pause(0.1)
    putsample(ao,U-4*U/10)
    pause(0.1)
    putsample(ao,U-5*U/10)
    pause(0.1)
    putsample(ao,U-6*U/10)
    pause(0.1)
    putsample(ao,U-7*U/10)
    pause(0.1)
    putsample(ao,U-8*U/10)
    pause(0.1)
    putsample(ao,U-9*U/10)
    pause(0.1)
    putsample(ao,0)%ukon?enie pulzu
    %--------------------------------------------------------------------------
    y = y-mean(y);%posunutie priemeru na nulu
    pause(0.0001)
    %
    %--------------------------------------------------------------------------
    %hodnotenie signalu (zisti ci nastal uder tj. ci bola prekrocena prahova
    %hodnota) ak nie zvyši sa urove? budenia a funkcia sa ukon?i:
    if get(handles.checkbox7,'Value')
        if max(y)<str2double(get(handles.edit62,'String'))
            %ak nebol prekroceny treshold tak ešte raz sa skusi vzorka
            %excitova? to tým istým bázovým napätím a ak sa ani potom
            %neprekro?í na nameranom sigánle treschold tak zvýši? napätie na
            %báze tranzistora:
            if opakovanie>0
                set(handles.edit56,'String',num2str(U+U/100))%zvyšenie sily budenia
                display('Neakceptovaný signál')
                if U+U/100>3.5
                    set(handles.edit56,'String',num2str(2.15))%ak as prekro?í hodnota napätia 3.5 skusi sa napätie zníži?
                    display(['Magnituda znížená z ' num2str(U) 'na ' num2str(2.15) ' V'])
                else
                    display(['Magnituda zvyšená z ' num2str(U) 'na ' num2str(U+U/100) ' V'])
                end
                opakovanie = 0;
                pause(6)
                %return%ukon?enie funkcie
            else
                display('Neakceptovany signal - Opakujem s tou istou magnitudou')
                pause(6)%?akanie na nabitie kondenzátora
                opakovanie = opakovanie+1;
            end
            %%%%%%%%%%%

        else
            zlySignal = 0;
        end
    else
        zlySignal = 0;
    end
    %--------------------------------------------------------------------------
end

pcas = udata{2};%doterajšie ?asy
pcas(end+1) = cas;%prida? aktualny cas na koniec
pteplota = udata{3};%doterajsie teploty
pfrez = udata{4};%doterajsie frekvencie
flast5 = udata{8};%poslednych 5 rez. frekvencii
if isempty(flast5)
    flast5(1:5) = str2double(get(handles.edit55,'String'));%frekvencia na zacatku
end
flast=mean(flast5);
%urcenie hranic v ktorych sa hlada frekvencia:
if ~isempty(pfrez)
    if flast5(1)==flast5(end)
        fmin = flast-str2double(get(handles.edit58,'String'));
        fmax = flast+str2double(get(handles.edit58,'String'));
    else
        dT = abs(teplota-pteplota(end));%zmena teploty
        df = 10;%maximálna predpokladaná zmena frekvencie pri zmene teploty o 1°C
        fmin = flast-(dT*df)-str2double(get(handles.edit58,'String'));
        if fmin<0
            fmin=0;
        end
        fmax = flast+(dT*df)+str2double(get(handles.edit58,'String'));
    end
else
    fmin = flast-str2double(get(handles.edit58,'String'));
    if fmin<0
        fmin=0;
    end
    fmax = flast+str2double(get(handles.edit58,'String'));
end

%spracovanie signalu, vystup a hodnotenie kvality spektra ak je požadovane:
vystupSpracuj=spracuj1(y,t1,fmin,fmax,hObject, eventdata, handles);
if ~isempty(vystupSpracuj)
%     do prememennej vystupSpracuj sa uklada frekvencia pri rucnom posune hranic, ktora lezi v ich strede
    flast5=vystupSpracuj;
end
    
    %aplikácie pásmovej zádrže
    if get(handles.checkbox4,'Value')
        pushbutton34_Callback(hObject, eventdata, handles)
    end
    %aplikacia pasmovej priepuste:
    if get(handles.checkbox5,'Value')
        pushbutton11_Callback(hObject, eventdata, handles)
    end
    
frez = str2double(get(handles.edit42,'String'));%aktualna frekvencia
if ~isnan(frez)
    %----------------------------------------------------------------------
    if get(handles.checkbox11,'Value')
    %ak sa prekro?í istý po?et prekmitov cez prahovú hodnotu zníži sa budenie:
        Z = ampCheck(y);%hodnoty  lokalnych maxim
        if length(y(Z>0.46))>0.08*frez
            set(handles.edit56,'String',num2str(U-U/300));
        end
    end
    %----------------------------------------------------------------------
    %dekrement:
    dekC=str2double(get(handles.edit22,'String'));%dek zo sirky
    dekL=str2double(get(handles.edit23,'String'));%dek z laveho svahu
    dekR=str2double(get(handles.edit24,'String'));%dek z praveho svahu
    if get(handles.radiobutton3,'Value')==1
        dek = str2double(get(handles.text11,'String'));
    end
    if get(handles.radiobutton4,'Value')==1
        dek = str2double(get(handles.edit22,'String'));
    end
    if get(handles.radiobutton5,'Value')==1
        dek = str2double(get(handles.edit23,'String'));
    end
    if get(handles.radiobutton6,'Value')==1
        dek = str2double(get(handles.edit24,'String'));
    end
%     dek=min([dekC dekL dekR]);%akceptovany dekrement je ten ktory je najmensi
    %%%%%
    pteplota(end+1) = teplota;    
    pfrez(end+1) = frez;
    flast5(1:4)=flast5(2:5);flast5(5)=frez;%poslednych 5 rez frekvencii.
    pdek = udata{5};
    pdek(end+1) = dek;
    
    %set the recording time accordingly to the damping---------------------
%     averdek = mean(lastN(pdek,5));%average decrement of last 5 measurements
%     averfrek = mean(lastN(pfrez,5));%average resonant frequency of last 5 measurements
%     recTime = 3.91/(averdek*averfrek);%time to decrease of the amplitude to the 1/50 it's orrginal value
%     if recTime<0.03
%         recTime=0.03;%minimum recording time
%     end
%     rectimevect = linspace(0,t1,length(y));%time vector of recorded signal
%     lastOvershotTime = rectimevect(find(y>0.46,1,'last'));%time of last overshod of the value 0.46
%     %signBeginTime = rectimevect(find(y>str2double(get(handles.edit62,'String')),1,'first'));%time of the signal begin
%     set(handles.edit4,'String',num2str(recTime+lastOvershotTime));
    %----------------------------------------------------------------------
    
     %výpoèet modulu pružnosti v ?ahu
    if get(handles.checkbox10,'Value')
        %[nazov,cesta]=uigetfile %najst cestu k suboru
        L0 = str2double(get(handles.edit67,'String'));
        d0 = str2double(get(handles.edit68,'String'));
        m0 = str2double(get(handles.edit69,'String'));
        TD = get(handles.pushbutton39,'UserData');
        TG = get(handles.pushbutton40,'UserData');
        E = modulPruz(L0,d0,m0,frez,TD,TG,teplota)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    set(handles.uipanel21,'UserData',{cas0 pcas pteplota pfrez pdek ao AI flast5});
    %teplotna alebo casova oblast
    if get(handles.radiobutton9,'Value')
        plot(handles.axes5,pteplota,pfrez,'Marker','.','LineStyle','none');
        plot(handles.axes6,pteplota,pdek,'Marker','.','LineStyle','none','Color','green');  
        xlabel(handles.axes5,'Teplota [°C]')
    else
        plot(handles.axes5,pcas/60,pfrez,'Marker','.','LineStyle','none');
        plot(handles.axes6,pcas/60,pdek,'Marker','.','LineStyle','none','Color','green');
        xlabel(handles.axes5,'Cas [min]')
    end
    xlim(handles.axes6,get(handles.axes5,'XLim'))%rovnaka x-ova os
    
    %limity grafu rez. frek. a log. dek.
    if get(handles.checkbox8,'Value')
        ylim(handles.axes5,[str2double(get(handles.edit63,'String')) str2double(get(handles.edit64,'String'))])
    else
        ylim(handles.axes5,'auto')
    end
    if get(handles.checkbox9,'Value')
        ylim(handles.axes6,[str2double(get(handles.edit66,'String')) str2double(get(handles.edit65,'String'))])
    else
        ylim(handles.axes6,'auto')
    end
    %%%%%%%%%%%%%%
    
    ex = fopen('export.txt','wt');
    fprintf(ex,'%.8d; %.8d; %.8d; %.8d\n',[pcas' pteplota' pfrez' pdek']');
    fclose(ex);
else
    display('Zle spektrum')
    %set(handles.edit56,'String',num2str(U+U/100))%zosilnenie ?uknutia
end
%vypne ak teplota v segmente chladenia klesne pod xx C
if cas/60>seg3 && teplota<50
    pushbutton38_Callback(hObject, eventdata, handles)
    return
end
% set(handles.edit56,'String',num2str(U-0.001))%zníženie sily budenia

%end%ak sa už chladí-------------------------------------------------------
end

function E = modulPruz(L0,d0,m0,fr,TD,TG,T)
%funkcia poèítajúca aktuálnu hodnotu Youngovho modulu pružnosti v ?ahu pri
%teplote T.
%L0 - poèiatoèná dåžka vzorky [mm]
%d0 - poèiatoèný priemer vzorky [mm]
%m0 - poèiatoèná hmotnos? vzorky [g]
%fr - rezonanèná frekvencia pri teplote T [Hz]
%TD - termodilatometrická krivka (prvý ståpec teplota, druhý relatívne prdåženie v percentách)
%TG - termogravimetrická krivka (prvý ståpec teplota, druhý relatívna zmena hmotnosti v percentách)
%T - aktuálna teplota [°C]
%E - modul pružnosti v ?ahu [Pa]

nu=0.3;%poissonovo èíslo

relPredl = interp1(TD(:,1),TD(:,2),T,'nearest','extrap')/100;
L = L0*(1+relPredl);
d = d0*(1+relPredl);
dm = interp1(TG(:,1),TG(:,2),T,'nearest','extrap')/100;
m = m0*(1+dm);


T1 = 1+4.939*(1+0.0752*nu+0.8109*nu^2)*(d/L)^2-...
        0.4883*(d/L)^4-(4.691*(1+0.2023*nu+2.173*nu^2)*(d/L)^4)/...
        (1.000+4.754*(1+0.1408*nu+1.536*nu^2)*(d/L)^2);
E = 1.6067*(L^3/d^4)*(m*fr^2)*T1;
end

%dialog na vybratie správnych st?pcov:
function [T,v,unit] = columSelect(data,typ,handles)
%data = vstupné dáta z ktorých sa vyberajú ståpce
%T = stlpec v ktorom je ulozena teplota
%v = stlpce v ktorom je relatívne predlzenie resp. relativna strata
%hmotnosti
%unit = 0 - ak je v percentách, 1 - ak je to relatívny pomer
s = size(data);
popuString = '1';
for i=2:s(2)
    popuString = [popuString '|' num2str(i)];
end
fh = figure('Position',[250 250 700 350],...
            'MenuBar','none','NumberTitle','off',...
            'Name','Výber ståpcov');
tab = uitable(fh,'Position',[20 70 340 150],...
    'Data',data);
uicontrol(fh,'Style','pushbutton',...
    'Position',[150 10 50 30],...
    'String','Done',...
    'Callback',@donebutton_callback);
teplota=uicontrol(fh,'Style','popup',...
    'String',popuString,...
    'Position',[75 325 35 14],...
    'Callback',@tepStlpec_callback);
uicontrol(fh,'Style','text',...
    'String','Teplota:',...
    'Position',[20 320 50 14]);
udaje=uicontrol(fh,'Style','popup',...
    'String',popuString,...
    'Position',[75 300 35 14],...
    'Callback',@velStlpec_callback);
jedn=uicontrol(fh,'Style','popup',...
        'String','%|rel',...
        'Position',[110 300 40 14]);
if strcmp(typ,'TD')  
    uicontrol(fh,'Style','text',...
        'String','TD:',...
        'Position',[20 300 50 14]);
elseif strcmp(typ,'TG')
    uicontrol(fh,'Style','text',...
        'String','TG:',...
        'Position',[20 300 50 14]);
end
    %global ax;
    ax = axes;%graf
    set(ax,'position',[0.62 0.2 0.36 0.7])
    %kliknutie na tlacidlo "done":
    function donebutton_callback(hObject,eventdata)
        %callback pri kliknutí na tlaèidlo done  
        T = get(teplota,'Value');
        v = get(udaje,'Value');
        unit = get(jedn,'Value');
        close(fh)
    end
%--------------------------------------------------------------------------
    %co sa vykona pri vybere stlpcov
    function velStlpec_callback(hObject,eventdata)
        plot(ax,data(:,get(teplota,'Value')),data(:,get(udaje,'Value')))
    end
    function tepStlpec_callback(hObject,eventdata)
        plot(ax,data(:,get(teplota,'Value')),data(:,get(udaje,'Value')))
    end
%--------------------------------------------------------------------------
waitfor(fh)%èaka? pokia¾ sa nezavra figura fh
if strcmp(typ,'TD')  
    set(handles.pushbutton39,'BackgroundColor','green')
elseif strcmp(typ,'TG')
    set(handles.pushbutton40,'BackgroundColor','green')
end
end

function f =lastN(x,N)
%vrati poslednych N hodnôt z vektora x. Ak je vektro x kratsi ako N tak
%vrati iba dostupne hodnoty
n = length(x);
if n>N-1
    f = x(end:-1:end-N+1);
else
    f = x;
end
end

function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52 as text
%        str2double(get(hObject,'String')) returns contents of edit52 as a double
end

% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double
end

% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double
end

% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
end



function edit55_Callback(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit55 as text
%        str2double(get(hObject,'String')) returns contents of edit55 as a double
end

% --- Executes during object creation, after setting all properties.
function edit55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
end



function edit56_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<0) || (cislo>5)
    set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',get(hObject,'String'))

end



function edit57_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo)
    set(hObject,'String',get(hObject,'UserData'))
    return
elseif (cislo<7)
    set(hObject,'String',num2str(7))
    set(hObject,'UserData',num2str(7))
else
    set(hObject,'UserData',num2str(cislo))
end

if ~isempty(timerfind)
    stop(timerfind)
    set(timerfind,'Period',str2double(get(handles.edit57,'String')))
    start(timerfindall)
end
end

% --- Executes during object creation, after setting all properties.
function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',get(hObject,'String'))
end


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
udata = get(handles.uipanel21,'UserData');
figure;

if get(handles.radiobutton9,'Value')==1
    [ax, h1, h2]=plotyy(udata{3},udata{4},udata{3},udata{5});
    set(h1,'Marker','.','LineStyle','none')
    set(h2,'Marker','.','LineStyle','none')
    xlabel(ax(1),'Teplota [°C]')
    ylabel(ax(1),'Rez. Frek [Hz]')
    ylabel(ax(2),'Log. dek [-]')
else
    [ax, h1, h2]=plotyy(udata{2}/60,udata{4},udata{2}/60,udata{5});
    set(h1,'Marker','.','LineStyle','none')
    set(h2,'Marker','.','LineStyle','none')
    xlabel(ax(1),'Cas [min]')
    ylabel(ax(1),'Rez. Frek [Hz]')
    ylabel(ax(2),'Log. dek [-]')
end
end

function edit58_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',get(hObject,'String'))
end



function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double
end

% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit60_Callback(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit60 as text
%        str2double(get(hObject,'String')) returns contents of edit60 as a double
end

% --- Executes during object creation, after setting all properties.
function edit60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit61_Callback(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit61 as text
%        str2double(get(hObject,'String')) returns contents of edit61 as a double
end

% --- Executes during object creation, after setting all properties.
function edit61_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit62_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<0)
set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

% --- Executes during object creation, after setting all properties.
function edit62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',get(hObject,'String'))
end

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
end

function edit63_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo>str2double(get(handles.edit64,'String')))
    set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

% --- Executes during object creation, after setting all properties.
function edit63_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',get(hObject,'String'))
end


function edit64_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<str2double(get(handles.edit63,'String')))
    set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

% --- Executes during object creation, after setting all properties.
function edit64_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'UserData',get(hObject,'String'))

end


function edit65_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo<str2double(get(handles.edit66,'String')))
    set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

% --- Executes during object creation, after setting all properties.
function edit65_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit65 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',get(hObject,'String'))
end


function edit66_Callback(hObject, eventdata, handles)
cislo=str2double(get(hObject,'String'));
if isnan(cislo) || (cislo>str2double(get(handles.edit65,'String')))
    set(hObject,'String',get(hObject,'UserData'))
else
    set(hObject,'UserData',num2str(cislo))
end
end

% --- Executes during object creation, after setting all properties.
function edit66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'UserData',get(hObject,'String'))
end

% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
end

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
end

% --- Executes when selected object is changed in uipanel24.
function uipanel24_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel24 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
%set(handles.uipanel21,'UserData',{cas0 cas teplota frez dek ao})
data=get(handles.uipanel21,'UserData');
pteplota = data{3};
pfrez = data{4};
pdek = data{5};
pcas = data{2};
    if get(handles.radiobutton9,'Value')
        plot(handles.axes5,pteplota,pfrez,'Marker','.','LineStyle','none');
        plot(handles.axes6,pteplota,pdek,'Marker','.','LineStyle','none','Color','green');  
        xlabel(handles.axes5,'Teplota [°C]')
        set(handles.axes6,'XTickLabel',[])
    else
        plot(handles.axes5,pcas/60,pfrez,'Marker','.','LineStyle','none');
        plot(handles.axes6,pcas/60,pdek,'Marker','.','LineStyle','none','Color','green');
        xlabel(handles.axes5,'Cas [min]')
        set(handles.axes6,'XTickLabel',[])
    end
    xlim(handles.axes6,get(handles.axes5,'XLim'))%rovnaka x-ova os
        %limity grafu rez. frek. a log. dek.
    if get(handles.checkbox8,'Value')
        ylim(handles.axes5,[str2double(get(handles.edit63,'String')) str2double(get(handles.edit64,'String'))])
    else
        ylim(handles.axes5,'auto')
    end
    if get(handles.checkbox9,'Value')
        ylim(handles.axes6,[str2double(get(handles.edit66,'String')) str2double(get(handles.edit65,'String'))])
    else
        ylim(handles.axes6,'auto')
    end
    %%%%%%%%%%%%%%
end


function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double
end

% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit68_Callback(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit68 as text
%        str2double(get(hObject,'String')) returns contents of edit68 as a double
end

% --- Executes during object creation, after setting all properties.
function edit68_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit69_Callback(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit69 as text
%        str2double(get(hObject,'String')) returns contents of edit69 as a double
end

% --- Executes during object creation, after setting all properties.
function edit69_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.edit67,'Enable','on')
    set(handles.edit68,'Enable','on')
    set(handles.edit69,'Enable','on')
    set(handles.pushbutton39,'Enable','on')
    set(handles.pushbutton40,'Enable','on')

else
    set(handles.pushbutton39,'Enable','off')
    set(handles.pushbutton40,'Enable','off')
end
end

% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
im = uiimport('-file');
fn = fieldnames(im);
TD=getfield(im,fn{1});
[sT,srl,unit]=columSelect(TD,'TD',handles);
    T = TD(:,sT);
if unit==1%ak je v percentách
    rl = TD(:,srl);
elseif unit==2%ak je to relatívny pomer
    rl = TD(:,srl)*100;
end
%ošetrenie aby neboli dva body s rovnakou teplotodu:
[T,xi]=sort(T);%potriedenie vzostupne
rl = rl(xi);%potriedenie relatívneho prdåženia podla potriedenej teploty
eq = diff(T)==0;%najdenie rovnakých hodnôt
T(eq)=[];%vymazanie jednej z rovnakých hodnôt
rl(eq)=[];
%zápis do premennej:
set(hObject,'UserData',[T rl])
end

% tlacidlo nahrat TG
function pushbutton40_Callback(hObject, eventdata, handles)
im = uiimport('-file');
fn = fieldnames(im);
TG=getfield(im,fn{1});
[sT,stg,unit]=columSelect(TG,'TG',handles);
T = TG(:,sT);
if unit==1%ak je v percentách
    tg = TG(:,stg);
elseif unit==2%ak je to relatívny pomer
    tg = TG(:,stg)*100;
end
%ošetrenie aby neboli dva body s rovnakou teplotodu:
[T,xi]=sort(T);%potriedenie vzostupne
tg = tg(xi);%potriedenie relatívneho prdåženia podla potriedenej teploty
eq = diff(T)==0;%najdenie rovnakých hodnôt
T(eq)=[];%vymazanie jednej z rovnakých hodnôt
tg(eq)=[];
%zápis do premennej:
set(hObject,'UserData',[T tg])
end


% function edit70_Callback(hObject, eventdata, handles)
% % hObject    handle to edit70 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of edit70 as text
% %        str2double(get(hObject,'String')) returns contents of edit70 as a double
% end
% 
% % --- Executes during object creation, after setting all properties.
% function edit70_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit70 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% end

function edit71_Callback(hObject, eventdata, handles)
% hObject    handle to edit71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit71 as text
%        str2double(get(hObject,'String')) returns contents of edit71 as a double
end


% --- Executes during object creation, after setting all properties.
function edit71_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit72_Callback(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit72 as text
%        str2double(get(hObject,'String')) returns contents of edit72 as a double
end

% --- Executes during object creation, after setting all properties.
function edit72_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
end

% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12
end

% Finish
function pushbutton38_Callback(hObject, eventdata, handles)
sendCommand(s,'REGSTOP:',[]);
stop(timerfindall)%zastavenie timeru
delete(timerfindall)%vypnutie timeru
udata = get(handles.uipanel21,'UserData');

if ~isempty(daqfind)
    putsample(udata{6},0)%nastevenie vystupu na nulu
    delete(daqfind)%vymazanie komunika?neho kanlu s kartou (input aj output)
end

%zapísanie do súboru:

nazovSuboru = [datum '.txt'];
SampleName = get(handles.edit71,'String');
SampleMass = get(handles.edit69,'String');
SampleLength = get(handles.edit67,'String');
SampleDiameter = get(handles.edit68,'String');
SampleNotes = get(handles.edit72,'String');

if fopen([cesta nazovSuboru])==-1%ak este s dnesnym datumom neexistuje
    ex = fopen([cesta nazovSuboru],'w');
    fprintf(ex,'####################################\r\n');
    fprintf(ex,['#Date: ' datum '\r\n']);
    fprintf(ex,['#Sample: ' SampleName '\r\n']);
    fprintf(ex,['#Mass: ' SampleMass ' g' '\r\n']);
    fprintf(ex,['#Length: ' SampleLength ' mm' '\r\n']);
    fprintf(ex,['#Diameter: ' SampleDiameter ' mm' '\r\n']);
    fprintf(ex,['#Notes: ' SampleNotes '\r\n']);
    fprintf(ex,'#Time[s] Temperature[°C] Res.Freq.[Hz] Log.Dek[-]\r\n');
    fprintf(ex,'####################################\r\n');
    fprintf(ex,'%.8d; %.8d; %.8d; %.8d\r\n',[(udata{2})' (udata{3})' (udata{4}') (udata{5})']');
    fclose(ex);
else
    nazovSuboru = [datum 'a.txt'];
    ex = fopen([cesta nazovSuboru],'w');
    fprintf(ex,'####################################\r\n');
    fprintf(ex,['#Date: ' datum '\r\n']);
    fprintf(ex,['#Sample: ' SampleName '\r\n']);
    fprintf(ex,['#Mass: ' SampleMass ' g' '\r\n']);
    fprintf(ex,['#Length: ' SampleLength ' mm' '\r\n']);
    fprintf(ex,['#Diameter: ' SampleDiameter ' mm' '\r\n']);
    fprintf(ex,['#Notes: ' SampleNotes '\r\n']);
    fprintf(ex,['#Time[s] Temperature[°C] Res.Freq.[Hz] Log.Dek[-]' '\r\n']);
    fprintf(ex,'####################################\r\n');
    fprintf(ex,'%.8d; %.8d; %.8d; %.8d\r\n',[(udata{2})' (udata{3})' (udata{4}') (udata{5})']');
    fclose(ex);
end
%--------------------------------------------------------------------------
%ulozenie figur:
h=figure;
    [ax, h1, h2]=plotyy(udata{3},udata{4},udata{3},udata{5});
    set(h1,'Marker','.','LineStyle','none')
    set(h2,'Marker','.','LineStyle','none')
    xlabel(ax(1),'Teplota [°C]')
    ylabel(ax(1),'Rez. Frek [Hz]')
    ylabel(ax(2),'Log. dek [-]')
    xLim = get(ax(1),'XLim');
    yLim = get(ax(1),'YLim');
    text((xLim(2)-xLim(1))/2+xLim(1),(yLim(2)-yLim(1))/2+yLim(1),{['Sample: ' SampleName];...
        ['Date: ' datum];...    
        ['Mass: ' SampleMass ' g'];...
        ['Length: ' SampleLength ' mm'];...
        ['Diameter: ' SampleDiameter ' mm'];...
        ['Notes: ' SampleNotes]});
if fopen([cesta datum '-xteplota.fig'])==-1%ak este s dnesnym datumom neexistuje
    saveas(h,[cesta datum '-xteplota'],'fig')
else
    saveas(h,[cesta datum '-xteplota-a'],'fig')
end
delete(h)
h = figure;
    [ax, h1, h2]=plotyy(udata{2}/60,udata{4},udata{2}/60,udata{5});
    set(h1,'Marker','.','LineStyle','none')
    set(h2,'Marker','.','LineStyle','none')
    xlabel(ax(1),'Cas [min]')
    ylabel(ax(1),'Rez. Frek [Hz]')
    ylabel(ax(2),'Log. dek [-]')
        xLim = get(ax(1),'XLim');
    yLim = get(ax(1),'YLim');
    text((xLim(2)-xLim(1))/2+xLim(1),(yLim(2)-yLim(1))/2+yLim(1),{['Sample: ' SampleName];...
        ['Date: ' datum];... 
        ['Mass: ' SampleMass ' g'];...
        ['Length: ' SampleLength ' mm'];...
        ['Diameter: ' SampleDiameter ' mm'];...
        ['Notes: ' SampleNotes]});
if fopen([cesta datum '-xcas.fig'])==-1%ak este s dnesnym datumom neexistuje
    saveas(h,[cesta datum '-xcas'],'fig')
else
    saveas(h,[cesta datum '-xcas-a'],'fig')
end
delete(h)
%--------------------------------------------------------------------------
%ulozenie spektier---------------------------------------------------------
% udata = get(handles.checkbox2,'UserData');
% if ~isempty(udata)
%     spe = udata{1};
%     fre = udata{2};
%     save('spektra','spe');%uloženei amplitúd
%     save('freqaxes','fre');%uleženie príslušných frekvencií
% end
%--------------------------------------------------------------------------
set(handles.pushbutton38,'Enable','off')
set(handles.pushbutton35,'Enable','on')

%ukon?enie analogoveho vstupu
udata=get(handles.uipanel21,'UserData');
AI=udata{7};%analogovy vstup (visa objekt)
fclose(AI)
delete(AI)

display('Finish')
display(['Subor ulozeny v: ' cesta nazovSuboru])
delete(instrfind);
% delete(timerfind);
fclose('all');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles) %okno pri zatvarani programu
% potvrdzovacie okno
choice = questdlg('Naozaj chces zavriet aplikaciu?', ...
	'Zatvorit aplikaciu', ...
	'Ano','Nie','Nie');
% udalost pre moznosti
switch choice
    case 'Ano'
        delete(hObject);
    case 'Nie'
end
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
end

function chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck)
global rStat oStat gStat
if (nameCheck==1 && shapeCheck==1) && (YCheck==1 || YCheck==2)
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(gStat);
    set(handles.axes2,'UserData',1);
elseif (nameCheck==0 || shapeCheck==0) && YCheck==2
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(oStat);
    set(handles.axes2,'UserData',2);
else
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(rStat);
    set(handles.axes2,'UserData',3);
end
end

% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
global s timerR
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SData=get(handles.pushbutton41,'UserData');
nameCheck=0; shapeCheck=0; YCheck=0;
if isempty(timerR) || ~isvalid(timerR)
    SData=OpenBox(s,SData);
else
    stop(timerR);
    SData=OpenBox(s,SData);
    start(timerR);
end
set(handles.pushbutton41,'UserData',SData);
if ~isempty(SData.SampleName)
    nameCheck=1;
end
if SData.shape=='c'
    if ~isempty(SData.SampleName) && SData.fr>0 && SData.m>0 && SData.l>0 && SData.d>0
        shapeCheck=1;
    end
else
    if ~isempty(SData.SampleName) && SData.fr>0 && SData.m>0 && SData.l>0 && SData.a>0 && SData.b>0
        shapeCheck=1;
    end
end
if SData.Y==1
    if isempty(SData.DIL) && isempty(SData.TG)
        YCheck=0;
        chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
        set(handles.pushbutton35,'Enable','off');
        f = msgbox('Missing DIL and TG data', 'Error','warn');
    elseif isempty(SData.DIL)
        YCheck=0;
        chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
        set(handles.pushbutton35,'Enable','off');
        f = msgbox('Missing DIL data', 'Error','warn');
    elseif isempty(SData.TG)
        YCheck=0;
        chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
        set(handles.pushbutton35,'Enable','off');
        f = msgbox('Missing TG data', 'Error','warn');
    else     
        YCheck=1;
        if ~isempty(s)
            set(handles.pushbutton35,'Enable','on');
        end
        chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);

    end
else
    YCheck=2;
    chechConfiguration(hObject, eventdata, handles, nameCheck, shapeCheck, YCheck);
end
end



function edit73_Callback(hObject, eventdata, handles)
% hObject    handle to edit73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit73 as text
%        str2double(get(hObject,'String')) returns contents of edit73 as a double
end

% --- Executes during object creation, after setting all properties.
function edit73_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit74_Callback(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit74 as text
%        str2double(get(hObject,'String')) returns contents of edit74 as a double

end
% --- Executes during object creation, after setting all properties.
function edit74_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit75_Callback(hObject, eventdata, handles)
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit75 as text
%        str2double(get(hObject,'String')) returns contents of edit75 as a double

end
% --- Executes during object creation, after setting all properties.
function edit75_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit76_Callback(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit76 as text
%        str2double(get(hObject,'String')) returns contents of edit76 as a double

end
% --- Executes during object creation, after setting all properties.
function edit76_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit77_Callback(hObject, eventdata, handles)
% hObject    handle to edit77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit77 as text
%        str2double(get(hObject,'String')) returns contents of edit77 as a double

end

% --- Executes during object creation, after setting all properties.
function edit77_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit78_Callback(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit78 as text
%        str2double(get(hObject,'String')) returns contents of edit78 as a double

end

% --- Executes during object creation, after setting all properties.
function edit78_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function currentTemperature(hob, evdat, hObject, eventdata, handles)
    global s rStat oStat gStat
%     handles = guidata(hObject);
    temperature=sendCommand(s,'AT:',[]);
% temperature=22;
    if isempty(temperature)
        set(handles.text94,'String','error');
        set(handles.axes7,'Units','pixels');
%         axes(handles.axes7);
        imshow(oStat, 'Parent', handles.axes7);
    else
        temperature=[temperature ' °C'];
%         temperature='20 °C';
        set(handles.text94,'String',temperature);
        set(handles.axes7,'Units','pixels');
%         axes(handles.axes7);
        imshow(gStat,'Parent', handles.axes7);
    end
end

function currentTemperatureError(hob, evdat, hObject, eventdata, handles)
    global s rStat oStat gStat
    handles = guidata(hObject);
    temperature=sendCommand(s,'AT:',[]);
    if isempty(temperature)
        set(handles.text94,'String','error');
        set(handles.axes7,'Units','pixels');
        axes(handles.axes7);
        imshow(oStat);
    else
        temperature=[temperature ' °C'];
        set(handles.text94,'String',temperature);
        set(handles.axes7,'Units','pixels');
        axes(handles.axes7);
        imshow(gStat);
    end
end

% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
global s rStat oStat gStat timerR
% sendTemperatureProgram(s,SData);

% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% baudRate = str2num(get(handles.edit78,'String'));
if isequal(get(handles.pushbutton42,'String'),'Connect')
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
    end
    port = get(handles.edit77,'String');
    s = serial(port);
    set(s,'DataBits',8);
    set(s,'StopBits',1);
    set(s,'BaudRate',9600);
    set(s,'Parity','even');
%     set(s,'RequestToSend','on');
    s.Timeout = 5;
    fopen(s);
    set(handles.pushbutton42,'String','Disconnect');
    set(handles.pushbutton43,'Enable','on');
    set(handles.pushbutton35,'Enable','on');
    set(handles.axes7,'Units','pixels');
    axes(handles.axes7);
    imshow(oStat);
    timerR = timer('Period', 0.5,'ExecutionMode','fixedSpacing');
    set(timerR, 'TimerFcn', ({@currentTemperature, hObject, eventdata, handles}));
%     set(handles.timerR,'TimerFcn', @(hObject, eventdata) currentTemperature(eventdata, handles));
%     set(handles.timerR,'ErrorFcn', @(hObject, eventdata) currentTemperatureError(eventdata, handles));
%     timerR.ErrorFcn = {@currentTemperatureError};%?o sa ma sta? pri chybe
    start(timerR)
elseif isequal(get(handles.pushbutton42,'String'),'Disconnect')
%     stop(handles.timerR);
%     delete(handles.timerR);
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
    end
    set(handles.pushbutton42,'String','Connect');
    set(handles.pushbutton43,'Enable','off');
    set(handles.pushbutton35,'Enable','off');
    set(handles.axes7,'Units','pixels');
    axes(handles.axes7);
    imshow(rStat);
    set(handles.text94,'String','');
end
end

% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13
end


% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
global s timerR
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RData=get(handles.pushbutton43,'UserData');
    stop(timerR);
    RData=RegConfig(s,RData);
    start(timerR);
    set(handles.pushbutton43,'UserData',RData);
end
