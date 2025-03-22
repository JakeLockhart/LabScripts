clear; clc; close all; format short; format compact;

% Select folder and retrieve file list
SystemProperties.FileType = '*.csv';  
SystemProperties.FilePath.GetFolder = uigetdir('*.*','Select a file');                           
SystemProperties.FilePath.Address = SystemProperties.FilePath.GetFolder + "\" + SystemProperties.FileType;         
SystemProperties.FilePath.Folder = dir(SystemProperties.FilePath.Address);                    
SystemProperties.FilePath.Data.Length = length(SystemProperties.FilePath.Folder);           
SystemProperties.FilePath.Data.Address = erase(SystemProperties.FilePath.Address, SystemProperties.FileType);  
[FolderPath, ~, ~] = fileparts(SystemProperties.FilePath.Address);
SystemProperties.FilePath.CurrentFolder = regexp(FolderPath, '([^\\]+)$', 'match', 'once');

%% Read .CSV files
for i = 1:SystemProperties.FilePath.Data.Length
    Name = erase(SystemProperties.FilePath.Folder(i).name, ".csv");
    TempFile = readtable(fullfile(SystemProperties.FilePath.Data.Address, Name));
    Oscope.Time(i,:) = TempFile{:,4} / TempFile{2,2}; % Normalize time
    Oscope.Voltage(i,:) = TempFile{:,5};
end

%% Run the Demo and Get Xline Values
[X1, X2, canceled] = demo(Oscope.Time, Oscope.Voltage);

if canceled
    disp('User canceled the operation. Exiting...');
    return;
end

fprintf('Final Xline 1 Position: %.4f\n', X1);
fprintf('Final Xline 2 Position: %.4f\n', X2);

function [X1, X2, canceled] = demo(x, y)
    fig = figure('Name', 'Demo', 'NumberTitle', 'off', 'Position', [100 100 800 600]);
    t = tiledlayout(3,1, 'Parent', fig);
    ax = gobjects(3,1);
    xl1 = gobjects(3,1);
    xl2 = gobjects(3,1);
    
    for i = 1:3
        ax(i) = nexttile(t);
        plot(ax(i), x(i,:), y(i,:));
        hold on;
        x1_init = min(x(i,:)) + (max(x(i,:)) - min(x(i,:))) * 0.3;
        x2_init = min(x(i,:)) + (max(x(i,:)) - min(x(i,:))) * 0.7;
        xl1(i) = xline(ax(i), x1_init, 'r', 'LineWidth', 2);
        xl2(i) = xline(ax(i), x2_init, 'b', 'LineWidth', 2);
    end
    
    sld1 = create_slider(x(1,:), x1_init, [0.1 0.1 0.35 0.05]);
    sld2 = create_slider(x(1,:), x2_init, [0.55 0.1 0.35 0.05]);
    
    sld1.UserData.LastValue = sld1.Value;
    sld2.UserData.LastValue = sld2.Value;
    
    addlistener(sld1, 'ContinuousValueChange', @(src, ~) adaptive_xline_update(src, xl1, xl2, true));
    addlistener(sld2, 'ContinuousValueChange', @(src, ~) adaptive_xline_update(src, xl1, xl2, false));
    
    create_button('Get Xline Values', [0.3 0.02 0.2 0.05], @() uiresume(fig));
    create_button('Check', [0.55 0.02 0.2 0.05], @() check_xlim(ax, xl1(1).Value, xl2(1).Value));
    create_button('Cancel', [0.05 0.02 0.2 0.05], @() cancel_demo(fig));
    
    uiwait(fig);
    
    if isvalid(fig)
        X1 = xl1(1).Value;
        X2 = xl2(1).Value;
        canceled = false;
        close(fig);
    else
        X1 = [];
        X2 = [];
        canceled = true;
    end
end

function slider = create_slider(x, init_value, position)
    slider = uicontrol('Style', 'slider', 'Min', min(x), 'Max', max(x), 'Value', init_value, 'Units', 'normalized', 'Position', position);
end

function create_button(label, position, callback)
    uicontrol('Style', 'pushbutton', 'String', label, 'Units', 'normalized', 'Position', position, 'Callback', @(~, ~) callback());
end

function adaptive_xline_update(slider, xl1, xl2, isX1)
    newValue = slider.Value;
    lastValue = slider.UserData.LastValue;
    speed = abs(newValue - lastValue);
    fine_step = 0.001 * (xl2(1).Value - xl1(1).Value);
    coarse_step = 0.02 * (xl2(1).Value - xl1(1).Value);
    step_size = ifelse(speed < 0.005 * (xl2(1).Value - xl1(1).Value), fine_step, coarse_step);
    newValue = round(newValue / step_size) * step_size;
    
    if isX1
        if newValue >= xl2(1).Value - step_size
            newValue = xl2(1).Value - step_size;
            flash_xline(xl1(1));
            warning('Xline 1 cannot exceed Xline 2. Keeping at limit.');
        end
        for i = 1:3
            xl1(i).Value = newValue;
        end
    else
        if newValue <= xl1(1).Value + step_size
            newValue = xl1(1).Value + step_size;
            flash_xline(xl2(1));
            warning('Xline 2 cannot be lower than Xline 1. Keeping at limit.');
        end
        for i = 1:3
            xl2(i).Value = newValue;
        end
    end
    
    slider.UserData.LastValue = newValue;
    slider.Value = newValue;
end

function check_xlim(ax, X1, X2)
    for i = 1:3
        ax(i).XLim = [0.9 * X1, 1.1 * X2];
    end
end

function cancel_demo(fig)
    close(fig);
end

function flash_xline(xl)
    originalColor = xl.Color;
    xl.Color = 'm';
    pause(0.1);
    xl.Color = originalColor;
end

function result = ifelse(condition, true_value, false_value)
    if condition
        result = true_value;
    else
        result = false_value;
    end
end
