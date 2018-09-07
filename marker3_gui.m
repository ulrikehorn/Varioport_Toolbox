function varargout = marker3_gui(varargin)
% function varargout = marker3_gui(handles.xy_AUX)
% MARKER3_GUI MATLAB code for marker3_gui.fig
%      MARKER3_GUI, by itself, creates a new MARKER3_GUI or raises the existing
%      singleton*.
%
%      H = MARKER3_GUI returns the handle to a new MARKER3_GUI or the handle to
%      the existing singleton*.
%
%      MARKER3_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARKER3_GUI.M with the given input arguments.
%
%      MARKER3_GUI('Property','Value',...) creates a new MARKER3_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before marker3_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to marker3_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help marker3_gui

% Last Modified by GUIDE v2.5 11-Aug-2017 14:34:49

% Ulrike Horn
% ulrike.horn@uni-greifswald.de
% 31.08.2017

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @marker3_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @marker3_gui_OutputFcn, ...
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


% --- Executes just before marker3_gui is made visible.
function marker3_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to marker3_gui (see VARARGIN)

% Choose default command line output for marker3_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% 
xy_data = getappdata(0,'xy_data');

axes(handles.plot1); % create plot window
cla; % clear plot content
plot (xy_data(20:end, 1), xy_data(20:end, 2), 'k');
axis ( [ min(xy_data(20:end, 1)) max(xy_data(20:end, 1)) ...
    min(xy_data(20:end, 2)) max(xy_data(20:end, 2)) ] );
xlabel({'time (s)'});
ylabel({'data (a.u.)'});
handles.dcm_obj = datacursormode;
guidata(hObject, handles);

% UIWAIT makes marker3_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = marker3_gui_OutputFcn(hObject, eventdata, handles) 
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
else
    setappdata(0,'marker3',c_info.Position(1));
    close
end
