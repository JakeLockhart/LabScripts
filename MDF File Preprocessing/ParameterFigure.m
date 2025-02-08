clear; clc;
% Collect first 50 Frames
RawStack = randi([0,4000], 512, 512, 20);

% Determine Window Positions
WindowPosition.ScreenXY = get(0, 'ScreenSize');
WindowPosition.Box = [750, 750];
WindowPosition.Main = [ (WindowPosition.ScreenXY(3) - WindowPosition.Box(1))/2, (WindowPosition.ScreenXY(4) - WindowPosition.Box(2))/2, WindowPosition.Box(1), WindowPosition.Box(2)];
WindowPosition.ParametersPanel =    [10, 650, WindowPosition.Main(3) - 20, 100];
WindowPosition.ControlPanel =       [10, 540, WindowPosition.Main(3) - 20, 100];
WindowPosition.ImagePanel =         [10, 10,  WindowPosition.Main(3) - 20, 520];

% Create figure & panels
Main = uifigure('Name', 'Preprocessing Raw Stack', 'Position', WindowPosition.Main);
ParametersPanel = uipanel(Main,'Title', 'Parameters', 'Position', WindowPosition.ParametersPanel);
ImagePanel = uipanel(Main, 'Title', 'Imaging Plane(s)', 'Position', WindowPosition.ImagePanel);
ControlPanel = uipanel(Main, 'Title', 'Controls', 'Position', WindowPosition.ControlPanel);

% Create Controllers
uicontrol('Style', 'text', 'Parent', ParametersPanel, 'Position', [10, 5, 50, 50], 'String', 'Imaging Planes ');
Prompt.ImagingPlanes = uieditfield(ParametersPanel, "numeric", "Limits", [1, Inf], 'RoundFractionalValues', true, 'Position', [75, 15, 50, 50], 'ValueChangedFcn', @(src, event) updateImagePlanes(ImagePanel, src.Value, RawStack));
updateImagePlanes(ImagePanel, Prompt.ImagingPlanes.Value, RawStack);

uicontrol('Style', 'text', 'Parent', ParametersPanel, 'Position', [150, 5, 50, 50], 'String', 'Analysis Method ');
Prompt.AnalysisMethod = uidropdown(ParametersPanel, "Items", ["TiRS", "FWHM", "Point-Spread Function", "Preprocessing"], "Position", [210, 15, 75, 50]);

uicontrol('Style', 'pushbutton', 'Parent', ControlPanel, 'Position', [10,10,50,50], 'String', 'Confirm', 'Callback', @(src, event) uiresume(gcbf));


% Exit GUI & Save Controls
uiwait(Main);
ImagingPlanes = Prompt.ImagingPlanes.Value;
AnalysisMethod = Prompt.AnalysisMethod.Value;

close(Main);
disp("Parameters Collected.")

function updateImagePlanes(ImagePanel, TotalPlanes, RawStack)
    delete(ImagePanel.Children);
    t = tiledlayout(ImagePanel, 'flow', 'Padding', 'compact', 'TileSpacing', 'compact');
    Columns = ceil(sqrt(TotalPlanes));
    Rows = ceil(sqrt(TotalPlanes/Columns));
    t.GridSize = [Rows, Columns];
    for i = 1:TotalPlanes
        ax = nexttile(t);
        img = RawStack(:,:,i:TotalPlanes:end);
        img = mean(img,3);
        img = img - min(img, [], 'all');
        img = img / max(img, [], 'all');
        img = img * 65535;
        imshow(img, 'Parent', ax);
        title(ax, sprintf('Imaging Plane %d', i));
    end
end
function updateContrast()
end
function updatePixelShift()
end








