% General script to read a Physiometer output file (.pmd file from a Varioport measurement)
% and plot the recorded data.
% This version extracts the data rate and the number of used channels from the header
% and uses this information for calculations and plots.
% If a marker was used, its non-zero values are plotted on the previous graph
% The plots are saved as figures and the variables as .mat files

% Allia Kaza, 06.04.2011
% Ulrike Horn
% ulrike.horn90@googlemail.com
% 06.09.2018
%%

function [xy_AUX,data_rate,xy_Marker] = load_pmd(pmd_file,load_AUX,load_marker)

if load_AUX==0
    xy_AUX=[];
end
if load_marker==0
    xy_Marker=[];
end


%---- parameters from Varioport manual ----
offset = 32767;
EDA_MUL = 10; 	EDA_DIV = 6400;
EMG_MUL = 1297;	EMG_DIV = 10000;
UBATT_MUL = 127;	UBATT_DIV = 10000;

%---- Definition of possibly used Varioport channels, from Varioport manual:
%EDA: channel 1 	EMG1: channel 2 		EMG2: channel 3
%AUX: channel 4		Marker: channel 65		UBATT: channel 66
%-----------------------------------------------------------------------------

tic;
%create a waitbar with all active channels which will be loaded anew
% multiWaitbar( 'Load AUX', 0, 'Color', 'b' ,'CancelFcn', @(a,b) disp( ['Cancel ',a] ));
multiWaitbar( 'Load Marker', 0, 'Color', 'b' ,'CancelFcn', @(a,b) disp( ['Cancel ',a] ));

for a = 1: length(sorted_active_channels)
    
    % ---- AUX ------------------------------------------------------
    if sorted_active_channels(a) == 4 && load_AUX ==1		% if channel 4 (AUX) is used (ball pressure)
        display('calculating and plotting the AUX ...');
        % get corresponding data column and calculate the AUX values
        AUX = pmd_data.data(:, a) - offset ;	%no factors given in manual for AUX, possible to omit offset
        % creating the x-values (time indexes) by using the sampling rate
%         multiWaitbar( 'Load AUX', 0, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );
        for i=1:length(AUX)
%             abort = multiWaitbar( 'Load AUX', i/length(AUX) );
%             if abort
%                 % Here we would normally ask the user if they're sure
%                 break
%             else
                xAUX(i)= i * (1/data_rate);
%             end
        end
        
%         w = waitbar(0,'Please wait for the AUX calculation ...');
%         for i=1: length(AUX)
%             xAUX(i)= i * (1 / data_rate);
%             waitbar(i/length(AUX))
%         end
        xAUX = xAUX' ;
        xy_AUX = horzcat(xAUX, AUX);
%         close(w);
        save(strcat(fullfile(pmd_path,pmd_name),'_AUX'), 'xy_AUX', 'data_rate');	%saving the .mat file
    end
    
    % ---- Marker ------------------------------------------------------
    if sorted_active_channels(a) == 65 && load_marker == 1		% if channel 65 (Marker) is used
        display('calculating the Marker, plotting it on the previous graph ...');
        % get corresponding data column and calculate the Marker values
        Marker = pmd_data.data(:, a) ;
        % creating the x-values (time indexes) by using the sampling rate
%          multiWaitbar( 'Load Marker', 0, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );
        for i=1:length(Marker)
            abort = multiWaitbar( 'Load Marker', i/length(Marker) );
            if abort
                % Here we would normally ask the user if they're sure
                break
            else
                xMarker(i)= i * (1 / data_rate);
            end
        end
       
%         w = waitbar(0,'Please wait for the Marker calculation ...');
%         for i=1: length(Marker)
%             xMarker(i)= i * (1 / data_rate);
%             waitbar(i/length(Marker))
%         end
        xMarker = xMarker' ;
        xy_Marker = horzcat(xMarker, Marker);
%         close(w);
        save(strcat(fullfile(pmd_path,pmd_name),'_marker'), 'xy_Marker');			%saving the .mat file
    end
    
    % ---- EDA ------------------------------------------------------
    if sorted_active_channels(a) == 1		% if channel 1 (EDA) is used
        display('calculating and plotting the EDA ...');
        % get corresponding data column and calculate the EDA values
        EDA = ( (pmd_data.data(:, a) - offset) * EDA_MUL ) / EDA_DIV;
        % creating the x-values (time indexes) by using the sampling rate
        w = waitbar(0,'Please wait for the EDA calculation ...');
        for i=1: length(EDA)
            xEDA(i)= i * (1 / data_rate);
            waitbar(i/length(EDA))
        end
        xEDA = xEDA' ;
        xy_EDA = horzcat(xEDA, EDA);
        close (w);
        save(strcat('EDA-', pmd_name), 'xy_EDA', 'data_rate');		%saving the .mat file
    end
    
    % ---- EMG1 ------------------------------------------------------
    if sorted_active_channels(a) == 2		% if channel 2 (EMG1) is used
        display('calculating and plotting the EMG1 ...');
        % get corresponding data column and calculate the EMG1 values
        EMG1 = ( (pmd_data.data(:, a) - offset) * EMG_MUL ) / EMG_DIV;
        % creating the x-values (time indexes) by using the sampling rate
        w = waitbar(0,'Please wait for the EMG1 calculation ...');
        for i=1: length(EMG1)
            xEMG1(i)= i * (1 / data_rate);
            waitbar(i/length(EMG1))
        end
        xEMG1 = xEMG1' ;
        xy_EMG1 = horzcat(xEMG1, EMG1);
        close(w);
        save(strcat(fullfile(pmd_path,pmd_name),'_EMG1'), 'xy_EMG1', 'data_rate');			%saving the .mat file
    end
    
    % ---- EMG2 ------------------------------------------------------
    if sorted_active_channels(a) == 3		% if channel 3 (EMG2) is used
        display('calculating and plotting the EMG2 ...');
        % get corresponding data column and calculate the EMG2 values
        EMG2 = ( (pmd_data.data(:, a) - offset) * EMG_MUL ) / EMG_DIV;
        % creating the x-values (time indexes) by using the sampling rate
        w = waitbar(0,'Please wait for the EMG2 calculation ...');
        for i=1: length(EMG2)
            xEMG2(i)= i * (1 / data_rate);
            waitbar(i/length(EMG2))
        end
        xEMG2 = xEMG2' ;
        xy_EMG2 = horzcat(xEMG2, EMG2);
        close(w);
        save(strcat(fullfile(pmd_path,pmd_name),'_EMG2'), 'xy_EMG2', 'data_rate');			%saving the .mat file
    end
    
    % ---- UBATT ------------------------------------------------------
    if sorted_active_channels(a) == 66		% if channel 66 (UBATT) is used (battery voltage)
        display('calculating and plotting the UBATT ...');
        % get corresponding data column and calculate the UBATT values
        UBATT = pmd_data.data(:, a) * UBATT_MUL / UBATT_DIV;
        % creating the x-values (time indexes) by using the sampling rate
        w = waitbar(0,'Please wait for the UBATT calculation ...');
        for i=1: length(UBATT)
            xUBATT(i)= i * (1 / data_rate);
            waitbar(i/length(UBATT))
        end
        xUBATT = xUBATT' ;
        xy_UBATT = horzcat(xUBATT, UBATT);
        close(w);
        save(strcat(fullfile(pmd_path,pmd_name),'_UBATT'), 'xy_UBATT', 'data_rate');			%saving the .mat file
    end
    
end
multiWaitbar( 'CloseAll' );
time_taken = toc;
display(['Calculations treating the specified channels took ', num2str(time_taken/60), ' minutes']);
display( 'Variables of each active channel saved in corresponding .mat files in the working directory');

end