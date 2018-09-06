function varargout = varioport_toolbox(varargin)

% VARIOPORT_TOOLBOX MATLAB code for varioport_toolbox.fig
%      VARIOPORT_TOOLBOX, by itself, creates a new VARIOPORT_TOOLBOX or raises the existing
%      singleton*.
%
%      H = VARIOPORT_TOOLBOX returns the handle to a new VARIOPORT_TOOLBOX or the handle to
%      the existing singleton*.
%
%      VARIOPORT_TOOLBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VARIOPORT_TOOLBOX.M with the given input arguments.
%
%      VARIOPORT_TOOLBOX('Property','Value',...) creates a new VARIOPORT_TOOLBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the VARIOPORT_TOOLBOX before varioport_toolbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to varioport_toolbox_OpeningFcn via varargin.
%
%      *See VARIOPORT_TOOLBOX Options on GUIDE's Tools menu.  Choose "VARIOPORT_TOOLBOX allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help varioport_toolbox

% Last Modified by GUIDE v2.5 25-Aug-2017 16:25:18

% Ulrike Horn
% ulrike.horn@uni-greifswald.de
% 31.08.2017


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @varioport_toolbox_OpeningFcn, ...
    'gui_OutputFcn',  @varioport_toolbox_OutputFcn, ...
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

clear
% --- Executes just before varioport_toolbox is made visible.
function varioport_toolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to varioport_toolbox (see VARARGIN)

% Choose default command line output for varioport_toolbox
handles.output = hObject;

% initialize several variable handles to pass them to many functions
handles.pmd_file = hObject;
handles.pmd_file = '';
handles.xy_AUX = hObject;
handles.xy_AUX = [];
handles.data_rate = hObject;
handles.data_rate = [];
handles.marker_exists = hObject;
handles.marker_exists = [];
handles.max_ampu = hObject;
handles.max_ampu = {};
handles.design = hObject;
handles.design = {};
handles.corr_max_ampu = hObject;
handles.corr_max_ampu = {};
handles.crest_start = hObject;
handles.crest_start = [];


% Update handles structure
guidata(hObject, handles);

% Plot Initialisierung
if strcmp(get(hObject,'Visible'),'off')
    cla reset;
end



% UIWAIT makes varioport_toolbox wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = varioport_toolbox_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------------------------------------------------------------
% [handles.pmd_file,handles.xy_AUX,handles.data_rate,handles.marker_exists,xy_Marker]=open_pmd;
% User chooses a pmd file to open
% Function opens file and checks which channels are used and returns info to main function
[handles.pmd_file,handles.data_rate,handles.sorted_active_channels,handles.pmd_data] = open_pmd;
%-------------------------------------------------------------------------------------
guidata(hObject, handles)
% if no file has been chosen
if handles.pmd_file==0
    return
else
    %delete handles from previous sessions
    handles.crest_start = [];
    handles.max_ampu = [];
    handles.corr_max_ampu = [];
    %show file name
    set(handles.file_name_output,'String',handles.pmd_file);
    [~,pmd_name, ~] = fileparts(handles.pmd_file);
    guidata(hObject, handles)
    
    xy_data=load_channel_data(handles.pmd_file,handles.data_rate,handles.sorted_active_channels,handles.pmd_data);
    
    
    if handles.marker_exists
        %-------------------------------------------------------------------------------------
        [handles.crest_start]=calculate_blocks_with_marker(handles.xy_AUX,handles.data_rate,xy_Marker);
        guidata(hObject, handles) % Update handles structure
        %-------------------------------------------------------------------------------------
        set(handles.protocol,'String',{'Successfully loaded AUX data and saved it in a figure.',...
            'The marker was used for defining the analysis blocks.'});
        axes(handles.plot1); % create plot window
        cla; % clear plot content
        plot_again(handles.xy_AUX,pmd_name,'marker',handles.crest_start)
    else
        set(handles.protocol,'String',{'Successfully loaded AUX data and saved it in a figure.',...
            'There is no marker to use for defining the analysis blocks.'});
        axes(handles.plot1); % create plot window
        cla; % clear plot content
        plot_again(handles.xy_AUX,pmd_name)
    end
end

% --- Executes on button press in find_peaks_button.
function find_peaks_button_Callback(hObject, eventdata, handles)
% hObject    handle to find_peaks_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.pmd_file)
    errordlg('Load a file first.','Error');
else
    [pmd_path,pmd_name, ~] = fileparts(handles.pmd_file);
    %-------------------------------------------------------------------------------------
    setappdata(0,'xy_AUX',handles.xy_AUX);
    peak_gui
    uiwait;
    handles.max_ampu = getappdata(0,'max_ampu');
    %-------------------------------------------------------------------------------------
    guidata(hObject, handles) % Update handles structure
    strings=get(handles.protocol,'String');
    strings(length(strings)+1)={'Several peaks have been found and saved.'};
    set(handles.protocol,'String',strings);
    strings=get(handles.protocol,'String');
    strings(length(strings)+1)={'Check the design to define where the background should be.'};
    set(handles.protocol,'String',strings);
    peaksname = strcat(pmd_name,'_peaks');
    max_ampu=handles.max_ampu;
    save(fullfile(pmd_path,peaksname), 'max_ampu');
    if ~isempty(handles.crest_start)
        plot_again(handles.xy_AUX,pmd_name,'marker',handles.crest_start,'peaks',max_ampu);
    else
        plot_again(handles.xy_AUX,pmd_name,'peaks',max_ampu);
    end
end

% --- Executes on button press in define_blocks_button.
function define_blocks_button_Callback(hObject, eventdata, handles)
% hObject    handle to define_blocks_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.pmd_file)
    errordlg('Load a file first.','Error');
else
    if isempty(handles.max_ampu) %no peaks have been defined in this session
        [pmd_path,pmd_name, ~] = fileparts(handles.pmd_file);
        if ~exist(strcat(fullfile(pmd_path,pmd_name),'_peaks.mat'),'file') % and there is no peaks file from another session
            errordlg('Please define peaks first.','Error');
            return
        else
            %ask if the user wants to load the old peak file
            promptMessage = sprintf('There is already a file with calculated peaks.\n Do you want to use it?');
            button = questdlg(promptMessage, 'Warning', 'Yes', 'No', 'No');
            if strcmpi(button, 'Yes')
                load(strcat(fullfile(pmd_path,pmd_name),'_peaks.mat'), 'max_ampu');
                handles.max_ampu=max_ampu;
                guidata(hObject, handles) % Update handles structure
            end
            if strcmpi(button, 'No')
                errordlg('Then define new peaks by clicking on the button "Find peaks".','Error');
                return
            end
        end
    end
    setappdata(0,'xy_AUX',handles.xy_AUX);
    setappdata(0,'pmd_file',handles.pmd_file);
    setappdata(0,'max_ampu',handles.max_ampu);
    setappdata(0,'data_rate',handles.data_rate);
    if ~isempty(handles.crest_start)
        setappdata(0,'crest_start',handles.crest_start);
    else
        setappdata(0,'crest_start',0);
    end
    %-------------------------------------------------------------------------------------
    task_rest_gui
    %-------------------------------------------------------------------------------------
    uiwait;
    handles.marker = getappdata(0,'marker');
    handles.design = getappdata(0,'design');
    guidata(hObject, handles) % Update handles structure
    [~,pmd_name, ~] = fileparts(handles.pmd_file);
    if isempty(handles.design)
        errordlg('No design definition found.','Error');
        return
    else
        task_start_end=cell2mat(handles.design(strcmp(handles.design(:,4),'task'),2:3));
        plot_again(handles.xy_AUX,pmd_name,'marker',handles.marker,'peaks',handles.max_ampu,'task',task_start_end);
    end
end


% --- Executes on button press in substract_background_button.
function substract_background_button_Callback(hObject, eventdata, handles)
% hObject    handle to substract_background_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.pmd_file)
    errordlg('Load a file first.','Error');
    return
else
    [pmd_path,pmd_name, ~] = fileparts(handles.pmd_file);
    if isempty(handles.max_ampu) %no peaks have been defined in this session
        if ~exist(strcat(fullfile(pmd_path,pmd_name),'_peaks.mat'),'file') % and there is no peaks file from another session
            errordlg('Define peaks first.','Error');
            return
        else
            %ask if the user wants to load the old peak file
            promptMessage = sprintf('There is already a file with calculated peaks.\n Do you want to use it?');
            button = questdlg(promptMessage, 'Warning', 'Yes', 'No', 'No');
            if strcmpi(button, 'Yes')
                load(strcat(fullfile(pmd_path,pmd_name),'_peaks.mat'), 'max_ampu');
                handles.max_ampu=max_ampu;
                guidata(hObject, handles) % Update handles structure
            end
            if strcmpi(button, 'No')
                errordlg('Then define new peaks by clicking on the button "find peaks".','Error');
                return
            end
        end
    end
    
    if isempty(handles.design)
        if ~exist(strcat(fullfile(pmd_path,pmd_name),'_design.mat'),'file')
            errordlg('No design definition found.','Error');
            return
        else
            %ask if the user wants to load the old design file
            promptMessage = sprintf('There is already a file with calculated peaks.\n Do you want to use it?');
            button = questdlg(promptMessage, 'Warning', 'Yes', 'No', 'No');
            if strcmpi(button, 'Yes')
                load(strcat(fullfile(pmd_path,pmd_name),'_design.mat'), 'design');
                handles.design=design;
                guidata(hObject, handles) % Update handles structure
            end
            if strcmpi(button, 'No')
                errordlg('Then define a new design by clicking on the button "check design".','Error');
                return
            end
        end
    end
    %-------------------------------------------------------------------------------------
    [handles.corr_max_ampu,mean_bkgr]=substract_background(handles.xy_AUX,handles.max_ampu,handles.design);
    %-------------------------------------------------------------------------------------
    guidata(hObject, handles) % Update handles structure
    task_start_end=cell2mat(handles.design(strcmp(handles.design(:,4),'task'),2:3));
    plot_again(handles.xy_AUX,pmd_name,'marker',handles.marker,'peaks',handles.max_ampu,'task',task_start_end,'background',mean_bkgr);
    strings=get(handles.protocol,'String');
    strings(length(strings)+1)={'The amplitudes have been corrected for background noise.'};
    set(handles.protocol,'String',strings);
    strings=get(handles.protocol,'String');
    strings(length(strings)+1)={'Results can now be saved.'};
    set(handles.protocol,'String',strings);
end

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.pmd_file)
    errordlg('Load a file first.','Error');
else
    [~,pmd_name, ~] = fileparts(handles.pmd_file);
    if isempty(handles.corr_max_ampu)
        promptMessage = sprintf('You did not correct for background noise.\n Do you want to continue with \nuncorrected values (not recommended),or cancel?');
        button = questdlg(promptMessage, 'Continue', 'Continue', 'Cancel', 'Continue');
        if strcmpi(button, 'Cancel')
            return;
        end
        if strcmpi(button, 'Continue')
            setappdata(0,'max_ampu',handles.max_ampu);
        end
    else
        setappdata(0,'max_ampu',handles.corr_max_ampu);
    end
    [pmd_path,~, ~] = fileparts(handles.pmd_file);
    load(strcat(fullfile(pmd_path,pmd_name),'_design.mat'), 'design');
    setappdata(0,'design',design);
    setappdata(0,'pmd_file',handles.pmd_file);
    setappdata(0,'data_rate',handles.data_rate);
    %-------------------------------------------------------------------------------------
    save_gui;
    %-------------------------------------------------------------------------------------
    strings=get(handles.protocol,'String');
    strings(length(strings)+1)={['Results have been saved in file ' pmd_name '_results.xlsx.']};
    set(handles.protocol,'String',strings);
    
end

% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% delete all app data which has been accumulated
appdata = get(0,'ApplicationData');
fns = fieldnames(appdata);
for ii = 1:numel(fns)
    rmappdata(0,fns{ii});
end
clear clc
close



function protocol_Callback(hObject, eventdata, handles)
% hObject    handle to protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of protocol as text
%        str2double(get(hObject,'String')) returns contents of protocol as a double


% --- Executes during object creation, after setting all properties.
function protocol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Settings_Callback(hObject, eventdata, handles)
% hObject    handle to Settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
settings_gui;
