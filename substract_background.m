% Calculates from the PM*.mat file the mean frequency and amplitude for each block by
% considering the maxima AND NOT the fitted peaks, and by substracting from the actual amplitude values
% the mean background value, which is calculated by placing 2 cursors in each inactive blocks 2 and 22
% and considering the mean of their mean in the region defined by the cursors.
% In this version the individual amplitudes of maxima and the frequencies for each block are saved in the
% cell variables mmampu and freq respectively, and alltogether in the variables all_mmampu and all_freq respectively,
% that can be used as input in SPSS.
% Plots the mean frequency and amplitude for each block and saves the plots as .png files
% calculates the mean frequency and amplitude over all active blocks, taking as input the
% output from the find_PMu_block.m, that contains unique maxima only in the maxampu variable
%
% The variables for the mean frequency and amplitude for each block are saved in a resultsu_*.mat file

% Allia, 14.04.2011
% Ulrike Horn
% ulrike.horn@uni-greifswald.de
% 31.08.2017

function [mmampu,mean_bkgr]=substract_background(xy_AUX,maxampu,design)
%% ------------ calculating the baseline (background) amplitude ---------------------
% get .mat file with the defined blocks
% the user puts 2 cursors on the stable background of the plot of block 2 (rest)

rest_start_end=cell2mat(design(strcmp(design(:,4),'rest'),2:3));

%for each rest block check if there are unwanted peaks in between
peak_counter=zeros(length(rest_start_end),1);
rest_block_length=zeros(length(rest_start_end),1);
for irest=1:length(rest_start_end)
    %calculate rest block lengths
    rest_block_length(irest,1)=rest_start_end(irest,2)-rest_start_end(irest,1);
    for ipeak=1:length(maxampu)
        if rest_start_end(irest,1)<maxampu(ipeak,1)&&maxampu(ipeak,1)<rest_start_end(irest,2)
            peak_counter(irest)=peak_counter(irest)+1;
        end
    end
end

%take longest rest blocks --> if there are peaks find out where they are
%and cut after or before width of peak -------------------TO DO!
[~,index_one]=max(rest_block_length);
rest_block_length(index_one)=0;
[~,index_two]=max(rest_block_length);

xy_AUX_start_end=zeros(1,2);
for i=1:length(xy_AUX)
    if round(xy_AUX(i,1),4)==round(rest_start_end(index_one,1),4)
        xy_AUX_start_end(1,1)=i;
    end
    if round(xy_AUX(i,1),4)==round(rest_start_end(index_one,2),4)
        xy_AUX_start_end(1,2)=i;
    end
    if round(xy_AUX(i,1),4)==round(rest_start_end(index_two,1),4)
        xy_AUX_start_end(2,1)=i;
    end
    if round(xy_AUX(i,1),4)==round(rest_start_end(index_two,2),4)
        xy_AUX_start_end(2,2)=i;
    end
end

rest_block_one=xy_AUX(xy_AUX_start_end(1,1):xy_AUX_start_end(1,2),:);
setappdata(0,'range',rest_block_one);
restmarker_gui;
uiwait;
firstmarker = getappdata(0,'marker');

% those 2 cursors are used to define a background region between them, 
% over which the mean amplitude is calculated
for j = 1: length(rest_block_one)
    if rest_block_one(j,1) == firstmarker(2).Position(1)
        lower_limit = j;
    end
    if rest_block_one(j,1) == firstmarker(1).Position(1)
        upper_limit = j;
    end
end
% sometimes (if the user clicks the second marker first) the markers are
% interchanged but they are correct so just switch them
if lower_limit<upper_limit
    bkgr_first = rest_block_one(lower_limit:upper_limit,2);
else
    bkgr_first = rest_block_one(upper_limit:lower_limit,2);
end
mean_bkgr_first = mean(bkgr_first(:,1));

%%
rest_block_two=xy_AUX(xy_AUX_start_end(2,1):xy_AUX_start_end(2,2),:);
setappdata(0,'range',rest_block_two);
restmarker_gui;
uiwait;
secondmarker = getappdata(0,'marker');

% those 2 cursors are used to define a background region between them, 
% over which the mean amplitude is calculated
for j = 1: length(rest_block_two)
    if rest_block_two(j,1) == secondmarker(2).Position(1)
        lower_limit = j;
    end
    if rest_block_two(j,1) == secondmarker(1).Position(1)
        upper_limit = j;
    end
end
% sometimes (if the user clicks the second marker first) the markers are
% interchanged but they are correct so just switch them
if lower_limit<upper_limit
    bkgr_second = rest_block_two(lower_limit:upper_limit,2);
else
    bkgr_second = rest_block_two(upper_limit:lower_limit,2);
end
mean_bkgr_second = mean(bkgr_second(:,1));


% taking as mean background value the mean of the background in the first 
% and the second rest block
mean_bkgr = (mean_bkgr_first + mean_bkgr_second)/2;

%% ------------ substracting background from amplitude values ---------------------
for k = 1: length(maxampu)	% for all blocks
    mmampu(:,1)=maxampu(:,1);
    mmampu(:,2)=maxampu(:,2) - round(mean_bkgr);
end

end