classdef Oscope_WaveformPlotting < Oscope_WaveformAnalysis
    properties

    end

    methods
        %% SuperConstructor - Inherit the objecs from WaveformAnalysis
        function obj = Oscope_WaveformPlotting(Signals, LoadedData)
            obj@Oscope_WaveformAnalysis(Signals, LoadedData);
        end

        function PlotRawSignal(obj)
            figure()
            ColorMap = hsv(obj.Lookup.FileCount);

            t = tiledlayout(obj.Lookup.FileCount, 1);
            title(t, "Raw Voltage Signal", 'Color', 'White')
            xlabel(t, "Time [ms]", 'Color', 'White')
            ylabel(t, "Voltage [V]", 'Color', 'White')

            set(gcf, 'Color', [0, 0, 0]);

            for i = 1:obj.Lookup.FileCount
                nexttile(t, i); hold on;
                title(obj.Signals(i), 'Color', 'White')
                plot(obj.Oscope.Time(i,:), obj.Oscope.Voltage(i,:), "Color", ColorMap(i,:))
                set(gca, 'Color', [0 0 0]);  set(gca, 'XColor', 'white', 'YColor', 'white')
                axis tight
            end
        end

        function PlotCrossCorrelation(obj)
            figure()

        end
    end



end