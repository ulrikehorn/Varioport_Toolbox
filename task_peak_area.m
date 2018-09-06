function varargout = task_peak_area(varargin)
% TASK_PEAK_AREA MATLAB code for task_peak_area.fig
%      TASK_PEAK_AREA, by itself, creates a new TASK_PEAK_AREA or raises the existing
%      singleton*.
%
%      H = TASK_PEAK_AREA returns the handle to a new TASK_PEAK_AREA or the handle to
%      the existing singleton*.
%
%      TASK_PEAK_AREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TASK_PEAK_AREA.M with the given input arguments.
%
%      TASK_PEAK_AREA('Property','Value',...) creates a new TASK_PEAK_AREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before task_peak_area_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to task_peak_area_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help task_peak_area

% Last Modified by GUIDE v2.5 30-Jan-2018 16:55:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @task_peak_area_OpeningFcn, ...
                   'gui_OutputFcn',  @task_peak_area_OutputFcn, ...
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


% --- Executes just before task_peak_area is made visible.
function task_peak_area_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to task_peak_area (see VARARGIN)

% Choose default command line output for task_peak_area
handles.output = hObject;
handles.xy_AUX = getappdata(0,'xy_AUX');
handles.max_ampu = getappdata(0,'max_ampu');
handles.pmd_name = getappdata(0,'pmd_name');
% Update handles structure
guidata(hObject, handles);

%calculate mean time interval between peaks and use as start value
peak_intervals=handles.max_ampu(2:2:end,1)-handles.max_ampu(1:2:end-1,1);
max_value=max(peak_intervals);
min_value=min(peak_intervals);
handles.area=mean(peak_intervals);
% peak_intervals=handles.max_ampu(2:2:end,1)-handles.max_ampu(1:2:end-1,1);
% handles.area=mean(peak_intervals);
% Update handles structure
guidata(hObject, handles);
task_start_end=[handles.max_ampu(:,1)-handles.area handles.max_ampu(:,1)+handles.area];
i=1;
while i<length(task_start_end)
    while task_start_end(i,2)>task_start_end(i+1,1)
        task_start_end(i,2)=task_start_end(i+1,2);
        task_start_end(i+1,:)=[];
        if (i==length(task_start_end)-1) || (i==length(task_start_end))
            break
        end
    end
    i=i+1;
end
if task_start_end(end-1,2)>task_start_end(end,1)
    task_start_end(end-1,2)=task_start_end(end,2);
    task_start_end(end,:)=[];
end

handles.task_start_end=task_start_end;
% Update handles structure
guidata(hObject, handles);

axes(handles.axes1); % create plot window
cla; % clear plot content
plot_again(handles.xy_AUX,handles.pmd_name,'peaks',handles.max_ampu,'task',task_start_end);

% UIWAIT makes task_peak_area wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = task_peak_area_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.area = get(handles.slider1,'Value');
% Update handles structure
guidata(hObject, handles);
set(handles.slider_value,'String',num2str(handles.area));

task_start_end=[handles.max_ampu(:,1)-handles.area handles.max_ampu(:,1)+handles.area];
i=1;
while i<length(task_start_end)
    while task_start_end(i,2)>task_start_end(i+1,1)
        task_start_end(i,2)=task_start_end(i+1,2);
        task_start_end(i+1,:)=[];
        if (i==length(task_start_end)-1) || (i==length(task_start_end))
            break
        end
    end
    i=i+1;
end
if task_start_end(end-1,2)>task_start_end(end,1)
    task_start_end(end-1,2)=task_start_end(end,2);
    task_start_end(end,:)=[];
end
handles.task_start_end=task_start_end;
% Update handles structure
guidata(hObject, handles);
axes(handles.axes1); % create plot window
cla; % clear plot content
plot_again(handles.xy_AUX,handles.pmd_name,'peaks',handles.max_ampu,'task',task_start_end);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
max_ampu = getappdata(0,'max_ampu');
%calculate mean time interval between peaks and use as start value
peak_intervals=max_ampu(2:2:end,1)-max_ampu(1:2:end-1,1);
% area=mean(peak_intervals);

max_value=max(peak_intervals);
min_value = min(peak_intervals);
area=mean(peak_intervals);
%area=(max_value+min_value)/2;

set(hObject,'Min',min_value);
set(hObject,'Max',max_value);
set(hObject,'Value',area);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0,'task_start_end',handles.task_start_end);
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'task_start_end',handles.task_start_end);
close