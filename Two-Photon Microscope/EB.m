clear; clc; format short g; format compact;

%% Choose Folder with .TIF Files
addpath('C:\Workspace\LabScripts\Functions')
Lookup = FileLookup('tif');

%% Read .TIF File
for i = 1:Lookup.FileCount
    File{i} = imread(fullfile(Lookup.FolderAddress, Lookup.FolderInfo(i).name));
end

%% Draw ROI on .TIF
figure(1)
imagesc(double(File{1}));
colormap gray; axis image;
title("Draw your ROI");
xlabel('Pixels'); ylabel('Pixels');
Box = drawrectangle('FaceAlpha', 0);
disp("Drawn your ROI where you want it. Press 'Enter' when done");
input("Drawn your ROI where you want it. Press 'Enter' when done");
ROI.xy = Box.Position;
close(figure(1));
ROI.PixelWidth = round(ROI.xy(1):ROI.xy(1)+ROI.xy(3));
ROI.PixelHeight = round(ROI.xy(2):ROI.xy(2)+ROI.xy(4));

%% Display all .TIF files to confirm ROI
figure(1)
t = tiledlayout('flow');
for i = 1:Lookup.FileCount
    nexttile;
    imagesc(double(File{i}));
    colormap gray; axis image;
    title(string(Lookup.FolderInfo(i).name), 'Interpreter', 'none');
    hold on;
    rectangle("Position", ROI.xy, "FaceColor", "none", "EdgeColor", [.1 .8 .8], "LineWidth", 2);
end
