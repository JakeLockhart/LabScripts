classdef MassSpectrometryDataAnalysis
    properties
        Variables = [
                     "Checked"
                     "Master"
                     "Accession"
                     "Description"
                     "Coverage [%]"
                     "# Peptides"
                     "# PSMs"
                     "# Unique Peptides"
                     "# AAs"
                     "MW [kDa]"
                     "calc. pI"
                     "Score Sequest HT: Sequest HT"
                     "# Peptides (by Search Engine): Sequest HT"
                     "Contaminant"
                     "Biological Process"
                     "Cellular Component"
                     "Molecular Function"
                     "Pfam IDs"
                     "Entrez Gene ID"
                     "Gene Symbol"
                     "Gene ID"
                     "Ensembl Gene ID"
                     "WikiPathways"
                     "Reactome Pathways"
                     "# Protein Pathway Groups"
                     "Found in Sample: [S13] F13: Sample"
                     "# Protein Groups"
                    ];
        Variables_Numeric = [ 
                            "Coverage [%]"
                            "# Peptides"
                            "# PSMs"
                            "# Unique Peptides"
                            "# AAs"
                            "MW [kDa]"
                            "calc. pI"
                            "Score Sequest HT: Sequest HT"
                            "# Peptides (by Search Engine): Sequest HT"
                            "Entrez Gene ID"
                            "# Protein Pathway Groups"
                            "# Protein Groups"
                           ];
        Variables_Text = [
                         "Checked"
                         "Master"
                         "Accession"
                         "Description"
                         "Contaminant"
                         "Biological Process"
                         "Cellular Component"
                         "Molecular Function"
                         "Pfam IDs"
                         "Gene Symbol"
                         "Gene ID"
                         "Ensembl Gene ID"
                         "WikiPathways"
                         "Reactome Pathways"
                         "Found in Sample: [S13] F13: Sample"
                        ];
        Keys = [
                "Accession"
                "Description"
               ]
    end
    
    properties
        DirectoryInfo struct = struct()
        MatLabVariables struct = struct()
        Data struct = struct()
    end

    %% Constructor
    methods
        function obj = MassSpectrometryDataAnalysis()
            addpath("C:\Workspace\LabScripts\Functions");
            zap
            obj.DirectoryInfo = MassSpectrometryDataAnalysis.FindFiles("xlsx", "TroubleShoot", "C:\Users\jsl5865\Desktop\OneDrive_1_7-15-2025");
            obj.MatLabVariables = MassSpectrometryDataAnalysis.MakeValidVariables(obj);
            obj = ReadData(obj);
            obj = Add_SAF_NSAF(obj);
        end
    end

    %% Callable functions
    methods (Access = public)
        function TotalProteins(obj)
            Fields = string(fieldnames(obj.Data));
            Alignment = max(strlength(Fields));
            for i = 1:length(Fields)
                ProteinCount = height(obj.Data.(Fields(i)).Description);
                fprintf("%*s   -   %i\n",Alignment, Fields(i), ProteinCount)
            end
        end

        function [GelData, Display] = GelParameters(obj, SelectionMode) % Solely to show ALL data from plots, no comparison, just display. use sortrows() 
            arguments
                obj
                SelectionMode string {mustBeMember(SelectionMode, ["single", "multiple"])} = "single";
            end
            Display = obj.UI_FilesandVariables(SelectionMode);
            GelData = [];
            switch SelectionMode
                case "single"
                    GelData = DisplaySingleGelProperties(obj, Display);
                case "multiple"
                    GelData = DisplayMultipleGelProperties(obj, Display);
            end
        end

        function [FlaggedProteins, GelTypes, Parameter] = Plot_InputvsSamples(obj)
            GelTypes = obj.UI_DefineInputUnboundElution;
            Parameter = obj.UI_GetVariables(GelTypes);  
            for i = 1:length(GelTypes)

            end

            [Input, BoundvsUnbound] = CalculatePlotData_InputvsSamples(obj, GelTypes, Parameter)
            

            FlaggedProteins = 1;
            %[x, y] = CalculatePlotData_InputvsSamples(obj, Display)

        end

        %function [GelData] = SortGelData(obj, GelData)
        %   Sortingcriteria = UI_getvariable()
        %end
        %function CompareGels % setdiff() to compare properties
        %end

    end

    %% Initializtion functions
    methods (Static, Access = private)
        function DirectoryInfo = FindFiles(FileType, SearchMode, ConstantAddress)
            arguments
                FileType char {mustBeMember(FileType, {'csv', 'xlsx', 'txt', 'tiff', 'mdf'})} = 'csv'
                SearchMode char {mustBeMember(SearchMode, {'SingleFolder', 'AllSubFolders', 'TroubleShoot'})} = 'SingleFolder'
                ConstantAddress char = ''
            end

            DirectoryInfo = FileLookup(FileType, SearchMode, ConstantAddress);
        end

        function MatLabVariables = MakeValidVariables(obj)
            VariableList = ["Variables" "Variables_Numeric" "Variables_Text"];
            
            for i = 1:length(VariableList)
                Temp_Variables = obj.(VariableList(i));
                MatLabVariables.(VariableList(i)) = matlab.lang.makeValidName(Temp_Variables);
            end
        end
    end

    %% Create default data set
    methods (Access = private)        
        function obj = ReadData(obj)
            Dir = obj.DirectoryInfo;
            Var = obj.MatLabVariables.Variables;
            NVar = obj.MatLabVariables.Variables_Numeric;

            for i = 1:Dir.FileCount
                GelBand = erase(Dir.FolderInfo(i).name, ".xlsx");
                Temp_Dir = fullfile(Dir.FolderInfo(i).folder, GelBand);
                Temp_File = readtable(Temp_Dir, "VariableNamingRule", "preserve");
                for j = 1:length(Var)
                    GelBand = matlab.lang.makeValidName(GelBand);
                    if ismember(Var(j), NVar)
                        obj.Data.(GelBand).(Var(j)) = table2array(Temp_File(:,j));
                    else
                        obj.Data.(GelBand).(Var(j)) = Temp_File(:,j);
                    end
                end
            end
        end

        function obj = Add_SAF_NSAF(obj)
            GelBands = fieldnames(obj.Data);
            for i = 1:length(fieldnames(obj.Data))
                obj.Data.(GelBands{i}).SAF = Calculate_SAF(obj, GelBands{i});
                obj.Data.(GelBands{i}).NSAF = Calculate_NSAF(obj, GelBands{i});
            end
            obj = UpdateVariables(obj, "SAF");
            obj = UpdateVariables(obj, "NSAF");
        end
    end

    %% Helper functions
    methods (Access = private)
        function obj = UpdateVariables(obj, NewVariable)
            VariableList = ["Variables" "Variables_Numeric" "Variables_Text"];
            NewVariable = matlab.lang.makeValidName(NewVariable);

            for i = 1:length(VariableList)
                obj.(VariableList(i)) = union(obj.(VariableList(i)), NewVariable);
                obj.MatLabVariables.(VariableList(i)) = union(obj.(VariableList(i)), NewVariable);
            end
        end

        function SAF = Calculate_SAF(obj, GelBand)
            SAF = obj.Data.(GelBand).x_PSMs ./ obj.Data.(GelBand).x_AAs;
        end

        function NSAF = Calculate_NSAF(obj, GelBand)
            SAF = obj.Data.(GelBand).SAF;
            NSAF = SAF ./ sum(SAF);
        end

        function Display = UI_FilesandVariables(obj, SelectionMode)
            arguments
                obj
                SelectionMode string {mustBeMember(SelectionMode, ["single", "multiple"])} = "single";
            end

            Display.Gel = listdlg("PromptString", "Choose a Gel Band", "SelectionMode", SelectionMode, "ListString", fieldnames(obj.Data));
            Temp_Gel = fieldnames(obj.Data);
            Display.Gel = string(Temp_Gel(Display.Gel));

            Display.Vars = listdlg("PromptString", "Select properties to view", "SelectionMode", "multiple", "ListString", fieldnames(obj.Data.(Display.Gel(1))));
            Temp_Vars = fieldnames(obj.Data.(Display.Gel(1)));
            Display.Vars = Temp_Vars(Display.Vars);
            Display.Vars = union(obj.Keys, Display.Vars, "stable");
            

            fprintf("Gel band(s) selected:\n")
            for i = 1:length(Display.Gel)
                fprintf("\t%s\n", Display.Gel(i))
            end
            fprintf("Property(s) selected: \n")
            for i = 1:length(Display.Vars)
                fprintf("\t%s\n", Display.Vars(i))
            end
        end

        function GelTypes = UI_DefineInputUnboundElution(obj)
            Figure = figure("Name", "Define gel samples {Input, Unbound, Bound}", ...
                            'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none', ...
                            'Resize', 'off', 'Position', [500, 500, 300, 200]);

            Labels = {"Choose input gel", "Choose unbound gel", "Choose bound gel"};
            OptionList = fieldnames(obj.Data);

            Field.LabelWidth = 150;
            Field.DropDownWidth = 150;
            Field.RowHeight = 30;
            Field.TopMargin = 50;
            Field.Spacing = 10;

            DropdownHandles = gobjects(1, length(Labels));

            for i = 1:length(Labels)
                FieldPosition = Field.TopMargin + (length(Labels)-i) * (Field.RowHeight + Field.Spacing);

                uicontrol("Style", "text", "Parent", Figure, ...
                          "String", Labels{i}, 'HorizontalAlignment', 'left', ...
                          'Position', [20, FieldPosition, Field.LabelWidth, Field.RowHeight]);

                DropdownHandles(i) = uicontrol("Style", "popupmenu", "Parent", Figure, ...
                                               "String", OptionList, ...
                                               'Position', [130, FieldPosition, Field.DropDownWidth, Field.RowHeight]);
            end

            uicontrol('Style', 'pushbutton', 'String', 'OK', ...
                      'Position', [50, 10, 80, 30], ...
                      'Callback', @(src, event) onOK());

            uicontrol('Style', 'pushbutton', 'String', 'Cancel', ...
                      'Position', [170, 10, 80, 30], ...
                      'Callback', @(src, event) close(Figure));

            uiwait(Figure);

            function onOK()
                selections = cell(1, length(DropdownHandles));
                for j = 1:length(DropdownHandles)
                    idx = DropdownHandles(j).Value;
                    selections{j} = OptionList{idx};
                end

                if numel(unique(selections)) < numel(selections)
                    errordlg('Each selection must be unique. Please choose different gels.', ...
                             'Duplicate Selection');
                    return; 
                end

                GelTypes = struct( ...
                                  'InputGel', selections{1}, ...
                                  'UnboundGel', selections{2}, ...
                                  'BoundGel', selections{3});
                close(Figure);
            end
        end

        function Parameter = UI_GetVariables(obj, GelTypes)
            Parameter = listdlg("PromptString", "Select properties to view", "SelectionMode", "single", "ListString", fieldnames(obj.Data.(GelTypes.InputGel)));
            Temp_Parameter = fieldnames(obj.Data.(GelTypes.InputGel));
            Parameter = Temp_Parameter(Parameter);
        end

        function GelData = DisplaySingleGelProperties(obj, Display)
            GelData = obj.Data.(Display.Gel).Description;
            for i = 1:length(Display.Vars)
                switch Display.Vars(i)
                    case "Description"
                        continue
                    otherwise
                        ParameterData = obj.Data.(Display.Gel).(Display.Vars(i));
                        if istable(ParameterData)
                            ParameterData.Properties.VariableNames = {char(Display.Vars(i))};
                        else
                            ParameterData = table(ParameterData, 'VariableNames', {char(Display.Vars(i))});
                        end
                        GelData = [GelData, ParameterData];
                end
            end
        end

        function GelData = DisplayMultipleGelProperties(obj, Display)
            DataSet = cell(1, length(Display.Gel));
            for i = 1:length(Display.Gel)
                DataSet{i} = obj.Data.(Display.Gel(i));
            end

            MergedTable = obj.MergeTables(DataSet);
            MergedParameters = obj.MergeTableParameters(MergedTable, Display);
            ReducedParameters = obj.ShowDesiredParameters(MergedParameters, Display);
            GelData = obj.ExpandCells(ReducedParameters, Display);
        end

        function CellData = NormalizeTableVars(obj, GelData)
            CellData = GelData;
            Fields = fieldnames(CellData);
            for i = 1:length(Fields)
                value = GelData.(Fields{i});
                switch class(CellData.(Fields{i}))
                    case {'cell', 'double'}
                        CellData.(Fields{i}) = value;
                    case 'table'
                        TempVar = value.Properties.VariableNames{1};
                        CellData.(Fields{i}) = value.(TempVar);
                end
            end
            CellData.Description = string(CellData.Description);
            CellData = struct2table(CellData);
        end

        function CombinedTable = MergeTables(obj, DataSet)
            Tables = cellfun(@(d) obj.NormalizeTableVars(d), DataSet, 'UniformOutput', false);
            CombinedTable = Tables{1};
            
            for i = 2:length(Tables)
                CombinedTable = outerjoin(CombinedTable, Tables{i}, 'Keys', obj.Keys, 'MergeKeys', true, 'Type', 'full');
            end       
        end

        function DataSet = MergeTableParameters(obj, DataSet, Display)
            AllParameters = DataSet.Properties.VariableNames;
            Suffix = '_left$|_right$|_x\d+$|_CombinedTable$|_Var\d+$';
            Parameters = unique(regexprep(AllParameters, Suffix, ''));
            
            for i = 1:length(Parameters)
                BaseParameter = Parameters{i};
                FauxParameters = AllParameters(startsWith(AllParameters, BaseParameter) & ~strcmp(AllParameters, BaseParameter));
                
                if isempty(FauxParameters)
                    continue
                end

                CombinedValue = cell(height(DataSet), 1);

                for row = 1:height(DataSet)
                    CombinedRow = cell(1, length(Display.Gel));
                    for column = 1:length(FauxParameters)
                        ColumnName = FauxParameters{column};
                        if ismember(ColumnName, DataSet.Properties.VariableNames)
                            Value = DataSet.(ColumnName)(row);
                            if iscell(Value)
                                if isempty(Value) || (numel(Value) == 1 && isempty(Value{1}))
                                    CombinedRow{column} = NaN;
                                else
                                    CombinedRow{column} = Value;
                                end
                            elseif isempty(Value)
                                CombinedRow{column} = NaN;
                            else
                                CombinedRow{column} = Value;
                            end
                        else
                            CombinedRow{column} = NaN;
                        end
                    end
                    % Pad with NaN if fewer columns than gels
                    if numel(FauxParameters) < length(Display.Gel)
                        CombinedRow(numel(FauxParameters)+1:length(Display.Gel)) = {NaN};
                    end
                    CombinedValue{row} = CombinedRow;
                end

                DataSet.(BaseParameter) = CombinedValue;
                DataSet(:, FauxParameters) = [];
                AllParameters = DataSet.Properties.VariableNames;
            end
        end

        function SelectedDataSet = ShowDesiredParameters(obj, DataSet, Display)
            SelectedDataSet = DataSet(:, Display.Vars);
        end

        function DisplayDataSet = ExpandCells(obj, DataSet, Display)
            for i = 1:length(Display.Vars)
                Parameter = Display.Vars{i};
                if ~ismember(Parameter, obj.Keys)
                    ParameterData = obj.NaN2Inf(DataSet.(Parameter));
                    DataSet.(Parameter) = cellfun(@(x) strjoin(string(x), sprintf(' ')), ParameterData, "UniformOutput", false);
                end
            end
            DisplayDataSet = DataSet(:,Display.Vars);
        end

        function DataSet = NaN2Inf(obj, DataSet)
            for i = 1:length(DataSet)
                for j = 1:length(DataSet{i})
                    if isnan(DataSet{i}{j}(:))
                        DataSet{i}{j} = "NaN";
                    end
                end
            end
        end

        function [Input, BoundvsUnbound] = CalculatePlotData_InputvsSamples(obj, GelTypes, Parameter)
            PlotData.Input = obj.Data.(GelTypes.Input).(Parameter);
            PlotData.Bound = obj.Data.(GelTypes.Bound).(Parameter);
            PlotData.Unbound = obj.Data.(GelTypes.Unbound).(Parameter);

            Input = PlotData.Input;
            BoundvsUnbound = (PlotData.Bound) ./ (PlotData.Bound + PlotData.Unbound);
        end
    end
end