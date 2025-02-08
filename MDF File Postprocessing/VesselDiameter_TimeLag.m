%%  Penetrating Arteriole Vessel Diameter Cross Correlation (2 Planes)
%   Problem:
%       Determine the lag-time between two cross-section of a penetrating
%       arteriole's trunk.
%   Notes:
%       This script takes two sets of inputs. The first set [a,b] is the 
%       frame where a vasodilation event begins and finishes. The second
%       set are two .txt files contianing the vessel diameters obtained
%       from the Transform in Radon Space (TiRS) function.
%       This is a proof of concept and only works for a single vasodilaiton
%       event.
%   Output:
%       Figure 1 - Raw penetrating arteriole diameter plotted for both .txt
%                  files and overlayed. Followed by a median filter to the
%                  data, and then normalized with respect to baseline
%                  diameter (overal mean of data).
%       Figure 2 - Diameter of penetrating arteriole at both cross-sections
%                  plotted with region of interest based on [a,b].
%       Figure 3 - Normalized penetrating arteriole diameter for both
%                  cross-sections with region of interest identified.
%                  Normalized plot zoomed into region of interest. Cross
%                  correlation of the two data sets.
clear; clc; format short; format compact;
%% Data

a = 17650; b = 17800;

Data.Top.RawArea = readtable("JSL000_Practice6_241204_Processing_Top_Area.txt");
Data.Top.Time = length(Data.Top.RawArea.area)/39.55;
Data.Top.Area = Data.Top.RawArea.area;
Data.Top.Diameter = 2*sqrt(Data.Top.Area/pi);
Data.Top.FilteredDiameter = medfilt3(Data.Top.Diameter);
Data.Top.Normalized = 100*(Data.Top.FilteredDiameter - mean(Data.Top.FilteredDiameter))/mean(Data.Top.FilteredDiameter);
Data.Top.ForCorrelation = Data.Top.Normalized(a:b) - mean(Data.Top.Normalized(a:b));

Data.Bottom.RawArea = readtable("JSL000_Practice6_241204_Processing_Bottom_Area.txt");
Data.Bottom.Time = length(Data.Bottom.RawArea.area)/39.55;
Data.Bottom.Area = Data.Bottom.RawArea.area;
Data.Bottom.Diameter = 2*sqrt(Data.Bottom.Area/pi);
Data.Bottom.FilteredDiameter = medfilt3(Data.Bottom.Diameter);
Data.Bottom.Normalized = 100*(Data.Bottom.FilteredDiameter - mean(Data.Bottom.FilteredDiameter))/mean(Data.Bottom.FilteredDiameter);
Data.Bottom.ForCorrelation = Data.Bottom.Normalized(a:b) - mean(Data.Bottom.Normalized(a:b));

Data.Range.Top = length(Data.Top.RawArea.area);
Data.Range.Bottom = length(Data.Bottom.RawArea.area);
Data.Range.Range = min(Data.Range.Top, Data.Range.Bottom);

[CorrelationCoefficient1, Lags1] = xcorr(Data.Bottom.ForCorrelation, Data.Top.ForCorrelation);


%% Plot

figure(1)
t = tiledlayout(1,3);
    t1 = tiledlayout(t,3,1);
        t1.Layout.Tile = 1;
        title(t1,"Raw P.A. Area (Running)");
        xlabel(t1,'Time [s]')
        nexttile(t1);   plot(Data.Top.RawArea.area); hold on;
                        title('P.A. Upper Layer (20\mum deep)')
                        ylabel('P.A. Area [\mum^2]');
        nexttile(t1);   plot(Data.Bottom.RawArea.area,'k');
                        title('P.A. Lower Layer (70\mum deep)')
                        ylabel('P.A. Area [\mum^2]');
        nexttile(t1);   plot(Data.Top.RawArea.area); hold on;
                        plot(Data.Bottom.RawArea.area,'k'); hold on;
                        title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
                        legend('20\mum','70\mum')
    t2 = tiledlayout(t,3,1);
        t2.Layout.Tile = 2;
        title(t2,"Filtered P.A. Diameteter (Running)")
        xlabel(t2, 'Time [s]')
        nexttile(t2);   plot(Data.Top.FilteredDiameter);
                        title('P.A. Upper Layer (20\mum deep)')
                        ylabel('P.A. Diameter [\mum]');
        nexttile(t2);   plot(Data.Bottom.FilteredDiameter,'k');
                        title('P.A. Lower Layer (70\mum deep)')
                        ylabel('P.A. Diameter [\mum]');
        nexttile(t2);   plot(Data.Top.FilteredDiameter); hold on;
                        plot(Data.Bottom.FilteredDiameter,'k'); hold on;
                        title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
                        ylabel('P.A. Diameter [\mum]');
                        legend('20\mum','70\mum')
    t3 = tiledlayout(t,3,1);
        t3.Layout.Tile = 3;
        title(t3,"Normalized P.A. Diameteter (Running)")
        xlabel(t3, 'Time [s]')
        nexttile(t3);   plot(Data.Top.Normalized);
                        title('P.A. Upper Layer (20\mum deep)')
                        ylabel('P.A. \DeltaDiameter/Diameter [%]');
        nexttile(t3);   plot(Data.Bottom.Normalized,'k');
                        title('P.A. Lower Layer (70\mum deep)')
                        ylabel('P.A. \DeltaDiameter/Diameter [%]');
        nexttile(t3);   plot(Data.Top.Normalized); hold on;
                        plot(Data.Bottom.Normalized,'k'); hold on;
                        title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
                        ylabel('P.A. \DeltaDiameter/Diameter [%]');
                        legend('20\mum','70\mum')
figure(2)
t = tiledlayout(3,1);
    t1 = tiledlayout(t,1,1);
        t1.Layout.Tile = 1;
        title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
        ylabel('P.A. \DeltaDiameter/Diameter [%]');
            plot(Data.Top.Normalized); hold on;
            plot(Data.Bottom.Normalized,'k'); hold on;
            title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
            ylabel('P.A. \DeltaDiameter/Diameter [%]');
            legend('20\mum','70\mum')
            xline(a,'--r',LineWidth=2); xline(b,'--r',LineWidth=2);



figure(3)
tiledlayout(3,1);
nexttile;
plot(Data.Top.Normalized); hold on;
plot(Data.Bottom.Normalized,'k'); hold on;
title('P.A. Upper & Lower Layer (20\mum, 70\mum deep)');
ylabel('P.A. \DeltaDiameter/Diameter [%]');
legend('20\mum','70\mum')
xline(a,'--r',LineWidth=2); xline(b,'--r',LineWidth=2);
nexttile
plot(Data.Top.Normalized(a:b)); hold on;
plot(Data.Bottom.Normalized(a:b),'k');
xlim([-5,b-a+5]);
xline(0,'--r',LineWidth=2); xline(b-a,'--r',LineWidth=2);
nexttile
plot(Lags1,CorrelationCoefficient1); hold on;
xlim([-(b-a+5),b-a+5]);
xline(0)
xline(-(b-a),'--r',LineWidth=2); xline(b-a,'--r',LineWidth=2);
xline(157-.5*length(CorrelationCoefficient1))
% 
% %%
% [c,lags] = xcorr(Area.Data.Bottom(7200:7700)-mean(Area.Data.Bottom(7200:7700)),Area.Data.Top(7250:7400)-mean(Area.Data.Top(7250:7400)));
% 
% figure('Name','xcorr')
% plot(lags,c); hold on;
% xline(0)
% %%
% figure('Name','raw')
% plot(Area.Data.Top(7250:7400))
% %%
% figure('Name','raw2')
% plot(Area.Data.Bottom(7250:7400))