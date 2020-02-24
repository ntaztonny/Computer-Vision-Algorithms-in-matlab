function varargout = CCProjGUIFrame(varargin)
% CCPROJGUIFRAME MATLAB code for CCProjGUIFrame.fig
%      CCPROJGUIFRAME, by itself, creates a new CCPROJGUIFRAME or raises the existing
%      singleton*.
%
%      H = CCPROJGUIFRAME returns the handle to a new CCPROJGUIFRAME or the handle to
%      the existing singleton*.
%
%      CCPROJGUIFRAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CCPROJGUIFRAME.M with the given input arguments.
%
%      CCPROJGUIFRAME('Property','Value',...) creates a new CCPROJGUIFRAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CCProjGUIFrame_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CCProjGUIFrame_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CCProjGUIFrame

% Last Modified by GUIDE v2.5 14-May-2017 02:16:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CCProjGUIFrame_OpeningFcn, ...
                   'gui_OutputFcn',  @CCProjGUIFrame_OutputFcn, ...
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


% --- Executes just before CCProjGUIFrame is made visible.
function CCProjGUIFrame_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CCProjGUIFrame (see VARARGIN)

% Choose default command line output for CCProjGUIFrame
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global v;
global frame;
global numFrames;


global Q_L;
global Q_C;
global zigZag;
Q_L = [ 16 11 10 16 24  40  51  61  ;...
        12 12 14 19 26  58  60  55  ;...
        14 13 16 24 40  57  69  56  ;...
        14 17 22 29 51  87  80  62  ;...
        18 22 37 56 68  109 103 77  ;...
        24 36 55 64 81  104 113 92  ;...
        49 64 78 87 103 121 120 101 ;...
        72 92 95 98 112 100 103 99  ];
    
Q_C = [ 17 18 24 47 99 99 99 99  ;...
        18 21 26 66 99 99 99 99  ;...
        24 26 56 99 99 99 99 99  ;...
        47 66 99 99 99 99 99 99  ;...
        99 99 99 99 99 99 99 99  ;...
        99 99 99 99 99 99 99 99  ;...
        99 99 99 99 99 99 99 99  ;...
        99 99 99 99 99 99 99 99  ];
    
zigZag = [  1 2 9 17 10 3 4 11 ...
            18 25 33 26 19 12 5 6 ...
            13 20 27 34 41 49 42 35 ...
            28 21 14 7 8 15 22 29  ...
            36 43 50 57 58 51 44 37 ...
            30 23 16 24 31 38 45 52 ...
            59 60 53 46 39 32 40 47 ...
            54 61 62 55 48 56 63 64];
        

if(isempty(v))
    set(handles.text16, 'String', ['Error!' char(10) 'Run the other file (ProjectGUI)!']);
    frame = [];
    numFrames = 0;
else
    v.CurrentTime = 0.0;
    vidHeight = v.Height;
    vidWidth = v.Width;
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);
    numFrames = 1; 
    while hasFrame(v)
        s(numFrames).cdata = readFrame(v);
        if(numFrames == 1)
            frame = s(numFrames).cdata;
        end
        numFrames = numFrames + 1;
    end
    axes(handles.axesextracted);
    imshow(frame);
    set(handles.FrameNo, 'String', '1');
    set(handles.text16, 'String', ['Select Frame Num -> [1,' num2str(numFrames) ']!']);
end


% UIWAIT makes CCProjGUIFrame wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CCProjGUIFrame_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function FrameNo_Callback(hObject, eventdata, handles)
% hObject    handle to FrameNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameNo as text
%        str2double(get(hObject,'String')) returns contents of FrameNo as a double
% global frame;
% frame = str2double(get(handles.FrameNo,'string'));

% --- Executes during object creation, after setting all properties.
function FrameNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Get the current string in the text box.



%Save the compressed frame to disk
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% We did everything we can but we had a hard time to save the frame to
% disk. We found matlab scripts that we used as reference but still we
% could not save the frame. The scripts are jpeg_encoder.m and huffman.m.




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

function edit2compressrate_Callback(hObject, eventdata, handles)
% hObject    handle to edit2compressrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2compressrate as text
%        str2double(get(hObject,'String')) returns contents of edit2compressrate as a double


% --- Executes during object creation, after setting all properties.
function edit2compressrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2compressrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3bitrate_Callback(hObject, eventdata, handles)
% hObject    handle to edit3bitrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3bitrate as text
%        str2double(get(hObject,'String')) returns contents of edit3bitrate as a double


% --- Executes during object creation, after setting all properties.
function edit3bitrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3bitrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4rmserror_Callback(hObject, eventdata, handles)
% hObject    handle to edit4rmserror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4rmserror as text
%        str2double(get(hObject,'String')) returns contents of edit4rmserror as a double


% --- Executes during object creation, after setting all properties.
function edit4rmserror_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4rmserror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5psnr_Callback(hObject, eventdata, handles)
% hObject    handle to edit5psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5psnr as text
%        str2double(get(hObject,'String')) returns contents of edit5psnr as a double


% --- Executes during object creation, after setting all properties.
function edit5psnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5psnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Start Compression of extracted Frame and display intermediate steps and
%compressed frame on specific axes.
% --- Executes on button press in pushbutton4start.
function pushbutton4start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frame;
global numFrames;
global Q_L;
global Q_C;
global zigZag;

if(isempty(frame))
    set(handles.text16, 'String', ['Encoding : Error!' ...
        char(10) 'Select Frame Num -> [1,' num2str(numFrames) ']!']);
end
img = frame;
[rOrg,cOrg,~]=size(img);
rSamp=ceil(rOrg/8);
cSamp=ceil(cOrg/8);
% Convert and subsample color
imgYcBcR = rgb2ycbcr(img);
imgSampYcBcR = uint8(zeros(rSamp*8,cSamp*8,3));
imgSampYcBcR(1:rOrg,1:cOrg,:) = imgYcBcR;

axes(handles.axes3colorconversion);set(handles.text16, 'String', ['Encoding : Start!' char(10) 'Loading ...']);

imshow(imgYcBcR,[]);
%imshow(imgSampYcBcR,[]);

%DCT
imgSampYcBcR_d = double(imgSampYcBcR);
imgc = zeros(size(imgSampYcBcR));
imgDct = zeros(size(imgSampYcBcR,1),size(imgSampYcBcR,2));
bloc8qZ = cell(rSamp,cSamp);
% i=1; j=1;
for i=1:rSamp
    for j=1:cSamp
        % Pick 8x8 blocks of an image
        bloc8Y = imgSampYcBcR_d(1+(i-1)*8:i*8,1+(j-1)*8:j*8,1)-128;
        bloc8U = imgSampYcBcR_d(1+(i-1)*8:i*8,1+(j-1)*8:j*8,2)-128;
        bloc8V = imgSampYcBcR_d(1+(i-1)*8:i*8,1+(j-1)*8:j*8,3)-128;
        % Applying DCT 
        bloc8Yd = dct2(bloc8Y);
        bloc8Ud = dct2(bloc8U);
        bloc8Vd = dct2(bloc8V);
        imgDct(1+(i-1)*8:i*8,1+(j-1)*8:j*8) = bloc8Yd;
        % Quantization step using the matrix Q_L and Q_C
        bloc8Ydq = round(bloc8Yd./Q_L);
        bloc8Udq = round(bloc8Ud./Q_C);
        bloc8Vdq = round(bloc8Vd./Q_C);
        % Zig-zag ordering
        bloc8YdqZ = bloc8Ydq(zigZag)';
        bloc8UdqZ = bloc8Udq(zigZag)';
        bloc8VdqZ = bloc8Vdq(zigZag)';
        
        bloc8qZ{i,j} = cat(2,bloc8YdqZ,bloc8UdqZ,bloc8VdqZ);
        
        bloc8Ydc = bloc8Ydq.*Q_L;
        bloc8Udc = bloc8Udq.*Q_C;
        bloc8Vdc = bloc8Vdq.*Q_C;
        bloc8Yc = idct2(bloc8Ydc);
        bloc8Uc = idct2(bloc8Udc);
        bloc8Vc = idct2(bloc8Vdc);
        imgc(1+(i-1)*8:i*8,1+(j-1)*8:j*8,1) = bloc8Yc+128;
        imgc(1+(i-1)*8:i*8,1+(j-1)*8:j*8,2) = bloc8Uc+128;
        imgc(1+(i-1)*8:i*8,1+(j-1)*8:j*8,3) = bloc8Vc+128;
    end
end

imgcSamp = uint8(imgc(1:rOrg,1:cOrg,:));
imgcRGB = ycbcr2rgb(imgcSamp);

axes(handles.axes4dct);
imshow(uint8(imgDct(1:rOrg,1:cOrg,:)),[]);

axes(handles.axes6quantization);
imshow(imgcSamp,[]);

axes(handles.axes2compressed);
imshow(imgcRGB,[]);


% evaluation criteria for compression
% -- RMS
%- ref: https://fr.mathworks.com/matlabcentral/answers/50470-how-to-obtain-rms-error
difference = single(imgcRGB) - single(img);
squaredError = difference .^ 2;
meanSquaredError = sum(squaredError(:)) / numel(img);
rmsError = sqrt(meanSquaredError);
psnr = -10*log10(meanSquaredError);
set(handles.edit4rmserror,'string',num2str(rmsError));
set(handles.edit5psnr,'string',num2str(psnr));
% -- Compression Ratio
%- ref: https://fr.mathworks.com/matlabcentral/fileexchange/13584-compression-ratio
imwrite(imgcRGB,'test.jpg');
k=imfinfo('test.jpg');
ib=k.Width*k.Height*k.BitDepth/8;
cb=k.FileSize;
cr=ib/cb;
set(handles.edit2compressrate,'string',num2str(cr));

BitRate=8/cr;
set(handles.edit3bitrate,'string',num2str(BitRate));

set(handles.text16, 'String', ['Encoding : Start!' char(10) 'Encoding : End!']);

%selecting frame and loading it.
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global v;
global frame;
global numFrames;

fNum = str2num(get(handles.FrameNo, 'string'));

if(~isempty(v) && fNum >= 1 && fNum <=numFrames)
    vidHeight = v.Height;
    vidWidth = v.Width;
    v.CurrentTime = 0.0;
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);
    k = 1;
    while hasFrame(v)
        s(k).cdata = readFrame(v);
        if(k==fNum)
            frame = s(k).cdata;
        end
        k = k+1;
    end
    axes(handles.axesextracted);
    imshow(frame);
    set(handles.text16, 'String', ['Frame #' num2str(fNum) ' : Selected!']);
else
    frame = [];
    cla(handles.axesextracted,'reset');
    set(handles.text16, 'String', ['Frame #' num2str(fNum) ' : Error!' ...
        char(10) 'Select Frame Num -> [1,' num2str(numFrames) ']!']);
end
