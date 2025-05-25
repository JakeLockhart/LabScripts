function Oscope = ReadOscope(Lookup)
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