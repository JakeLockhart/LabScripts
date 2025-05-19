function Lookup = FileLookup(FileType, SearchMode)
    %% Validate file type 
        if ~ischar(FileType) && ~isstring(FileType)                                 % Ensure input is a string ('csv', 'txt', etc)
            error('File type must be a string or character array.');                %   Throw error message otherwise
        end                                                                         %   Continue
        Lookup.FileType = strcat('*.', FileType);                                   % Choose file type
    
    %% Determine search type (Single Folder || All subfolders)
        if nargin < 2 || isempty(SearchMode)                                        % Assume no subfolders unless otherwise stated
            SearchMode = 'single';                                                  %   Define file search based on empty argument
        elseif ~any(strcmpi(SearchMode, {'single', 'all'}))                         %   Validate second argument
            error("SearchMode must be 'single' or 'all'.");                         %       Throw error message
        end                                                                         %   Continue

    %% Select the folder
        Lookup.FolderAddress = uigetdir('*.*','Select a folder');                   % Choose folder path location
        if isequal(Lookup.FolderAddress, 0)                                         % Esure directory is found and user did not cancel operation
            error('No folder selected.');                                           %   Throw error message otherwise
        end                                                                         %   Continue

    %% Determine file search based on SearchMode
        if strcmpi(SearchMode, 'all')                                               % SearchMode = All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, '**', Lookup.FileType);  %   Find all FileType within subfolders
        else                                                                        %   SearchMode /= All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, Lookup.FileType);        %   Find all Filetype within single folder
        end                                                                         %   continue

    %% Find all FileType within defined folder
        Lookup.AllFiles = searchPattern;                                            % Create general file path
        Lookup.FolderInfo = dir(searchPattern);                                     % Identify the folder directory
        Lookup.FileCount = length(Lookup.FolderInfo);                               % Determine the number of files in this folder
        Lookup.FolderCount = length(unique({Lookup.FolderInfo.folder}));            % Determine the number of folders 
        [~, Lookup.CurrentFolder] = fileparts(Lookup.FolderAddress);                % Collect folder information
end