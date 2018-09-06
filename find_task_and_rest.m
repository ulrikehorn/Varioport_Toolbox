function [marker,design]=find_task_and_rest(xy_AUX,max_ampu,pmd_name,crest_start,data_rate)
%check if there is a marker, then the starts are already defined
if crest_start~=0
    %ask if user wants to use the marker
    promptMessage = sprintf('Do you want to use the saved marker?');
    button = questdlg(promptMessage, 'Question', 'Yes', 'No', 'Cancel', 'Cancel');
    if strcmpi(button, 'Cancel')
        marker=[];
        design=[];
        return;
    end
    if strcmpi(button, 'Yes')
        marker=crest_start;
        no_marker=0;
        % count peaks in each region
        peaknums=zeros(length(crest_start),1);
        for istart=1:length(crest_start)-1
            peakcounter=0;
            for ipeaks=1:length(max_ampu)
                if max_ampu(ipeaks,1)>crest_start(istart,1)&&max_ampu(ipeaks,1)<crest_start(istart+1,1)
                    peakcounter=peakcounter+1;
                end
            end
            peaknums(istart,1)=peakcounter;
        end
        peakcounter=0;
        for ipeaks=1:length(max_ampu)
            if max_ampu(ipeaks,1)>crest_start(end,1)
                peakcounter=peakcounter+1;
            end
        end
        peaknums(end,1)=peakcounter;
        % which regions have consistently
        % more peaks than the others? (task regions)
        mean_peak_num=mean(peaknums);
        task_blocks=zeros(length(crest_start),1);
        for i=1:length(crest_start)
            if peaknums(i)>mean_peak_num
                task_blocks(i)=1;
            end
        end
        % plot task and rest regions
        [task_index,~]=find(task_blocks);
        for itask=1:length(task_index)
            task_start_end(itask,1:2)=[crest_start(task_index(itask)) crest_start(task_index(itask)+1)];
        end
        design=calculate_rest(task_start_end,xy_AUX);
    end
    if strcmpi(button, 'No')
        no_marker=1;
    end
    
    
else %no marker
    no_marker=1;
end
if no_marker==1
    promptMessage = sprintf('Do you want to define a design?');
    button = questdlg(promptMessage, 'Question', 'Yes', 'No', 'Cancel', 'Cancel');
    if strcmpi(button, 'No')
        %%here the design is estimated by the peaks
        setappdata(0,'xy_AUX',xy_AUX);
        setappdata(0,'max_ampu',max_ampu);
        setappdata(0,'pmd_name',pmd_name);
        task_peak_area
        uiwait
        task_start_end = getappdata(0,'task_start_end');
        task_start_end=round(task_start_end,log10(data_rate));
        design=calculate_rest(task_start_end,xy_AUX);
        % also define marker
        task_marker=sort([task_start_end(:,1);task_start_end(:,2)]);
        % this one does not necessarily have to be in xy_AUX
        % how accurate is xy_AUX? --> see data_rate
        task_marker=round(task_marker,log10(data_rate));
        marker=zeros(length(task_marker),2);
        marker(:,1)=task_marker;
        for i=1:length(task_marker)
            for aa = 1:length(xy_AUX)
                if round(xy_AUX(aa,1),log10(data_rate)) == task_marker(i)
                    marker(i,2) = xy_AUX(aa,2);
                end
            end
        end
        return;
    end
    if strcmpi(button, 'Cancel')
        marker=[];
        design=[];
        return;
    end
    if strcmpi(button, 'Yes')
        %check for settings file and load default values
        %folder of toolbox
        filename=which('varioport_toolbox');
        [location,~,~] = fileparts(filename);
        if exist(fullfile(location,'settings.mat'),'file')
            load(fullfile(location,'settings.mat'));
            def_num_blocks = settings.num_blocks;
            def_task_blocks = settings.task_block;
            def_rest_blocks = settings.rest_block;
        else
            def_num_blocks = 2;
            def_task_blocks = 18;
            def_rest_blocks = 18;
        end
        %     guidata(hObject, handles) % Update handles structure
        loop=1;
        while loop
            % asks the user to define the design of the experiment
            prompt = {'Enter number of blocks/events:',...
                'Enter length of task block/event in seconds:',...
                'Enter length of rest block/event in seconds'};
            dlg_title = 'Design';
            num_lines = 1;
            defaultans = {num2str(def_num_blocks),num2str(def_task_blocks),num2str(def_rest_blocks)};
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
            %user clicks "cancel"
            if isempty(answer)
                marker=[];
                design=[];
                return
            end
            num_blocks=str2double(answer{1});
            length_task=str2double(answer{2});
            length_rest=str2double(answer{3});
            %if one of them is not entered
            if isnan(num_blocks)||isnan(length_task)||isnan(length_rest)
                loop=1;
                continue
            end
            % check if design fits the AUX file approximately
            design_length=num_blocks*length_task*data_rate+(num_blocks+1)*length_rest*data_rate;
            if design_length>length(xy_AUX)
                %design too long
                promptMessage = sprintf('The design is too long for the given file.\n Do you want to enter another design,\nor Cancel to abort this step?');
                button = questdlg(promptMessage, 'Warning', 'Continue', 'Cancel', 'Continue');
                if strcmpi(button, 'Cancel')
                    return;
                end
                if strcmpi(button, 'Continue')
                    loop =1;
                end
            else
                loop=0;
                %design correct
                % define beginning of experiment -> set first task block
                setappdata(0,'xy_AUX',xy_AUX);
                %-------------------------------------------------------------------------------------
                marker3_gui
                %-------------------------------------------------------------------------------------
                uiwait;
                marker3 = getappdata(0,'marker3');
                if ~isempty(marker3)
                    % check that marker3+design is not longer than the AUX
                    % file, otherwise calculate_blocks does something wrong
                    % give marker3 info to function which calculates block starts and ends
                    %-------------------------------------------------------------------------------------
                    [marker,task_start_end]=calculate_design_with_first_task_marker(marker3,num_blocks,length_task,length_rest,xy_AUX,data_rate);
                    %-------------------------------------------------------------------------------------
                    design=calculate_rest(task_start_end,xy_AUX);
                else
                    errordlg('You have not specified a marker.','Error');
                end
            end
        end
    end
end
end