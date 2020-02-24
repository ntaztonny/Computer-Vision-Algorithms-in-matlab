function varargout = CCProjectGUI(varargin)
% CCPROJECTGUI MATLAB code for CCProjectGUI.fig
%      CCPROJECTGUI, by itself, creates a new CCPROJECTGUI or raises the existing
%      singleton*.
%
%      H = CCPROJECTGUI returns the handle to a new CCPROJECTGUI or the handle to
%      the existing singleton*.
%
%      CCPROJECTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CCPROJECTGUI.M with the given input arguments.
%
%      CCPROJECTGUI('Property','Value',...) creates a new CCPROJECTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CCProjectGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CCProjectGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CCProjectGUI

% Last Modified by GUIDE v2.5 14-May-2017 02:18:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CCProjectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CCProjectGUI_OutputFcn, ...
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

%Main Gui for Loading, Playing/preview, and Compression of Video Using JPEG
%encoder

% --- Executes just before CCProjectGUI is made visible.
function CCProjectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CCProjectGUI (see VARARGIN)

% Choose default command line output for CCProjectGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global v; % make the video global to be utilized by other functions
v = [];



% UIWAIT makes CCProjectGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CCProjectGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonload.
function pushbuttonload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Load the video on GUI

global v;
[FileName,PathName] = uigetfile({'*.avi;''*.mpg;''*.*','All Files' },'Select video files only!'); %allow user to select video from a folder
v = VideoReader(fullfile(PathName,FileName)); % read video
vidHeight = v.Height; %Determine the height and width of the frames.
vidWidth = v.Width;
axes(handles.axesmain);
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]); % Create a MATLAB® movie structure array, s.
v.CurrentTime = 0.0;
k=1;

%Read one frame at a time using readFrame until the end of the file is reached. 
%Append data from each video frame to the structure array.
if(hasFrame(v))
    s(k).cdata = readFrame(v);
    image(s(k).cdata);
end
set(handles.text5, 'String', ['Video load!' char(10) 'Ready to Play!']);

% Reference: https://fr.mathworks.com/help/matlab/import_export/read-video-files.html


% --- Executes on button press in pushbuttoninstruct.
function pushbuttoninstruct_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttoninstruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('CCProjGUIInstruction');% directs to another GUI which instructs the user about the process

% --- Executes on button press in pushbuttonstop.
function pushbuttonstop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global v;
v=[];
close; % closes video

%Play the video or display a preview of it.
% --- Executes on button press in pushbuttonplayprev.
function pushbuttonplayprev_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonplayprev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global v;
if(~isempty(v))
    set(handles.text5, 'String', 'Video start!');
    vidHeight = v.Height;
    vidWidth = v.Width;
    axes(handles.axesmain);
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
        'colormap',[]);
    v.CurrentTime = 0.0;
    k = 1;
    while hasFrame(v)
        s(k).cdata = readFrame(v);
        image(s(k).cdata);
        k = k+1;
    end
    set(handles.text5, 'String', ['Video start!' char(10) ...
       'Video finish!']);
else
    set(handles.text5, 'String', ['Error to play!' char(10) ...
        'Load a proper video!']);
end



% ideally, this would be the algorithm for compression of the video if each
% frame was saved to disk. 

% --- Executes on button press in pushbuttonvideo.
function pushbuttonvideo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonvideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frame;
global Q_L;
global Q_C;
global zigZag;
global v;

% frame = compressed and saved frame
k = 1;
while hasFrame(v)
    frame = readFrame(v); 
    img = frame;
    
    % Apply jpeg to each frame
    [rOrg,cOrg,~]=size(img);
    rSamp=ceil(rOrg/8);
    cSamp=ceil(cOrg/8);
    % Convert and subsample color
    imgYcBcR = rgb2ycbcr(img);
    imgSampYcBcR = uint8(zeros(rSamp*8,cSamp*8,3));
    imgSampYcBcR(1:rOrg,1:cOrg,:) = imgYcBcR;

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
    k = k+1;
end


% --- Executes on button press in pushbuttonframe.
function pushbuttonframe_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global v;
if(~isempty(v))
    CCProjGUIFrame; % directs to another GUI which is for the extracted frame           
else
    set(handles.text5, 'String', ['Error to encode!' char(10) ...
        'Load a proper video!']);
end

% References: 
% https://fr.mathworks.com/matlabcentral/answers/70476-how-to-close-a-gui-and-open-another-gui-in-the-callback-code


% --- Executes on button press in pushbuttonexit.
function pushbuttonexit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(CCProjectGUI); close(CCProjGUIInstruction); close(CCProjGUIFrame); % closes all GUI
