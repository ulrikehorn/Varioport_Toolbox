% Ulrike Horn
% ulrike.horn@uni-greifswald.de
% 11.01.2018

function [maxampu]=find_peaks(pmd_file)

[pmd_path,pmd_name, ~] = fileparts(pmd_file);
load(strcat(fullfile(pmd_path,pmd_name),'_AUX'), 'xy_AUX');

%use matlab function
% interactive?
% [pks,locs,w,p]=findpeaks(xy_AUX(20:end,2),xy_AUX(20:end,1),'MinPeakHeight',700);
[pks,locs]=findpeaks(xy_AUX(20:end,2),xy_AUX(20:end,1),'MinPeakProminence',50);
maxampu=[locs,pks];

figure;
jScrollbar = javax.swing.JScrollBar;
jScrollbar.setOrientation(jScrollbar.VERTICAL);
javacomponent(jScrollbar,[10,40,20,200]);

figure;
jSlider = javax.swing.JSlider;
jSlider.setValue(57);
[jhSlider,hContainer]=javacomponent(jSlider,[10,55,100,40]);
set(jSlider,'MajorTickSpacing',20,'PaintLabels',true);
% javacomponent(jSlider,[10,70,200,20]); 
% set(jSlider, 'Value',84, 'MajorTickSpacing',20, 'PaintLabels',true);  % no labels, no ticks 
% hjSlider = handle(jSlider, 'CallbackProperties'); 
% hjSlider = javahandle_withcallbacks.javax.swing.JSlider; 
% set(hjSlider, 'StateChangedCallback', @myCallback);  %Callback definieren 
% figure;
% % Standard Java JSlider (20px high if no ticks/labels, otherwise use 45px)
% % jSlider = javax.swing.JSlider;
% % [jSlider, hContainer] = javacomponent(jSlider,[10,10,100,40]);
% % set(jSlider, 'Value',72, 'Orientation',jSlider.VERTICAL, 'MinorTickSpacing',5);
% % set(hContainer,'position',[10,10,40,100]); %note container size change
% 
% jSlider = javaObjectEDT(javax.swing.JSlider);
% set(jSlider, 'Value',22, 'MajorTickSpacing',20,'PaintTicks',true);
% jSlider.setPaintLabels(true); % or: jSlider.setPaintLabels(1);


% plot the found maxima on the previous graph
% hold on;
% plot (maxampu(:,1), maxampu(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'b', 'LineStyle', 'none');