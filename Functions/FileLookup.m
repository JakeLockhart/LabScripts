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
    %   Currently supports multiple search modes:   Files within a single folder (SingleFolder)
    %                                               All files within subfolders (AllSubFolders
    %                                               One file (TroubleShoot)
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
        SearchMode char {mustBeMember(SearchMode, {'SingleFolder', 'AllSubFolders', 'TroubleShoot'})} = 'SingleFolder';
        ConstantAddress char = ''
    end
    %% Define the file structure
        Lookup.FileType = strcat('*.', FileType);                                   % Choose file type
    
    %% Select the folder
        if strcmpi(SearchMode, 'TroubleShoot')                                      % SearchMode = Constant filepath for testing
            if ~isfolder(ConstantAddress)                                           %   Determine if three fields are provided  
                error("For 'TroubleShoot' mode, you must provide a" + ...           %       Throw error message if filepath not defined
                      " valid folder path as the third argument.");                 %   
            end                                                                     %   Continue
            Lookup.FolderAddress = ConstantAddress;                                 %   Define folder path location
        else                                                                        %   SearchMode /= Constant filepath for testing
            Lookup.FolderAddress = uigetdir('*.*','Select a folder');               %   Choose folder path location
            if isequal(Lookup.FolderAddress, 0)                                     %       Esure directory is found and user did not cancel operation
                error('No folder selected.');                                       %         Throw error message otherwise
            end                                                                     %         Continue
        end

    %% Determine file search based on SearchMode
        if strcmpi(SearchMode, 'AllSubFolders')                                     % SearchMode = All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, '**', Lookup.FileType);  %   Find All FileType within subfolders
        else                                                                        %   SearchMode /= All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, Lookup.FileType);        %   Find All Filetype within SingleFolder folder
        end                                                                         %   continue

    %% Find All FileType within defined folder
        Lookup.AllFiles = searchPattern;                                            % Create general file path
        Lookup.FolderInfo = dir(searchPattern);                                     % Identify the folder directory
        Lookup.FileCount = length(Lookup.FolderInfo);                               % Determine the number of files in this folder
        Lookup.FolderCount = length(unique({Lookup.FolderInfo.folder}));            % Determine the number of folders 
        [~, Lookup.CurrentFolder] = fileparts(Lookup.FolderAddress);                % Collect folder information
end