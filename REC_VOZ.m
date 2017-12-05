function varargout = REC_VOZ_METIV(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @REC_VOZ_METIV_OpeningFcn, ...
                   'gui_OutputFcn',  @REC_VOZ_METIV_OutputFcn, ...
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

function REC_VOZ_METIV_OpeningFcn(hObject, eventdata, handles, varargin)

axes(handles.axes4);
path = 'logo_fcm_unmsm.jpg';
img = imread(path);
imshow(img);
axis off;
handles.output = hObject;
guidata(hObject, handles);

function varargout = REC_VOZ_METIV_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function BotonSalir_Callback(hObject, eventdata, handles)
exit; 


function BotonGrabar_Callback(hObject, eventdata, handles)
clc 
% clear all
global y fs; %Estabelecer variaveis globais 
fs=11025; %frequencia
tempograve=1.5; %Tempo de gravacão
y=wavrecord(tempograve*fs,fs,1); %função de gravação
soundsc(y,fs); %reproduzir gravação
ts=1/fs;
t=0:ts:tempograve-ts;
b=[1 -0.95];
yf=filter(b,1,y); %filtro
len = length(y); %longitude
avg_e = sum(y.*y)/len; 
THRES = 0.2;
soundsc(y,fs) %reproduz sinal filtrado
wavwrite(yf,fs,'voz'); %grava arquivo .wav
%---- 
set(handles.axes1); 
axes(handles.axes1);
plot(t,yf);grid on;
%----

handles.y=y;
msgbox('Gravação concluida');
guidata(hObject, handles);

function BotonReproducir_Callback(hObject, eventdata, handles)
[y,fs]=wavread('voz'); %leitura do arquivo gravado
soundsc(y,fs); %reprodução do arquivo gravado

%----- 
function somN=normalizar(som)
maximo=max(abs(som));
n=length(som); %Calcula o tamanho do vetor
somN=zeros(1,n);
for i=1:1:n
somN(i)=som(i)/maximo;
end

function [nome, transf_usuario, transff_bd, min_error] = LeerDirectorio()

voz_usuario=wavread('voz');
norm_usuario=normalizar(voz_usuario);
transf_usuario=abs((fft(norm_usuario))); %transformada rapida de Fourier
min_error=100000;
transff_bd=1;
nome=' ';

lee_audios = dir([pwd '\BD\' '*.wav']); 
for k = 1:length(lee_audios)
    audio_nom = lee_audios(k).name; %obtem o nome dos audios
    
    if ~strcmp(audio_nom,'voz.wav')
        voz_bd = wavread([pwd '\BD\' audio_nom]);
        norm_voz_bd=normalizar(voz_bd);
        transf_voz_bd=abs((fft(norm_voz_bd)));

        actual_error=mean(abs(transf_voz_bd - transf_usuario));
        if actual_error < min_error  
            min_error=actual_error
            nome=audio_nom
            transff_bd=transf_voz_bd;
        end         
    end    
   
end
audio_nom

function BotaoTransformar_Callback(hObject, eventdata, handles)
y=handles.y;
fs=11025;
N=length(y); %calcula o tamanho do vetor 
f=(0:N-1)*fs/N;
[nome, transf_usuario, transff_bd, band]=LeerDirectorio;
if band < 10
    set(handles.axes2); 
    axes(handles.axes2); 
    plot(f(1:N/2),transff_bd(1:N/2));grid on;
    set (handles.text1, 'string', upper(nome(1:end-4)));
    set(handles.axes3);
    axes(handles.axes3); 
    plot(f(1:N/2),transf_usuario(1:N/2));grid on; 
else
    set (handles.text1, 'string', ' ');
    msgbox('Advertencia, voce nao esta autorizado');
end


% --- 
function rbt1_Callback(hObject, eventdata, handles)
function rbt2_Callback(hObject, eventdata, handles)
function grabar_Callback(hObject, eventdata, handles)
function uipanel15_SelectionChangeFcn(hObject, eventdata, handles)


% --- 
function agregar_voz_Callback(hObject, eventdata, handles)

fs=11025; 
tempograve=1.5; %tempo de gravação
leer=get(handles.leer1,'String');
y=wavrecord(tempograve*fs,fs,1); %função de gravação
soundsc(y,fs);
b=[1 -0.95];
yf=filter(b,1,y);

wavwrite(yf,fs,strcat('/BD/',leer));
 
msgbox('éxito');
guidata(hObject, handles);



function leer1_Callback(hObject, eventdata, handles)

function leer1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
