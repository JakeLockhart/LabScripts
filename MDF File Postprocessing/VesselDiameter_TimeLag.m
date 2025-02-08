%%  Penetrating Arteriole Vessel Diameter Cross Correlation (2 Planes)
%   Problem:
%       Determine the lag-time between two cross-section of a penetrating
%       arteriole's trunk.
%   Notes:
%       This script accepts two .txt files, each containing penetrating 
%       arteriole diameters at a specific frame. In the 'Parameters'
%       section, identify the frames at which vasodilation events begin, as
%       well as the duration of the event, the median filter level, and the
%       frame rate of the resonant two-photon microscope at the time of
%       recording. 
%       The .txt files can be obtained from the Transform in Radon Space
%       (TiRS) function.
%       This will become a part of the pipeline to analyze data, but must
%       first be refined to accept ROIs of variable length, converted to a
%       function, and ...
%   Output:
%       Figure 1 - 3x3 window of plots. Columns 1,2,3 represent the raw 
%                  penetrating arteriole diameter, filtered penetrating 
%                  arteriole diameter, and normalized penetrating areriole 
%                  diameter, respectively. Rows 1,2,3 represent the upper 
%                  cross-section, lower cross-section, and overlayed 
%                  cross-sections of the penetrating arteriole trunk.
%       Figure 2 - Depicts the normalzied penetrating arteriole diameter of
%                  both cross-sections along with highlighted regions of
%                  interest. Following are cropped plots displaying only
%                  regions of interests, and finaly the cross correlation
%                  for each region of interest.

%% Parameters
Parameter.FilterSize = 5;
Parameter.Gap = 100;
Parameter.FPS = 39.55;
Parameter.ROIs = [600; 2900; 7300; 7750; 12050; 12600; 16850];
    Parameter.ROIs(:,2) = Parameter.ROIs(:,1) + Parameter.Gap;
Parameter.CorrelationCoefficient = []; 
Parameter.Lag = [];

%% Data - General Data Processing
Data.Top.RawArea = readtable("JSL000_Practice6_241204_Processing_Top_Area.txt");
Data.Top.Time = length(Data.Top.RawArea.area)/39.55;
Data.Top.Area = Data.Top.RawArea.area;
Data.Top.Diameter = 2*sqrt(Data.Top.Area/pi);
Data.Top.FilteredDiameter = medfilt1(Data.Top.Diameter,Parameter.FilterSize);
Data.Top.Normalized = 100*(Data.Top.FilteredDiameter - mean(Data.Top.FilteredDiameter))/mean(Data.Top.FilteredDiameter);

Data.Bottom.RawArea = readtable("JSL000_Practice6_241204_Processing_Bottom_Area.txt");
Data.Bottom.Time = length(Data.Bottom.RawArea.area)/39.55;
Data.Bottom.Area = Data.Bottom.RawArea.area;
Data.Bottom.Diameter = 2*sqrt(Data.Bottom.Area/pi);
Data.Bottom.FilteredDiameter = medfilt1(Data.Bottom.Diameter,Parameter.FilterSize);
Data.Bottom.Normalized = 100*(Data.Bottom.FilteredDiameter - mean(Data.Bottom.FilteredDiameter))/mean(Data.Bottom.FilteredDiameter);

%% Data - ROI & Correlations
for i = 1:size(Parameter.ROIs,1)
    TopBaseline= Data.Top.Normalized(Parameter.ROIs(i,1):Parameter.ROIs(i,2)) - mean(Data.Top.Normalized(Parameter.ROIs(i,1):Parameter.ROIs(i,2)));
    BottomBaseline= Data.Bottom.Normalized(Parameter.ROIs(i,1):Parameter.ROIs(i,2)) - mean(Data.Bottom.Normalized(Parameter.ROIs(i,1):Parameter.ROIs(i,2)));
    [CC,L] = xcorr(BottomBaseline,TopBaseline,"normalized");
    Parameter.CorrelationCoefficient(:,i) = CC;
    Parameter.Lag(:,i) = L';
    Parameter.ColorMap(i,:) = randi([0,10],[1,3])/10;
end

%% Plot - Processing
TimeTop = (1:height(Data.Top.RawArea))/Parameter.FPS;
TimeBottom = (1:height(Data.Bottom.RawArea))/Parameter.FPS;
figure(1)
t = tiledlayout(1,3);
    t1 = tiledlayout(t,3,1);
        t1.Layout.Tile = 1;
        title(t1,"Raw P.A. Area (Running)");
        xlabel(t1,'Time [s]')
        nexttile(t1);   plot(TimeTop,Data.Top.RawArea.area); hold on;
                        title('P.A. Upper Layer (20\mum deep)')
                        ylabel('P.A. Area [\mum^2]');
        nexttile(t1);   plot(TimeBottom,Data.Bottom.RawArea.area,'k');
                        title('P.A. Lower Layer (70\mum deep)')
                        ylabel('P.A. Area [\mum^2]');
        nexttile(t1);   plot(TimeTop,Data.Top.RawArea.area); hold on;
                        plot(TimeBottom,Data.Bottom.RawArea.area,'k'); hold on;
                        title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
                        legend('20\mum','70\mum')
    t2 = tiledlayout(t,3,1);
        t2.Layout.Tile = 2;
        title(t2,"Filtered P.A. Diameteter (Running)")
        xlabel(t2, 'Time [s]')
        nexttile(t2);   plot(TimeTop,Data.Top.FilteredDiameter);
                        title('P.A. Upper Layer (20\mum deep)')
                        ylabel('P.A. Diameter [\mum]');
        nexttile(t2);   plot(TimeBottom,Data.Bottom.FilteredDiameter,'k');
                        title('P.A. Lower Layer (70\mum deep)')
                        ylabel('P.A. Diameter [\mum]');
        nexttile(t2);   plot(TimeTop,Data.Top.FilteredDiameter); hold on;
                        plot(TimeBottom,Data.Bottom.FilteredDiameter,'k'); hold on;
                        title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
                        ylabel('P.A. Diameter [\mum]');
                        legend('20\mum','70\mum')
    t3 = tiledlayout(t,3,1);
        t3.Layout.Tile = 3;
        title(t3,"Normalized P.A. Diameteter (Running)")
        xlabel(t3, 'Time [s]')
        nexttile(t3);   plot(TimeTop,Data.Top.Normalized);
                        title('P.A. Upper Layer (20\mum deep)')
                        ylabel('P.A. \DeltaDiameter/Diameter [%]');
        nexttile(t3);   plot(TimeBottom,Data.Bottom.Normalized,'k');
                        title('P.A. Lower Layer (70\mum deep)')
                        ylabel('P.A. \DeltaDiameter/Diameter [%]');
        nexttile(t3);   plot(TimeTop,Data.Top.Normalized); hold on;
                        plot(TimeBottom,Data.Bottom.Normalized,'k'); hold on;
                        title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
                        ylabel('P.A. \DeltaDiameter/Diameter [%]');
                        legend('20\mum','70\mum')
%% Plot - Correlation
figure(2)
t = tiledlayout(3,1);
    t1 = tiledlayout(t,1,1);
    t1.Layout.Tile = 1;
    title(t,'Cross Correlation of JSL000.6 Penetrating Arteriole while Running');
    xlabel(t,'Time [s]');
        nexttile(t1);
        plot(TimeTop,Data.Top.Normalized); hold on;
        plot(TimeBottom,Data.Bottom.Normalized,'k'); hold on;
        title(t1,'P.A. Upper & Lower Layer (20\mum, 70\mum deep)')
        ylabel('P.A. \DeltaD/D [%]');
        legend('20\mum','70\mum')
        for i = 1:size(Parameter.ROIs,1)
            xline(TimeTop(Parameter.ROIs(i,1)),'--r',LineWidth=2,HandleVisibility='off',Color=Parameter.ColorMap(i,:)); 
            xline(TimeBottom(Parameter.ROIs(i,2)),'--r',LineWidth=2,HandleVisibility='off',Color=Parameter.ColorMap(i,:));
            axis('tight')
        end
    t2 = tiledlayout(t,1,size(Parameter.ROIs,1));
    t2.Layout.Tile = 2;
        title(t2,'P.A. Upper & Lower Layer (20\mum, 70\mum deep) Sections');
        ylabel(t2,'P.A. \DeltaD/D [%]');
        for i = 1:size(Parameter.ROIs,1)
            nexttile(t2);
            plot(TimeTop(Parameter.ROIs(i,1):Parameter.ROIs(i,2)),Data.Top.Normalized(Parameter.ROIs(i,1):Parameter.ROIs(i,2))); hold on;
            plot(TimeBottom(Parameter.ROIs(i,1):Parameter.ROIs(i,2)),Data.Bottom.Normalized(Parameter.ROIs(i,1):Parameter.ROIs(i,2)),'k'); hold on;
            xline(TimeTop(Parameter.ROIs(i,1)),'--r',LineWidth=2,HandleVisibility='off',Color=Parameter.ColorMap(i,:)); 
            xline(TimeTop(Parameter.ROIs(i,2)),'--r',LineWidth=2,HandleVisibility='off',Color=Parameter.ColorMap(i,:));
            axis('tight')
        end
    t3 = tiledlayout(t,1,size(Parameter.ROIs,1));
    t3.Layout.Tile = 3;
        title(t3,'Cross Correlation of P.A. Parameter.ROIs');
        ylabel(t3,'Cross Correlation Coefficient')
        for i = 1:size(Parameter.ROIs,1)
            nexttile(t3)
            xlim([-Parameter.Gap,Parameter.Gap])
            plot(Parameter.Lag(:,i),Parameter.CorrelationCoefficient(:,i)); hold on;
            xline(0,'--k');
            xline(-Parameter.Gap,'--r',LineWidth=2,HandleVisibility='off',Color=Parameter.ColorMap(i,:)); 
            xline(Parameter.Gap,'--r',LineWidth=2,HandleVisibility='off',Color=Parameter.ColorMap(i,:));
            axis('tight')
        end
%%
figure(4)
plot(Data.Top.Normalized); hold on;
plot(Data.Bottom.Normalized); hold on;
axis('tight')
xregion(length(Data.Top.Normalized),0,'FaceColor','b')
x_bin = Data.Top.Normalized > Data.Bottom.Normalized(1:end-1,1);
