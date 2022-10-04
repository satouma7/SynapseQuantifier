function varargout = eval_synapse_GUI(varargin)
% eval_synapse_GUI MATLAB code for eval_synapse_GUI.fig
%      eval_synapse_GUI, by itself, creates a new eval_synapse_GUI or raises the existing
%      singleton*.
%
%      H = eval_synapse_GUI returns the handle to a new eval_synapse_GUI or the handle to
%      the existing singleton*.
%
%      eval_synapse_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in eval_synapse_GUI.M with the given input arguments.
%
%      eval_synapse_GUI('Property','Value',...) creates a new eval_synapse_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eval_synapse_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eval_synapse_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eval_synapse_GUI

% Last Modified by GUIDE v2.5 17-Aug-2022 15:46:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eval_synapse_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @eval_synapse_GUI_OutputFcn, ...
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


% --- Executes just before eval_synapse_GUI is made visible.
function eval_synapse_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eval_synapse_GUI (see VARARGIN)
global imgori imgcrop preW preH Mark 

filelist = ls(fullfile('nnSynapse','*.mat'));
set(handles.cpselect,'String',filelist);

filelist = ls(fullfile('LSMdata','*.???'));%oirとnd2の両対応にしたい
set(handles.lsmselect,'String',filelist);

contens = cellstr(get(handles.cpselect,'String'));
cpPath = fullfile('nnSynapse',contens{get(handles.cpselect,'Value')});
handles.cppath = cpPath;

contents = cellstr(get(handles.lsmselect,'String'));
imgPath = fullfile('LSMdata',contents{get(handles.lsmselect,'Value')});
handles.imgpath = imgPath;

handles.ori=bfopen(handles.imgpath);
info=handles.ori{1}{1,2};
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Cmax=str2num(extractAfter(extractAfter(info,"C="),"/"));
if isempty(extractAfter(info,"C="))
    Cmax=1;
    Zmax=str2num(extractAfter(extractAfter(info,"Z="),"/"));
else
    Zmax=str2num(extractAfter(extractBefore(extractAfter(info,"Z="),";"),"/"));
end
if isempty(extractAfter(info,"Z="))
    Zmax=1;
end

Zmid=round(Zmax/2);
Zstart=Zmid-2;Zend=Zmid+2;
if Zstart<1
    Zstart=1;
end
if Zend>Zmax
    Zend=Zmax;
end

XYradius=30;Zradius=2;Ywgt=0.5;C=1;
handles.rot=0;
XYrad_max=100;XYrad_min=10;
Zrad_max=6;Zrad_min=1;
Ywgt_max=1;Ywgt_min=0.2;

set(handles.Zslider,'Value',Zmid);
set(handles.Zslider,'Min',1);
set(handles.Zslider,'Max',Zmax);
set(handles.Zslider,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.minlabel,'String',1);
set(handles.maxlabel,'String',Zmax);
set(handles.Zedit,'Value',Zmid);
set(handles.Zedit,'String',Zmid);

set(handles.Zstart,'Value',Zstart);
set(handles.Zstart,'Min',1);
set(handles.Zstart,'Max',Zmax);
set(handles.Zstart,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.Zstartvalue,'Value',Zstart);
set(handles.Zstartvalue,'String',Zstart);

set(handles.Zend,'Value',Zend);
set(handles.Zend,'Min',1);
set(handles.Zend,'Max',Zmax);
set(handles.Zend,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.Zendvalue,'Value',Zend);
set(handles.Zendvalue,'String',Zend);

set(handles.XYrad_slider,'Value',XYradius);
set(handles.XYrad_slider,'Min',XYrad_min);
set(handles.XYrad_slider,'Max',XYrad_max);
set(handles.XYrad_slider,'SliderStep',[1/(XYrad_max-XYrad_min) 5/(XYrad_max-XYrad_min)]);
set(handles.XYrad_value,'String',XYradius);

set(handles.Zrad_slider,'Value',Zradius);
set(handles.Zrad_slider,'Min',1);
set(handles.Zrad_slider,'Max',6);
set(handles.Zrad_slider,'SliderStep',[1/(Zrad_max-Zrad_min) 5/(Zrad_max-Zrad_min)]);
set(handles.Zrad_value,'String',Zradius);

set(handles.Ywgt_slider,'Value',Ywgt);
set(handles.Ywgt_slider,'Min',Ywgt_min);
set(handles.Ywgt_slider,'Max',Ywgt_max);
set(handles.Ywgt_slider,'SliderStep',[0.01/(Ywgt_max-Ywgt_min) 0.1/(Ywgt_max-Ywgt_min)]);
set(handles.Ywgt_value,'String',Ywgt);


set(handles.rotationslider,'Value',0);
set(handles.rotationvalue,'String',0);

set(handles.cslider,'Value',C);
set(handles.cslider,'Min',1);
set(handles.cslider,'Max',Cmax);
if Cmax==1
    set(handles.cslider,'SliderStep',[0 0]);
else
    set(handles.cslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
end
set(handles.cvalue,'Value',C);
set(handles.cvalue,'String',C);

set(handles.Lslider,'Value',2);%stride
set(handles.Lslider,'Min',1);
set(handles.Lslider,'Max',5);
set(handles.Lslider,'SliderStep',[0.25 0.25]);
set(handles.Lvalue,'Value',2);
set(handles.Lvalue,'String',2);

set(handles.Oslider,'Value',0.6);%Overlap threthold
set(handles.Ovalue,'Value',0.6);
set(handles.Ovalue,'String',0.6);

set(handles.Dslider,'Value',0.9);%Detection threthold
set(handles.Dvalue,'Value',0.9);
set(handles.Dvalue,'String',0.9);

Poly=6;
set(handles.Vertex_slider,'Value',Poly);
set(handles.Vertex_value,'String',Poly);
X=zeros(1,Poly);Y=zeros(1,Poly);R=200;
for I=1:Poly
    theta=(I-1)*2*pi/Poly;
    X(I)=round(R*cos(theta)+Xmax/2);
    Y(I)=round(R*sin(theta)+Ymax/2);
end

V1=min(X);V2=min(X);W1=min(Y);W2=min(Y);
width=max(X)-min(X);height=max(Y)-min(Y);
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%

set(handles.Xslider1,'Value',V1);set(handles.Xslider1,'Max',Xmax);set(handles.Xslider1,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Xslider2,'Value',V2);set(handles.Xslider2,'Max',Xmax);set(handles.Xslider2,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Yslider1,'Value',W1);set(handles.Yslider1,'Max',Ymax);set(handles.Yslider1,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.Yslider2,'Value',W2);set(handles.Yslider2,'Max',Ymax);set(handles.Yslider2,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.X1value,'String',V1);
set(handles.X2value,'String',V2);
set(handles.Y1value,'String',W1);
set(handles.Y2value,'String',W2);

Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Blim=BlimExt(handles.ori{1},Brightness,Zstart,Zend,C,Cmax);
% imgori = handles.ori{1}{C,1};
% imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
% hightM=size(imgcropZ,1);
% widthM=size(imgcropZ,2);
% for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
%     I=(Z-1)*Cmax+C;
%     imgori = handles.ori{1}{I,1};
%     imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
%     imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
% end
% Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zmid-1)*Cmax+C;
handles.img=handles.ori{1}{I,1};
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop, Xcrop]=size(imgcrop);
preW=240;preH=240;
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Z)]);

axes(handles.axes8);imshow(imread('syn001_10a.tif'));
axes(handles.axes9);imshow(imread('syn002_10a.tif'));
axes(handles.axes10);imshow(imread('syn003_10a.tif'));
axes(handles.axes11);imshow(imread('syn004_10a.tif'));
axes(handles.result3d);cla(gca);

Mark={'o', 's', 'd', '^', 'v', '>', '<', 'p', 'h', 'x'};

set(handles.Gnum1,'String','');
set(handles.Gnum2,'String','');
set(handles.Snum,'String','');

set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');
set(handles.rotation,'Enable','off');
set(handles.rotationslider,'Enable','off');
set(handles.Snum,'Enable','off');
set(handles.remove,'Enable','off');
set(handles.remove2,'Enable','off');
set(handles.Gnum1,'Enable','off');
set(handles.Gnum2,'Enable','off');
set(handles.regroup,'Enable','off');
set(handles.degroup,'Enable','off');
% Choose default command line output for eval_synapse_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eval_synapse_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eval_synapse_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lsmselect.
function lsmselect_Callback(hObject, eventdata, handles)
% hObject    handle to lsmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y Poly Blim
contents = cellstr(get(hObject,'String'));
imgPath = fullfile('LSMdata',contents{get(hObject,'Value')});
handles.imgpath = imgPath;
handles.ori=bfopen(handles.imgpath);
info=handles.ori{1}{1,2};
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Cmax=str2num(extractAfter(extractAfter(info,"C="),"/"));
if isempty(extractAfter(info,"C="))
    Cmax=1;
    Zmax=str2num(extractAfter(extractAfter(info,"Z="),"/"));
else
    Zmax=str2num(extractAfter(extractBefore(extractAfter(info,"Z="),";"),"/"));
end
if isempty(extractAfter(info,"Z="))
    Zmax=1;
end

Zmid=round(Zmax/2);
Zstart=Zmid-2;Zend=Zmid+2;
if Zstart<1
    Zstart=1;
end
if Zend>Zmax
    Zend=Zmax;
end

C=1;rot=0;
set(handles.Zslider,'Value',Zmid);
set(handles.Zedit,'Value',Zmid);
set(handles.Zedit,'String',Zmid);
set(handles.Zslider,'Min',1);
set(handles.Zslider,'Max',Zmax)
set(handles.minlabel,'String',1);
set(handles.maxlabel,'String',Zmax);
set(handles.Zslider,'SliderStep',[1/(Zmax-1) 5/(Zmax-1)]);
set(handles.cslider,'Value',C);
set(handles.cslider,'Min',1);
set(handles.cslider,'Max',Cmax);
if Cmax==1
    set(handles.cslider,'SliderStep',[0 0]);
else
    set(handles.cslider,'SliderStep',[1/(Cmax-1) 1/(Cmax-1)]);
end
set(handles.cvalue,'Value',C);
set(handles.cvalue,'String',C);

X=zeros(1,Poly);Y=zeros(1,Poly);
for I=1:Poly
    theta=(I-1)*2*pi/Poly;
    X(I)=round(100*cos(theta)+Xmax/2);
    Y(I)=round(100*sin(theta)+Ymax/2);
end
V1=min(X);V2=min(X);W1=min(Y);W2=min(Y);
width=max(X)-min(X);height=max(Y)-min(Y);

set(handles.Xslider1,'Value',V1);set(handles.Xslider1,'Max',Xmax);set(handles.Xslider1,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Xslider2,'Value',V2);set(handles.Xslider2,'Max',Xmax);set(handles.Xslider2,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Yslider1,'Value',W1);set(handles.Yslider1,'Max',Ymax);set(handles.Yslider1,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.Yslider2,'Value',W2);set(handles.Yslider2,'Max',Ymax);set(handles.Yslider2,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.X1value,'String',V1);
set(handles.X2value,'String',V2);
set(handles.Y1value,'String',W1);
set(handles.Y2value,'String',W2);

set(handles.rotationslider,'Value',0);
set(handles.rotationvalue,'String',0);

Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');
I=(Zmid-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};

imgcrop=imresize(handles.img(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
Blim=stretchlim(imgcrop,[Bthreshold/200 1-Bthreshold/200]);  %%
imgori=imadjust(handles.img,Blim);
axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X,Ymax-Y+1,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Zmid)]);

set(handles.Gnum1,'String','');
set(handles.Gnum2,'String','');
set(handles.Snum,'String','');

set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');
set(handles.rotation,'Enable','off');
set(handles.rotationslider,'Enable','off');
set(handles.Snum,'Enable','off');
set(handles.remove,'Enable','off');
set(handles.remove2,'Enable','off');
set(handles.Gnum1,'Enable','off');
set(handles.Gnum2,'Enable','off');
set(handles.regroup,'Enable','off');
set(handles.degroup,'Enable','off');
guidata(hObject,handles);


% Hints: contents = cellstr(get(hObject,'String')) returns lsmselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lsmselect


% --- Executes during object creation, after setting all properties.
function lsmselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsmselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in cpselect.
function cpselect_Callback(hObject, eventdata, handles)
% hObject    handle to cpselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contens = cellstr(get(hObject,'String'));
cpPath = fullfile('nnSynapse',contens{get(hObject,'Value')});
handles.cppath = cpPath;

guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns cpselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpselect


% --- Executes during object creation, after setting all properties.
function cpselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Zslider_Callback(hObject, eventdata, handles)
% hObject    handle to Zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zmid = round(get(handles.Zslider,'Value'));
set(handles.Zslider,'Value',Zmid);set(handles.Zedit,'String',num2str(Zmid));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');

C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zmid-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Z)]);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Zslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ZsectionJump.
function ZsectionJump_Callback(hObject, eventdata, handles)
% hObject    handle to ZsectionJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zmid=get(handles.Zslider,'Value');
set(handles.Zslider,'Value',Zmid);set(handles.Zedit,'String',num2str(Zmid));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

I=(Zmid-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Zmid)]);

function Zedit_Callback(hObject, eventdata, handles)
% hObject    handle to Zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori preW preH rot X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zmid = round(str2num(get(handles.Zedit,'String')));
set(handles.Zslider,'Value',Zmid);set(handles.Zedit,'String',num2str(Zmid));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zmid-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Zmid)]);


% Hints: get(hObject,'String') returns contents of Zedit as text
%        str2double(get(hObject,'String')) returns contents of Zedit as a double

% --- Executes during object creation, after setting all properties.
function Zedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Zstart_Callback(hObject, eventdata, handles)
% hObject    handle to Zstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH rot X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zstart = round(get(hObject,'Value'));Zend=get(handles.Zend,'Value');
if Zstart>Zend
    Zstart=Zend;
end
set(handles.Zstart,'Value',Zstart);
set(handles.Zstartvalue,'String',num2str(Zstart));
Zmid = round(get(handles.Zslider,'Value'));
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zstart-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z start image=',num2str(Zstart)]);

% --- Executes during object creation, after setting all properties.
function Zstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ZstartJump.
function ZstartJump_Callback(hObject, eventdata, handles)
% hObject    handle to ZstartJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global preW preH rot X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zstart=get(handles.Zstart,'Value');
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
dX=V2-V1;dY=W2-W1;

Cmax=handles.cslider.Max;
I=(Zstart-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);
guidata(hObject,handles);

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z start image=',num2str(Zstart)]);

% --- Executes on slider movement.
function Zend_Callback(hObject, eventdata, handles)
% hObject    handle to Zend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH rot X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zend = round(get(hObject,'Value'));Zstart=get(handles.Zstart,'Value');
if Zstart>Zend
    Zend=Zstart;
end
set(handles.Zend,'Value',Zend);
set(handles.Zendvalue,'String',num2str(Zend));
Zmid = round(get(handles.Zslider,'Value'));
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zend-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z end image=',num2str(Zend)]);


% --- Executes during object creation, after setting all properties.
function Zend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ZendJump.
function ZendJump_Callback(hObject, eventdata, handles)
% hObject    handle to ZendJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global preW preH rot X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
dX=V2-V1;dY=W2-W1;

Cmax=handles.cslider.Max;
I=(Zend-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);
guidata(hObject,handles);

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Z end image=',num2str(Zend)]);

% --- Executes on slider movement.
function Xslider1_Callback(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y Blim rot
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=round(get(handles.Xslider1,'Value'));W1=round(get(handles.Yslider1,'Value'));
V2=round(get(handles.Xslider2,'Value'));W2=round(get(handles.Yslider2,'Value'));
if V1<1
    V1=1;
end
if V1+width>Xmax
    V1=Xmax-width;
end
set(handles.Xslider1,'Value',V1);set(handles.X1value,'String',V1);
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
X=X-min(X)+V1;
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

% I=(Zstart-1)*Cmax+C;
% handles.img = handles.ori{1}{I,1};
% if rot~=0
%     handles.img=rot90(handles.img,rot);
% end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);

hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop, Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Xslider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Xslider2_Callback(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y Blim rot
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=round(get(handles.Xslider1,'Value'));W1=round(get(handles.Yslider1,'Value'));
V2=round(get(handles.Xslider2,'Value'));W2=round(get(handles.Yslider2,'Value'));
if V2<1
    V2=1;
end
if V2+width>Xmax
    V2=Xmax-width;
end
set(handles.Xslider2,'Value',V2);set(handles.X2value,'String',V2);
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

% I=(Zstart-1)*Cmax+C;
% handles.img = handles.ori{1}{I,1};
% if rot~=0
%     handles.img=rot90(handles.img,rot);
% end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop, Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Xslider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Yslider1_Callback(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y Blim rot
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=round(get(handles.Xslider1,'Value'));W1=round(get(handles.Yslider1,'Value'));
V2=round(get(handles.Xslider2,'Value'));W2=round(get(handles.Yslider2,'Value'));
if W1<1
    W1=1;
end
if W1+height>Ymax
    W1=Ymax-height;
end
set(handles.Yslider1,'Value',W1);set(handles.Y1value,'String',W1);
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
Y=Y-min(Y)+W1;
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

% I=(Zstart-1)*Cmax+C;
% handles.img = handles.ori{1}{I,1};
% if rot~=0
%     handles.img=rot90(handles.img,rot);
% end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop, Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Yslider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Yslider2_Callback(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y Blim rot
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
width=max(X)-min(X);height=max(Y)-min(Y);
V1=round(get(handles.Xslider1,'Value'));W1=round(get(handles.Yslider1,'Value'));
V2=round(get(handles.Xslider2,'Value'));W2=round(get(handles.Yslider2,'Value'));
if W2<1
    W2=1;
end
if W2+width>Ymax
    W2=Ymax-width;
end
set(handles.Yslider2,'Value',W2);set(handles.Y2value,'String',W2);
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

% I=(Zend-1)*Cmax+C;
% handles.img = handles.ori{1}{I,1};
% if rot~=0
%     handles.img=rot90(handles.img,rot);
% end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop, Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

% --- Executes during object creation, after setting all properties.
function Yslider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in rotbutton.
function rotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to rotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rot preW preH X Y Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
handles.img = rot90(handles.img);
rot=rot+1;
if rot>3
    rot=0;
end
Xtemp=-Y+Xmax;Y=X;X=Xtemp;
width=max(X)-min(X);height=max(Y)-min(Y);
dV=V2-V1;dW=W2-W1;
V1=min(X);W1=min(Y);
Vtemp=-dW;dW=dV;dV=Vtemp;
V2=V1+dV;W2=W1+dW;

set(handles.Xslider1,'Value',V1);set(handles.Xslider1,'Max',Xmax);set(handles.Xslider1,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Xslider2,'Value',V2);set(handles.Xslider2,'Max',Xmax);set(handles.Xslider2,'SliderStep',[1/(Xmax-1) 10/(Xmax-1)]);
set(handles.Yslider1,'Value',W1);set(handles.Yslider1,'Max',Ymax);set(handles.Yslider1,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.Yslider2,'Value',W2);set(handles.Yslider2,'Max',Ymax);set(handles.Yslider2,'SliderStep',[1/(Ymax-1) 10/(Ymax-1)]);
set(handles.X1value,'String',V1);
set(handles.X2value,'String',V2);
set(handles.Y1value,'String',W1);
set(handles.Y2value,'String',W2);

dX=V2-V1;dY=W2-W1;
imgori=imadjust(handles.img,Blim);
axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

Mag=get(handles.Mslider,'Value');
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);

guidata(hObject,handles);


% --- Executes on slider movement.
function Dslider_Callback(hObject, eventdata, handles)
% hObject    handle to Dslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Dthreshold=round(get(hObject,'Value'),2);
set(handles.Dslider,'Value',Dthreshold);
set(handles.Dvalue,'String',Dthreshold);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Dslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Oslider_Callback(hObject, eventdata, handles)
% hObject    handle to Oslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Othreshold=round(get(hObject,'Value'),2);
set(handles.Oslider,'Value',Othreshold);
set(handles.Ovalue,'String',Othreshold);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Oslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Oslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function O2slider_Callback(hObject, eventdata, handles)
% hObject    handle to O2slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
O2threshold=round(get(hObject,'Value'),2);
set(handles.O2slider,'Value',O2threshold);
set(handles.O2value,'String',O2threshold);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function O2slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to O2slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Bslider_Callback(hObject, eventdata, handles)
% hObject    handle to Bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y Blim rot
Bthreshold=round(get(hObject,'Value'),2);
set(handles.Bslider,'Value',Bthreshold);
set(handles.Bvalue,'String',Bthreshold);

Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zmid = round(get(handles.Zslider,'Value'));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zmid-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data

axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

%imgcrop=imresize(imgori(Ymax+1-W1-height-ddY:Ymax+1-W1-ddY,V1+ddX:V1+width+ddX),Mag);
imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Zmid)]);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Bslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Mslider_Callback(hObject, eventdata, handles)
% hObject    handle to Mslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH X Y Blim rot
Mag=round(get(hObject,'Value'),2);
set(handles.Mslider,'Value',Mag);
set(handles.Mvalue,'String',Mag);
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
Zmid = round(get(handles.Zslider,'Value'));
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zmid-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Zmid)]);

% --- Executes during object creation, after setting all properties.
function Mslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Lslider_Callback(hObject, eventdata, handles)
% hObject    handle to Lslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
L=round(get(hObject,'Value'));
set(handles.Lslider,'Value',L);
set(handles.Lvalue,'String',L);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Lslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function cslider_Callback(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global preW preH rot X Y Blim rot
C=round(get(hObject,'Value'));Cmax=handles.cslider.Max;
set(handles.cslider,'Value',C);set(handles.cvalue,'String',C);
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zmid = round(get(handles.Zslider,'Value'));
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
dX=V2-V1;dY=W2-W1;

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

I=(Zmid-1)*Cmax+C;
handles.img = handles.ori{1}{I,1};
if rot~=0
    handles.img=rot90(handles.img,rot);
end
imgori=imadjust(handles.img,Blim);%imgori: brightness adjusted 2D data
guidata(hObject,handles);

axes(handles.main_img);%imshow(imgori);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
hold on;
patch(X+dX,Ymax-Y+1-dY,'g', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);
hold off;

imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
[Ycrop Xcrop]=size(imgcrop);
if Xcrop>preW
    V1=fix((Xcrop-preW)/2)+1;
    imgcrop=imgcrop(:,V1:V1+preW-1);
end
if Ycrop>preH
    W1=fix((Ycrop-preH)/2)+1;
    imgcrop=imgcrop(W1:W1+preH-1,:);
end
if Xcrop<preW
    imgcrop(:,Xcrop+1:preW)=0;
end
if Ycrop<preH
    imgcrop(Ycrop+1:preH,:)=0;
end
axes(handles.mag_img);imshow(imgcrop);
set(handles.Zsign,'String',['Current Z section image=',num2str(Zmid)]);

% --- Executes during object creation, after setting all properties.
function cslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)%Survey
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net imgori imgcropA total rot X Y hex height width Mark Blim
global list overlap count m n i j Flist Glist list1 list2 I Zstart Zend Final imgsA scoreA wn hn ID ddX ddY imgcropZ
disp('Survey start');
tic;
load(handles.cppath);
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Zstart=get(handles.Zstart,'Value');Zend=get(handles.Zend,'Value');
Zmid=round(get(handles.Zslider,'Value'));
C=round(get(handles.cslider,'Value'));Cmax=handles.cslider.Max;
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%

rotation=0;
set(handles.rotationslider,'Value',rotation);
set(handles.rotationvalue,'String',rotation);

ws = 12;
area = ws * ws;
cor = round(ws/2);
stride=get(handles.Lslider,'Value');
detectionthreshold=get(handles.Dslider,'Value');
overlapthreshold=get(handles.Oslider,'Value');
overlapthreshold2=get(handles.O2slider,'Value');

imgori = handles.ori{1}{C,1};
imgcropZ=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%resize後のZシリーズを格納する２次元行列imgcropZ
hightM=size(imgcropZ,1);
widthM=size(imgcropZ,2);
for Z=Zstart:Zend %全Zセクションの画像を連結した上で明るさを判定する
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);
    imgcropZ(hightM*(Z-Zstart)+1:hightM*(Z-Zstart+1),1:widthM)=imgcropA;
end
Blim=stretchlim(imgcropZ,[Bthreshold/200 1-Bthreshold/200]);%%imgcropZをもとにBlimを設定

wn = floor((width*Mag-ws)/stride+1);%161
hn = floor((height*Mag-ws)/stride+1);%161
Flist = cell(1,Zend-Zstart+1);Glist = cell(1,1);
ddV=0;ddW=0;
if V1>V2
    ddV=V1-V2;
end
if W1<W2
    ddW=W1-W2;
end

disp('Classification start');
for Z=Zstart:Zend
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    if rot~=0
        imgori=rot90(imgori,rot);
    end
    ddX=round((Z-Zstart)*(V2-V1)/(Zend-Zstart));
    ddY=round((Z-Zstart)*(W2-W1)/(Zend-Zstart));
    hex=polyshape((X-V1)*Mag+1,(W1+height-Y)*Mag+1);
    
    imgcropA=imresize(imgori(Ymax+1-W1-height-ddY:Ymax+1-W1-ddY,V1+ddX:V1+width+ddX),Mag);%%
    imgcropA=imadjust(imgcropA,Blim);%Blimをもとに明るさ補正
    imgsA = uint16(zeros(ws,ws,1,1));
    list = zeros(1,4);
    
    ID=1;Basal=1*10^6;
    Fast=get(handles.radiobutton1,'Value');
    for m=1:hn%161
        j=(m-1)*stride+1;%Y
        for n=1:wn%161
           i=(n-1)*stride+1;%X
           if Fast==0
                if (isinterior(hex,i+cor,j+cor)==1)  
                    imgsA(:,:,1,ID) = imgcropA(j:j+ws-1,i:i+ws-1);%
                    list(ID,1) = i+cor+ddX+ddV;%X axis
                    list(ID,2) = j+cor-ddY-ddW;%Y axis
                    list(ID,3) = ID;%ID
                    ID=ID+1;
               end
           else
                if (isinterior(hex,i+cor,j+cor)==1)&&(sum(imgcropA(j:j+ws-1,i:i+ws-1),'all')>Basal)
                    imgsA(:,:,1,ID) = imgcropA(j:j+ws-1,i:i+ws-1);%
                    list(ID,1) = i+cor+ddX+ddV;%X axis
                    list(ID,2) = j+cor-ddY-ddW;%Y axis
                    list(ID,3) = ID;%ID
                    ID=ID+1;
               end
           end
        end
    end
    ID=ID-1;
    
    [~,scoreA] = classify(net,imgsA,'ExecutionEnvironment','auto');%auto, cpu, gpu
    list(:,4) = scoreA(:,2);%norm(adjusted)
    list((list(:,4)<detectionthreshold),:) = []; 
    list = sortrows(list,4,'descend');

    count = 1;%count: 
    while(count<size(list,1))%overlap removal in the same Z section
        x = list(count,1);%
        y = list(count,2);%
        n = count+1;%n:
        while(n<=size(list,1))
            nx = list(n,1);%
            ny = list(n,2);%
%             x1 = max([x nx])-ws/2;%
%             y1 = max([y ny])-ws/2;%
%             x2 = min([x nx])+ws/2;%
%             y2 = min([y ny])+ws/2;%
            w = x-nx;%
            h = y-ny;%
            r = sqrt((w/ws)^2+(h/ws)^2);%２つの領域間の距離r
            if r < overlapthreshold
               list(n,:) = [];
                n = n-1;
            end
            n = n+1;
        end
        count = count+1;
    end
    list = sortrows(list,1,'ascend');
    list = sortrows(list,2,'ascend');%list:１平面上のシナプス座標
    Flist{Z-Zstart+1}=list;%Flist: listをZ方向に並べたcell行列
end

disp('Classification completed/Z-overlap being removed');

Glist{  1}=Flist{1};%Glist: FlistからZ方向の重複を除いたシナプス座標リスト
if Zstart<Zend %more than 2 Z-sections
    for I=1:Zend-Zstart
        if size(Glist{  I},1)~=0
            list1=Glist{  I};total1=size(list1,1);list1(:,3)=I;%section ID1
            list=list1;
        else
            total1=0;
        end
        if size(Flist{I+1},1)~=0
            list2=Flist{I+1};total2=size(list2,1);list2(:,3)=I+1;%section ID2
            list(total1+1:total1+total2,:)=list2;
        end
        list = sortrows(list,4,'descend');%sort by normalness
        count = 1;%count: 
        while(count<size(list,1))%overlap removal between neighboring sections
            x = list(count,1);%
            y = list(count,2);%
            n = count+1;%n:
            while(n<=size(list,1))
                nx = list(n,1);%
                ny = list(n,2);%
%                 x1 = max([x nx])-ws/2;%
%                 y1 = max([y ny])-ws/2;%
%                 x2 = min([x nx])+ws/2;%
%                 y2 = min([y ny])+ws/2;%
                w = x-nx;%
                h = y-ny;%
                r = sqrt((w/ws)^2+(h/ws)^2+(6.46/12)^2);%Zstep/Xstep=0.5/0.077354=6.46pix
                if r < overlapthreshold2 %隣のZ平面では異なる閾値を使う
                   list(n,:) = [];%
                    n = n-1;
                end
                n = n+1;
            end
            count = count+1;
        end
        list=sortrows(list,3,'ascend');%sort by section ID
        total=size(list,1);
        J=1;
        list1=zeros(1,4);N1=1;
        list2=zeros(1,4);N2=1;
        while (J<=total)&&(list(J,3)==I)
            list1(N1,:)=list(J,:);
            J=J+1;N1=N1+1;
        end
        while (J<=total)&&(list(J,3)==I+1)
            list2(N2,:)=list(J,:);
            J=J+1;N2=N2+1;
        end
        list1 = sortrows(list1,1,'ascend');
        list1 = sortrows(list1,2,'ascend');
        if N1~=1
            Glist{  I}=list1;
        else
            Glist{  I}=[];
        end
        list2 = sortrows(list2,1,'ascend');
        list2 = sortrows(list2,2,'ascend');
        if N2~=1
            Glist{I+1}=list2;
        else
            Glist{I+1}=[];
        end
    end
end
[a name1 c]=fileparts(handles.imgpath);
[a name2 c]=fileparts(handles.cppath);
disp('Z-overlap removed/Grouping started');

%シナプスのグループ分け
%Glist: Z方向の重複を除いたシナプス座標リスト
N=1;Flist=zeros(1,6);%Flist: Glistのシナプス座標を全Z座標についてまとめたリスト
Clist=zeros(1,6);%Clist: グループが決定したシナプスのリスト
Final=cell(1,1);%Final: グループごとのシナプス座標のリスト
for I=1:size(Glist,2)
    M=size(Glist{I},1); 
    if M~=0
        Flist(N:N+M-1,1)=N:N+M-1;%シナプスID
        Flist(N:N+M-1,2:5)=Glist{I};
    end
    N=N+M;
end

Rlist=Flist;%Rlist: FlistのXY座標を回転させたリスト（ここでは回転させずに退避させているだけ）
N=N-1;
group=1;candidate=zeros(1,1);%groupを1とする
XYradius=round(get(handles.XYrad_slider,'Value'));
Zradius=round(get(handles.Zrad_slider,'Value'));

while size(Rlist,1)~=0   
    Cnum=1;Clist=zeros(1,6);
    Rlist(Cnum,6)=group;
    Clist(Cnum,:)=Rlist(1,:);Rlist(1,:)=[];%Rlistの一番上をClistに退避
    RX=Clist(Cnum,2);RY=Clist(Cnum,3);RZ=Clist(Cnum,4);%退避したシナプスの座標RX,RY,RZ
    while size(Rlist,1)~=0 
            R=sqrt((RX-Rlist(:,2)).^2+(RY-Rlist(:,3)).^2);
            Rlist((R<XYradius)&(Rlist(:,4)>RZ-Zradius)&(Rlist(:,4)<RZ+Zradius),6)=group;%近くにあるシナプスにgourpを設定

            candidate=find(Rlist(:,6)==group);%groupが設定されたシナプスのリスト
            if size(candidate,1)==0 %groupが設定されたシナプスがなければ中止
                break
            end
            Cnum=Cnum+1;
            target=Rlist(candidate(1),1);%groupが設定された１番目のシナプスのID=target

            Clist(Cnum,:)=Rlist(candidate(1),:);Clist(Cnum,6)=group;%１番目のシナプスをClistに退避
            Rlist(candidate(1),:)=[];
            RX=Clist(Cnum,2);RY=Clist(Cnum,3);RZ=Clist(Cnum,4);%退避したシナプスの座標RX,RY,Z
    end    
    Final{1,group}=Clist;
    group=group+1;
end
group=group-1;

for I=1:group
    Zcheck=all(Final{I}(:,4)>1) * all(Final{I}(:,4)<Zend-Zstart+1);
    Xcheck=all(Final{I}(:,2)>20) * all(Final{I}(:,2)<width-20);
    Ycheck=all(Final{I}(:,3)>20) * all(Final{I}(:,3)<height-20);
    Final{I}(:,7)=Zcheck*Xcheck*Ycheck;
end
disp('Grouping completed');
toc;

axes(handles.result3d);cla(gca);
c=hsv(6);M=1;J=1;
hold on;%3次元プレビュー
for I=1:group
    Clist=Final{I};Labels=Clist(:,1);D=12;
    M=ceil(I/6);J=mod(I,6);
    M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
    if J==0
        J=6;
    end
    if M==0
        M=10;
    end
    scatter3(Clist(:,2),Clist(:,3),Clist(:,4)*10,D,c(J,:),Mark{M});daspect([1 1 1]);
end
hold off;

ax=gca;ax.XAxis.Visible='off';ax.YAxis.Visible='off';
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');%set(gca,'Color','k');

handles.date=datestr(now, 'mmdd_HHMM');
set(handles.Gnum1,'String','');
set(handles.Gnum2,'String','');
set(handles.Snum,'String','');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');
set(handles.rotation,'Enable','on');
set(handles.rotationslider,'Enable','on');
set(handles.Snum,'Enable','off');
set(handles.remove,'Enable','off');
set(handles.remove2,'Enable','off');
set(handles.Gnum1,'Enable','off');
set(handles.Gnum2,'Enable','off');
set(handles.regroup,'Enable','off');
set(handles.degroup,'Enable','off');
guidata(hObject,handles);

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Final Zstart Excelist

[a name c]=fileparts(handles.imgpath);
name=strcat(name,'_', handles.date, '.xls');

Start=1;Excelist=zeros(1,7);
groupN=size(Final,2);N=zeros(groupN,2);
for I=1:groupN
    list=Final{I};N(I,1)=list(1,7);N(I,2)=size(list,1);
    if N(I,2)~=0    
        Excelist(Start:Start+N(I,2)-1,:)=list;
        Excelist(Start:Start+N(I,2)-1,4)=Excelist(Start:Start+N(I,2)-1,4)+Zstart-1;
    end
    Start=Start+N(I,2);
end
warning('off','MATLAB:xlswrite:AddSheet');
xlswrite(name, Excelist,1);%
xlswrite(name, N,2);%
set(handles.movie,'Enable','on');

% --- Executes on button press in movie.
function movie_Callback(hObject, eventdata, handles)
% hObject    handle to movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imgori imgcropA total Final Zstart Zend Elist Glist Excelist list sublist I X Y rot Mark Blim
Zstart=round(get(handles.Zstart,'Value'));Zend=get(handles.Zend,'Value');
C=round(get(handles.cslider,'Value'));
Bthreshold=get(handles.Bslider,'Value');
Mag=get(handles.Mslider,'Value');
stride=get(handles.Lslider,'Value');
detectionthreshold=get(handles.Dslider,'Value');
overlapthreshold=get(handles.Oslider,'Value');
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
Cmax=handles.cslider.Max;

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%

[a name c]=fileparts(handles.imgpath);
name=strcat(name,'_', handles.date);
mov=VideoWriter(name, 'MPEG-4');
open(mov);

[a name1 c]=fileparts(handles.imgpath);
[a name2 c]=fileparts(handles.cppath);

Start=1;Excelist=zeros(1,7);
groupN=size(Final,2);
for I=1:groupN
    list=Final{I};N=size(list,1);
    if N~=0    
        Excelist(Start:Start+N-1,:)=list;
        Excelist(Start:Start+N-1,4)=Excelist(Start:Start+N-1,4)+Zstart-1;
    end
    Start=Start+N;
end
Elist=sortrows(Excelist,6,'ascend');%Elist: シナプス座標を全Z座標についてまとめたリスト(グループ番号)
    
c=hsv(6);
figure('Position',[0 400 1000 400]);
synapseIDstart=1;
for Z=Zstart:Zend
    I=(Z-1)*Cmax+C;
    imgori = handles.ori{1}{I,1};
    if rot~=0
        imgori=rot90(imgori,rot);
    end
    imgcropA=imresize(imgori(Ymax+1-Top:Ymax+1-Bottom,Left:Right),Mag);%%
    imgcropA=imadjust(imgcropA,Blim);%
    I=Z-Zstart+1;
    list=Elist(Elist(:,4)==Z,:);total=size(list,1);
    subplot(1,2,1);imshow(imgcropA);title(strcat(name1,' :',name2,' :Z=',num2str(Z), ' :Mag=',num2str(Mag)),'Interpreter','none');
    subplot(1,2,2);imshow(imgcropA);title(strcat('N=',num2str(total),' :Stride=',num2str(stride),' :Detection=',num2str(detectionthreshold),' :Overlap=',num2str(overlapthreshold),' :Brightness=',num2str(Bthreshold)),'Interpreter','none');
    
    if total~=0
        hold on;
        for I=list(1,6):list(total,6)
            sublist=list(list(:,6)==I,:);
            sublist(:,2)=sublist(:,2);
            sublist(:,3)=sublist(:,3);
            M=ceil(I/6);J=mod(I,6);
            M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
            if J==0
                J=6;
            end
            if M==0
                M=10;
            end
            plot(sublist(:,2),sublist(:,3),Mark{M},'MarkerEdgeColor',c(J,:));
        end
        plabels=list(:,1);%plabels=plabels';%
        text(list(:,2)+6,list(:,3),num2str(plabels),'Color','m','FontSize',6);%        
        hold off;
    end
    writeVideo(mov, getframe(gcf));
end
writeVideo(mov, getframe(gcf));
close(mov);


% --- Executes on slider movement.
function XYrad_slider_Callback(hObject, eventdata, handles)
% hObject    handle to XYrad_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Flist Glist Final Rlist X Y Mark
XYradius=round(get(hObject,'Value'));
set(handles.XYrad_slider,'Value',XYradius);
set(handles.XYrad_value,'String',XYradius);

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
rotation=round(get(handles.rotationslider,'Value'));
Ywgt=get(handles.Ywgt_slider,'Value');Ywgt2=Ywgt*Ywgt;
guidata(hObject,handles);

%シナプスのグループ分け
%Glist: Z方向の重複を除いたシナプス座標リスト
N=1;
%Flist=zeros(1,6);%Flist: Glistのシナプス座標を全Z座標についてまとめたリスト
Clist=zeros(1,6);%Clist: グループが決定したシナプスのリスト
Final=cell(1,1);%Final: グループごとのシナプス座標のリスト

X0=(Right-Left)/2;Y0=(Top-Bottom)/2;
Theta=-rotation/180*pi;

Rlist=Flist;%Rlist: FlistのXY座標を回転させたリスト
XR=Flist(:,2)-X0;YR=Flist(:,3)-Y0;
Rlist(:,2)=cos(Theta)*XR+sin(Theta)*YR+X0;
Rlist(:,3)=-sin(Theta)*XR+cos(Theta)*YR+Y0;

N=N-1;
group=1;candidate=zeros(1,1);%groupを1とする
XYradius=round(get(handles.XYrad_slider,'Value'));
Zradius=round(get(handles.Zrad_slider,'Value'));

while size(Rlist,1)~=0   
    Cnum=1;Clist=zeros(1,6);
    Rlist(Cnum,6)=group;
    Clist(Cnum,:)=Rlist(1,:);Rlist(1,:)=[];%Rlistの一番上をClistに退避
    XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    while size(Rlist,1)~=0 
            R=sqrt((XR-Rlist(:,2)).^2+Ywgt2*(YR-Rlist(:,3)).^2);
            Rlist((R<XYradius)&(Rlist(:,4)>ZR-Zradius)&(Rlist(:,4)<ZR+Zradius),6)=group;%近くにあるシナプスにgourpを設定

            candidate=find(Rlist(:,6)==group);%groupが設定されたシナプスのリスト
            if size(candidate,1)==0 %groupが設定されたシナプスがなければ中止
                break
            end
            Cnum=Cnum+1;
            target=Rlist(candidate(1),1);%groupが設定された１番目のシナプスのID=target

            Clist(Cnum,:)=Rlist(candidate(1),:);Clist(Cnum,6)=group;%１番目のシナプスをClistに退避
            Rlist(candidate(1),:)=[];
            XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    end    
    Final{1,group}=Clist;
    group=group+1;
end
 group=group-1;
 
 axes(handles.result3d);cla(gca);
 c=hsv(6);M=1;J=1;
hold on;%3次元プロット
for I=1:group
    Clist=Final{I};Labels=Clist(:,1);D=12;
    M=ceil(I/6);J=mod(I,6);
    M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
    if J==0
        J=6;
    end
    if M==0
        M=10;
    end
    scatter3(Clist(:,2),Clist(:,3),Clist(:,4)*10,D,c(J,:),Mark{M});daspect([1 1 1]);
end
hold off;

ax=gca;ax.XAxis.Visible='off';ax.YAxis.Visible='off';%ax.Color='k';
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');

% --- Executes during object creation, after setting all properties.
function XYrad_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XYrad_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Zrad_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Zrad_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Flist Glist Final Rlist X Y Mark
Zradius=round(get(hObject,'Value'));
set(handles.Zrad_slider,'Value',Zradius);
set(handles.Zrad_value,'String',Zradius);

rotation=round(get(handles.rotationslider,'Value'));
Ywgt=get(handles.Ywgt_slider,'Value');Ywgt2=Ywgt*Ywgt;
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
guidata(hObject,handles);

%シナプスのグループ分け
%Glist: Z方向の重複を除いたシナプス座標リスト
N=1;
%Flist=zeros(1,6);%Flist: Glistのシナプス座標を全Z座標についてまとめたリスト
Clist=zeros(1,6);%Clist: グループが決定したシナプスのリスト
Final=cell(1,1);%Final: グループごとのシナプス座標のリスト

X0=(Right-Left)/2;Y0=(Top-Bottom)/2;
Theta=-rotation/180*pi;

Rlist=Flist;%Rlist: FlistのXY座標を回転させたリスト
XR=Flist(:,2)-X0;YR=Flist(:,3)-Y0;
Rlist(:,2)=cos(Theta)*XR+sin(Theta)*YR+X0;
Rlist(:,3)=-sin(Theta)*XR+cos(Theta)*YR+Y0;

N=N-1;
group=1;candidate=zeros(1,1);%groupを1とする
XYradius=round(get(handles.XYrad_slider,'Value'));
Zradius=round(get(handles.Zrad_slider,'Value'));

while size(Rlist,1)~=0   
    Cnum=1;Clist=zeros(1,6);
    Rlist(Cnum,6)=group;
    Clist(Cnum,:)=Rlist(1,:);Rlist(1,:)=[];%Rlistの一番上をClistに退避
    XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    while size(Rlist,1)~=0 
            R=sqrt((XR-Rlist(:,2)).^2+Ywgt2*(YR-Rlist(:,3)).^2);
            Rlist((R<XYradius)&(Rlist(:,4)>ZR-Zradius)&(Rlist(:,4)<ZR+Zradius),6)=group;%近くにあるシナプスにgourpを設定

            candidate=find(Rlist(:,6)==group);%groupが設定されたシナプスのリスト
            if size(candidate,1)==0 %groupが設定されたシナプスがなければ中止
                break
            end
            Cnum=Cnum+1;
            target=Rlist(candidate(1),1);%groupが設定された１番目のシナプスのID=target

            Clist(Cnum,:)=Rlist(candidate(1),:);Clist(Cnum,6)=group;%１番目のシナプスをClistに退避
            Rlist(candidate(1),:)=[];
            XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    end    
    Final{1,group}=Clist;
    group=group+1;
end
 group=group-1;
 
axes(handles.result3d);cla(gca);
c=hsv(6);M=1;J=1;
hold on;%3次元プロット
for I=1:group
    Clist=Final{I};Labels=Clist(:,1);D=12;
    M=ceil(I/6);J=mod(I,6);
    M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
    if J==0
        J=6;
    end    
    if M==0
        M=10;
    end
    scatter3(Clist(:,2),Clist(:,3),Clist(:,4)*10,D,c(J,:),Mark{M});daspect([1 1 1]);
end
hold off;

ax=gca;ax.XAxis.Visible='off';ax.YAxis.Visible='off';%ax.Color='k';
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');

% --- Executes during object creation, after setting all properties.
function Zrad_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zrad_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function rotationslider_Callback(hObject, eventdata, handles)
% hObject    handle to rotationslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Flist Glist Final Rlist X Y Mark
rotation=round(get(hObject,'Value'));
set(handles.rotationslider,'Value',rotation);
set(handles.rotationvalue,'String',rotation);

width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
Ywgt=get(handles.Ywgt_slider,'Value');Ywgt2=Ywgt*Ywgt;

%シナプスのグループ分け
%Glist: Z方向の重複を除いたシナプス座標リスト
N=1;
%Flist=zeros(1,6);%Flist: Glistのシナプス座標を全Z座標についてまとめたリスト
Clist=zeros(1,6);%Clist: グループが決定したシナプスのリスト
Final=cell(1,1);%Final: グループごとのシナプス座標のリスト

X0=(Right-Left)/2;Y0=(Top-Bottom)/2;
Theta=-rotation/180*pi;

Rlist=Flist;%Rlist: FlistのXY座標を回転させたリスト
XR=Flist(:,2)-X0;YR=Flist(:,3)-Y0;
Rlist(:,2)=cos(Theta)*XR+sin(Theta)*YR+X0;
Rlist(:,3)=-sin(Theta)*XR+cos(Theta)*YR+Y0;

N=N-1;
group=1;candidate=zeros(1,1);%groupを1とする
XYradius=round(get(handles.XYrad_slider,'Value'));
Zradius=round(get(handles.Zrad_slider,'Value'));

while size(Rlist,1)~=0   
    Cnum=1;Clist=zeros(1,6);
    Rlist(Cnum,6)=group;
    Clist(Cnum,:)=Rlist(1,:);Rlist(1,:)=[];%Rlistの一番上をClistに退避
    XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    while size(Rlist,1)~=0 
            R=sqrt((XR-Rlist(:,2)).^2+Ywgt2*(YR-Rlist(:,3)).^2);
            Rlist((R<XYradius)&(Rlist(:,4)>ZR-Zradius)&(Rlist(:,4)<ZR+Zradius),6)=group;%近くにあるシナプスにgourpを設定

            candidate=find(Rlist(:,6)==group);%groupが設定されたシナプスのリスト
            if size(candidate,1)==0 %groupが設定されたシナプスがなければ中止
                break
            end
            Cnum=Cnum+1;
            target=Rlist(candidate(1),1);%groupが設定された１番目のシナプスのID=target

            Clist(Cnum,:)=Rlist(candidate(1),:);Clist(Cnum,6)=group;%１番目のシナプスをClistに退避
            Rlist(candidate(1),:)=[];
            XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    end    
    Final{1,group}=Clist;
    group=group+1;
end
group=group-1;
 
axes(handles.result3d);cla(gca);
c=hsv(6);M=1;J=1;
hold on;%3次元プロット
for I=1:group
    Clist=Final{I};Labels=Clist(:,1);D=12;
    M=ceil(I/6);J=mod(I,6);
    M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
    if J==0
        J=6;
    end
    if M==0
        M=10;
    end
    scatter3(Clist(:,2),Clist(:,3),Clist(:,4)*10,D,c(J,:),Mark{M});daspect([1 1 1]);
end
hold off;

ax=gca;ax.XAxis.Visible='off';ax.YAxis.Visible='off';%ax.Color='k';
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function rotationslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotationslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in rotation.
function rotation_Callback(hObject, eventdata, handles)
% hObject    handle to rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Glist Flist Final Rlist height width X Y Mark Poly
rotation=round(get(handles.rotationslider,'Value'));
Ywgt=get(handles.Ywgt_slider,'Value');Ywgt2=Ywgt*Ywgt;
width=max(X)-min(X);height=max(Y)-min(Y);
Zstart=get(handles.Zstart,'Value');Zend=get(handles.Zend,'Value');
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
Mag=get(handles.Mslider,'Value');

%シナプスのグループ分け
%Glist: Z方向の重複を除いたシナプス座標リスト
N=1;
%Flist=zeros(1,8);%Rlist: Glistのシナプス座標を全Z座標についてまとめたリスト
Clist=zeros(1,8);%Clist: グループが決定したシナプスのリスト
Final=cell(1,1);%Final: グループごとのシナプス座標のリスト

X0=(Right-Left)/2;Y0=(Top-Bottom)/2;
Theta=-rotation/180*pi;

Rlist=Flist;%Rlist: FlistのXY座標を回転させたリスト
XR=Rlist(:,2)-X0;YR=Rlist(:,3)-Y0;
Rlist(:,7)=cos(Theta)*XR+sin(Theta)*YR+X0;%回転後のx座標
Rlist(:,8)=-sin(Theta)*XR+cos(Theta)*YR+Y0;%回転後のy座標

N=N-1;
group=1;candidate=zeros(1,1);%groupを1とする
XYradius=round(get(handles.XYrad_slider,'Value'));
Zradius=round(get(handles.Zrad_slider,'Value'));

while size(Rlist,1)~=0   
    Cnum=1;Clist=zeros(1,8);
    Rlist(Cnum,6)=group;
    Clist(Cnum,:)=Rlist(1,:);Rlist(1,:)=[];%Rlistの一番上をClistに退避
    XR=Clist(Cnum,7);YR=Clist(Cnum,8);ZR=Clist(Cnum,4);%退避したシナプスの回転後座標X,Y,Z
    while size(Rlist,1)~=0 
            R=sqrt((XR-Rlist(:,7)).^2+Ywgt2*(YR-Rlist(:,8)).^2);
            Rlist((R<XYradius)&(Rlist(:,4)>ZR-Zradius)&(Rlist(:,4)<ZR+Zradius),6)=group;%近くにあるシナプスにgroupを設定

            candidate=find(Rlist(:,6)==group);%groupが設定されたシナプスのリスト
            if size(candidate,1)==0 %groupが設定されたシナプスがなければ中止
                break
            end
            Cnum=Cnum+1;

            Clist(Cnum,:)=Rlist(candidate(1),:);Clist(Cnum,6)=group;%１番目のシナプスをClistに退避
            Rlist(candidate(1),:)=[];
            XR=Clist(Cnum,7);YR=Clist(Cnum,8);ZR=Clist(Cnum,4);%退避したシナプスの回転後座標XR,YR,Z
    end    
    Final{1,group}=Clist(:,1:6);
    group=group+1;
end
group=group-1;
 
for I=1:group
    Zcheck=all(Final{I}(:,4)>1) * all(Final{I}(:,4)<max(Flist(:,4)));
    Xcheck=all(Final{I}(:,2)>20) * all(Final{I}(:,2)<width-20);
    Ycheck=all(Final{I}(:,3)>20) * all(Final{I}(:,3)<height-20);
    Final{I}(:,7)=Zcheck*Xcheck*Ycheck;
end

ddV=0;ddW=0;
if V1>V2
    ddV=V1-V2;
end
if W1<W2
    ddW=W1-W2;
end
ddX=V2-V1;ddY=W2-W1;
X3Dstart=X-V1+1+ddV;X3Dstart(1,Poly+1)=X3Dstart(1,1);
Y3Dstart=W1+height-Y+1-ddW;Y3Dstart(1,Poly+1)=Y3Dstart(1,1);
Z3Dstart=zeros(1,Poly+1);
X3Dend=X-V1+1+ddX+ddV;X3Dend(1,Poly+1)=X3Dend(1,1);
Y3Dend=W1+height-Y+1-ddY-ddW;Y3Dend(1,Poly+1)=Y3Dend(1,1);
Z3Dend=10*ones(1,Poly+1)*(Zend-Zstart+1);

figure;c=hsv(6);M=1;J=1;
Gindex=zeros(group,5);
hold on;%3次元プロット
plot3(X3Dstart,Y3Dstart,Z3Dstart,'Color',[0.5 0 0]);
plot3(X3Dend,Y3Dend,Z3Dend,'Color',[0 0.5 0]);
for I=1:Poly
    plot3([X3Dstart(I) X3Dend(I)],[Y3Dstart(I) Y3Dend(I)],[Z3Dstart(I) Z3Dend(I)],'Color',[0.5 0.5 0]);
end
for I=1:group
    Clist=Final{I};Labels=Clist(:,1);Clist(:,4)=Clist(:,4)*10;
    Gindex(I,1)=I;Gindex(I,2:4)=Clist(1,2:4);Gindex(I,5)=size(Clist,1);
    D=16*Final{I}(1,7)+8;
    M=ceil(I/6);J=mod(I,6);
    M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
    if J==0
        J=6;
    end
    if M==0
        M=10;
    end
    scatter3(Clist(:,2),Clist(:,3),Clist(:,4),D,c(J,:),Mark{M});daspect([1 1 1]);
    text(Clist(:,2)+3,Clist(:,3),Clist(:,4),num2str(Labels),'FontUnits','pixels','FontSize',8,'Color',[0.5 0.5 0.5]);%
end
text(Gindex(:,2)-12,Gindex(:,3)-3,Gindex(:,4),num2str(Gindex(:,1)),'FontUnits','pixels','FontSize',12,'Color','w');%グループ番号描画
text(Gindex(:,2)-4,Gindex(:,3)+3,Gindex(:,4),strcat('(',num2str(Gindex(:,5)),')'),'FontUnits','pixels','FontSize',10,'Color','w');%シナプス数描画
xlim([0 width+abs(V2-V1)+1]);ylim([0 height+abs(W2-W1)]+1);
hold off;
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');set(gca,'Color','k');
set(handles.Gnum1,'String','');
set(handles.Gnum2,'String','');
set(handles.Snum,'String','');
set(handles.save,'Enable','on');
set(handles.movie,'Enable','on');
set(handles.Snum,'Enable','on');
set(handles.remove,'Enable','off');
set(handles.remove2,'Enable','on');
set(handles.Gnum1,'Enable','on');
set(handles.Gnum2,'Enable','on');
set(handles.regroup,'Enable','off');
set(handles.degroup,'Enable','on');
handles.date=datestr(now, 'mmdd_HHMM');
guidata(hObject,handles);


% --- Executes on slider movement.
function Ywgt_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Ywgt_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Flist Glist Final Rlist X Y Mark
Ywgt=get(hObject,'Value');Ywgt2=Ywgt*Ywgt;
set(handles.Ywgt_slider,'Value',Ywgt);
set(handles.Ywgt_value,'String',Ywgt);

rotation=round(get(handles.rotationslider,'Value'));
width=max(X)-min(X);height=max(Y)-min(Y);
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Left=min(V1,V2);Right=max(V1,V2)+width;Bottom=min(W1,W2);Top=max(W1,W2)+height;%%
guidata(hObject,handles);

%シナプスのグループ分け
%Glist: Z方向の重複を除いたシナプス座標リスト
N=1;
%Flist=zeros(1,6);%Flist: Glistのシナプス座標を全Z座標についてまとめたリスト
Clist=zeros(1,6);%Clist: グループが決定したシナプスのリスト
Final=cell(1,1);%Final: グループごとのシナプス座標のリスト

X0=(Right-Left)/2;Y0=(Top-Bottom)/2;
Theta=-rotation/180*pi;

Rlist=Flist;%Rlist: FlistのXY座標を回転させたリスト
XR=Flist(:,2)-X0;YR=Flist(:,3)-Y0;
Rlist(:,2)=cos(Theta)*XR+sin(Theta)*YR+X0;
Rlist(:,3)=-sin(Theta)*XR+cos(Theta)*YR+Y0;

N=N-1;
group=1;candidate=zeros(1,1);%groupを1とする
XYradius=round(get(handles.XYrad_slider,'Value'));
Zradius=round(get(handles.Zrad_slider,'Value'));

while size(Rlist,1)~=0   
    Cnum=1;Clist=zeros(1,6);
    Rlist(Cnum,6)=group;
    Clist(Cnum,:)=Rlist(1,:);Rlist(1,:)=[];%Rlistの一番上をClistに退避
    XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    while size(Rlist,1)~=0 
            R=sqrt((XR-Rlist(:,2)).^2+Ywgt2*(YR-Rlist(:,3)).^2);
            Rlist((R<XYradius)&(Rlist(:,4)>ZR-Zradius)&(Rlist(:,4)<ZR+Zradius),6)=group;%近くにあるシナプスにgourpを設定

            candidate=find(Rlist(:,6)==group);%groupが設定されたシナプスのリスト
            if size(candidate,1)==0 %groupが設定されたシナプスがなければ中止
                break
            end
            Cnum=Cnum+1;
            target=Rlist(candidate(1),1);%groupが設定された１番目のシナプスのID=target

            Clist(Cnum,:)=Rlist(candidate(1),:);Clist(Cnum,6)=group;%１番目のシナプスをClistに退避
            Rlist(candidate(1),:)=[];
            XR=Clist(Cnum,2);YR=Clist(Cnum,3);ZR=Clist(Cnum,4);%退避したシナプスの座標X,Y,Z
    end    
    Final{1,group}=Clist;
    group=group+1;
end
 group=group-1;
 
axes(handles.result3d);cla(gca);
c=hsv(6);M=1;J=1;
hold on;%3次元プロット
for I=1:group
    Clist=Final{I};Labels=Clist(:,1);D=12;
    M=ceil(I/6);J=mod(I,6);
    M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
    if J==0
        J=6;
    end
    if M==0
        M=10;
    end
    scatter3(Clist(:,2),Clist(:,3),Clist(:,4)*10,D,c(J,:),Mark{M});daspect([1 1 1]);
end
hold off;

ax=gca;ax.XAxis.Visible='off';ax.YAxis.Visible='off';%ax.Color='k';
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');

% --- Executes during object creation, after setting all properties.
function Ywgt_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ywgt_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ROI.
function ROI_Callback(hObject, eventdata, handles)
% hObject    handle to ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global preW preH X Y Poly Blim
Xmax=size(handles.ori{1}{1,1},1);Ymax=size(handles.ori{1}{1,1},2);
set(handles.ROImessage,'String',['Please click ',num2str(Poly),' points to specify a ROI.']);
set(handles.startbutton,'Enable','off');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');
set(handles.rotation,'Enable','off');
set(handles.rotationslider,'Enable','off');

imgori=imadjust(handles.img,Blim);
axes(handles.main_img);
imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
Xold=X;Yold=Y;
X=zeros(1,Poly);Y=zeros(1,Poly);
hold on;
for I=1:Poly
    set(handles.ROImessage,'String',['Please specify ' num2str(I) '-th point out of ' num2str(Poly)]);
    axes(handles.main_img);
    [x,y]=ginput(1);
    x=round(x);
    y=Ymax-round(y);
    if (x<1)||(x>Xmax)||(y<1)||(y>Ymax)
        break;
    end
    plot(x,Ymax-y+1,'r*');
    X(I)=x;Y(I)=y;
end
hold off;

hex=polyshape(X,Y);
V1=min(X);V2=min(X);W1=min(Y);W2=min(Y);
width=max(X)-min(X);height=max(Y)-min(Y);
if (V1>=1)&&(V1+width<=Xmax)&&(W1>=1)&&(W1+height<=Ymax)&&(size(hex.Vertices,1)==Poly)&&(hex.NumRegions==1)&&(hex.NumHoles==0)
    set(handles.ROImessage,'String','A new ROI was appropriately speficied.');
    axes(handles.main_img);
    imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
    
    hold on;
    patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'g', 'FaceAlpha',0.3);
    hold off;
    
    set(handles.Xslider1,'Value',V1);
    set(handles.X1value,'String',V1);
    set(handles.Xslider2,'Value',V2);
    set(handles.X2value,'String',V2);
    set(handles.Yslider1,'Value',W1);
    set(handles.Y1value,'String',W1);
    set(handles.Yslider2,'Value',W2);
    set(handles.Y2value,'String',W2);

    Mag=get(handles.Mslider,'Value');
    imgcrop=imresize(imgori(Ymax+1-W1-height:Ymax+1-W1,V1:V1+width),Mag);
    [Ycrop Xcrop]=size(imgcrop);
    if Xcrop>preW
        V1=fix((Xcrop-preW)/2)+1;
        imgcrop=imgcrop(:,V1:V1+preW-1);
    end
    if Ycrop>preH
        W1=fix((Ycrop-preH)/2)+1;
        imgcrop=imgcrop(W1:W1+preH-1,:);
    end
    if Xcrop<preW
        imgcrop(:,Xcrop+1:preW)=0;
    end
    if Ycrop<preH
        imgcrop(Ycrop+1:preH,:)=0;
    end
    axes(handles.mag_img);imshow(imgcrop);
else
    set(handles.ROImessage,'String','Invalid ROI (the previous ROI being resumed).');
    X=Xold;Y=Yold;
    axes(handles.main_img);
    imagesc(imgori);set(gca,'XTick',[]);set(gca,'YTick',[]);
    hold on;
    patch(X,Ymax-Y+1,'r', 'FaceAlpha',0.3);patch(X,Ymax-Y+1,'g', 'FaceAlpha',0.3);
    hold off;
end
set(handles.startbutton,'Enable','on');
set(handles.save,'Enable','off');
set(handles.movie,'Enable','off');
set(handles.rotation,'Enable','off');
set(handles.rotationslider,'Enable','off');

% --- Executes on slider movement.
function Vertex_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Vertex_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Poly
I=round(get(hObject,'Value'));
if I~=Poly
    Poly=I;
    set(handles.Vertex_slider,'Value',Poly);
    set(handles.Vertex_value,'String',Poly);
    set(handles.ROImessage,'String',['Please click ',num2str(Poly),' points to specify a ROI.']);
    set(handles.startbutton,'Enable','off');
    set(handles.save,'Enable','off');
    set(handles.movie,'Enable','off');
    set(handles.rotation,'Enable','off');
    set(handles.rotationslider,'Enable','off');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Vertex_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vertex_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in regroup.
function regroup_Callback(hObject, eventdata, handles)
% hObject    handle to regroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  Final X Y Mark Poly
width=max(X)-min(X);height=max(Y)-min(Y);
Zstart=get(handles.Zstart,'Value');Zend=get(handles.Zend,'Value');
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
Gnum1=str2num(get(handles.Gnum1,'String'));Gnum2=str2num(get(handles.Gnum2,'String'));
group=size(Final,2);

g1=min(Gnum1,Gnum2);g2=max(Gnum1,Gnum2);
Gnum1=g1;Gnum2=g2;

Final{Gnum2}(:,6)=Gnum1;
M=size(Final{Gnum1},1);N=size(Final{Gnum2},1);
Final{Gnum1}(M+1:M+N,:)=Final{Gnum2};
Final(Gnum2)=[];
Final{Gnum1}(:,7)=min(Final{Gnum1}(:,7));

%3Dプロット
ddV=0;ddW=0;
if V1>V2
    ddV=V1-V2;
end
if W1<W2
    ddW=W1-W2;
end
ddX=V2-V1;ddY=W2-W1;
X3Dstart=X-V1+1+ddV;X3Dstart(1,Poly+1)=X3Dstart(1,1);
Y3Dstart=W1+height-Y+1-ddW;Y3Dstart(1,Poly+1)=Y3Dstart(1,1);
Z3Dstart=zeros(1,Poly+1);
X3Dend=X-V1+1+ddX+ddV;X3Dend(1,Poly+1)=X3Dend(1,1);
Y3Dend=W1+height-Y+1-ddY-ddW;Y3Dend(1,Poly+1)=Y3Dend(1,1);
Z3Dend=10*ones(1,Poly+1)*(Zend-Zstart+1);

figure;c=hsv(6);M=1;J=1;group=size(Final,2);
Gindex=zeros(group,5);
hold on;%3次元プロット
plot3(X3Dstart,Y3Dstart,Z3Dstart,'Color',[0.5 0 0]);
plot3(X3Dend,Y3Dend,Z3Dend,'Color',[0 0.5 0]);
for I=1:Poly
    plot3([X3Dstart(I) X3Dend(I)],[Y3Dstart(I) Y3Dend(I)],[Z3Dstart(I) Z3Dend(I)],'Color',[0.5 0.5 0]);
end
for I=1:group
    Clist=Final{I};Labels=Clist(:,1);Clist(:,4)=Clist(:,4)*10;
    Gindex(I,1)=I;Gindex(I,2:4)=Clist(1,2:4);Gindex(I,5)=size(Clist,1);
    D=16*Final{I}(1,7)+8;
    M=ceil(I/6);J=mod(I,6);
    M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
    if J==0
        J=6;
    end
    if M==0
        M=10;
    end
    scatter3(Clist(:,2),Clist(:,3),Clist(:,4),D,c(J,:),Mark{M});daspect([1 1 1]);
    text(Clist(:,2)+3,Clist(:,3),Clist(:,4),num2str(Labels),'FontUnits','pixels','FontSize',8,'Color',[0.5 0.5 0.5]);%
end
text(Gindex(:,2)-12,Gindex(:,3)-3,Gindex(:,4),num2str(Gindex(:,1)),'FontUnits','pixels','FontSize',12,'Color','w');%グループ番号描画
text(Gindex(:,2)-4,Gindex(:,3)+3,Gindex(:,4),strcat('(',num2str(Gindex(:,5)),')'),'FontUnits','pixels','FontSize',10,'Color','w');%シナプス数描画
xlim([0 width+abs(V2-V1)+1]);ylim([0 height+abs(W2-W1)]+1);
hold off;
set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');set(gca,'Color','k');

set(handles.Gnum1,'String','');set(handles.Gnum2,'String','');
set(handles.save,'Enable','on');
set(handles.movie,'Enable','on');
set(handles.Snum,'Enable','off');
set(handles.remove,'Enable','off');
set(handles.remove2,'Enable','on');
set(handles.Gnum1,'Enable','on');
set(handles.Gnum2,'Enable','on');
set(handles.regroup,'Enable','off');
set(handles.degroup,'Enable','on');
handles.date=datestr(now, 'mmdd_HHMM');
guidata(hObject,handles);


function Gnum1_Callback(hObject, eventdata, handles)
% hObject    handle to Gnum1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gnum1 as text
%        str2double(get(hObject,'String')) returns contents of Gnum1 as a double
global Final
Gnum1=round(str2num(get(handles.Gnum1,'String')));
Gnum2=str2num(get(handles.Gnum2,'String'));
group=size(Final,2);
set(handles.regroup,'Enable','off');
if (Gnum1~=Gnum2)&&(Gnum1>=1)&&(Gnum1<=group)&&(Gnum2>=1)&&(Gnum2<=group)
    set(handles.ROImessage,'String','Press Regroup to merge synapse groups.');
    set(handles.regroup,'Enable','on');
end
if Gnum1==Gnum2
    set(handles.ROImessage,'String','Specify different group numbers.');
end
if (Gnum1<1)||(Gnum1>group)
    set(handles.ROImessage,'String','Specify existing group number.');
end
set(handles.Gnum1,'String',num2str(Gnum1));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Gnum1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gnum1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Gnum2_Callback(hObject, eventdata, handles)
% hObject    handle to Gnum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gnum2 as text
%        str2double(get(hObject,'String')) returns contents of Gnum2 as a double
global Final
Gnum2=round(str2num(get(handles.Gnum2,'String')));
Gnum1=str2num(get(handles.Gnum1,'String'));
group=size(Final,2);
set(handles.regroup,'Enable','off');
if (Gnum1~=Gnum2)&&(Gnum1>=1)&&(Gnum1<=group)&&(Gnum2>=1)&&(Gnum2<=group)
    set(handles.ROImessage,'String','Press Regroup to merge synapse groups.');
    set(handles.regroup,'Enable','on');
end
if Gnum1==Gnum2
    set(handles.ROImessage,'String','Specify different group numbers.');
end
if (Gnum2<1)||(Gnum2>group)
    set(handles.ROImessage,'String','Specify existing group number.');
end
set(handles.Gnum2,'String',num2str(Gnum2));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Gnum2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gnum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Snum_Callback(hObject, eventdata, handles)
% hObject    handle to Snum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Snum as text
%        str2double(get(hObject,'String')) returns contents of Snum as a double
global Flist
Snum=round(str2num(get(handles.Snum,'String')));
N=size(Snum,2);Flag=0;
for I=1:N
    if any(Flist(:,1)==Snum(1,I))
        Flag=Flag+1;
    end
end
if Flag==N
    set(handles.ROImessage,'String','Press remove synapse.');
    set(handles.Snum,'String',num2str(Snum));
    set(handles.remove,'Enable','on');
else
    set(handles.ROImessage,'String','Specify existing synapse ID.');
    set(handles.Snum,'String','');
    set(handles.remove,'Enable','off');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Snum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Snum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Flist
Snum=round(str2num(get(handles.Snum,'String')));
Flist = sortrows(Flist,1,'ascend');
N=size(Snum,2);
for I=1:N
    Flist(Flist(:,1)==Snum(1,I),:)=[];
end
Flist(:,1)=1:size(Flist,1);
set(handles.ROImessage,'String','Specified synapses were removed.');
set(handles.Snum,'String','');
set(handles.remove,'Enable','off');


% --- Executes on button press in degroup.
function degroup_Callback(hObject, eventdata, handles)
% hObject    handle to degroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  Final Flist X Y Mark Poly
width=max(X)-min(X);height=max(Y)-min(Y);
Zstart=get(handles.Zstart,'Value');Zend=get(handles.Zend,'Value');
V1=get(handles.Xslider1,'Value');W1=get(handles.Yslider1,'Value');
V2=get(handles.Xslider2,'Value');W2=get(handles.Yslider2,'Value');
group=size(Final,2);

Mat=round(str2num(clipboard('paste')));
if size(Mat,2)==3
    Mat(:,3)=Mat(:,3)/10;
    M=size(Flist,1);N=size(Mat,1);Flag=0;
    list=zeros(1,N);%Regroupするシナプス番号のリスト
    %クリップボード中の座標がFlistに含まれているか確認
    for I=1:N%クリップボード中のすべての座標について検索
        for J=1:M%Flist中のすべての座標について検索
            if all(Flist(J,2:4)==Mat(I,1:3))
                Flag=Flag+1;
                list(I)=Flist(J,1);
            end
        end
    end
    list=sort(list);%Regroupするシナプス番号のリスト(要素数N)
    if Flag==N
        Final{group+1}=zeros(N,7);
        for I=1:N
            for J=1:group
                if any(Final{J}(:,1)==list(I))
                    Final{group+1}(I,:)=Final{J}(Final{J}(:,1)==list(I),:);
                    Final{J}(Final{J}(:,1)==list(I),:)=[];
                end
            end
        end
        J=1;
        while size(Final,2)>=J
            if size(Final{J},1)==0
                Final(J)=[];
                J=J-1;
            end
            J=J+1;
        end
        group=size(Final,2);
        for J=1:group
            Final{J}(:,6)=J;
        end
        
        %3Dプロット
        ddV=0;ddW=0;
        if V1>V2
            ddV=V1-V2;
        end
        if W1<W2
            ddW=W1-W2;
        end
        ddX=V2-V1;ddY=W2-W1;
        X3Dstart=X-V1+1+ddV;X3Dstart(1,Poly+1)=X3Dstart(1,1);
        Y3Dstart=W1+height-Y+1-ddW;Y3Dstart(1,Poly+1)=Y3Dstart(1,1);
        Z3Dstart=zeros(1,Poly+1);
        X3Dend=X-V1+1+ddX+ddV;X3Dend(1,Poly+1)=X3Dend(1,1);
        Y3Dend=W1+height-Y+1-ddY-ddW;Y3Dend(1,Poly+1)=Y3Dend(1,1);
        Z3Dend=10*ones(1,Poly+1)*(Zend-Zstart+1);

        figure;c=hsv(6);M=1;J=1;group=size(Final,2);
        Gindex=zeros(group,5);
        hold on;%3次元プロット
        plot3(X3Dstart,Y3Dstart,Z3Dstart,'Color',[0.5 0 0]);
        plot3(X3Dend,Y3Dend,Z3Dend,'Color',[0 0.5 0]);
        for I=1:Poly
            plot3([X3Dstart(I) X3Dend(I)],[Y3Dstart(I) Y3Dend(I)],[Z3Dstart(I) Z3Dend(I)],'Color',[0.5 0.5 0]);
        end
        for I=1:group
            Clist=Final{I};Labels=Clist(:,1);Clist(:,4)=Clist(:,4)*10;
            Gindex(I,1)=I;Gindex(I,2:4)=Clist(1,2:4);Gindex(I,5)=size(Clist,1);
            D=16*Final{I}(1,7)+8;
            M=ceil(I/6);J=mod(I,6);
            M2=num2str(M);M3=extract(M2,strlength(M2));M=str2num(M3{1});
            if J==0
                J=6;
            end
            if M==0
                M=10;
            end
            scatter3(Clist(:,2),Clist(:,3),Clist(:,4),D,c(J,:),Mark{M});daspect([1 1 1]);
            text(Clist(:,2)+3,Clist(:,3),Clist(:,4),num2str(Labels),'FontUnits','pixels','FontSize',8,'Color',[0.5 0.5 0.5]);%
        end
        text(Gindex(:,2)-12,Gindex(:,3)-3,Gindex(:,4),num2str(Gindex(:,1)),'FontUnits','pixels','FontSize',12,'Color','w');%グループ番号描画
        text(Gindex(:,2)-4,Gindex(:,3)+3,Gindex(:,4),strcat('(',num2str(Gindex(:,5)),')'),'FontUnits','pixels','FontSize',10,'Color','w');%シナプス数描画
        xlim([0 width+abs(V2-V1)+1]);ylim([0 height+abs(W2-W1)]+1);
        hold off;
        set(gca,'Ydir','Reverse');set(gca,'Zdir','Reverse');set(gca,'Color','k');
        
        set(handles.ROImessage,'String','A new group was created.');
        handles.date=datestr(now, 'mmdd_HHMM');
        guidata(hObject,handles);
        
    else
        set(handles.ROImessage,'String','Copy appropriate synapse coordinates to the clipboard.');
    end
else
    set(handles.ROImessage,'String','Copy appropriate synapse coordinates to the clipboard.');
end

% --- Executes on button press in remove2.
function remove2_Callback(hObject, eventdata, handles)
% hObject    handle to remove2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Flist
Mat=round(str2num(clipboard('paste')));
if size(Mat,2)==3
    Mat(:,3)=Mat(:,3)/10;
    M=size(Flist,1);N=size(Mat,1);Flag=0;
    list=zeros(1,N);%消去するシナプスのリスト
    %クリップボード中の座標がFlistに含まれているか確認
    for I=1:N
        for J=1:M
            if all(Flist(J,2:4)==Mat(I,1:3))
                Flag=Flag+1;
                list(I)=Flist(J,1);
            end
        end
    end
    list=sort(list)
    if Flag==N
        Flist = sortrows(Flist,1,'ascend');
        for I=1:N
            Flist(Flist(:,1)==list(I),:)=[];
        end
        Flist(:,1)=1:size(Flist,1);
        set(handles.ROImessage,'String','Specified synapses were removed.');
    else
        set(handles.ROImessage,'String','Copy appropriate synapse coordinates to the clipboard.');
    end
else
    set(handles.ROImessage,'String','Copy appropriate synapse coordinates to the clipboard.');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
