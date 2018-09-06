function varargout = peak_gui(varargin)
% PEAK_GUI MATLAB code for peak_gui.fig
%      PEAK_GUI, by itself, creates a new PEAK_GUI or raises the existing
%      singleton*.
%
%      H = PEAK_GUI returns the handle to a new PEAK_GUI or the handle to
%      the existing singleton*.
%
%      PEAK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEAK_GUI.M with the given input arguments.
%
%      PEAK_GUI('Property','Value',...) creates a new PEAK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before peak_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to peak_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help peak_gui

% Last Modified by GUIDE v2.5 31-Jan-2018 13:18:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @peak_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @peak_gui_OutputFcn, ...
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


% --- Executes just before peak_gui is made visible.
function peak_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to peak_gui (see VARARGIN)

% Choose default command line output for peak_gui
handles.output = hObject;
%default values
handles.amp=700;
handles.prom=50;
handles.xy_AUX = getappdata(0,'xy_AUX');
handles.maxampu=[];
% Update handles structure
guidata(hObject, handles);

axes(handles.axes1); % create plot window
cla; % clear plot content
plot (handles.xy_AUX(20:end, 1), handles.xy_AUX(20:end, 2), 'k');
axis ( [ min(handles.xy_AUX(20:end, 1)) max(handles.xy_AUX(20:end, 1)) ...
    min(handles.xy_AUX(20:end, 2)) max(handles.xy_AUX(20:end, 2)) ] );
xlabel({'time (s)'});
ylabel({'AUX (a.u.)'});

[pks,locs]=findpeaks(handles.xy_AUX(20:end,2),handles.xy_AUX(20:end,1),'MinPeakHeight',handles.amp,'MinPeakProminence',handles.prom);
handles.maxampu=[locs,pks];
% Update handles structure
guidata(hObject, handles);
% plot the found maxima on the previous graph
hold on;
plot (handles.maxampu(:,1), handles.maxampu(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'b', 'LineStyle', 'none');
% UIWAIT makes peak_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = peak_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function prom_slider_Callback(hObject, eventdata, handles)
% hObject    handle to prom_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.prom = get(handles.prom_slider,'Value');
% Update handles structure
guidata(hObject, handles);
axes(handles.axes1); % create plot window
cla; % clear plot content
plot (handles.xy_AUX(20:end, 1), handles.xy_AUX(20:end, 2), 'k');
axis ( [ min(handles.xy_AUX(20:end, 1)) max(handles.xy_AUX(20:end, 1)) ...
    min(handles.xy_AUX(20:end, 2)) max(handles.xy_AUX(20:end, 2)) ] );
xlabel({'time (s)'});
ylabel({'AUX (a.u.)'});
[pks,locs]=findpeaks(handles.xy_AUX(20:end,2),handles.xy_AUX(20:end,1),'MinPeakHeight',handles.amp,'MinPeakProminence',handles.prom);
handles.maxampu=[locs,pks];
% Update handles structure
guidata(hObject, handles);
% plot the found maxima on the previous graph
hold on;
plot (handles.maxampu(:,1), handles.maxampu(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'b', 'LineStyle', 'none');
set(handles.prom_slider_value,'String',num2str(handles.prom));

% --- Executes during object creation, after setting all properties.
function prom_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prom_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Min',0);
set(hObject,'Max',100);
set(hObject,'Value',50);

% --- Executes on slider movement.
function amp_slider_Callback(hObject, eventdata, handles)
% hObject    handle to amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.amp = get(handles.amp_slider,'Value');
% Update handles structure
guidata(hObject, handles);
axes(handles.axes1); % create plot window
cla; % clear plot content
plot (handles.xy_AUX(20:end, 1), handles.xy_AUX(20:end, 2), 'k');
axis ( [ min(handles.xy_AUX(20:end, 1)) max(handles.xy_AUX(20:end, 1)) ...
    min(handles.xy_AUX(20:end, 2)) max(handles.xy_AUX(20:end, 2)) ] );
xlabel({'time (s)'});
ylabel({'AUX (a.u.)'});
[pks,locs]=findpeaks(handles.xy_AUX(20:end,2),handles.xy_AUX(20:end,1),'MinPeakHeight',handles.amp,'MinPeakProminence',handles.prom);
handles.maxampu=[locs,pks];
% Update handles structure
guidata(hObject, handles);
% plot the found maxima on the previous graph
hold on;
plot (handles.maxampu(:,1), handles.maxampu(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'b', 'LineStyle', 'none');
set(handles.amp_slider_value,'String',num2str(handles.amp));

% --- Executes during object creation, after setting all properties.
function amp_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Min',0);
set(hObject,'Max',3000);
set(hObject,'Value',700);


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.maxampu)
    set(handles.Error_text,'String','There are no peaks.');
else
    setappdata(0,'max_ampu',handles.maxampu);
    close
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0,'max_ampu',handles.maxampu);
% Hint: delete(hObject) closes the figure
delete(hObject);
