function Lookup = FileLookup(FileType, SearchMode, ConstantAddress)
    % FileLookup()
    %   Determine file path/directories as well as folder information to be used for reading file information
    %   Created by: jsl5865
    %
    % Syntax:
    %   Lookup = FileLookup(FileType, SearchMode, ConstantAddress)
    %
    % Description:
    %   This function creates a structure (Lookup) that contains the type of files being found, the folder address,
    %       the file address, total number of files/subfolders, the folder information structure, and the current 
    %       folder.
    %   Any file type can be chosen; a preset list has been made which can be extended.
    %   Currently supports multiple search modes:   Singular file selection (SingleFile)
    %                                               Files within a single folder (SingleFolder)
    %                                               All files within subfolders (AllSubFolders
    %                                               One constant folder (TroubleShoot)
    %
    % Input: 
    %   FileType        - The file extension for the type of desired files (.csv, .txt, .jpg, etc)
    %   SearchMode      - File selection protocol
    %   ConstantAddress - Single file path that will not call for user input.
    %                       - Only necessary if SearchMode = TroubleShoot
    %
    % Output:
    %   Lookup.{FileType, FolderAddress, AllFiles, FolderInfo.{name, folder, date, bytes, isdir, datenum}, FileCount, FolderCount, CurrentFolder}
    arguments
        FileType char {mustBeMember(FileType, {'csv', 'xlsx', 'txt', 'tif', 'mdf'})};
        SearchMode char {mustBeMember(SearchMode, {'SingleFile', 'SingleFolder', 'AllSubFolders', 'TroubleShoot'})} = 'SingleFolder';
        ConstantAddress char = ''
    end
    %% Define the file structure
        Lookup.FileType = strcat('*.', FileType);   % Choose file type
    
    %% Select the folder
        switch SearchMode                                                               % SearchMode = Constant filepath for testing
            case 'TroubleShoot'                                                             % User input: Troubleshoot
                if ~isfolder(ConstantAddress)                                                   % Validate that user defined path exists and is valid
                    error("For 'TroubleShoot' mode, you must provide a" + ...                   % Throw error if invalid
                          " valid folder path as the third argument.");      
                end
                    Lookup.FolderAddress = ConstantAddress;                                     % Set folder address to user defined path
                    searchPattern = fullfile(Lookup.FolderAddress, Lookup.FileType);            % Create a search pattern based on folder address
            case 'SingleFile'                                                               % User input: SingleFile
                [FileName, FolderPath] = uigetfile(Lookup.FileType, 'Select a file');           % Prompt user to select a single file
                if isequal(FileName, 0)                                                         % Validate file selection 
                    error("No file selected");                                                  % Throw error if invalid
                end
                Lookup.FolderAddress = FolderPath;                                              % Set folder address to user defined path
                searchPattern = fullfile(Lookup.FolderAddress, FileName);                       % Create a search pattern based on folder address
            case 'SingleFolder'                                                             % User input: SingleFolder
                Lookup.FolderAddress = uigetdir('*.*', 'Select a folder');                      % Prompt user to select a folder
                if isequal(Lookup.FolderAddress, 0)                                             % Validate folder selection
                    error('No folder selected');                                                % Throw error if invalid
                end
                searchPattern = fullfile(Lookup.FolderAddress, Lookup.FileType);                % Create a search pattern based on an individual folder
            case 'AllSubFolders'                                                            % User input: Troubleshoot
                Lookup.FolderAddress = uigetdir('*.*', 'Select a folder');                      % Prompt user to select a folder
                if isequal(Lookup.FolderAddress, 0)                                             % Validate folder selection
                    error('No folder selected');                                                % Throw error if invalid
                end
                searchPattern = fullfile(Lookup.FolderAddress, '**', Lookup.FileType);          % Create a search pattern based on all sub folders
        end

    %% Find All FileType within defined folder
        Lookup.AllFiles = searchPattern;                                                                    % Create general file path
        Lookup.FolderInfo = dir(searchPattern);                                                             % Identify the folder directory
        Lookup.FileCount = length(Lookup.FolderInfo);                                                       % Determine the number of files in this folder
        Lookup.FolderCount = length(unique({Lookup.FolderInfo.folder}));                                    % Determine the number of folders 
        [~, Lookup.CurrentFolder] = fileparts(Lookup.FolderAddress);                                        % Collect folder information
        Lookup.Path = arrayfun(@(x) fullfile(x.folder, x.name), Lookup.FolderInfo, 'UniformOutput', false); % Identify the file path
end