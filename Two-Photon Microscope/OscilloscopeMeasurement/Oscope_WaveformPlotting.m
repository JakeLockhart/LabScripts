classdef Oscope_WaveformPlotting < Oscope_WaveformAnalysis
    properties
        ColorMap (:,3) double = [0 0 0]
    end

    methods
        %% SuperConstructor - Inherit the objecs from WaveformAnalysis
        function obj = Oscope_WaveformPlotting(Signals, LoadedData)
            obj@Oscope_WaveformAnalysis(Signals, LoadedData);
            obj.ColorMap = hsv(obj.Lookup.FileCount);
        end

        function PlotRawSignal(obj)
            figure()

            t = tiledlayout(obj.Lookup.FileCount, 1);
            title(t, "Raw Voltage Signal", 'Color', 'White')
            xlabel(t, "Time [ms]", 'Color', 'White')
            ylabel(t, "Voltage [V]", 'Color', 'White')

            set(gcf, 'Color', [0, 0, 0]);

            for i = 1:obj.Lookup.FileCount
                nexttile(t, i); hold on;
                title(obj.Signals(i), 'Color', 'White')
                plot(obj.Oscope.Time(i,:), obj.Oscope.Voltage(i,:), "Color", obj.ColorMap(i,:))
                set(gca, 'Color', [0 0 0]);  set(gca, 'XColor', 'white', 'YColor', 'white')
                axis tight
            end
        end

        %function PlotCrossCorrelation(obj)
        %    figure()
%
        %    Rows = (obj.Lookup.FileCount * (obj.Lookup.FileCount - 1)) / 2;
        %    MainLayout = tiledlayout(Rows, 3);
        %    title("Time Lag Between Signals", 'Color', 'White')
        %    
        %    
%
%
%
%
%
        %end
    end



end