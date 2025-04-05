function Lookup = FileLookup(FileType)
    if ~ischar(FileType) && ~isstring(FileType)                                         % Ensure input is a string ('csv', 'txt', etc)
        error('File type must be a string or character array.');                        %   Throw error message otherwise
    end                                                                                 %   Continue
    Lookup.FileType = strcat('*.', FileType);                                           % Choose file type
    Lookup.FolderAddress = uigetdir('*.*','Select a file');                             % Choose folder path location
    if isequal(Lookup.FolderAddress, 0)                                                 % Esure directory is found and user did not cancel operation
        error('No File Selected');                                                      %   Throw error message otherwise
    end                                                                                 %   Continue
    Lookup.AllFiles = Lookup.FolderAddress + "\" + Lookup.FileType;                     % Convert to filepath
    Lookup.FolderAddress = erase(Lookup.AllFiles, Lookup.FileType);                     % Create beginning address for file path
    [Lookup.CurrentFolder, ~, ~] = fileparts(Lookup.AllFiles);                          % Collect folder information
    Lookup.CurrentFolder = regexp(Lookup.CurrentFolder, '([^\\]+)$', 'match', 'once');  % Determine the parent folder
    Lookup.FolderInfo = dir(Lookup.AllFiles);                                           % Identify the folder directory
    Lookup.FileCount = length(Lookup.FolderInfo);                                       % Determine the number of files in folder directory
end