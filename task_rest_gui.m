function varargout = task_rest_gui(varargin)
% TASK_REST_GUI MATLAB code for task_rest_gui.fig
%      TASK_REST_GUI, by itself, creates a new TASK_REST_GUI or raises the existing
%      singleton*.
%
%      H = TASK_REST_GUI returns the handle to a new TASK_REST_GUI or the handle to
%      the existing singleton*.
%
%      TASK_REST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TASK_REST_GUI.M with the given input arguments.
%
%      TASK_REST_GUI('Property','Value',...) creates a new TASK_REST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before task_rest_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to task_rest_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help task_rest_gui

% Last Modified by GUIDE v2.5 31-Jan-2018 13:34:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @task_rest_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @task_rest_gui_OutputFcn, ...
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


% --- Executes just before task_rest_gui is made visible.
function task_rest_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to task_rest_gui (see VARARGIN)

% Choose default command line output for task_rest_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.xy_data = getappdata(0,'xy_data');
pmd_file = getappdata(0,'pmd_file');
handles.data_type = getappdata(0,'data_type');
handles.crest_start = getappdata(0,'crest_start');
handles.xy_peaks = getappdata(0,'xy_peaks');
handles.data_rate = getappdata(0,'data_rate');
[handles.pmd_path,handles.pmd_name, ~] = fileparts(pmd_file);
handles.design=[];
handles.saved=0;
handles.marker=handles.crest_start;
guidata(hObject, handles);

axes(handles.plot1); % create plot window
cla; % clear plot content
if handles.crest_start~=0
    plot_again(handles.xy_data,handles.pmd_name,handles.data_type,'marker',handles.crest_start,'peaks',handles.xy_peaks);
else
    plot_again(handles.xy_data,handles.pmd_name,handles.data_type,'peaks',handles.xy_peaks);
end
guidata(hObject, handles);
[handles.marker,handles.design]=find_task_and_rest(handles.xy_data,handles.xy_peaks,handles.pmd_name,handles.crest_start,handles.data_rate);
guidata(hObject, handles);
if isempty(handles.marker)
    set(handles.text2,'String','The design have not been defined. Please click on <change design>.');
else
    task_start_end=cell2mat(handles.design(strcmp(handles.design(:,4),'task'),2:3));
    plot_again(handles.xy_data,handles.pmd_name,handles.data_type,'marker',handles.marker,'peaks',handles.xy_peaks,'task',task_start_end);
end
% UIWAIT makes task_rest_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = task_rest_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
task_file_name = strcat(handles.pmd_name,'_design');
if ~isempty(handles.design)
    design=handles.design;
    setappdata(0,'design',handles.design);
    save(fullfile(handles.pmd_path,task_file_name), 'design');
    handles.saved=1;
    set(handles.text2,'String','Design has been saved.');
    guidata(hObject, handles);
else
    set(handles.text2,'String','Design has not been calculated. Nothing was saved.');
end

% --- Executes on button press in changebutton.
function changebutton_Callback(hObject, eventdata, handles)
% hObject    handle to changebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.saved=0;
set(handles.text2,'String','');
[handles.marker,handles.design]=find_task_and_rest(handles.xy_data,handles.xy_peaks,handles.pmd_name,handles.crest_start,handles.data_rate);
guidata(hObject, handles);
if ~isempty(handles.marker)
    axes(handles.plot1); % create plot window
    cla; % clear plot content
    task_start_end=cell2mat(handles.design(strcmp(handles.design(:,4),'task'),2:3));
    plot_again(handles.xy_data,handles.pmd_name,handles.data_type,'marker',handles.marker,'peaks',handles.xy_peaks,'task',task_start_end);
end

% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close %see close request function


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.marker)
    setappdata(0,'marker',handles.marker);
    if handles.saved==0
        promptMessage = sprintf('Do you want to save the changes?');
        button = questdlg(promptMessage, 'Warning', 'Save design', 'Do not save', 'Cancel', 'Cancel');
        if strcmpi(button, 'Do not save')
            delete(hObject);
        end
        if strcmpi(button, 'Cancel')
            % stay in gui
        end
        if strcmpi(button, 'Save design')
            task_file_name = strcat(handles.pmd_name,'_design');
            if ~isempty(handles.design)
                design=handles.design;
                save(fullfile(handles.pmd_path,task_file_name), 'design');
                setappdata(0,'design',handles.design);
                set(handles.text2,'String','Design has been saved.');
            else
                set(handles.text2,'String','Design has not been calculated. Nothing was saved.');
            end
            delete(hObject);
        end
    else
        delete(hObject);
    end
else
    delete(hObject);
end

