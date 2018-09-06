% plots the input
% necessary arguments:
%   xy_AUX (data),
%   pmd_name (for the title)
% optional input as name value pairs:
%   marker
%   peaks
% Ulrike Horn
% ulrike.horn@uni-greifswald.de
% 31.08.2017

function plot_again(xy_AUX,pmd_name,varargin)

default_marker=[];
default_peaks=[];
default_task=[];
default_background=[];
p = inputParser;
addRequired(p,'xy_AUX');
addRequired(p,'pmd_name');
addParameter(p,'marker',default_marker,@isnumeric);
addParameter(p,'peaks',default_peaks,@isnumeric);
addParameter(p,'task',default_task,@isnumeric);
addParameter(p,'background',default_background,@isnumeric);

parse(p,xy_AUX,pmd_name,varargin{:});

xy_AUX=p.Results.xy_AUX;
pmd_name=p.Results.pmd_name;
marker=p.Results.marker;
peaks=p.Results.peaks;
task=p.Results.task;
background=p.Results.background;

% do not plot the first time points as the varioport needs some time to
% reach the normal amplitude
plot (xy_AUX(20:end, 1), xy_AUX(20:end, 2), 'k');
axis ( [ min(xy_AUX(20:end, 1)) max(xy_AUX(20:end, 1)) ...
    min(xy_AUX(20:end, 2)) max(xy_AUX(20:end, 2)) ] );
xlabel({'time (s)'});
ylabel({'AUX (a.u.)'});
title({strcat('AUX-', pmd_name) });
hold on

if ~isempty(marker)
    plot(marker(:,1), marker(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'r', 'LineStyle', 'none');
end
if ~isempty(peaks)
    plot (peaks(:,1), peaks(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'b', 'LineStyle', 'none');
end
if ~isempty(task)
    for i=1:size(task,1)
        patch([task(i,1) task(i,1) task(i,2) task(i,2)],[min(ylim) max(ylim) max(ylim) min(ylim)],[0.7 0.7 0.7]);
    end
    plot (xy_AUX(20:end, 1), xy_AUX(20:end, 2), 'k');
    if ~isempty(marker)
        plot(marker(:,1), marker(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'r', 'LineStyle', 'none');
    end
    if ~isempty(peaks)
        plot (peaks(:,1), peaks(:,2), 'Marker', 'o', 'MarkerSize', 5, 'Color', 'b', 'LineStyle', 'none');
    end
end
if ~isempty(background)
    line([xy_AUX(20,1) xy_AUX(end,1)],[background background],'Color','red','LineStyle','-');
end
hold off