%% Plot Results
clear; clc; format short; format compact;
Path = "C:\Users\jsl5865\OneDrive\Documents\UTK\Research\Microfluidics, Tissue Engineering Lab";
Lookup = FileLookup('xlsx', 'TroubleShoot', Path);
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

%% Plot Data
PlotResults = {@Plot_CombinedAverage};
PlotBioluminescenceResults(Data,Drugs,Concentrations, SheetNames, PlotResults)

%% Functions to plot data
function PlotBioluminescenceResults(Data, Drugs, Concentrations, SheetNames, PlotResults)
    for i = 1:length(PlotResults)
        feval(PlotResults{i}, Data, Drugs, Concentrations, SheetNames);
    end
end

function Plot_RawData(Data, Drugs, Concentrations, SheetNames)
    %% Plot Raw Data
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
                Column = (k-1)*9 + (1:9); % assumes N=9
                GroupData = DataOnly(:, Column);
            
                p1 = plot(Time, GroupData, 'Color', [0.2 0.5 0.8 0.3]);
                hold on;
                p2 = plot(MeanTime, MeanValues(:,k), 'k', 'LineWidth', 2);
                title([Drug ' - ' Concentrations{k}], "Interpreter", "none");
                xlabel('Time [Hrs]');
                ylabel('Luminescence');
                grid on; axis tight; hold off;
            end
        end
        legend([p1(1), p2(1)], ["Raw Data", "Mean Data"], "Location", "best")
    end
end
function Plot_AveragedData(Data, Drugs, Concentrations, SheetNames)
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

            nexttile(j);
            for k = 1:size(DataOnly, 2)
                plot(Time, DataOnly(:,k), 'Color', ColorMap{i}(k,:), 'LineWidth', 1.5);
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
    end
end
function Plot_CombinedAverage(Data, Drugs, Concentrations, SheetNames)
    figure
    ColorMap = {autumn(length(Concentrations)), abyss(length(Concentrations))};
    t = tiledlayout(length(Drugs), 1);
    title(t, "Combined Average Bioluminescence");
    ControlIdx = length(Concentrations);
    for i = 1:length(Drugs)
        nexttile(i); hold on;
        Drug = Drugs{i};
        for j = 1:length(SheetNames)
            SheetName = SheetNames{j};
            AllData = table2array(Data.Mean.(SheetName).(Drug));
            Time = AllData(:,1);
            DataOnly = AllData(:,2:end);
            for k = 1:size(DataOnly, 2)
                LineStyle = '-';
                if j == 2 && k == ControlIdx
                    LineStyle = '--';
                end
                plot(Time, DataOnly(:,k), 'Color', ColorMap{j}(k,:), 'LineWidth', 1.5, 'LineStyle', LineStyle);
            end
        end
        title(Drug, 'Interpreter', 'none');
        xlabel('Time [Hrs]'); ylabel('Luminescence');
        grid on; axis tight;
    end

    legendHandles = gobjects(1, 2*length(Concentrations));
    legendLabels = strings(1, 2*length(Concentrations));
    for k = 1:length(Concentrations)
        legendHandles(k) = plot(nan, nan, '-', 'Color', ColorMap{1}(k,:), 'LineWidth', 1.5);
        legendLabels(k) = ['CAG - ' Concentrations{k}];
        ls = '-'; if k == ControlIdx, ls = '--'; end
        legendHandles(k + length(Concentrations)) = plot(nan, nan, ls, 'Color', ColorMap{2}(k,:), 'LineWidth', 1.5);
        legendLabels(k + length(Concentrations)) = ['CMV - ' Concentrations{k}];
    end
    legend(legendHandles, legendLabels, 'Location', 'southoutside', 'Orientation', 'horizontal', 'NumColumns', 7);
end
function Plot_InstantaneousGrowthRate(Data, Drugs, Concentrations, SheetNames)
    for i = 1:length(SheetNames)
        figure
        ColorMap = {autumn(length(Concentrations)), abyss(length(Concentrations))};
        t = tiledlayout(length(Drugs), 1, "TileSpacing", "compact");
        title(t, ['Instantaneous Growth Rate Constants (' SheetNames{i} ')']);
        SheetName = SheetNames{i};
        for j = 1:length(Drugs)
            Drug = Drugs{j};
            AllData = table2array(Data.InstantaneousGrowthRate.(SheetName).(Drug));
            Time = AllData(:,1);
            DataOnly = AllData(:,2:end);

            nexttile(j);
            for k = 1:size(DataOnly, 2)
                plot(Time, DataOnly(:,k), 'Color', ColorMap{i}(k,:), 'LineWidth', 1.5);
                hold on;
            end
            hold off;
            title(Drug, "Interpreter", "none");
            xlabel('Time [Hrs]');
            ylabel('Growth Rate');
            grid on;
            axis tight;
        end
        nexttile(1)
        legend(Concentrations, "Location", "bestoutside");
    end
end


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

%% Misc functions
function Lookup = FileLookup(FileType, SearchMode, ConstantAdress)
    %% Validate file type 
        if ~ischar(FileType) && ~isstring(FileType)                                 % Ensure input is a string ('csv', 'txt', etc)
            error('File type must be a string or character array.');                %   Throw error message otherwise
        end                                                                         %   Continue
        Lookup.FileType = strcat('*.', FileType);                                   % Choose file type
    
    %% Determine search mode (Single Folder || All Subfolders || Constant TroubleShoot)
        if nargin < 2 || isempty(SearchMode)                                        % Assume no subfolders unless otherwise stated
            SearchMode = 'Single';                                                  %   Define file search based on empty argument
        elseif ~any(strcmpi(SearchMode, {'Single', 'All', 'TroubleShoot'}))              %   Validate second argument
            error("SearchMode must be 'Single', 'All', or 'TroubleShoot'.");             %       Throw error message
        end                                                                         %   Continue

    %% Select the folder
        if strcmpi(SearchMode, 'TroubleShoot')                                      % SearchMode = Constant filepath for testing
            if nargin < 3 || ~isfolder(ConstantAdress)                              %   Determine if three fields are provided  
                error("For 'TroubleShoot' mode, you must provide a" + ...           %       Throw error message if filepath not defined
                      " valid folder path as the third argument.");                 %   
            end                                                                     %   Continue
            Lookup.FolderAddress = ConstantAdress;                                  %   Define folder path location
        else                                                                        %   SearchMode /= Constant filepath for testing
            Lookup.FolderAddress = uigetdir('*.*','Select a folder');               %   Choose folder path location
            if isequal(Lookup.FolderAddress, 0)                                     %       Esure directory is found and user did not cancel operation
                error('No folder selected.');                                       %         Throw error message otherwise
            end                                                                     %         Continue
        end

    %% Determine file search based on SearchMode
        if strcmpi(SearchMode, 'All')                                               % SearchMode = All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, '**', Lookup.FileType);  %   Find All FileType within subfolders
        else                                                                        %   SearchMode /= All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, Lookup.FileType);        %   Find All Filetype within Single folder
        end                                                                         %   continue

    %% Find All FileType within defined folder
        Lookup.AllFiles = searchPattern;                                            % Create general file path
        Lookup.FolderInfo = dir(searchPattern);                                     % Identify the folder directory
        Lookup.FileCount = length(Lookup.FolderInfo);                               % Determine the number of files in this folder
        Lookup.FolderCount = length(unique({Lookup.FolderInfo.folder}));            % Determine the number of folders 
        [~, Lookup.CurrentFolder] = fileparts(Lookup.FolderAddress);                % Collect folder information
end