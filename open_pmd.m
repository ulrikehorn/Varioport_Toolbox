% User chooses a pmd file to open
% Function opens file and checks which channels are used 
% returns info to main function

% Allia Kaza, 06.04.2011
% Ulrike Horn
% ulrike.horn90@googlemail.com
% 06.09.2018

% function [pmd_file,xy_AUX,data_rate,marker_exists,xy_Marker] = open_pmd
function [pmd_file,data_rate,sorted_active_channels,pmd_data] = open_pmd

% select the .pmd file via user interface
[file, dir] = uigetfile('*.pmd','Select Physiometer file');
if dir~=0
cd(dir);
pmd_file = fullfile(dir,file);
% [pmd_path, pmd_name, ~] = fileparts(pmd_file);	%to be used for saving later

% open pmd_file and find data starting line to use it for importing data correctly
% NOTE: I noticed that the importdata command worked differently in different MATLAB versions,
% so it is safer to use first fopen command and get the subheader information later
fid=fopen(pmd_file);	% open file
line_counter=0;
while 1
    fileline = fgetl(fid);
    line_counter = line_counter +1;
    if ~ischar(fileline),   break;
    end
    if ( strncmp (fileline, '# Data:', 7) == 1 )    %finding starting line of the data part
        startdata_line = line_counter;
    end
end
fclose(fid);

% importing the data from the Physiometer file
pmd_data = importdata( pmd_file, '\t', startdata_line );

% finding from header starting line of the Varioport settings
for i = 1: length(pmd_data.textdata)
    if ( strncmp (pmd_data.textdata(i), '# Varioport Settings:', 21) == 1 )
        settings_line = i;
    end
end

% retrieving from the header the values of the active channels and the data rate used
% NOTE: it would be possible to read the <channel settings> and use the title given there in the plots;
% BUT experience shows that sometimes people use a wrong title in the channel settings,
% so the safest method is to read and use the activeChannels from the Varioport Settings
Varioport_settings = char(pmd_data.textdata(settings_line+1) );
pos_active_channels = strfind(Varioport_settings, 'activeChannels=');
pos_data_rate = strfind(Varioport_settings, 'dataRate=');
pos_comm_time_out = strfind(Varioport_settings, 'commTimeOut=');
active_channels = str2num( Varioport_settings(pos_active_channels + length('activeChannels=') : pos_data_rate-1) );
data_rate = str2num( Varioport_settings(pos_data_rate + length('dataRate=') : pos_comm_time_out-1) );
display( ['recorded channels according to header: ', num2str(active_channels)] );
sorted_active_channels = sort(active_channels);
display( ['sorted active channels : ', num2str(sorted_active_channels)] );

%
% % load new data if chosen by user
% [xy_AUX,data_rate,xy_Marker] = load_pmd(pmd_file,load_new_AUX,load_new_marker);
% 
% % otherwise use saved data
% if load_new_AUX==0
%     load(strcat(fullfile(pmd_path,pmd_name),'_AUX.mat'),'xy_AUX','data_rate');
% end
% if load_new_marker==0
%     load(strcat(fullfile(pmd_path,pmd_name),'_marker.mat'),'xy_Marker');
% end
% 
% if ~isempty(xy_AUX)
%     % plot data
%     h_AUX = figure; set(gca,'YGrid','on');		%plotting AUX
%     plot (xy_AUX(:, 1), xy_AUX(:, 2), 'k');
%     axis ( [ min(xy_AUX(:, 1)) max(xy_AUX(:, 1)) min(xy_AUX(:, 2)) max(xy_AUX(:, 2)) ] );
%     xlabel({'time (s)'});
%     ylabel({'AUX (a.u.)'});
%     title({strcat('AUX-', pmd_name) });
%     marker_exists=0;
%     if ~isempty(xy_Marker)
%         hold on; % plotting Marker on the previous figure
%         for i=1: length(xy_Marker)
%             if xy_Marker(i,2) ~= 0
%                 plot (xy_Marker(i, 1), xy_Marker(i, 2), 'm', 'Marker', 's', 'Markersize', 5);
%                 marker_exists=1;
%             end
%         end
%     end
%     if marker_exists
%         legend('plotted variable', 'marker');
%     else
%         legend('plotted variable');
%     end
%     saveas(h_AUX, strcat(fullfile(pmd_path,pmd_name),'_AUX'), 'jpg');
%     close(h_AUX);
% else
%     errordlg('There is no AUX data in this file!','Data Error');
%     data_rate=[];
%     marker_exists=[];
%     xy_Marker=[];
% end
% 
% else
%     pmd_file=0;
%     xy_AUX=0;
%     data_rate=0;
%     marker_exists=0;
%     xy_Marker=0;
%     return
% end
end
