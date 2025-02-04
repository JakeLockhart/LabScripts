%%  Resonant 2Photon Power (R2P) Measurement
%   Problem:
%       Measuring the power of the resonant 2photon by manually altering
%       the power on the MScan software and recording the signal from the
%       power meter is relatively inefficient (time intensive and subject
%       to examiner error). 
%       By setting Mscan to average multiple frames and using the automatic 
%       intensity control (linear) to alter the power intensity, a graph of
%       the R2P power intensity vs laser output can be created.

%% System Properties
[SystemProperties.Info,SystemProperties.Location] = uigetfile('*.*','Select a file');   % Choose file 
SystemProperties.FilePath = string([SystemProperties.Location,SystemProperties.Info]);  % Create file path
SystemProperties.Threshold = 1;                                                         % Adjust minimum threshold to remove data before/after active recording

%% Data Collection/Processing
R2Pm.FilePath = SystemProperties.FilePath;                                                                      % Define file path
    R2Pm.ImportOptions = detectImportOptions(R2Pm.FilePath);                                                    % Import all data as MM/dd/yyyy
    R2Pm.ImportOptions = setvaropts(R2Pm.ImportOptions, 'Var1', 'InputFormat', 'MM/dd/yyyy hh:mm:ss.SSS a');    % Import all data as MM/dd/yyyy
R2Pm.RawData = readtable(R2Pm.FilePath, R2Pm.ImportOptions);                                                    % Create table based on raw data file

R2Pm.Data = table;                                                                      % Create table for processing data 
    R2Pm.Data.DateTime = R2Pm.RawData.Var1;                                             % Insert time (DateTime format) variable into table
    R2Pm.Data.ReferenceTime = datenum(R2Pm.RawData.Var1);                               % Insert reference time (time since recording starts) variable into table. Convert from datetime to number format
    R2Pm.Data.Intensity = R2Pm.RawData.Var2*1000;                                       % Insert laser intensity variable into table. Multiply x1000 to convert power to mW units
    R2Pm.Data = R2Pm.Data(~(R2Pm.Data.Intensity < SystemProperties.Threshold),:);       % Remove all rows that give power intensity below threshold
        R2Pm.Data.DateTime = R2Pm.Data.DateTime - R2Pm.Data.DateTime(1);                % Reset time (DateTime format) variable to 0
        R2Pm.Data.ReferenceTime = R2Pm.Data.ReferenceTime - R2Pm.Data.ReferenceTime(1); % Reset time (number format) variable to 0
R2Pm.Results = table;                                                                                   % Create table for results
    [R2Pm.Results.OutputIntensity, index] = findpeaks([R2Pm.Data.Intensity]);                           % Find local maximum laser power intensities and associated index
    R2Pm.Results.Time = R2Pm.Data.ReferenceTime(index);                                                 % Determine time variable based on index
    R2Pm.Results.InputIntensity = [0, 100*((1:size(R2Pm.Results,1)-1) / (size(R2Pm.Results,1)-1))]';    % Create input power intensity based on percentages (actually input for MScan)
R2Pm.Analysis = table;                                                                                                                                  % Create table for data analysis
    R2Pm.Analysis.InterestValues = [0:5:70,80:10:100]';                                                                                                 % Power values of interest as defined by excel sheet
        for i = 1:length(R2Pm.Analysis.InterestValues)                                                                                                  % Begin for loop to iterate over values of interest
            R2Pm.Analysis.Time(i,1) = interp1(R2Pm.Results.InputIntensity, R2Pm.Results.Time,R2Pm.Analysis.InterestValues(i));                          % Interpolate input intensity for scanning time based on values of interest
            R2Pm.Analysis.OutputIntensity(i,1) = interp1(R2Pm.Results.InputIntensity, R2Pm.Results.OutputIntensity,R2Pm.Analysis.InterestValues(i));    % Interpolate input intensity for output intensity based on values of interest 
        end                                                                                                                                             % End for loop

%% Plot & Output
figure(1)
plot(R2Pm.Data.DateTime, R2Pm.Data.Intensity, 'Color', [0 0.4470 0.7410]); hold on;
plot(R2Pm.Results.Time, R2Pm.Results.OutputIntensity, 'red*'); hold on;
plot(R2Pm.Analysis.Time,R2Pm.Analysis.OutputIntensity,'k.','MarkerSize',20); hold on;
title("Resonant 2Photon Laser Power Measurement")
xlabel('Session Duration [min]'); ylabel('Laser Power Output Intensity [mW]')
for i = 1:length(R2Pm.Analysis.InterestValues)
     xline(R2Pm.Analysis.Time(i),'-',{"Input Laser Power = " + num2str(R2Pm.Analysis.InterestValues(i))+'%'})
end

% fprintf('Below are the results of the power calibration of the resonant two photon microscope.\n');
% disp([R2Pm.Analysis.InterestValues, R2Pm.Analysis.OutputIntensity])
