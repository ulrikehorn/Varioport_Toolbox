% show user which channels are in file
% which ones are you interested in?
% (only if more than one of interest, not including marker)
%---- Definition of possibly used Varioport channels, from Varioport manual:
%EDA: channel 1 	EMG1: channel 2 		EMG2: channel 3
%AUX: channel 4		Marker: channel 65		UBATT: channel 66
%-----------------------------------------------------------------------------

function [xy_data,xy_marker,channel_name_of_interest] = load_channel_data(pmd_file,data_rate,active_channels,pmd_data)
load_marker=false;
[pmd_path, pmd_name, ~] = fileparts(pmd_file);	%to be used for saving later
channels_wo_marker=active_channels;
channels_wo_marker(channels_wo_marker==65)=[];
if size(channels_wo_marker,2)~= size(active_channels,2)
    load_marker=true;
end
channel_names=cell(1,size(channels_wo_marker,2));
for ichannel=1:size(channels_wo_marker,2)
    if channels_wo_marker(1,ichannel)==1
        channel_names{ichannel}='EDA';
    elseif channels_wo_marker(1,ichannel)==2
        channel_names{ichannel}='EMG1';
    elseif channels_wo_marker(1,ichannel)==3
        channel_names{ichannel}='EMG2';
    elseif channels_wo_marker(1,ichannel)==4
        channel_names{ichannel}='AUX';
    elseif channels_wo_marker(1,ichannel)==66
        channel_names{ichannel}='UBATT';
    else
        channel_names{ichannel}='unknown';
    end
end
% show user which channels are in file
% which ones are you interested in?
% (only if more than one of interest, not including marker)
if size(channels_wo_marker,2)>1
    [indx,tf] = listdlg('Name','Channel Selection','PromptString',...
        {'Which channel do you want','to examine?'},...
        'SelectionMode','single',...
        'ListString',channel_names);
    if tf
        channel_of_interest=channels_wo_marker(indx);
        channel_name_of_interest=channel_names(indx);
    else
        xy_data=[];
        xy_marker=[];
        return
    end
else
    channel_of_interest=channels_wo_marker;
    channel_name_of_interest=channel_names;
end

if exist(strcat(fullfile(pmd_path,pmd_name),'_',channel_name_of_interest{1},'.mat'),'file')
    % Construct a questdlg with three options
    choice = questdlg('The data for this channel has already been loaded and saved. Do you want to use it?', ... %question
        'File already existing', ... %title
        'Yes','No','No'); %options+default
    % Handle response
    switch choice
        case 'Yes'
            load_new_data = 0;
            load(strcat(fullfile(pmd_path,pmd_name),'_',channel_name_of_interest{1},'.mat'),'xy_data');
        case 'No'
            load_new_data = 1;
    end
else
    load_new_data = 1;
end

if load_new_data
    
    %---- parameters from Varioport manual ----
    offset = 32767;
    EDA_MUL = 10; 	EDA_DIV = 6400;
    EMG_MUL = 1297;	EMG_DIV = 10000;
    UBATT_MUL = 127;	UBATT_DIV = 10000;
    
    index= active_channels==channel_of_interest;
    % get corresponding data column and calculate the data values
    if channel_of_interest==4 %AUX
        data = pmd_data.data(:, index) - offset ;
        %no factors given in manual for AUX, possible to omit offset
    elseif channel_of_interest==1 %EDA
        data = ((pmd_data.data(:, index) - offset) * EDA_MUL ) / EDA_DIV;
    elseif channel_of_interest==2||channel_of_interest==3 %EMG1 or EMG2
        data = ((pmd_data.data(:, index) - offset) * EMG_MUL ) / EMG_DIV;
    elseif channel_of_interest==66 %UBATT = Battery data
        data = pmd_data.data(:, a) * UBATT_MUL / UBATT_DIV;
    end
    % creating the x-values (time indexes) by using the sampling rate
    %         multiWaitbar( 'Load AUX', 0, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );
    for i=1:length(data)
        %             abort = multiWaitbar( 'Load AUX', i/length(AUX) );
        %             if abort
        %                 % Here we would normally ask the user if they're sure
        %                 break
        %             else
        xdata(i)= i * (1/data_rate);
        %             end
    end
    xdata = xdata' ;
    xy_data = horzcat(xdata, data);
    
    save(strcat(fullfile(pmd_path,pmd_name),'_',channel_name_of_interest{1},'.mat'),...
        'xy_data', 'data_rate');	%saving the .mat file
end

if load_marker
    if exist(strcat(fullfile(pmd_path,pmd_name),'_marker.mat'),'file')
        % Construct a questdlg with three options
        choice = questdlg('The marker data has already been loaded and saved. Do you want to use it?', ... %question
            'File already existing', ... %title
            'Yes','No','No'); %options+default
        % Handle response
        switch choice
            case 'Yes'
                load_new_marker = 0;
                load(strcat(fullfile(pmd_path,pmd_name),'_marker.mat'),'xy_marker');

            case 'No'
                load_new_marker = 1;
        end
    else
        load_new_marker = 1;
    end
    if load_new_marker
        marker = pmd_data.data(:, active_channels==65);
        for i=1:length(marker)
            xmarker(i)= i * (1 / data_rate);
        end
        xmarker = xmarker' ;
        xy_marker = horzcat(xmarker, marker);
        
        save(strcat(fullfile(pmd_path,pmd_name),'_marker.mat'),...
        'xy_marker', 'data_rate');	%saving the .mat file
    end
else
    xy_marker=[];
end
end