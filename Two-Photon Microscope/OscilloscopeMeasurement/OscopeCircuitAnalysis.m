clear; clc; format short; format compact;
%   This script is designed to analyze multiple channels from an oscilloscope. 

SystemProperties.FilePath.GetFolder = uigetdir('*.*','Select a file');                          % Choose folder path location
        SystemProperties.FilePath.Address = SystemProperties.FilePath.GetFolder + "\*.csv";         % Convert to filepath
        SystemProperties.FilePath.Folder = dir(SystemProperties.FilePath.Address);                  % Identify the folder directory 
        SystemProperties.FilePath.Data.Length = length(SystemProperties.FilePath.Folder);           % Determine the number of files in folder directory
        SystemProperties.FilePath.Data.Address = erase(SystemProperties.FilePath.Address,"*.csv");  % Create beginning address for file path
        [FolderPath, ~, ~] = fileparts(SystemProperties.FilePath.Address);
        SystemProperties.FilePath.CurrentFolder = regexp(FolderPath, '([^\\]+)$', 'match', 'once');

%% Read .CSV file
for i = 1:SystemProperties.FilePath.Data.Length
    Name = erase(SystemProperties.FilePath.Folder(i).name, ".csv");
    TempFile = readtable(fullfile(SystemProperties.FilePath.Data.Address, Name));
    Oscope.RecordLength(i) = TempFile{1,2};
    Oscope.SampleInterval(i) = TempFile{2,2};
    Oscope.TriggerPoint(i) = TempFile{3,2};
    Oscope.VerticalScale(i) = TempFile{9,2};
    Oscope.VerticalOffset(i) = TempFile{10,2};
    Oscope.HorizontalScale(i) = TempFile{12,2};
    Oscope.Yzero(i) = TempFile{14,2};
    Oscope.ProbeAtten(i) = TempFile{15,2};
    Oscope.Time(i,:) = TempFile{:,4}/Oscope.SampleInterval(i);
    Oscope.Voltage(i,:) = TempFile{:,5};
end
