% select the block borders from the aux data file by using the marker data file
% in order to use the blocks later as input for FindPeakSlidersG_*
% the blocks are defined from the beginning of a marker to the beginning of the next marker
% NOTE: the first 1 second of the first block is skipped, to allow for AUX to reach its rest value 

% Allia Kaza, 06.04.2011
% Ulrike Horn, 06.09.2017

% function [block,mean_dur_task,mean_dur_rest]=calculate_blocks_with_marker(pmd_file,xy_AUX,data_rate,xy_Marker)
function [crest_start]=calculate_blocks_with_marker(xy_AUX,data_rate,xy_Marker)

if length(xy_AUX) == length(xy_Marker) 
	display('xy_AUX and xy_Marker have equal dimensions');
else
    display('ERROR: xy_AUX and xy_Marker have unequal dimensions'); return;
end

% find the time points where the marker has value different than zero
markercounter = 0;
for i = 1:length(xy_Marker)
    if xy_Marker(i,2) ~= 0
        markercounter = markercounter +1;
        position_marker (markercounter) = xy_Marker(i,1);
    end
end
position_marker = position_marker';

% find the start and end of the marker crests
crestcounter = 1;
crest_start(1) = position_marker(1);	%assigning the first value

for j = 2: length(position_marker) 
	if position_marker(j) - position_marker(j-1) > 1/data_rate +1
% !!! by viewing long e, obvious that adjacent timepoints difference isn't exactly 1/data_rate, 
% so I increased their difference by arbitrary value 1, sufficing to satisfy the if clause for usual data
		crestcounter = crestcounter +1;
		crest_start(crestcounter) = position_marker(j);
	end
end
crest_start = crest_start';
crest_start=[crest_start zeros(length(crest_start),1)];
for cc=1:length(crest_start)
    index= xy_AUX(:,1)==crest_start(cc);
    crest_start(cc,2)=xy_AUX(index,2);
end
% add beginning of recording as an additional starting point
start_rec=1/data_rate+1;
start_rec_index=xy_AUX(:,1)==start_rec;
crest_start=[start_rec xy_AUX(start_rec_index,2);crest_start];