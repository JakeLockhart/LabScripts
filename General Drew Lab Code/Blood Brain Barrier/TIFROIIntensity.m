%addpath('C:\Workspace\LabScripts\Functions')
%zap
%clear; clc; format short g; format compact;
%
%
%%% Add Function Path and Lookup .TIF Files
%addpath('C:\Workspace\LabScripts\Functions')
%Lookup = FileLookup('tif');
%
%%% Convert MDF to TIF
%%% Deinterleave
%%% Read TIF File
%for i = 1:Lookup.FileCount
%    Image.All{i} = double(imread(fullfile(Lookup.FolderAddress, Lookup.FolderInfo(i).name)));
%end
%
%%% Separate Green/Red Channel
%for i = 1:Lookup.FileCount
%    if contains(Lookup.FolderInfo(i).name, 'green')
%        Image.Green.RawData{i} = Image.All{i};
%        Image.Green.Name{i} = Lookup.FolderInfo(i).name;
%    elseif contains(Lookup.FolderInfo(i).name, 'red')
%        Image.Red.RawData{i} = Image.All{i};
%        Image.Red.Name{i} = Lookup.FolderInfo(i).name;
%    end
%end
%Image.Green.RawData = Image.Green.RawData(~cellfun(@isempty, Image.Green.RawData));
%Image.Green.Name = Image.Green.Name(~cellfun(@isempty, Image.Green.Name));
%Image.Red.RawData = Image.Red.RawData(~cellfun(@isempty, Image.Red.RawData));
%Image.Red.Name = Image.Red.Name(~cellfun(@isempty, Image.Red.Name));
%
%%% Display TIF Files; separated by Red/Green Channel
%Image.Green.Layout = ImageSet(Image.Green, "Green", "RawData");
%Image.Red.Layout = ImageSet(Image.Red, "Red", "RawData");
%
%function ImageLayout = ImageSet(ImageStruct, Channel, ImageType)
%    ImageLayout.(Channel) = figure('Name', Channel);
%    tiledlayout('flow');
%    ImageLayout.axes = gobjects(1, numel(ImageStruct.(ImageType)));
%    for i = 1:numel(ImageStruct.(ImageType))
%        ImageLayout.axes(i) = nexttile;
%        imagesc(ImageLayout.axes(i), ImageStruct.(ImageType){i});
%        colormap gray; axis image off;
%        title(ImageLayout.axes(i), string(ImageStruct.Name{i}), 'Interpreter', 'none');
%    end
%end
%
%%% Choose Reference Image
%ReferenceImage = ChooseReference(Image.Green.Layout.Green);
%
%function ReferenceImage = ChooseReference(Figure)
%    figure((Figure))
%    [~,~] = ginput(1);
%    ReferenceImage = gca;
%end



% -------------------- Old mix
addpath('C:\Workspace\LabScripts\Functions')
zap
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
ImageSet(Image.Green, "Green", "Data")
ImageSet(Image.Red, "Red", "Data")

function ImageSet(ImageStruct, Channel, ImageType)
    figure('Name', Channel)
    tiledlayout('flow');
    ImageLayout = gobjects(1, numel(ImageStruct.(ImageType)));
    for i = 1:numel(ImageStruct.(ImageType))
        ImageLayout(i) = nexttile;
        imagesc(ImageLayout(i), ImageStruct.(ImageType){i});
        colormap gray; axis image off;
        title(ImageLayout(i), string(ImageStruct.Name{i}), 'Interpreter', 'none');
    end
end

%% Draw ROI
figure(1);
[ROI, ReferenceImage] = DefineROI(Image.Green, "Data");

function [ROI, ReferenceImage] = DefineROI(ImageStruct, ImageType)
    disp("Click on the iamge you'd like to draw the ROI on...");
    ImageLayout = gobjects(1, numel(ImageStruct.(ImageType)));
    [~,~] = ginput(1);
    Index = gca;
    ReferenceImage = find(ImageLayout == Index);

    disp("Draw your ROI on the chosen image...");
    ROI.UserDefined = drawfreehand('Parent', Index, 'FaceAlpha', 0.2, 'Color', [.1 .8 .8]);
    ROI.Mask = createMask(ROI.UserDefined);
end


%% Image registration to align images and update figures
Image.Green = ImageRegister(Image.Green);
Image.Red = ImageRegister(Image.Red);
ImageSet(Image.Green, "Green Aligned", "Registered")
ImageSet(Image.Red, "Red Aligned", "Registered")

function ImageStruct = ImageRegister(ImageStruct)
    ImageStruct.Registered{3} = ImageStruct.Data{1};
    optimizer = registration.optimizer.RegularStepGradientDescent;
    metric = registration.metric.MeanSquares;
    for i = 1:numel(ImageStruct.Data)
        Moving = ImageStruct.Data{i};
        Registered = imregister(Moving, ImageStruct.Registered{3}, 'translation', optimizer, metric);
        ImageStruct.Registered{i} = Registered;
    end
end

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