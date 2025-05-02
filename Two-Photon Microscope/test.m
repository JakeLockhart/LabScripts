clear; clc; format short g; format compact;

%% Add Function Path and Lookup .TIF Files
addpath('C:\Workspace\LabScripts\Functions')
Lookup = FileLookup('tif');

%% Read All .TIF Files
for i = 1:Lookup.FileCount
    File{i} = imread(fullfile(Lookup.FolderAddress, Lookup.FolderInfo(i).name));
end

%% Display All Images in Tiled Layout
figure(1)
t = tiledlayout('flow');
ax = gobjects(1, Lookup.FileCount);  % Preallocate axes handles

for i = 1:Lookup.FileCount
    ax(i) = nexttile;
    imagesc(ax(i), double(File{i}));
    colormap gray; axis image off;
    title(ax(i), string(Lookup.FolderInfo(i).name), 'Interpreter', 'none');
end

%% Let User Select a Tile to Draw ROI
disp("Click on the image you'd like to draw the ROI on...");
[~, selectedAx] = ginput(1);  % Get click, but only x is returned
clickedPos = get(gca, 'CurrentPoint');
roiIndex = find(ax == gca);

disp("Draw your spline ROI on the selected image.");
h = drawfreehand('Parent', gca, 'FaceAlpha', 0.2, 'Color', [.1 .8 .8]);
input("Press Enter when you're done drawing the ROI...");

% Create mask from ROI
ROI.Mask = createMask(h);

%% Display All Images with ROI Overlay
figure(1)
tiledlayout('flow');

for i = 1:Lookup.FileCount
    nexttile;
    imagesc(double(File{i}));
    colormap gray; axis image off;
    title(string(Lookup.FolderInfo(i).name), 'Interpreter', 'none');
    hold on;

    % Draw ROI boundary
    B = bwboundaries(ROI.Mask);
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'Color', [.1 .8 .8], 'LineWidth', 2);
    end
end
