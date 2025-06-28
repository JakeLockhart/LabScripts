function Oscope = ReadOscope(Lookup)
    % Oscope()
    %   Collect data created from Tektronix TDS 2014C Four Channel Digital Storage Oscilloscope
    %   Created by: jsl5865
    % Syntax:
    %   Oscope = ReadOscope(Lookup)
    % Description:
    %   Data collection from Tektronix TDS 2014C oscilloscope is standardized, therefore all recordings output the same 
    %       data structure. This function reads all of the oscilloscopes parameters and recorded data from the .csv file(s)
    %       produced after saving a waveform.
    %   This oscilloscope has four channels, which each produce a single .csv file when waveforms are saved (i.e. one .csv file
    %       for each channel). This script saves the Time & Voltage for each of these channels within arrays to be accessed later.
    % Input: 
    %   Lookup - structure created from FileLookup.m
    %          - File extension must be .csv
    %          - Only necessessary arguments: 
    %               - Lookup.FileCount : Total number of files
    %               - Lookup.FolderInfo.name : Name of files
    %               - Lookup.FolderInfo.folder : Folder(s) that contain files
    % Output:
    %   Oscope.{Oscilloscope Recording settings, Time, Voltage}

    arguments
        Lookup struct
    end
    for i = 1:Lookup.FileCount
        Name = erase(Lookup.FolderInfo(i).name, ".csv");
        TempFile = readtable(fullfile(Lookup.FolderInfo(i).folder, Name));
        Oscope.RecordLength(i) = TempFile{1,2};
        Oscope.SampleInterval(i) = TempFile{2,2};
        Oscope.SampleFrequency(i) = 1/Oscope.SampleInterval(i);
        Oscope.TriggerPoint(i) = TempFile{3,2};
        Oscope.VerticalScale(i) = TempFile{9,2};
        Oscope.VerticalOffset(i) = TempFile{10,2};
        Oscope.HorizontalScale(i) = TempFile{12,2};
        Oscope.Yzero(i) = TempFile{14,2};
        Oscope.ProbeAtten(i) = TempFile{15,2};
        Oscope.TimeInterval_dt(i) =  Oscope.SampleInterval(i)./Oscope.RecordLength(i);
        Oscope.TotalTime_Tnet(i) =  Oscope.SampleInterval(i).*Oscope.RecordLength(i);
        timeIndices = linspace(-Oscope.RecordLength(i)/2, Oscope.RecordLength(i)/2, Oscope.RecordLength(i));
        Oscope.Time(i,:) = 1000 * timeIndices * Oscope.SampleInterval(i);
        Oscope.Voltage(i,:) = TempFile{:,5};
    end
end