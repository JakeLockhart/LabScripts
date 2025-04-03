function Lookup = FileLookup(FileType)
    if ~ischar(FileType) && ~isstring(FileType)
        error('File type must be a string or character array.');
    end
    Lookup.FileType = strcat('*.', FileType);                                       % Choose file type
    Lookup.FolderAddress = uigetdir('*.*','Select a file');                             % Choose folder path location
    Lookup.AllFiles = Lookup.FolderAddress + "\" + Lookup.FileType;                     % Convert to filepath
    Lookup.FolderAddress = erase(Lookup.AllFiles, Lookup.FileType);                     % Create beginning address for file path
    [Lookup.CurrentFolder, ~, ~] = fileparts(Lookup.AllFiles);                          % Collect folder information
    Lookup.CurrentFolder = regexp(Lookup.CurrentFolder, '([^\\]+)$', 'match', 'once');  % Determine the parent folder
    Lookup.FolderInfo = dir(Lookup.AllFiles);                                           % Identify the folder directory
    Lookup.FileCount = length(Lookup.FolderInfo);                                       % Determine the number of files in folder directory
end