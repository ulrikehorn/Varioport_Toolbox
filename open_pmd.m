% User chooses a pmd file to open
% Function opens file and checks which channels are used and returns the
% data
function [pmd_file,xy_AUX,data_rate,marker_exists,xy_Marker] = open_pmd

%---- select the .pmd file via user interface ----
[file, dir] = uigetfile('*.pmd','Select Physiometer file');
if dir~=0
cd(dir);
pmd_file = fullfile(dir,file);
[pmd_path, pmd_name, ~] = fileparts(pmd_file);	%to be used for saving later

if exist(strcat(fullfile(pmd_path,pmd_name),'_AUX.mat'),'file')
    % Construct a questdlg with three options
    choice = questdlg('The AUX data has been loaded and saved already. Do you want to use it?', ... %question
        'File already existing', ... %title
        'Yes','No','No'); %options+default
    % Handle response
    switch choice
        case 'Yes'
            load_new_AUX = 0;
        case 'No'
            load_new_AUX = 1;
    end
else
    load_new_AUX = 1;
end

if exist(strcat(fullfile(pmd_path,pmd_name),'_marker.mat'),'file')
    % Construct a questdlg with three options
    choice = questdlg('The marker data has been loaded and saved already. Do you want to use it?', ... %question
        'File already existing', ... %title
        'Yes','No','No'); %options+default
    % Handle response
    switch choice
        case 'Yes'
            load_new_marker = 0;
        case 'No'
            load_new_marker = 1;
    end
else
    load_new_marker = 1;
end

% load new data if chosen by user
[xy_AUX,data_rate,xy_Marker] = load_pmd(pmd_file,load_new_AUX,load_new_marker);

% otherwise use saved data
if load_new_AUX==0
    load(strcat(fullfile(pmd_path,pmd_name),'_AUX.mat'),'xy_AUX','data_rate');
end
if load_new_marker==0
    load(strcat(fullfile(pmd_path,pmd_name),'_marker.mat'),'xy_Marker');
end

if ~isempty(xy_AUX)
    % plot data
    h_AUX = figure; set(gca,'YGrid','on');		%plotting AUX
    plot (xy_AUX(:, 1), xy_AUX(:, 2), 'k');
    axis ( [ min(xy_AUX(:, 1)) max(xy_AUX(:, 1)) min(xy_AUX(:, 2)) max(xy_AUX(:, 2)) ] );
    xlabel({'time (s)'});
    ylabel({'AUX (a.u.)'});
    title({strcat('AUX-', pmd_name) });
    marker_exists=0;
    if ~isempty(xy_Marker)
        hold on; % plotting Marker on the previous figure
        for i=1: length(xy_Marker)
            if xy_Marker(i,2) ~= 0
                plot (xy_Marker(i, 1), xy_Marker(i, 2), 'm', 'Marker', 's', 'Markersize', 5);
                marker_exists=1;
            end
        end
    end
    if marker_exists
        legend('plotted variable', 'marker');
    else
        legend('plotted variable');
    end
    saveas(h_AUX, strcat(fullfile(pmd_path,pmd_name),'_AUX'), 'jpg');
    close(h_AUX);
else
    errordlg('There is no AUX data in this file!','Data Error');
    data_rate=[];
    marker_exists=[];
    xy_Marker=[];
end

else
    pmd_file=0;
    xy_AUX=0;
    data_rate=0;
    marker_exists=0;
    xy_Marker=0;
    return
end
end
