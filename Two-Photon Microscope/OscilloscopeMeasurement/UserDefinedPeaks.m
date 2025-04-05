function [X1, X2, canceled] = UserDefinedPeaks(Lookup, numTiles, plotMode, useAlignedData)
    % Read data from CSV files and populate Temp structure
    for i = 1:Lookup.FileCount
        Name = erase(Lookup.FolderInfo(i).name, ".csv");
        TempFile = readtable(fullfile(Lookup.FolderAddress, Name));
        
        % Extract time and voltage information
        Temp.Time(i,:) = TempFile{:,4} / TempFile{2,2};
        Temp.Voltage(i,:) = TempFile{:,5};
    end

    % If 'UseAligned' is passed, perform cross-correlation and create AlignedVoltage
    if strcmp(useAlignedData, 'UseAligned')
        for i = 1:Lookup.FileCount
            [xc, lags] = xcorr(Temp.Voltage(end,:), Temp.Voltage(i,:));
            [~, Index] = max(xc);
            Shift = lags(Index);
            Temp.AlignedVoltage(i,:) = circshift(Temp.Voltage(i,:), Shift);
        end
    end

    % Choose which voltage to plot based on the string input
    if strcmp(useAlignedData, 'UseAligned')
        voltageData = Temp.AlignedVoltage;
    elseif strcmp(useAlignedData, 'UseRaw')
        voltageData = Temp.Voltage;
    else
        error('Invalid argument. Use ''UseRaw'' or ''UseAligned''.');
    end

    % Pass the selected voltage data to the demo for plotting
    [X1, X2, canceled] = demo(Temp.Time, voltageData, numTiles, plotMode);
    X1 = find(abs(Temp.Time(1,:) - round(X1)) < 1e-6);
    X2 = find(abs(Temp.Time(1,:) - round(X2)) < 1e-6);
    
    if canceled
        disp('User canceled the operation. Exiting...');
        return;
    end
end


function [X1, X2, canceled] = demo(x, y, numTiles, plotMode)
    % Create figure and layout
    fig = figure('Name', 'Demo', 'NumberTitle', 'off', 'Position', [100 100 800 600]);
    t = tiledlayout(numTiles, 1, 'Parent', fig, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    % Initialize variables
    ax = gobjects(numTiles, 1);
    xl1 = gobjects(numTiles, 1);
    xl2 = gobjects(numTiles, 1);
    
    % Initial Xline values
    x1_init = min(x(1,:)) + (max(x(1,:)) - min(x(1,:))) * 0.3;
    x2_init = min(x(1,:)) + (max(x(1,:)) - min(x(1,:))) * 0.7;

    % Plot data
    if strcmp(plotMode, "single")
        for i = 1:numTiles
            ax(i) = nexttile(t);
            plot(ax(i), x(i,:), y(i,:));
            hold on;
            xl1(i) = xline(ax(i), x1_init, 'r', 'LineWidth', 2);
            xl2(i) = xline(ax(i), x2_init, 'b', 'LineWidth', 2);
        end
    elseif strcmp(plotMode, "all")
        ax(1) = nexttile(t);
        hold(ax(1), 'on');
        for i = 1:size(y, 1)
            plot(ax(1), x(i,:), y(i,:));
        end
        xl1(1) = xline(ax(1), x1_init, 'r', 'LineWidth', 2);
        xl2(1) = xline(ax(1), x2_init, 'b', 'LineWidth', 2);
    end

    % Create sliders
    sld1 = create_slider(x(1,:), x1_init, [0.1 0.05 0.35 0.05]);
    sld2 = create_slider(x(1,:), x2_init, [0.55 0.05 0.35 0.05]);
    
    % Initialize slider values
    sld1.UserData.LastValue = sld1.Value;
    sld2.UserData.LastValue = sld2.Value;
    
    % Add listener to sliders for real-time updates
    addlistener(sld1, 'ContinuousValueChange', @(src, ~) adaptive_xline_update(src, xl1, xl2, true));
    addlistener(sld2, 'ContinuousValueChange', @(src, ~) adaptive_xline_update(src, xl1, xl2, false));
    
    % Create buttons
    create_button('Get Xline Values',[0.3 0.02 0.2 0.05], @() uiresume(fig));
    create_button('Check', [0.55 0.02 0.2 0.05], @() check_xlim(ax, xl1(1).Value, xl2(1).Value));
    create_button('Reset', [0.8 0.02 0.2 0.05], @() reset_demo(xl1, xl2, x1_init, x2_init));
    create_button('Cancel', [0.05 0.02 0.2 0.05], @() cancel_demo(fig));
    
    % Wait for user interaction
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
    slider = uicontrol('Style', 'slider', 'Min', min(x), 'Max', max(x), 'Value', init_value, ...
                       'Units', 'normalized', 'Position', position);
end

function create_button(label, position, callback)
    uicontrol('Style', 'pushbutton', 'String', label, 'Units', 'normalized', ...
              'Position', position, 'Callback', @(~, ~) callback());
end

function adaptive_xline_update(slider, xl1, xl2, isX1)
    persistent lastUpdateTime;
    
    % Get current time for throttling updates
    currentTime = tic;
    
    % Throttle the update rate by checking the time difference (e.g., 0.1 seconds)
    if isempty(lastUpdateTime) || toc(lastUpdateTime) > 0.1
        % Proceed with slider value update
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
        
        % Update the time of last update to throttle the function
        lastUpdateTime = currentTime;
    end
end

function check_xlim(ax, X1, X2)
    for i = 1:3
        ax(i).XLim = [0.9 * X1, 1.1 * X2];
    end
end

function cancel_demo(fig)
    close(fig);
end

function reset_demo(xl1, xl2, x1_init, x2_init)
    % Reset Xline positions to initial values
    for i = 1:3
        xl1(i).Value = x1_init;
        xl2(i).Value = x2_init;
    end
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
