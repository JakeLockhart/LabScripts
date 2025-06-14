function Lookup = FileLookup(FileType, SearchMode, ConstantAdress)
    %% Validate file type 
        if ~ischar(FileType) && ~isstring(FileType)                                 % Ensure input is a string ('csv', 'txt', etc)
            error('File type must be a string or character array.');                %   Throw error message otherwise
        end                                                                         %   Continue
        Lookup.FileType = strcat('*.', FileType);                                   % Choose file type
    
    %% Determine search mode (Single Folder || All Subfolders || Constant TroubleShoot)
        if nargin < 2 || isempty(SearchMode)                                        % Assume no subfolders unless otherwise stated
            SearchMode = 'Single';                                                  %   Define file search based on empty argument
        elseif ~any(strcmpi(SearchMode, {'Single', 'All', 'TroubleShoot'}))              %   Validate second argument
            error("SearchMode must be 'Single', 'All', or 'TroubleShoot'.");             %       Throw error message
        end                                                                         %   Continue

    %% Select the folder
        if strcmpi(SearchMode, 'TroubleShoot')                                      % SearchMode = Constant filepath for testing
            if nargin < 3 || ~isfolder(ConstantAdress)                              %   Determine if three fields are provided  
                error("For 'TroubleShoot' mode, you must provide a" + ...           %       Throw error message if filepath not defined
                      " valid folder path as the third argument.");                 %   
            end                                                                     %   Continue
            Lookup.FolderAddress = ConstantAdress;                                  %   Define folder path location
        else                                                                        %   SearchMode /= Constant filepath for testing
            Lookup.FolderAddress = uigetdir('*.*','Select a folder');               %   Choose folder path location
            if isequal(Lookup.FolderAddress, 0)                                     %       Esure directory is found and user did not cancel operation
                error('No folder selected.');                                       %         Throw error message otherwise
            end                                                                     %         Continue
        end

    %% Determine file search based on SearchMode
        if strcmpi(SearchMode, 'All')                                               % SearchMode = All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, '**', Lookup.FileType);  %   Find All FileType within subfolders
        else                                                                        %   SearchMode /= All files within subfolders
            searchPattern = fullfile(Lookup.FolderAddress, Lookup.FileType);        %   Find All Filetype within Single folder
        end                                                                         %   continue

    %% Find All FileType within defined folder
        Lookup.AllFiles = searchPattern;                                            % Create general file path
        Lookup.FolderInfo = dir(searchPattern);                                     % Identify the folder directory
        Lookup.FileCount = length(Lookup.FolderInfo);                               % Determine the number of files in this folder
        Lookup.FolderCount = length(unique({Lookup.FolderInfo.folder}));            % Determine the number of folders 
        [~, Lookup.CurrentFolder] = fileparts(Lookup.FolderAddress);                % Collect folder information
end