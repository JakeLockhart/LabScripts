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
    end
    
    properties
        DirectoryInfo struct = struct()
        MatLabVariables struct = struct()
        Data struct = struct()
    end

    %% Constructor and Commands
    methods
        function obj = MassSpectrometryDataAnalysis()
            addpath("C:\Workspace\LabScripts\Functions");
            zap
            obj.DirectoryInfo = MassSpectrometryDataAnalysis.FindFiles("xlsx","TroubleShoot", "C:\Users\jsl5865\Desktop\OneDrive_1_7-15-2025");
            obj.MatLabVariables = MassSpectrometryDataAnalysis.MakeValidVariables(obj);
            obj = ReadData(obj);
            obj = Add_SAF_NSAF(obj);
        end
    end

    %% Callable functions
    methods (Access = public)
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

        function CompareGels % setdiff() to compare properties
        end

        function TotalProteins(obj)
            Fields = string(fieldnames(obj.Data));
            Alignment = max(strlength(Fields));
            for i = 1:length(Fields)
                ProteinCount = height(obj.Data.(Fields(i)).Description);
                fprintf("%*s   -   %i\n",Alignment, Fields(i), ProteinCount)
            end
        end

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
            Display.Vars = union("Description", Display.Vars, "stable");
            

            fprintf("Gel band(s) selected:\n")
            for i = 1:length(Display.Gel)
                fprintf("\t%s\n", Display.Gel(i))
            end
            fprintf("Property(s) selected: \n")
            for i = 1:length(Display.Vars)
                fprintf("\t%s\n", Display.Vars(i))
            end
        end

        function GelData = DisplaySingleGelProperties(obj, Display)
            GelData = obj.Data.(Display.Gel).Description;
            for i = 1:length(Display.Vars)
                switch Display.Vars(i)
                    case "Description"
                        continue
                    otherwise
                        GelData = [GelData, table(obj.Data.(Display.Gel).(Display.Vars(i)), 'VariableNames', {char(Display.Vars(i))})];
                end
            end
        end

        function GelData = DisplayMultipleGelProperties(obj, Display)
        end        
    end
end