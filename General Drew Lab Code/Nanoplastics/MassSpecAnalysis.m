format short; format compact;
clear; clc;

addpath("C:\Workspace\LabScripts\Functions");
Lookup = FileLookup("xlsx","TroubleShoot", "C:\Users\jsl5865\Desktop\OneDrive_1_7-15-2025");

%% Data Collection
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
    GelBand{i} = erase(Lookup.FolderInfo(i).name, ".xlsx");
    TempFile = readtable(fullfile(Lookup.FolderInfo(i).folder, GelBand{i}), "VariableNamingRule", "preserve");
    for j = 1:length(AllVariables)
        GelBand_Name = matlab.lang.makeValidName(GelBand{i});
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

%% User Selection
DisplayGels = listdlg("PromptString", "Compare which gels?", "SelectionMode", "Multiple", "ListString", GelBand);
DisplayGels = GelBand(DisplayGels);
fprintf("Comparing the following gel bands:\n")
for i = 1:length(DisplayGels)
    fprintf('\t%s\n', DisplayGels{i})
end
DisplayGels = matlab.lang.makeValidName(DisplayGels);

DisplayVariables = listdlg("PromptString", "Select Variables", "SelectionMode", "Multiple", "ListString", Variables);
DisplayVariables = union("Description", Variables(DisplayVariables));
fprintf("Variables chosen:\n")
for i = 1:length(DisplayVariables)
    fprintf('\t%s\n', DisplayVariables(i))
end
DisplayVariables = matlab.lang.makeValidName(DisplayVariables);

SortCriteria = listdlg("PromptString", "Sort by which variable?", "SelectionMode", "single", "ListString", DisplayVariables);
SortCriteria = DisplayVariables(SortCriteria);
fprintf("Sorting by:\n")
fprintf('\t%s\n', SortCriteria)
SortCriteria = matlab.lang.makeValidName(SortCriteria);

%% Output

Result_1n2 = setdiff(MassSpecData.(DisplayGels{1}).Description, MassSpecData.(DisplayGels{2}).Description);
Result_2n1 = setdiff(MassSpecData.(DisplayGels{2}).Description, MassSpecData.(DisplayGels{1}).Description);


%% Functions
function SAF = Calculate_SAF(MassSpecData, GelBand_Name)
    SAF = MassSpecData.(GelBand_Name).x_PSMs ./ MassSpecData.(GelBand_Name).x_AAs;
end

function NSAF = Calculate_NSAF(MassSpecData, GelBand_Name)
    SAF = MassSpecData.(GelBand_Name).SAF;
    NSAF = SAF ./ sum(SAF);
end