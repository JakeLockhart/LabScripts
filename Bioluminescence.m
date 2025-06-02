clear; clc; format short; format compact;
addpath('C:\Workspace\LabScripts\Functions');
Lookup = FileLookup('xlsx');
tic

%% Read .xlxs file. (Bioluminescence Analysis - Raw Data (CAG-Lux) & Raw Data (CMV-Lux))
%   FilePath: C:\Users\jsl5865\OneDrive\Documents\UTK\Research\Microfluidics, Tissue Engineering Lab
%   Format:
%       Time | Drug 20uM | Drug 15uM | Drug 10uM | Drug 5 uM | Drug 0.5uM | Drug 0.05uM | Drug Control
%       n = 9 samples per group
FilePath = fullfile(Lookup.FolderInfo(1).folder, Lookup.FolderInfo(1).name);
Drugs = {'Temozolamide', 'Afatinib', 'Pifithrin', 'Doxorubicin'};
Concentrations = {'20uM', '15uM', '10uM' '5uM', '0.5uM', '0.05uM', 'Control'};
Sheets = {'Raw Data (CAG-Lux)', 'Raw Data (CMV-Lux)'};
SheetNames = {'CAGLux', 'CMVLux'};
Ranges = {'A3:BL171', 'A175:BL343', 'A347:BL515', 'A519:BL687'};
N = 9;
DescriptiveStatistics_List = {"Mean", "Median", "StandardDeviation", "Range"};

%% Process .xlxs file
%   Descriptive Statistics: Mean, Median, Standard Deviation, Range
%   Growth Rate: Instantaneous growth rate {r(t) = d/dt(ln(N(t)))}
for i = 1:length(Sheets)
    Sheet = Sheets{i};
    SheetName = SheetNames{i};
    for j = 1:length(Drugs)
        Drug = Drugs{j};
        Range = Ranges{j};
        RawData.(SheetName).(Drug) = readtable(FilePath, 'Sheet', Sheet, 'Range', Range);
        ReferenceTime = RawData.(SheetName).(Drug).Var1(1);
        RawData.(SheetName).(Drug).Var1 = hours(RawData.(SheetName).(Drug).Var1 - ReferenceTime);
        Data.Original.(SheetName).(Drug) = table2array(RawData.(SheetName).(Drug));
        
        [Time, Mean, Median, STD, Range] = DescriptiveStatistics(Data.Original.(SheetName).(Drug), N, length(Concentrations));
        Data.Mean.(SheetName).(Drug) = array2table([Time, Mean], "VariableNames", ['Time', Concentrations]);
        Data.Median.(SheetName).(Drug) = array2table([Time, Median], "VariableNames", ['Time', Concentrations]);
        Data.STD.(SheetName).(Drug) = array2table([Time, STD], "VariableNames", ['Time', Concentrations]);
        Data.Range.(SheetName).(Drug) = array2table([Time, Range], "VariableNames", ['Time', Concentrations]);
        
        [Time, r] = InstantaneousGrowthRate(Data.Mean.(SheetName).(Drug));
        Data.InstantaneousGrowthRate.(SheetName).(Drug) = array2table([Time(2:end,:), r], "VariableNames", ['Time', Concentrations]);
    end
    toc
end

%% Plot Results
% Plot Raw Data
for i = 1:length(SheetNames)
    figure
    t = tiledlayout(length(Drugs), length(Concentrations), "TileSpacing", "compact");
    title(t, ['Raw Bioluminescence Data (' SheetNames{i} ')']);
    SheetName = SheetNames{i}; 
    for j = 1:length(Drugs)
        Drug = Drugs{j};
        AllData = Data.Original.(SheetName).(Drug);
        Time = AllData(:,1);
        DataOnly = AllData(:,2:end);
        Groups = length(Concentrations);
        
        MeanData = table2array(Data.Mean.(SheetName).(Drug));
        MeanTime = MeanData(:,1);
        MeanValues = MeanData(:,2:end);
        
        for k = 1:Groups
            Tile = (j-1)*Groups + k;
            nexttile(t, Tile);
            Column = (k-1)*N + (1:N);
            GroupData = DataOnly(:, Column);
        
            p1 = plot(Time, GroupData, 'Color', [0.2 0.5 0.8 0.3]);
            hold on;
            p2 = plot(MeanTime, MeanValues(:,k), 'k', 'LineWidth', 2);

            title([Drug ' - ' Concentrations{k}], "Interpreter", "none");
            xlabel('Time [Hrs]');
            ylabel('Luminescence');
            grid on;
            axis tight;
            hold off;
        end
    end
    toc
    Lines = findobj(gca, 'Type', 'line');
    legend([p1(1), p2(1)], ["Raw Data", "Mean Data"], "Location", "best")
end

% Plot Average
ColorMap = {autumn(length(Concentrations)), abyss(length(Concentrations))};
for i = 1:length(SheetNames)
    figure
    t = tiledlayout(length(Drugs), 1, "TileSpacing", "compact");
    title(t, ['Averaged Bioluminescence Data (' SheetNames{i} ')']);
    SheetName = SheetNames{i};
    for j = 1:length(Drugs)
        Drug = Drugs{j};
        AllData = table2array(Data.Mean.(SheetName).(Drug));
        Time = AllData(:,1);
        DataOnly = AllData(:,2:end);
        Groups = length(DescriptiveStatistics_List);

        Tile = j;
        nexttile(t, Tile);

        Column = (1:length(Concentrations));
        GroupData = DataOnly(:, Column);

        for k = 1:size(GroupData, 2)
            plot(Time, GroupData(:,k), 'Color', ColorMap{i}(k,:), 'LineWidth', 1.5);
            hold on;
        end
        hold off;
        title(Drug, "Interpreter", "none");
        xlabel('Time [Hrs]');
        ylabel('Luminescence');
        grid on;
        axis tight;
    end
    nexttile(1)
    legend(Concentrations, "Location", "bestoutside");
    toc
end

% Plot combined average
figure
t = tiledlayout(length(Drugs), 1, 'TileSpacing', 'compact');
for j = 1:length(Drugs)
    nexttile(j);
    hold on;

    SheetName1 = SheetNames{1};
    Drug = Drugs{j};
    AllData1 = table2array(Data.Mean.(SheetName1).(Drug));
    Time1 = AllData1(:,1);
    DataOnly1 = AllData1(:, 2:end);
    GroupData1 = DataOnly1(:, 1:length(Concentrations));

    for k = 1:size(GroupData1, 2)
        plot(Time1, GroupData1(:, k), 'Color', ColorMap{1}(k,:), 'LineWidth', 1.5);
    end

    SheetName2 = SheetNames{2};
    AllData2 = table2array(Data.Mean.(SheetName2).(Drug));
    Time2 = AllData2(:,1);
    DataOnly2 = AllData2(:, 2:end);
    GD2 = DataOnly2(:, 1:length(Concentrations));

    for k = 1:size(GD2, 2)
        plot(Time2, GD2(:, k), 'Color', ColorMap{2}(k,:), 'LineWidth', 1.5);
    end

    hold off;
    title(Drug, 'Interpreter', 'none');
    xlabel('Time [Hrs]');
    ylabel('Luminescence');
    grid on;
    axis tight;
    toc
end
hold on;
legendHandles = gobjects(1, 2*length(Concentrations));
legendLabels = strings(1, 2*length(Concentrations));
for k = 1:length(Concentrations)
    legendHandles(k) = plot(nan, nan, '-', 'Color', ColorMap{1}(k,:), 'LineWidth', 1.5);
    legendLabels(k) = Concentrations{k};
    legendHandles(k+length(Concentrations)) = plot(nan, nan, '-', 'Color', ColorMap{2}(k,:), 'LineWidth', 1.5);
    legendLabels(k+length(Concentrations)) = [Concentrations{k}];
end
legend(legendHandles, legendLabels, 'Location', 'southoutside', 'Orientation', 'horizontal', 'NumColumns', 7);





%% Functions to calculate statistics
function [Time, Mean, Median, STD, Range] = DescriptiveStatistics(DataArray, N_Samples, N_Groups)
    Time = DataArray(:,1);
    Data = DataArray(:,2:end);
    [Rows, ~] = size(Data);
    ReshapedData = reshape(Data, Rows, N_Samples, N_Groups);
    Mean = squeeze(mean(ReshapedData, 2));
    Median = squeeze(median(ReshapedData, 2));
    STD = squeeze(std(ReshapedData, 0, 2));
    Range = squeeze(max(ReshapedData, [], 2) - min(ReshapedData, [], 2));
end

function [Time, r] = InstantaneousGrowthRate(DataArray)
    DataArray = table2array(DataArray);
    Time = DataArray(:,1);
    Data = DataArray(:,2:end);
    r = diff(log(Data)) ./ diff(Time);
end

%% Functions to plot
