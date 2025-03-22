clear; clc; close all; format short; format compact;

% Select folder and retrieve file list
SystemProperties.FilePath.GetFolder = uigetdir('*.*','Select a file');                          
SystemProperties.FilePath.Address = SystemProperties.FilePath.GetFolder + "\*.csv";         
SystemProperties.FilePath.Folder = dir(SystemProperties.FilePath.Address);                  
SystemProperties.FilePath.Data.Length = length(SystemProperties.FilePath.Folder);           
SystemProperties.FilePath.Data.Address = erase(SystemProperties.FilePath.Address,"*.csv");  
[FolderPath, ~, ~] = fileparts(SystemProperties.FilePath.Address);
SystemProperties.FilePath.CurrentFolder = regexp(FolderPath, '([^\\]+)$', 'match', 'once');

%% Read .CSV file
for i = 1:SystemProperties.FilePath.Data.Length
    Name = erase(SystemProperties.FilePath.Folder(i).name, ".csv");
    TempFile = readtable(fullfile(SystemProperties.FilePath.Data.Address, Name));
    Oscope.Time(i,:) = TempFile{:,4} / TempFile{2,2}; % Normalize time
    Oscope.Voltage(i,:) = TempFile{:,5};
end

%% Run the Demo and Get Xline Values
[X1, X2, canceled] = demo(Oscope.Time(1,:), Oscope.Voltage(1,:));

% If user canceled, stop execution
if canceled
    disp('User canceled the operation. Exiting...');
    return;
end

% Display stored xline values in the command window
fprintf('Final Xline 1 Position: %.4f\n', X1);
fprintf('Final Xline 2 Position: %.4f\n', X2);

function [X1, X2, canceled] = demo(x, y)
    % Create figure
    fig = figure('Name', 'Demo', 'NumberTitle', 'off', 'Position', [100 100 800 600]);
    ax = axes('Parent', fig, 'Position', [0.1 0.3 0.8 0.6]); 
    plot(ax, x, y);
    hold on;
    
    % Initial xline positions
    x1_init = min(x) + (max(x) - min(x)) * 0.3;
    x2_init = min(x) + (max(x) - min(x)) * 0.7;
    
    % Create xlines
    xl1 = xline(x1_init, 'r', 'LineWidth', 2);
    xl2 = xline(x2_init, 'b', 'LineWidth', 2);
    
    % Create UI elements
    sld1 = uicontrol('Style', 'slider', 'Min', min(x), 'Max', max(x), ...
        'Value', x1_init, 'Units', 'normalized', ...
        'Position', [0.1 0.1 0.35 0.05]);

    sld2 = uicontrol('Style', 'slider', 'Min', min(x), 'Max', max(x), ...
        'Value', x2_init, 'Units', 'normalized', ...
        'Position', [0.55 0.1 0.35 0.05]);

    % Store last value for adaptive sensitivity
    sld1.UserData.LastValue = sld1.Value;
    sld2.UserData.LastValue = sld2.Value;

    % Set up listeners for real-time updates while dragging
    addlistener(sld1, 'ContinuousValueChange', @(src, ~) adaptive_xline_update(src, xl1, xl2, true));
    addlistener(sld2, 'ContinuousValueChange', @(src, ~) adaptive_xline_update(src, xl1, xl2, false));

    % Button to fetch values and close window
    btn_get = uicontrol('Style', 'pushbutton', 'String', 'Get Xline Values', ...
        'Units', 'normalized', ...
        'Position', [0.3 0.02 0.2 0.05], ...
        'Callback', @(~, ~) uiresume(fig));

    % Button to update xlim based on X1 and X2
    btn_check = uicontrol('Style', 'pushbutton', 'String', 'Check', ...
        'Units', 'normalized', ...
        'Position', [0.55 0.02 0.2 0.05], ...
        'Callback', @(~, ~) check_xlim(ax, xl1.Value, xl2.Value));

    % Cancel Button (Stops Execution)
    btn_cancel = uicontrol('Style', 'pushbutton', 'String', 'Cancel', ...
        'Units', 'normalized', ...
        'Position', [0.05 0.02 0.2 0.05], ...
        'Callback', @(~, ~) cancel_demo(fig));

    % Wait for user interaction
    uiwait(fig);

    % If figure is still open, fetch final values; else return cancellation flag
    if isvalid(fig)
        X1 = xl1.Value;
        X2 = xl2.Value;
        canceled = false;
        close(fig);
    else
        X1 = [];
        X2 = [];
        canceled = true;
    end
end

% Callback function for dynamic sensitivity in slider movement
function adaptive_xline_update(slider, xl1, xl2, isX1)
    newValue = slider.Value;
    lastValue = slider.UserData.LastValue;
    
    % Compute speed of movement
    speed = abs(newValue - lastValue);
    
    % Define sensitivity levels
    fine_step = 0.001 * (xl2.Value - xl1.Value); % Small step
    coarse_step = 0.02 * (xl2.Value - xl1.Value); % Large step
    
    % Adjust step size dynamically
    if speed < 0.005 * (xl2.Value - xl1.Value)
        step_size = fine_step; % Fine tuning for small movements
    else
        step_size = coarse_step; % Coarse adjustment for fast movements
    end
    
    % Apply step size
    if isX1
        newValue = round(newValue / step_size) * step_size;
        if newValue >= xl2.Value
            newValue = xl2.Value - step_size; % Prevent overlap
        end
        xl1.Value = newValue;
    else
        newValue = round(newValue / step_size) * step_size;
        if newValue <= xl1.Value
            newValue = xl1.Value + step_size; % Prevent overlap
        end
        xl2.Value = newValue;
    end
    
    % Store last position for next update
    slider.UserData.LastValue = newValue;
    slider.Value = newValue;
end

% Callback function to update xlim() based on X1 and X2
function check_xlim(ax, X1, X2)
    ax.XLim = [0.9 * X1, 1.1 * X2]; % Zoom in based on xline positions
end

% Cancel Function: Closes the figure and stops execution
function cancel_demo(fig)
    close(fig); % Close UI figure
end
