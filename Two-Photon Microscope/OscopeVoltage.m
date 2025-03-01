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

%% Plot Global Histogram and Single Steps
t = tiledlayout(1,2);
set(gcf,"Color", [0 0 0])
ColorMap = hsv(SystemProperties.FilePath.Data.Length);
title(t, "Voltage Step & Histogram", 'Color', 'white');
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
for i = 1:SystemProperties.FilePath.Data.Length
    nexttile(1)
    bar(WF_T.BinCenter(i,:), WF_T.Count(i,:), "FaceAlpha", 0.75, "FaceColor", ColorMap(i,:), "EdgeColor", "none"); hold on;
    nexttile(2)
    plot(Oscope.Time(i,:), Oscope.AlignedVoltage(i,:), "Color", ColorMap(i,:)); hold on;
    pause(0.5);
end

%% Single Histogram
%figure()
%TotalBins = linspace(0, max(1.25*Oscope.Voltage(end)), 22*10);
%for i = 1:SystemProperties.FilePath.Data.Length
%    [Count, BinEdge] = histcounts(Oscope.AlignedVoltage(i,:), TotalBins);
%    BinCenter = (BinEdge(1:end-1) + BinEdge(2:end))/ 2;
%
%    bar(BinCenter, Count, "FaceAlpha", 0.75); hold on;
%    pause(.1)
%end
%
%%% Histogram to Determine Noise & Amplitudes
%figure()
%t = tiledlayout('flow');
%title(t,"Oscilloscope Waveform Histograms")
%xlabel(t, "Voltage [mV]"); ylabel(t, "Frequency");
%for i = 1: SystemProperties.FilePath.Data.Length
%    TotalBins = sqrt(size(Oscope.AlignedVoltage(i,:),2));
%    [Count, BinEdge] = histcounts(Oscope.AlignedVoltage(i,:), TotalBins);
%    BinCenter = (BinEdge(1:end-1) + BinEdge(2:end))/ 2;
%
%    LowSignal.Count = Count(1:round(end/2));
%    LowSignal.BinEdge = BinEdge(1:round(end/2));
%    LowSignal.BinCenter = BinCenter(1:round(end/2));
%    [LowPeak, LowLocation] = findpeaks(LowSignal.Count);
%    [~, Index] = max(LowPeak);
%    LowSignal.Voltage(i) = LowSignal.BinCenter(LowLocation(Index));
%
%    HighSignal.Count = Count(round(end/2):end);
%    HighSignal.BinEdge = BinEdge(round(end/2):end);
%    HighSignal.BinCenter = BinCenter(round(end/2):end);
%    [HighPeak, HighLocation] = findpeaks(HighSignal.Count);
%    [~, Index] = max(HighPeak);
%    HighSignal.Voltage(i) = HighSignal.BinCenter(HighLocation(Index));
%
%    nexttile
%    bar(BinCenter,Count); hold on;
%    xline(LowSignal.Voltage(i), "Color", 'b'); hold on;
%    xline(HighSignal.Voltage(i), "Color", 'r'); hold on;
%    if i == 1
%        Name = "Waveform: Laser off";
%    else
%        Name = "Waveform: " + num2str((i-2)*5) + "%";
%    end
%    title(Name);
%end
%
%%% Plot Waveforms
%figure()
%t = tiledlayout("flow");
%title(t, "MScan Output Voltage Measurement from 2P Oscilloscope");
%xlabel(t, "Time (\mus)");  ylabel(t, "Voltage (mV)"); 
%nexttile    %   --- Raw Data ---
%for i = 1:SystemProperties.FilePath.Data.Length
%    plot(Oscope.Time(i,:),Oscope.Voltage(i,:));
%    hold on;
%end
%title("Raw Voltage Output"); axis tight;
%nexttile    %   --- Sync Waveform Periods --
%for i = 1:SystemProperties.FilePath.Data.Length
%    plot(Oscope.Time(i,:), Oscope.AlignedVoltage(i,:));
%    hold on;
%end
%title("Aligned Voltage Output"); axis tight;
%nexttile    %   --- Show a Single Step ---
%for i = 1:SystemProperties.FilePath.Data.Length
%    plot(Oscope.Time(i,:),Oscope.AlignedVoltage(i,:));
%    hold on;
%end
%title("Synced Single Step")
%xlim([-50, 150]);
%nexttile    %   --- Histogram Results (Plot) ---
%Interval = [-1,0:5:100];
%plot(Interval, LowSignal.Voltage); hold on;
%plot(Interval, HighSignal.Voltage); hold on;
%title("High vs Low Signal");
%xlabel("Laser Input Intensity"); ylabel("Voltage [mV]");
%legend("Low Voltage", "High Voltage", "Location", "best");
%grid on; axis tight;
