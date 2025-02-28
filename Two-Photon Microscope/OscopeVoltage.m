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

%% Histogram to Determine Noise & Amplitudes
figure()
t = tiledlayout('flow');
title(t,"Oscilloscope Waveform Histograms")
xlabel(t, "Voltage [mV]"); ylabel(t, "Frequency");
for i = 1: SystemProperties.FilePath.Data.Length
    TotalBins = sqrt(size(Oscope.AlignedVoltage(i,:),2));
    [Count, BinEdge] = histcounts(Oscope.AlignedVoltage(i,:), TotalBins);
    BinCenter = (BinEdge(1:end-1) + BinEdge(2:end))/ 2;

    LowSignal.Count = Count(1:round(end/2));
    LowSignal.BinEdge = BinEdge(1:round(end/2));
    LowSignal.BinCenter = BinCenter(1:round(end/2));
    [LowPeak, LowLocation] = findpeaks(LowSignal.Count);
    [~, Index] = max(LowPeak);
    LowSignal.Voltage(i) = LowSignal.BinCenter(LowLocation(Index));

    HighSignal.Count = Count(round(end/2):end);
    HighSignal.BinEdge = BinEdge(round(end/2):end);
    HighSignal.BinCenter = BinCenter(round(end/2):end);
    [HighPeak, HighLocation] = findpeaks(HighSignal.Count);
    [~, Index] = max(HighPeak);
    HighSignal.Voltage(i) = HighSignal.BinCenter(HighLocation(Index));

    nexttile
    bar(BinCenter,Count); hold on;
    xline(LowSignal.Voltage(i), "Color", 'b'); hold on;
    xline(HighSignal.Voltage(i), "Color", 'r'); hold on;
    if i == 1
        Name = "Waveform: Laser off";
    else
        Name = "Waveform: " + num2str((i-2)*5) + "%";
    end
    title(Name);
end

%% Plot Waveforms
figure()
t = tiledlayout("flow");
title(t, "MScan Output Voltage Measurement from 2P Oscilloscope");
xlabel(t, "Time (\mus)");  ylabel(t, "Voltage (mV)"); 
nexttile    %   --- Raw Data ---
for i = 1:SystemProperties.FilePath.Data.Length
    plot(Oscope.Time(i,:),Oscope.Voltage(i,:));
    hold on;
end
title("Raw Voltage Output"); axis tight;
nexttile    %   --- Sync Waveform Periods --
for i = 1:SystemProperties.FilePath.Data.Length
    plot(Oscope.Time(i,:), Oscope.AlignedVoltage(i,:));
    hold on;
end
title("Aligned Voltage Output"); axis tight;
nexttile    %   --- Show a Single Step ---
for i = 1:SystemProperties.FilePath.Data.Length
    plot(Oscope.Time(i,:),Oscope.AlignedVoltage(i,:));
    hold on;
end
title("Synced Single Step")
xlim([-50, 150]);
nexttile    %   --- Histogram Results (Plot) ---
Interval = [-1,0:5:100];
plot(Interval, LowSignal.Voltage); hold on;
plot(Interval, HighSignal.Voltage); hold on;
title("High vs Low Signal");
xlabel("Laser Input Intensity"); ylabel("Voltage [mV]");
legend("Low Voltage", "High Voltage", "Location", "best");
grid on; axis tight;
