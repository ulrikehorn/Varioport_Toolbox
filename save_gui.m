function varargout = save_gui(varargin)
% SAVE_GUI MATLAB code for save_gui.fig
%      SAVE_GUI, by itself, creates a new SAVE_GUI or raises the existing
%      singleton*.
%
%      H = SAVE_GUI returns the handle to a new SAVE_GUI or the handle to
%      the existing singleton*.
%
%      SAVE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVE_GUI.M with the given input arguments.
%
%      SAVE_GUI('Property','Value',...) creates a new SAVE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before save_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to save_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help save_gui

% Last Modified by GUIDE v2.5 15-Aug-2017 13:43:16

% Ulrike Horn
% ulrike.horn@uni-greifswald.de
% 31.08.2017

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @save_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @save_gui_OutputFcn, ...
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


% --- Executes just before save_gui is made visible.
function save_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to save_gui (see VARARGIN)

% Choose default command line output for save_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes save_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Plot Initialisierung
if strcmp(get(hObject,'Visible'),'off')
    cla reset;
end

%% get (corrected) amplitude values of maxima peaks
xy_peaks = getappdata(0,'xy_peaks');
handles.pmd_file = getappdata(0,'pmd_file');
design = getappdata(0,'design');
[~,pmd_name, ~] = fileparts(handles.pmd_file);
data_rate = getappdata(0,'data_rate');
% Update handles structure

% maximum table length num blocks x num peaks 
% (for extreme case that all peaks are in one block
% but take two columns for inserting each peak's time AND amplitude
resulttable=cell(length(xy_peaks),size(design,1)*2);
%loop through design and check in which blocks the peaks are
peakcounter=1;
for block=1:size(design,1)
    line_index=1;
    for peak=peakcounter:length(xy_peaks)
        if xy_peaks(peak,1)>design{block,3} %then there is no peak in this block
            break
        elseif design{block,2}<xy_peaks(peak,1)<design{block,3}
            peakcounter=peak+1;
            resulttable{line_index,2*block-1}=xy_peaks(peak,1);
            resulttable{line_index,2*block}=xy_peaks(peak,2);
            line_index=line_index+1;
        else
            display("error - peaks and design file do not fit together")
            return
        end
        
    end
end

%count peaks per block
real_values=~cellfun(@isempty,resulttable);
num_peaks=sum(real_values);
max_num_peaks=max(num_peaks);
%shorten the table
resulttable(max_num_peaks+1:end,:)=[];
num_peaks=num_peaks(1:2:end);
%for each block with more than one peak 
% calculate mean amplitude and frequency and others
mean_amp=zeros(1,size(design,1));
std_amp=zeros(1,size(design,1));
mean_freq=zeros(1,size(design,1));
std_freq=zeros(1,size(design,1));
freq_hz=zeros(1,size(design,1));
max_amp=zeros(1,size(design,1));
min_amp=zeros(1,size(design,1));
for block=1:size(design,1)
    if num_peaks(block)>0
        mean_amp(1,block)=mean(cell2mat(resulttable(:,2*block)));
        std_amp(1,block)=std(cell2mat(resulttable(:,2*block)));
        max_amp(1,block)=max(cell2mat(resulttable(:,2*block)));
        min_amp(1,block)=min(cell2mat(resulttable(:,2*block)));
        if num_peaks(block)>1
            time_diff=zeros(1,num_peaks(block)-1);
            freq=zeros(1,num_peaks(block)-1);
            for i=1:num_peaks(block)-1
                % time difference between timepoints, in s
                time_diff(1,i)=abs(resulttable{i+1,2*block-1}-resulttable{i,2*block-1});
                freq(1,i)=1/time_diff(1,i);
            end
            mean_freq(1,block)=mean(freq);
            std_freq(1,block)=std(freq);
            % frequency as given by design
            freq_hz(1,block) = num_peaks(block)/(design{block,3}-design{block,2});
        end
    end
end

%overall means only for task blocks
task_indices= strcmp(design(:,4),'task');
mean_amp_all=mean(mean_amp(1,task_indices));
std_amp_all=mean(std_amp(1,task_indices));
mean_freq_all=mean(mean_freq(1,task_indices));
std_freq_all=mean(std_freq(1,task_indices));
freq_hz_all=mean(freq_hz(1,task_indices));
max_amp_all=max(max_amp(1,task_indices));
min_amp_all=min(min_amp(1,task_indices));

% put everything in a result table which will be saved below the original
% result table with the peak amplitudes
resulttable_below=cell(15,size(design,1));
for i=1:size(design,1)
    resulttable_below{2,i*2}=num_peaks(i);
    resulttable_below{3,i*2}=mean_amp(i);
    resulttable_below{4,i*2}=std_amp(i);
    resulttable_below{5,i*2}=mean_freq(i);
    resulttable_below{6,i*2}=std_freq(i);
    resulttable_below{7,i*2}=freq_hz(i);
end
resulttable_below{9,1}=mean_amp_all;
resulttable_below{10,1}=std_amp_all;
resulttable_below{11,1}=mean_freq_all;
resulttable_below{12,1}=std_freq_all;
resulttable_below{13,1}=freq_hz_all;
resulttable_below{14,1}=max_amp_all;
resulttable_below{15,1}=min_amp_all;

handles.resulttable=[resulttable;resulttable_below];
% Update handles structure
guidata(hObject, handles);

%make headers for the tables
header=cell(size(resulttable,1)+size(resulttable_below,1)+3,size(resulttable,2)+1);
header{1,1}='block';
header{2,1}='design';
header{3,1}='peaks';
header{size(resulttable,1)+5,1}='number of peaks';
header{size(resulttable,1)+6,1}='mean amplitude';
header{size(resulttable,1)+7,1}='std amplitude';
header{size(resulttable,1)+8,1}='mean frequency';
header{size(resulttable,1)+9,1}='std frequency';
header{size(resulttable,1)+10,1}='frequency (Hz)';
header{size(resulttable,1)+12,1}='mean amplitude all task blocks';
header{size(resulttable,1)+13,1}='std amplitude all task blocks';
header{size(resulttable,1)+14,1}='mean frequency all task blocks';
header{size(resulttable,1)+15,1}='std frequency all task blocks';
header{size(resulttable,1)+16,1}='frequency (Hz) all task blocks';
header{size(resulttable,1)+17,1}='maximum amplitude all task blocks';
header{size(resulttable,1)+18,1}='minimum amplitude all task blocks';
for i=1:(size(resulttable,2))/2
    header{1,i*2}=design{i,1};
    header{2,i*2}=design{i,4};
    header{3,i*2}='time';
    header{3,i*2+1}='amp';
end

handles.header=header;
% Update handles structure
guidata(hObject, handles);

%plot amplitudes and frequencies block wise
axes(handles.plot1); % create plot window
cla; % clear plot content
% plotting the individual blocks' mean amplitude with its std as error bar
errorbar(1:length(mean_amp),mean_amp,std_amp,'o','MarkerSize',6,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
xlabel('block number', 'fontweight','b');
ylabel('mean block amplitude (a.u.) ', 'fontweight','b');
title(pmd_name);

axes(handles.plot2); % create plot window
% plotting the individual blocks' mean frequency
plot(1:length(freq_hz),freq_hz,'o','MarkerSize',6,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
xlabel('block number', 'fontweight','b');
ylabel('mean block frequency', 'fontweight','b');
xlim([0 length(freq_hz)+1]);
ylim([0 max(freq_hz)+0.5])
title(pmd_name);


% --- Outputs from this function are returned to the command line.
function varargout = save_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[pmd_path,pmd_name, ~] = fileparts(handles.pmd_file);
% 
try
    file_path = strcat(fullfile(pmd_path,pmd_name),'_results.xlsx');
    xlswrite(file_path,handles.header,1,'B1'); %write header first
    xlswrite(file_path,handles.resulttable,1,'C4'); %then write resulttable
catch
    complete_table=handles.header;
    complete_table(4:end,2:end)=handles.resulttable;
    try
        file_path = strcat(fullfile(pmd_path,pmd_name),'_results.csv');
        complete_table=cell2table(complete_table);
        writetable(complete_table,file_path,'Delimiter',' ');
    catch
        file_path = strcat(fullfile(pmd_path,pmd_name),'_results.mat');
        save(file_path,'complete_table')
    end
end
close
