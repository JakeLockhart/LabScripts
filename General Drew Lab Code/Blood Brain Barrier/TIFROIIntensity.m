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
        Image.Green.RawData{i} = Image.All{i};
        Image.Green.Name{i} = Lookup.FolderInfo(i).name;
    elseif contains(Lookup.FolderInfo(i).name, 'red')
        Image.Red.RawData{i} = Image.All{i};
        Image.Red.Name{i} = Lookup.FolderInfo(i).name;
    end
end
Image.Green.RawData = Image.Green.RawData(~cellfun(@isempty, Image.Green.RawData));
Image.Green.Name = Image.Green.Name(~cellfun(@isempty, Image.Green.Name));
Image.Red.RawData = Image.Red.RawData(~cellfun(@isempty, Image.Red.RawData));
Image.Red.Name = Image.Red.Name(~cellfun(@isempty, Image.Red.Name));

%% Display TIF Files; separated by Red/Green Channel
Image.Green.Layout = ImageSet(Image.Green, "Green", "RawData");
Image.Red.Layout = ImageSet(Image.Red, "Red", "RawData");

function ImageLayout = ImageSet(ImageStruct, Channel, ImageType)
    ImageLayout.(Channel) = figure('Name', Channel);
    tiledlayout('flow');
    ImageLayout.axes = gobjects(1, numel(ImageStruct.(ImageType)));
    for i = 1:numel(ImageStruct.(ImageType))
        ImageLayout.axes(i) = nexttile;
        imagesc(ImageLayout.axes(i), ImageStruct.(ImageType){i});
        colormap gray; axis image off;
        title(ImageLayout.axes(i), string(ImageStruct.Name{i}), 'Interpreter', 'none');
    end
end

%% Choose Reference Image
ReferenceImage = ChooseReference(Image.Green.Layout.Green);

function ReferenceImage = ChooseReference(Figure)
    figure((Figure))
    [~,~] = ginput(1);
    ReferenceImage = gca;
end



