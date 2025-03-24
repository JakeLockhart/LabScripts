clear; clc; format short; format compact;

% Data
Data.Saline = [189, 145, 58, 95, 124, 75, 119, 188, 80, 99, 72, 235, 89, 92, 120, 95, 144, 84, 100, 300];
Data.Nanoplastics = [85, 50, 130, 215, 50, 81, 120, 300, 224, 300, 106, 300, 169, 65, 300, 300, 110, 300, 210];
Data.TotalData = [Data.Saline, Data.Nanoplastics];
Data.Group = [ones(size(Data.Saline)), ones(size(Data.Nanoplastics))*2];

% Boxplot
figure(1)
boxplot(Data.TotalData, Data.Group);
title('Olfactory Assay: Buried Food-Seeking Test');
set(gca, 'XTickLabel', {'Saline', 'Nanoplastics'});
xlabel('Group'); ylabel('Food Detection Time [s]');

% Histogram Setup
figure(2)
TotalBins = 18;
[Count.Saline, BinEdge.Saline] = histcounts(Data.Saline, TotalBins);
BinCenter.Saline = (BinEdge.Saline(1:end-1) + BinEdge.Saline(2:end))/2;
[Count.Nanoplastics, BinEdge.Nanoplastics] = histcounts(Data.Nanoplastics, TotalBins);
BinCenter.Nanoplastics = (BinEdge.Nanoplastics(1:end-1) + BinEdge.Nanoplastics(2:end))/2;

t = tiledlayout(2,2);
title(t, "Olfactory Assay: Buried Food-Seeking Test");
xlabel(t, 'Food Detection Time [s]');
ylabel(t, 'Total Mice');
nexttile;
bar(BinCenter.Saline, Count.Saline, "FaceColor", 'Red', 'EdgeColor', 'none');
title("Food Detection: Saline Group");
nexttile;
bar(BinCenter.Nanoplastics, Count.Nanoplastics, "FaceColor", 'Blue', 'EdgeColor', 'none');
title("Food Detection: Nanoplastic Group");
nexttile([1,2]);
bar(BinCenter.Saline, Count.Saline, "FaceColor", 'Red', 'EdgeColor', 'none'); hold on;
bar(BinCenter.Nanoplastics, Count.Nanoplastics, "FaceColor", 'Blue', 'EdgeColor', 'none');
title("Food Detection: All Mice");
hold off;

% BootStrapping
figure(3)
Sample = 100000;
BootStrap.Saline = bootstrp(Sample, @mean, Data.Saline);
[fi.Saline, xi.Saline] = ksdensity(BootStrap.Saline);
BootStrap.Nanoplastic = bootstrp(Sample, @mean, Data.Nanoplastics);
[fi.Nanoplastic, xi.Nanoplastic] = ksdensity(BootStrap.Nanoplastic);

t = tiledlayout(2,2);
title(t, "Olfactory Assay: Buried Food-Seeking Test");
xlabel(t, 'Food Detection Time [s]');
ylabel(t, 'Probability Density');
nexttile;
plot(xi.Saline, fi.Saline);
title("Food Detection: Saline Group");
nexttile;
plot(xi.Saline, fi.Nanoplastic);
title("Food Detection: Nanoplastic Group");
nexttile([1,2]);
plot(xi.Saline, fi.Saline); hold on;
plot(xi.Saline, fi.Nanoplastic);
title("Food Detection: All Mice");
hold off;

%% Results
ConfidenceInterval.Saline = bootci(Sample, @mean, Data.Saline);
ConfidenceInterval.Nanoplastic = bootci(Sample, @mean, Data.Nanoplastic);
AverageDetectionTime.Saline = mean(Data.Saline);
AverageDetectionTime.Nanoplastic = mean(Data.Nanoplastic);
