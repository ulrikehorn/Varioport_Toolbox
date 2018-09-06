function design = calculate_rest(task_start_end,xy_AUX)
%define rest blocks
rest_start_end=zeros(length(task_start_end)+1,2);
rest_start_end(1,1)=xy_AUX(50,1); %abhängig von data rate! TO DO
for i=1:length(task_start_end)
    rest_start_end(i,2)=task_start_end(i,1);
    rest_start_end(i+1,1)=task_start_end(i,2);
end
if ~(task_start_end(1,1)>xy_AUX(50,1)) %AUX file starts with start block
    rest_start_end(1,:)=[];
end
if rest_start_end(end,1)<xy_AUX(end,1) %AUX file ends with rest block
    rest_start_end(end,2)=xy_AUX(end,1);
else
    rest_start_end(end,:)=[];
end
%tag with task and rest respectively
design=[num2cell(task_start_end),cellstr(repmat("task",length(task_start_end),1))];
design=[design;[num2cell(rest_start_end),cellstr(repmat("rest",length(rest_start_end),1))]];
%sort by time of start
design=sortrows(design,1);
%enumerate blocks
design=[num2cell((1:1:length(design))'),design];