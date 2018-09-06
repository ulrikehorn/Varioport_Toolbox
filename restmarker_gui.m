function varargout = restmarker_gui(varargin)
% function varargout = restmarker_gui(handles.xy_AUX)
% RESTMARKER_GUI MATLAB code for restmarker_gui.fig
%      RESTMARKER_GUI, by itself, creates a new RESTMARKER_GUI or raises the existing
%      singleton*.
%
%      H = RESTMARKER_GUI returns the handle to a new RESTMARKER_GUI or the handle to
%      the existing singleton*.
%
%      RESTMARKER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESTMARKER_GUI.M with the given input arguments.
%
%      RESTMARKER_GUI('Property','Value',...) creates a new RESTMARKER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before restmarker_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to restmarker_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help restmarker_gui

% Last Modified by GUIDE v2.5 11-Aug-2017 15:34:03

% Ulrike Horn
% ulrike.horn@uni-greifswald.de
% 01.09.2017

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @restmarker_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @restmarker_gui_OutputFcn, ...
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


% --- Executes just before restmarker_gui is made visible.
function restmarker_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to restmarker_gui (see VARARGIN)

% Choose default command line output for restmarker_gui
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
range = getappdata(0,'range');

axes(handles.plot1); % create plot window
cla; % clear plot content
plot(range(:,1), range(:,2));
xlabel({'time (s)'});
ylabel({'AUX (a.u.)'});
handles.dcm_obj = datacursormode;
guidata(hObject, handles);

% UIWAIT makes restmarker_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = restmarker_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c_info = getCursorInfo(handles.dcm_obj);
if isempty(c_info)
    set(handles.Error_text,'String','You did not select anything.');
elseif length(c_info)==1
    set(handles.Error_text,'String','You only selected one data point. Hold shift to select two.');
else
%     display(c_info)
    setappdata(0,'marker',c_info);
    close
end
