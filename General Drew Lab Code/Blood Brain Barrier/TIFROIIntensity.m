clear; clc; format short g; format compact;

%% Add Function Path and Lookup .TIF Files
addpath('C:\Workspace\LabScripts\Functions')
Lookup = FileLookup('tif');

%% Convert MDF to TIF
%% Deinterleave
%% Read TIF File
for i = 1:Lookup.FileCount
    Image.All{i} = double(imread(fullfile(Lookup.FolderAddress, Lookup.FolderInfo(i).name)));
end

%% Separate Green/Red Channel
for i = 1:Lookup.FileCount
    if contains(Lookup.FolderInfo(i).name, 'green')
        Image.Green.Data{i} = Image.All{i};
        Image.Green.Name{i} = Lookup.FolderInfo(i).name;
    elseif contains(Lookup.FolderInfo(i).name, 'red')
        Image.Red.Data{i} = Image.All{i};
        Image.Red.Name{i} = Lookup.FolderInfo(i).name;
    end
end
Image.Green.Data = Image.Green.Data(~cellfun(@isempty, Image.Green.Data));
Image.Green.Name = Image.Green.Name(~cellfun(@isempty, Image.Green.Name));
Image.Red.Data = Image.Red.Data(~cellfun(@isempty, Image.Red.Data));
Image.Red.Name = Image.Red.Name(~cellfun(@isempty, Image.Red.Name));

%% Display TIF Files; separated by Red/Green Channel
ImageSet(Image.Green, "Green")
ImageSet(Image.Red, "Red")

function ImageSet(ImageStruct, Channel)
    figure('Name', Channel)
    tiledlayout('flow');
    ImageLayout = gobjects(1, numel(ImageStruct.Data));
    for i = 1:numel(ImageStruct.Data)
        ImageLayout(i) = nexttile;
        imagesc(ImageLayout(i), ImageStruct.Data{i});
        colormap gray; axis image off;
        title(ImageLayout(i), string(ImageStruct.Name{i}), 'Interpreter', 'none');
    end
end

%%% Display all TIF Files
%figure()
%t = tiledlayout('flow');
%ImageLayout = gobjects(1, Lookup.FileCount);
%for i = 1:Lookup.FileCount
%    ImageLayout(i) = nexttile;
%    imagesc(ImageLayout(i), Image{i});
%    colormap gray; axis image off;
%    title(ImageLayout(i), string(Lookup.FolderInfo(i).name), 'Interpreter', 'none');
%end

%% Define Image to Draw ROI
disp("Click on the image you'd like to draw the ROI on...")
[~, DemoImage.Click] = ginput(1);
DemoImage.ClickPosition = get(gca, 'CurrentPoint');
DemoImage.Index = find(ImageLayout == gca);

disp("Draw your ROI on the chosen image...")
ROI.UserDefined = drawfreehand('Parent', gca, 'FaceAlpha', 0.2, 'Color', [.1 .8 .8]);
ROI.Mask = createMask(ROI.UserDefined);

%% Overlay ROI onto all images
for i = 1:Lookup.FileCount
    axes(ImageLayout(i))
    hold on;
    ROIBoundary = bwboundaries(ROI.Mask);
    for j = 1:length(ROIBoundary)
        boundary = ROIBoundary{j};
        plot(boundary(:,2), boundary(:,1), 'Color', [.1 .8 .8], 'LineWidth', 2);
    end
end

%% Extract ROI Intensity
for i = 1:Lookup.FileCount
    ROI.Region = Image{i}(ROI.Mask);
    ROI.Information(i).Name = Lookup.FolderInfo(i).name;
    ROI.Information(i).Mean = mean(ROI.Region);
    ROI.Information(i).StandardDeviation = std(ROI.Region);
    ROI.Information(i).TotalPixels = numel(ROI.Region);
end

%% Results

ResultsTable = struct2table(ROI.Information);
disp(ResultsTable);
