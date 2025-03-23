clear; clc; format short; format compact;

Lookup.FileType = '*.csv';                                                          % Choose file type
    Lookup.FolderAddress = uigetdir('*.*','Select a file');                             % Choose folder path location
    Lookup.AllFiles = Lookup.FolderAddress + "\" + Lookup.FileType;                     % Convert to filepath
    Lookup.FolderAddress = erase(Lookup.AllFiles, Lookup.FileType);                     % Create beginning address for file path
    [Lookup.CurrentFolder, ~, ~] = fileparts(Lookup.AllFiles);                          % Collect folder information
    Lookup.CurrentFolder = regexp(Lookup.CurrentFolder, '([^\\]+)$', 'match', 'once');  % Determine the parent folder
    Lookup.FolderInfo = dir(Lookup.AllFiles);                                           % Identify the folder directory
    Lookup.FileCount = length(Lookup.FolderInfo);                                       % Determine the number of files in folder directory

%% Read .CSV file
    for i = 1:Lookup.FileCount
        Name = erase(Lookup.FolderInfo(i).name, ".csv");
        TempFile = readtable(fullfile(Lookup.FolderAddress, Name));
        Oscope.RecordLength(i) = TempFile{1,2};
        Oscope.SampleInterval(i) = TempFile{2,2};
        Oscope.TriggerPoint(i) = TempFile{3,2};
        Oscope.VerticalScale(i) = TempFile{9,2};
        Oscope.VerticalOffset(i) = TempFile{10,2};
        Oscope.HorizontalScale(i) = TempFile{12,2};
        Oscope.Yzero(i) = TempFile{14,2};
        Oscope.ProbeAtten(i) = TempFile{15,2};
        Oscope.Time(i,:) = TempFile{:,4}/Oscope.SampleInterval(i);
        Oscope.Voltage(i,:) = TempFile{:,5};
    end

%% Cross Correlation
    LowerBound = 850; %850
    UpperBound = 900; %900

    NormalizedBounded_Input = Oscope.Voltage(1, LowerBound:UpperBound) - mean(Oscope.Voltage(1, LowerBound:UpperBound));
    NormalizedBounded_ETL = Oscope.Voltage(2, LowerBound:UpperBound) - mean(Oscope.Voltage(2, LowerBound:UpperBound));
    NormalizedBounded_EOM = Oscope.Voltage(3, LowerBound:UpperBound) - mean(Oscope.Voltage(3, LowerBound:UpperBound));

    [Xc.Input_ETL, Lags.Input_ETL] = xcorr(NormalizedBounded_Input, NormalizedBounded_ETL, "coeff");
    [Xc.Input_EOM, Lags.Input_EOM] = xcorr(NormalizedBounded_Input, NormalizedBounded_EOM, "coeff");
    [Xc.ETL_EOM, Lags.ETL_EOM] = xcorr(NormalizedBounded_ETL, NormalizedBounded_EOM, "coeff");
    [~, Index.Input_ETL] = max(Xc.Input_ETL);
    [~, Index.Input_EOM] = max(Xc.Input_EOM);
    [~, Index.ETL_EOM] = max(Xc.ETL_EOM);
    Shift.Input_ETL = Lags.Input_ETL(Index.Input_ETL);
    Shift.Input_EOM = Lags.Input_EOM(Index.Input_EOM);
    Shift.ETL_EOM = Lags.ETL_EOM(Index.ETL_EOM);

%% Histogram
    TotalBins = sqrt(size(Oscope.Voltage(3,:),2));
    [Count, BinEdge] = histcounts(Oscope.Voltage(3,:), TotalBins);
    BinCenter = (BinEdge(1:end-1) + BinEdge(2:end))/ 2;

    Temp.Extension = [0,1,0];
    Temp.Count = [Count, Temp.Extension];
    [Peaks, Locations] = findpeaks(findpeaks(Temp.Count));
    for i = 1:size(Peaks, 2)
        index(i) = find(Count == Peaks(i));
    end
    VoltageStep = BinCenter(index);


%% Plot Raw Signals
    ColorMap = hsv(Lookup.FileCount);

    figure(1);
    t1 = tiledlayout(3,1);
    title(t1, "Oscope Circuit Amplitude Validation", 'Color', 'white');
    xlabel(t1, "Time [\mus]", 'Color', 'white'); 
    ylabel(t1, "Voltage [V]", 'Color', 'white');
    set(gcf, "Color", [0 0 0]);
    nexttile(1);
    title("Simulated MScan Input Signals", 'Color', 'white'); hold on;
    nexttile(2);
    title("TTL Pulses Output to ETL", 'Color', 'white'); hold on;
    nexttile(3);
    title("Analog Pulses Output to Amplifier (302RM)", 'Color', 'white'); hold on;
    for i = 1:Lookup.FileCount
        nexttile(t1, i);
        plot(Oscope.Time(i,:), Oscope.Voltage(i,:), "Color", ColorMap(i,:));
        set(gca, 'Color', [0 0 0]);  set(gca, 'XColor', 'white', 'YColor', 'white');
        axis tight; hold on;
    end

%% Plot Time Lag Between Signals
    figure(2)
    t2 = tiledlayout(4,3);
    title(t2, "Time Lag Between Signals", 'Color', 'white');
    set(gcf, "Color", [0 0 0]);
    for i = 1:12
        nexttile(t2, i); 
        set(gca, 'Color', [0 0 0]);  
        set(gca, 'XColor', 'white', 'YColor', 'white');
        axis tight;
        hold on;
    end

    nexttile(t2, 1)
    title("Simulated Input Signal & TTL Pulse to ETL", 'Color', 'white'); hold on;
    plot(Oscope.Time(1,:), Oscope.Voltage(1,:), "Color", ColorMap(1,:)); hold on;
    plot(Oscope.Time(2,:), Oscope.Voltage(2,:), "Color", ColorMap(2,:)); hold on;
    xline(Oscope.Time(1,LowerBound), "--", "Color", 'white'); xline(Oscope.Time(1,UpperBound), "--", "Color", 'white'); hold on;
    nexttile(t2, 4)
    title("Simulated Input Signal & Analog Pulse to EOM", 'Color', 'white'); hold on;
    plot(Oscope.Time(1,:), Oscope.Voltage(1,:), "Color", ColorMap(1,:)); hold on;
    plot(Oscope.Time(3,:), Oscope.Voltage(3,:), "Color", ColorMap(3,:)); hold on;
    xline(Oscope.Time(1,LowerBound), "--", "Color", 'white'); xline(Oscope.Time(1,UpperBound), "--", "Color", 'white'); hold on;
    ylabel("Voltage [V]")
    nexttile(t2, 7)
    title("TTL Pulse to ETL and Analog Pulse to EOM", 'Color', 'white'); hold on;
    plot(Oscope.Time(2,:), Oscope.Voltage(2,:), "Color", ColorMap(2,:)); hold on;
    plot(Oscope.Time(3,:), Oscope.Voltage(3,:), "Color", ColorMap(3,:)); hold on;
    xline(Oscope.Time(1,LowerBound), "--", "Color", 'white'); xline(Oscope.Time(1,UpperBound), "--", "Color", 'white'); hold on;
    nexttile(t2, 10)
    title("Input Signal Overlayed with Output Signals", 'Color', 'white'); hold on;
    plot(Oscope.Time(1,:), Oscope.Voltage(1,:), "Color", ColorMap(1,:)); hold on;
    plot(Oscope.Time(2,:), Oscope.Voltage(2,:), "Color", ColorMap(2,:)); hold on;
    plot(Oscope.Time(3,:), Oscope.Voltage(3,:), "Color", ColorMap(3,:)); hold on;
    xline(Oscope.Time(1,LowerBound), "--", "Color", 'white'); xline(Oscope.Time(1,UpperBound), "--", "Color", 'white'); hold on;
    xlim([-250,250]); hold on;
    xlabel("Time [\mus]");

    nexttile(t2, 2)
    title("Simulated Input Signal & TTL Pulse to ETL", 'Color', 'white'); hold on;
    plot(Oscope.Time(1,LowerBound:UpperBound), Oscope.Voltage(1,LowerBound:UpperBound), "Color", ColorMap(1,:)); hold on;
    plot(Oscope.Time(2,LowerBound:UpperBound), Oscope.Voltage(2,LowerBound:UpperBound), "Color", ColorMap(2,:)); hold on;
    nexttile(t2, 5)
    title("Simulated Input Signal & Analog Pulse to EOM", 'Color', 'white'); hold on;
    plot(Oscope.Time(1,LowerBound:UpperBound), Oscope.Voltage(1,LowerBound:UpperBound), "Color", ColorMap(1,:)); hold on;
    plot(Oscope.Time(3,LowerBound:UpperBound), Oscope.Voltage(3,LowerBound:UpperBound), "Color", ColorMap(3,:)); hold on;
    ylabel("Voltage [V]")
    nexttile(t2, 8)
    title("TTL Pulse to ETL and Analog Pulse to EOM", 'Color', 'white'); hold on;
    plot(Oscope.Time(2,LowerBound:UpperBound), Oscope.Voltage(2,LowerBound:UpperBound), "Color", ColorMap(2,:)); hold on;
    plot(Oscope.Time(3,LowerBound:UpperBound), Oscope.Voltage(3,LowerBound:UpperBound), "Color", ColorMap(3,:)); hold on;
    nexttile(t2, 11)
    title("Input Signal Overlayed with Output Signals", 'Color', 'white'); hold on;
    plot(Oscope.Time(1,LowerBound:UpperBound), Oscope.Voltage(1,LowerBound:UpperBound), "Color", ColorMap(1,:)); hold on;
    plot(Oscope.Time(2,LowerBound:UpperBound), Oscope.Voltage(2,LowerBound:UpperBound), "Color", ColorMap(2,:)); hold on;
    plot(Oscope.Time(3,LowerBound:UpperBound), Oscope.Voltage(3,LowerBound:UpperBound), "Color", ColorMap(3,:)); hold on;
    xlabel("Time [\mus]");

    nexttile(t2, 3)
    title("Time Lag Between Simulated Input Signal & TTL Pulse to ETL", 'Color', 'white')
    plot(Lags.Input_ETL, Xc.Input_ETL, "Color", "#D95319"); hold on;
    xline(Shift.Input_ETL, "--", "Color", "#D95319"); hold on;
    nexttile(t2, 6)
    title("Time Lag Between Simulated Input Signal & Analog Pulse to EOM", 'Color', 'white')
    plot(Lags.Input_EOM, Xc.Input_EOM, "Color", "#7E2F8E"); hold on;
    xline(Shift.Input_EOM, "--", "Color", "#7E2F8E"); hold on;
    ylabel("Correlation Coefficient", 'Color', 'white')
    nexttile(t2, 9)
    title("Time Lag Between TTL Pulse to ETL & Analog Pulse to EOM", 'Color', 'white')
    plot(Lags.ETL_EOM, Xc.ETL_EOM, "Color", "#77AC30"); hold on;
    xline(Shift.ETL_EOM, "--", "Color", "#77AC30"); hold on;
    nexttile(t2, 12)
    title("Overlayed Time Lag Between Signals", 'Color', 'white')
    plot(Lags.Input_ETL, Xc.Input_ETL, "Color", "#D95319"); hold on;
    plot(Lags.Input_EOM, Xc.Input_EOM, "Color", "#7E2F8E"); hold on;
    plot(Lags.ETL_EOM, Xc.ETL_EOM, "Color", "#77AC30"); hold on;
    xline(Shift.Input_ETL, "--", "Color", "#D95319"); hold on;
    xline(Shift.Input_EOM, "--", "Color", "#7E2F8E"); hold on;
    xline(Shift.ETL_EOM, "--", "Color", "#77AC30"); hold on;
    xlabel("Lag [\mus]")

%% Plot Histograms
    figure(3);
    t3 = tiledlayout(1,1);
    title(t3, "Voltage Steps & Histogram", "Color", 'white');
    set(gcf, "Color", [0 0 0]);
    nexttile(t3, 1)
    title("Analog Pulses from Arduino Due", "Color", 'white'); hold on;
    plot(Oscope.Time(3,:), Oscope.Voltage(3,:), "Color", ColorMap(3,:)); 
    set(gca, 'Color', [0 0 0]);  set(gca, 'XColor', 'white', 'YColor', 'white');
    axis tight; hold on;
    for i = 1:size(VoltageStep, 2)
        yline(VoltageStep(i), '--', "Color", 'white', 'Label', [num2str(VoltageStep(i)) + " V"]);
    end

%% Results
    fprintf('\nArduino Due Analysis\n')
    fprintf('\tThe input and output signals experience some delay:\n');
    fprintf('\t\tThe signal to the ETL lags the simulated MScan pulse by %.2f μs\n', Shift.Input_ETL)
    fprintf('\t\tThe signal to the EOM lags the simulated MScan pulse by %.2f μs\n', Shift.Input_EOM)
    fprintf('\t\tThe signal to the EOM lags the signal to the ETL by %.2f μs\n', Shift.ETL_EOM)
    fprintf('\tA total of %d analog steps were detected with voltage values of:\n', size(VoltageStep,2)-1);
    for i = 2:size(VoltageStep,2)
        fprintf('\t\t%.6f V\n', VoltageStep(i))
    end
    fprintf('\tThe peak-to-peak amplitude for each step is:\n');
    for i = 2:size(VoltageStep,2)
        fprintf('\t\t%.6f V\n', VoltageStep(i)-VoltageStep(1));
    end