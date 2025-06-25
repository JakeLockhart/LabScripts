function Lookup = FileLookup(FileType, SearchMode, ConstantAddress)
    arguments
        FileType char {mustBeMember(FileType, {'csv', 'xlsx', 'txt', 'tiff', 'mdf'})};
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