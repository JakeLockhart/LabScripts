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
    TotalBins = sqrt(size(Oscope.AlignedVoltage(i,:),2))
    [Count, BinEdge] = histcounts(Oscope.AlignedVoltage(i,:), TotalBins);
    BinCenter = (BinEdge(1:end-1) + BinEdge(2:end))/ 2

    LowSignal.Count = Count(1:round(end/2));
    LowSignal.BinEdge = BinEdge(1:round(end/2));
    LowSignal.BinCenter = BinCenter(1:round(end/2));
    [LowPeak, LowLocation] = findpeaks(LowSignal.Count);

    HighSignal.Count = Count(round(end/2):end);
    HighSignal.BinEdge = BinEdge(round(end/2):end);
    HighSignal.BinCenter = BinCenter(round(end/2):end);
    [HighPeak, HighLocation] = findpeaks(HighSignal.Count);

    %[~, IDx] = maxk(Count, 2);
    %LowVoltage.Average(i) = min(BinCenter(IDx));
    %HighVoltage.Average(i) = max(BinCenter(IDx));
%
    %Tolerance = 0.1 * (HighVoltage.Average - LowVoltage.Average);
    %LowVoltage.Range{i,:} = Oscope.AlignedVoltage(abs(Oscope.AlignedVoltage(i,:) - LowVoltage.Average(i)) < Tolerance(i));
    %HighVoltage.Range{i,:} = Oscope.AlignedVoltage(abs(Oscope.AlignedVoltage(i,:) - HighVoltage.Average(i)) < Tolerance(i));
%
    %LowVoltage.Base{i,:} = min(LowVoltage.Range{i,:});
    %LowVoltage.Peak{i,:} = max(LowVoltage.Range{i,:});
    %HighVoltage.Base{i,:} = min(LowVoltage.Range{i,:});
    %HighVoltage.Peak{i,:} = max(LowVoltage.Range{i,:});


    nexttile
    bar(BinCenter,Count); hold on;
    xline(LowSignal.BinCenter(LowLocation(:)), "LineWidth", 1, "Color", 'b'); hold on;
    xline(HighSignal.BinCenter(HighLocation(:)), "LineWidth", 1, "Color", 'r'); hold on;
end

%% Plot Waveforms
figure()
t = tiledlayout(3,2);
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
nexttile    %   --- Show Single Step (Raw) ---
for i = 1:SystemProperties.FilePath.Data.Length
    plot(Oscope.Time(i,:),Oscope.Voltage(i,:));
    hold on;
end
title("Raw Single Step")
xlim([-50, 150]);
nexttile    %   --- Show a Single Step ---
for i = 1:SystemProperties.FilePath.Data.Length
    plot(Oscope.Time(i,:),Oscope.AlignedVoltage(i,:));
    hold on;
end
title("Synced Single Step")
xlim([-50, 150]);



