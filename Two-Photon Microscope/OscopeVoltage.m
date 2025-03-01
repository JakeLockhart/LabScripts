clear; clc; format short; format compact;

SystemProperties.FilePath.GetFolder = uigetdir('*.*','Select a file');                          % Choose folder path location
        SystemProperties.FilePath.Address = SystemProperties.FilePath.GetFolder + "\*.csv";         % Convert to filepath
        SystemProperties.FilePath.Folder = dir(SystemProperties.FilePath.Address);                  % Identify the folder directory 
        SystemProperties.FilePath.Data.Length = length(SystemProperties.FilePath.Folder);           % Determine the number of files in folder directory
        SystemProperties.FilePath.Data.Address = erase(SystemProperties.FilePath.Address,"*.csv");  % Create beginning address for file path


%% Read .CSV file
for i = 1:SystemProperties.FilePath.Data.Length
    Name = erase(SystemProperties.FilePath.Folder(i).name, ".csv");
    if strcmpi(Name, "Notes"); continue; end;
    TempFile = readtable(fullfile(SystemProperties.FilePath.Data.Address, Name));
    Oscope.RecordLength(i,:) = TempFile{1,2};
    Oscope.SampleInterval(i,:) = TempFile{2,2};
    Oscope.Time(i,:) = TempFile{:,4}/Oscope.SampleInterval(i,:);
    Oscope.Voltage(i,:) = TempFile{:,5};
end
Oscope.PulseWidth = 100;
Oscope.PulseGap = 50;

%% Cross Correlation to Sync Waveforms
for i = 1:SystemProperties.FilePath.Data.Length
    [xc, lags] = xcorr(Oscope.Voltage(end,:), Oscope.Voltage(i,:));
    [~, Index] = max(xc);
    Shift = lags(Index);
    Oscope.AlignedVoltage(i,:) = circshift(Oscope.Voltage(i,:), Shift);
end

%% Histogram & High/Low Signal Data Analysis
WF_T.TotalBins = linspace(0, max(1.25*Oscope.Voltage(end)), SystemProperties.FilePath.Data.Length*10);
for i = 1:SystemProperties.FilePath.Data.Length
    [Count, BinEdge] = histcounts(Oscope.AlignedVoltage(i,:), WF_T.TotalBins);
    WF_T.Count(i,:) = Count;
    WF_T.BinEdge(i,:) = BinEdge;
    WF_T.BinCenter(i,:) = (WF_T.BinEdge(i, 1:end-1) + WF_T.BinEdge(i, 2:end))/ 2;

    WF_S.TotalBins = sqrt(size(Oscope.AlignedVoltage(i,:),2));
    [Count, BinEdge] = histcounts(Oscope.AlignedVoltage(i,:), WF_S.TotalBins);
    WF_S.Count(i,:) = Count;
    WF_S.BinEdge(i,:) = BinEdge;
    WF_S.BinCenter(i,:) = (WF_S.BinEdge(i, 1:end-1) + WF_S.BinEdge(i, 2:end))/ 2;

    LowSignal.Count(i,:) = WF_S.Count(i, 1:round(end/2));
    LowSignal.BinEdge(i,:) = WF_S.BinEdge(i, 1:round(end/2));
    LowSignal.BinCenter(i,:) = WF_S.BinCenter(i, 1:round(end/2));
    [LowPeak, LowLocation] = findpeaks(LowSignal.Count(i,:));
    [~, Index] = max(LowPeak);
    LowSignal.Voltage(i,:) = LowSignal.BinCenter(i, LowLocation(Index));

    HighSignal.Count(i,:) = WF_S.Count(i, round(end/2):end);
    HighSignal.BinEdge(i,:) = WF_S.BinEdge(i, round(end/2):end);
    HighSignal.BinCenter(i,:) = WF_S.BinCenter(i, round(end/2):end);
    [HighPeak, HighLocation] = findpeaks(HighSignal.Count(i,:));
    [~, Index] = max(HighPeak);
    HighSignal.Voltage(i,:) = HighSignal.BinCenter(i, HighLocation(Index));
end

%% Plot Initial Signal Processing
figure(1)
t = tiledlayout(3,1);
title(t, "MScan Oscilloscope Data Processing", 'Color', 'white')
ylabel(t, "Waveform Voltage [mV]", 'Color', 'white');
ColorMap = hsv(SystemProperties.FilePath.Data.Length);
set(gcf,"Color", [0 0 0])
nexttile(1)
title("Raw Signal Data", 'Color', 'white')
axis tight;
set(gca, 'Color', [0 0 0]); 
set(gca, 'XColor', 'white', 'YColor', 'white');
hold on;
nexttile(2)
title("Aligned Signal Data", 'Color', 'white')
axis tight;
set(gca, 'Color', [0 0 0]); 
set(gca, 'XColor', 'white', 'YColor', 'white');
hold on;
nexttile(3)    
title("Aligned Single Step Waveforms", 'Color', 'white')
xlim([-25, 150]); ylim([1.05*min(min(Oscope.AlignedVoltage)), 1.1*max(max(Oscope.AlignedVoltage))]);
xlabel("Time [\mus]", 'Color', 'white');
set(gca, 'Color', [0 0 0]); hold on;
set(gca, 'XColor', 'white', 'YColor', 'white');

for i = 1:SystemProperties.FilePath.Data.Length
    nexttile(1)
    plot(Oscope.Time(i,:), Oscope.Voltage(i,:), "Color", ColorMap(i,:)); hold on;
    nexttile(2)
    plot(Oscope.Time(i,:), Oscope.AlignedVoltage(i,:), "Color", ColorMap(i,:)); hold on;
    nexttile(3)
    plot(Oscope.Time(i,:),Oscope.AlignedVoltage(i,:), "Color", ColorMap(i,:)); hold on;
    pause(0.01)
end

%% Plot Global Histogram and Single Steps
figure(2)
t = tiledlayout(1,3);
title(t, "Voltage Step & Histogram", 'Color', 'white');
ColorMap = hsv(SystemProperties.FilePath.Data.Length);
set(gcf,"Color", [0 0 0])
nexttile(1)
title("Low & High Signal Histogram for Each Waveform", 'Color', 'white')
xlabel("Waveform Voltage [mV]", 'Color', 'white'); ylabel("Frequency [Counts]", 'Color', 'white');
ylim([0,750]);
xlim([1.05*min(min(Oscope.AlignedVoltage)), 1.1*max(max(Oscope.AlignedVoltage))]);
set(gca, 'Color', [0 0 0]); 
set(gca, 'XColor', 'white', 'YColor', 'white');
hold on;
nexttile(2)    
title("Single Step Waveforms", 'Color', 'white')
xlabel("Time [\mus]", 'Color', 'white'); ylabel("Voltage [mV]", 'Color', 'white');
xlim([-25, 150]); ylim([1.05*min(min(Oscope.AlignedVoltage)), 1.1*max(max(Oscope.AlignedVoltage))]);
set(gca, 'Color', [0 0 0]); hold on;
set(gca, 'XColor', 'white', 'YColor', 'white');
nexttile(3)
title("High & Low Signal Voltages", 'Color', 'white')
xlabel("Laser Input Intensity", 'Color', 'white'); ylabel("Voltage [mV]", 'Color', 'white');
set(gca, 'Color', [0 0 0]); hold on;
set(gca, 'XColor', 'white', 'YColor', 'white');
Interval = [-1,0:5:100];
grid on; axis tight;
for i = 1:SystemProperties.FilePath.Data.Length
    nexttile(1)
    bar(WF_T.BinCenter(i,:), WF_T.Count(i,:), "FaceAlpha", 0.75, "FaceColor", ColorMap(i,:), "EdgeColor", "none"); hold on;
    nexttile(2)
    plot(Oscope.Time(i,:), Oscope.AlignedVoltage(i,:), "Color", ColorMap(i,:)); hold on;
    nexttile(3)
    plot(Interval(i), LowSignal.Voltage(i), '.', 'MarkerSize', 30, 'Color', ColorMap(i,:), 'HandleVisibility', 'off'); hold on;
    plot(Interval(i), HighSignal.Voltage(i), '.', 'MarkerSize', 30, 'Color', ColorMap(i,:), 'HandleVisibility', 'off'); hold on;
    pause(0.5);
end
    plot(Interval, HighSignal.Voltage, 'w--', 'HandleVisibility', 'off'); hold on;
    plot(Interval, LowSignal.Voltage, 'w--', 'HandleVisibility', 'off'); hold on;
    plot(Interval, HighSignal.Voltage, '.', 'MarkerSize', 30, 'Color', 'red'); hold on;
    plot(Interval, LowSignal.Voltage, '.', 'MarkerSize', 30, 'Color', 'blue'); hold on;
    legend("High Signal Voltage", "Low Signal Voltage", 'Color', 'white', 'Location', 'northwest')
%% Plot Individual Waveform Histograms
figure(3)
t = tiledlayout('flow');
title(t, "Low & High Signal Histogram for Each Waveform", 'Color', 'white')
xlabel(t, "Waveform Voltage [mV]", 'Color', 'white'); ylabel(t, "Frequency [Counts]", 'Color', 'white');
set(gcf,"Color", [0 0 0])
hold on;
for i = 1:SystemProperties.FilePath.Data.Length
    nexttile
    bar(WF_S.BinCenter(i,:), WF_S.Count(i,:), 'FaceColor', ColorMap(i,:), "EdgeColor", "none"); 
    xline(LowSignal.Voltage(i,:), 'w--');
    xline(HighSignal.Voltage(i,:), 'w--');
    if i == 1
        Name = "Waveform: Laser off";
    else
        Name = "Waveform: " + num2str((i-2)*5) + "%";
    end
    title(Name, 'Color', 'white');
    set(gca, 'Color', [0 0 0]); 
    set(gca, 'XColor', 'white', 'YColor', 'white');
    pause(0.05)
end

%% Plot Results


%Interval = [-1,0:5:100];
%plot(Interval, LowSignal.Voltage); hold on;
%plot(Interval, HighSignal.Voltage); hold on;
%title("High vs Low Signal");
%xlabel("Laser Input Intensity"); ylabel("Voltage [mV]");
%legend("Low Voltage", "High Voltage", "Location", "best");
%grid on; axis tight;
