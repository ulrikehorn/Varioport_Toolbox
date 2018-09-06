function varargout = settings_gui(varargin)
% SETTINGS_GUI MATLAB code for settings_gui.fig
%      SETTINGS_GUI, by itself, creates a new SETTINGS_GUI or raises the existing
%      singleton*.
%
%      H = SETTINGS_GUI returns the handle to a new SETTINGS_GUI or the handle to
%      the existing singleton*.
%
%      SETTINGS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETTINGS_GUI.M with the given input arguments.
%
%      SETTINGS_GUI('Property','Value',...) creates a new SETTINGS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before settings_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to settings_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help settings_gui

% Last Modified by GUIDE v2.5 25-Aug-2017 18:22:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @settings_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @settings_gui_OutputFcn, ...
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


% --- Executes just before settings_gui is made visible.
function settings_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to settings_gui (see VARARGIN)

% Choose default command line output for settings_gui
handles.output = hObject;



% UIWAIT makes settings_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%check for settings file and load default values
%folder of toolbox
filename=which('varioport_toolbox');
[location,~,~] = fileparts(filename);
if exist(fullfile(location,'settings.mat'),'file')
    load(fullfile(location,'settings.mat'));
    handles.def_num_blocks = settings.num_blocks;
    handles.def_task_block = settings.task_block;
    handles.def_rest_block = settings.rest_block;
else
    handles.def_num_blocks = 2;
    handles.def_task_block = 18;
    handles.def_rest_block = 18;
end
guidata(hObject, handles) % Update handles structure

% show default values in settings gui
set(handles.num_blocks,'string',handles.def_num_blocks);
set(handles.task_block,'string',handles.def_task_block);
set(handles.rest_block,'string',handles.def_rest_block);

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = settings_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function num_blocks_Callback(hObject, eventdata, handles)
% hObject    handle to num_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_blocks as text
%        str2double(get(hObject,'String')) returns contents of num_blocks as a double
handles.num_blocks_new=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function num_blocks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function task_block_Callback(hObject, eventdata, handles)
% hObject    handle to task_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of task_block as text
%        str2double(get(hObject,'String')) returns contents of task_block as a double
handles.task_block_new=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function task_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to task_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rest_block_Callback(hObject, eventdata, handles)
% hObject    handle to rest_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rest_block as text
%        str2double(get(hObject,'String')) returns contents of rest_block as a double
handles.rest_block_new=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rest_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rest_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=which('varioport_toolbox');
[location,~,~] = fileparts(filename);
% if exist(fullfile(location,'settings.mat'),'file')
% %     load(fullfile(location,'settings.mat'));
% end %maybe for permission to write problems
if isfield(handles,'num_blocks_new')
    settings.num_blocks=handles.num_blocks_new;
else
    settings.num_blocks=handles.def_num_blocks;
end

if isfield(handles,'task_block_new')
    settings.task_block=handles.task_block_new;
else
    settings.task_block=handles.def_task_block;
end
if isfield(handles,'rest_block_new')
    settings.rest_block=handles.rest_block_new;
else
    settings.rest_block=handles.def_rest_block;
end
save_file = fullfile(location, 'settings.mat');
save(save_file, 'settings');
set(handles.user_communication,'String','Settings were saved.');


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes on button press in help_peak_area.
function help_peak_area_Callback(hObject, eventdata, handles)
% hObject    handle to help_peak_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.help_text,'String',{'This defines the radius of the search area around each peak in which other peaks are deleted.',...
    'Depending on the frequency of your design you might want to adjust it.'});
