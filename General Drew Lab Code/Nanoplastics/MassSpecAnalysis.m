format short; format compact;
clear; clc;

addpath("C:\Workspace\LabScripts\Functions");
Lookup = FileLookup("xlsx","TroubleShoot", "C:\Users\jsl5865\Desktop\OneDrive_1_7-15-2025");

%% Data
Variables = [ "Checked"
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
NumericVariables = [ "Coverage [%]"
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

Mask = ~ismember(Variables, NumericVariables);
TextVariables = Variables(Mask);

AllVariables = matlab.lang.makeValidName(Variables);
NumericVariables = matlab.lang.makeValidName(NumericVariables);
TextVariables = matlab.lang.makeValidName(TextVariables);

for i = 1:Lookup.FileCount
    GelBand = erase(Lookup.FolderInfo(i).name, ".xlsx");
    TempFile = readtable(fullfile(Lookup.FolderInfo(i).folder, GelBand), "VariableNamingRule", "preserve");
    for j = 1:length(AllVariables)
        GelBand_Name = matlab.lang.makeValidName(GelBand);
        if ismember(AllVariables(j), NumericVariables)
            MassSpecData.(GelBand_Name).(AllVariables(j)) = table2array(TempFile(:,j));
        else
            MassSpecData.(GelBand_Name).(AllVariables(j)) = TempFile(:,j);
        end
    end
    MassSpecData.(GelBand_Name).SAF = Calculate_SAF(MassSpecData, GelBand_Name);
    Variables = union(Variables, "SAF", 'stable');
    MassSpecData.(GelBand_Name).NSAF = Calculate_NSAF(MassSpecData, GelBand_Name);
    Variables = union(Variables, "NSAF", 'stable');
end

%% Functions
function SAF = Calculate_SAF(MassSpecData, GelBand_Name)
    SAF = MassSpecData.(GelBand_Name).x_PSMs ./ MassSpecData.(GelBand_Name).x_AAs;
end

function NSAF = Calculate_NSAF(MassSpecData, GelBand_Name)
    SAF = MassSpecData.(GelBand_Name).SAF;
    NSAF = SAF ./ sum(SAF);
end

%% Display
DisplayVariables = listdlg("PromptString", "Select Variables", "SelectionMode", "Multiple", "ListString", Variables);
fprintf("Variables chosen:\n")
for i = 1:length(DisplayVariables)
    fprintf('\t%s\n', Variables(DisplayVariables(i)))
end
SortVariable = listdlg("PromptString", "Sort by which variable?", "SelectionMode", "single", "ListString", Variables(DisplayVariables));
fprintf("Sorting by:\n")
fprintf('\t%s\n', Variables(DisplayVariables(SortVariable)))