function [marker,task_start_end] = calculate_design_with_first_task_marker(marker3,num_task_blocks,length_task,length_rest,xy_AUX,data_rate)
% if the first active block is the second experimental block, => the third block of the AUX file
for aa = 1:length(xy_AUX)
    if xy_AUX(aa,1) == marker3
        %     if xy_AUX(aa,1) == marker3.Position(1)
        block_start(3) = aa;                        % the third block starts at the marker3 position
        block_end(3) = aa + data_rate*length_task -1;	% marker3 pos + task length = block 3 end
    end
end

block_end(2) = block_start(3) -1;                   % the second block ends right before the third one starts

%check if marker3 is too early in time so that no complete rest block(+1
%for beginning of experiment) fits in
calc_start=marker3-length_rest-1;
if calc_start<xy_AUX(1,1)
    first_rest_block_length=floor(2*(block_end(2)-xy_AUX(1,1)*data_rate)/3);
    block_start(2) = block_end(2) - first_rest_block_length +1;	% block 2 start = block 2 end - remaining rest length
else
    block_start(2) = block_end(2) - data_rate*length_rest +1;	% block 2 start = block 2 end - rest length
end


% the first block is defined but not to be considered in the data analysis: this is the time between
% starting the Varioport recording and starting the actual experimental conditions
block_start(1) = data_rate*1;	% assigning the beginning of the first block at the 1st second
% normally, I should assign the start of the first block as the first xy_AUX pair
% BUT I skip the first second, since AUX needs at least 1-2s to reach its rest value
block_end(1) = block_start(2) -1;  	% the first block ends just before the second one starts

% if there are x task blocks, there are additionally x+1 rest blocks and 2
% additional blocks before and after the experiment --> 2x+1+2 blocks in
% total
num_blocks_total = num_task_blocks*2+3;


%check if marker3 + design is longer than xy aux
calc_length=marker3+num_task_blocks*(length_task+length_rest);
if calc_length>xy_AUX(end,1)
    %check if the difference is bigger than rest time --> then
    %something with the marker3 is wrong
    missing =calc_length-xy_AUX(end,1);
    if missing>length_rest
        errordlg('The set marker and the defined design do not fit together. Either you set the marker too late or the design is too long','Error');
        block={};
        return
    else
        %otherwise you can just trim the last rest block to fit in
%         last_rest_block_length=floor(2*missing/3); %2/3 of the remaining shall be the rest block
        for blocknumber = 4:num_blocks_total-2 %normal until the last 2 blocks come up
            if mod(blocknumber,2) == 0  %rest block 4, 6, 8, etc
                block_start(blocknumber) = block_end(blocknumber-1) +1;
                block_end(blocknumber) = block_start(blocknumber) + data_rate*length_rest -1;
            else                        %task block 5, 7, 9, etc
                block_start(blocknumber) = block_end(blocknumber-1) +1;
                block_end(blocknumber) = block_start(blocknumber) + data_rate*length_task -1;
            end
        end
        % the block before the last one is now the trimmed rest block
        % new length of this block is 2/3 of the remaining length
        last_rest_block_length=floor(2*(xy_AUX(end,1)*data_rate-block_end(num_blocks_total-2))/3);
        block_start(num_blocks_total-1) = block_end(num_blocks_total-2) +1;
        block_end(num_blocks_total-1) = block_start(num_blocks_total-1) + last_rest_block_length -1;
        % the last block is defined but not to be considered in the data analysis: this is the time between
        % the end of the actual experimental conditions and stopping the Varioport recording.
        block_start(num_blocks_total) = block_end(num_blocks_total-1)+1;
        block_end(num_blocks_total) = length(xy_AUX); 	%end of the last block is the last xy_AUX
    end
else
    
    for blocknumber = 4:num_blocks_total-1
        if mod(blocknumber,2) == 0  %rest block 4, 6, 8, etc
            block_start(blocknumber) = block_end(blocknumber-1) +1;
            block_end(blocknumber) = block_start(blocknumber) + data_rate*length_rest -1;
        else                        %task block 5, 7, 9, etc
            block_start(blocknumber) = block_end(blocknumber-1) +1;
            block_end(blocknumber) = block_start(blocknumber) + data_rate*length_task -1;
        end
    end
    % the last block is defined but not to be considered in the data analysis: this is the time between
    % the end of the actual experimental conditions and stopping the Varioport recording.
    block_start(num_blocks_total) = block_end(num_blocks_total-1)+1;
    block_end(num_blocks_total) = length(xy_AUX); 	%end of the last block is the last xy_AUX
end

block_start = block_start';
block_end = block_end';

marker=xy_AUX(block_start,:);

block_time=[xy_AUX(block_start,1) xy_AUX(block_end,1)];
task_start_end=block_time(3:2:end-2,:);