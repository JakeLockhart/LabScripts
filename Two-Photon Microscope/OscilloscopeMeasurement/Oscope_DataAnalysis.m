classdef Oscope_DataAnalysis
    properties
       Oscope
       Signals
       LowerBound
       UpperBound
    end

    properties
        % Cross Correlation Properties
        Xc
        Lags
        Shift
        % Histogram Properties
        Peaks
        Count
    end

    methods
        %%  Constructor
        %       Create an object based on oscilloscope data, the types of signals, and 
        %       the bounds of a single pulse
        function obj = Oscope_DataAnalysis(Oscope, Signals, LowerBound, UpperBound)
            obj.Oscope = Oscope;
            obj.Signals = Signals;
            obj.LowerBound = LowerBound;
            obj.UpperBound = UpperBound;
        end

        %%  Method #1
        %       Determine the cross correlation, lags, and shift between each recorded 
        %       oscilloscope signal 
        function obj = CrossCorrelation(obj)
            Voltage = obj.Oscope.Voltage(:, obj.LowerBound:obj.UpperBound);
            Voltage = Voltage- mean(Voltage,2);

            TotalSignals = size(obj.Signals, 2);
            
            obj.Xc = struct();
            obj.Lags = struct();
            obj.Shift = struct();

            for i = 1:TotalSignals-1
                for j = i+1:TotalSignals
                    Signal = sprintf('%s_%s', obj.Signals{i}, obj.Signals{j});
                    Signal = matlab.lang.makeValidName(Signal);

                    [obj.Xc.(Signal), obj.Lags.(Signal)] = xcorr(Voltage(i,:), Voltage(j,:), 'coeff');
                    [~, idx] = max(obj.Xc.(Signal));
                    obj.Shift.(Signal) = obj.Lags.(Signal)(idx);
                end
            end
        end

        %%  Method #2
        %       Determine bin size, count and peaks of the recorded oscilloscope 
        %       data using histograms
        function obj = Histogram(obj, Signal)
            idx = find(strcmp(obj.Signals, Signal), 1);
            if isempty(idx)
                error('%s is not found within signal list', Signal);
            end

            Voltage = obj.Oscope.Voltage(idx,:);
            TotalBins = sqrt(size(Voltage, 2));
            [Count, BinEdge] = histcounts(Voltage, TotalBins);
            BinCenter = (BinEdge(1:end-1) + BinEdge(2:end))/2;
        end

    end
end