clear; clc; format short; format compact;

% Data
Data.Saline = [189, 145, 58, 95, 124, 75, 119, 188, 80, 99, 72, 235, 89, 92, 120, 95, 144, 84, 100, 300];
Data.Nanoplastic = [85, 50, 130, 215, 50, 81, 120, 300, 224, 300, 106, 300, 169, 65, 300, 300, 110, 300, 210];
Data.TotalData = [Data.Saline, Data.Nanoplastic];
Data.Group = [ones(size(Data.Saline)), ones(size(Data.Nanoplastic))*2];

% Boxplot
figure(1)
boxplot(Data.TotalData, Data.Group);
title('Olfactory Assay: Buried Food-Seeking Test');
set(gca, 'XTickLabel', {'Saline', 'Nanoplastic'});
xlabel('Group'); ylabel('Food Detection Time [s]');
hold on;
scatter(ones(size(Data.Saline)), Data.Saline, 50, 'r', 'filled', 'MarkerFaceAlpha', 0.6);
scatter(2 * ones(size(Data.Nanoplastic)), Data.Nanoplastic, 50, 'b', 'filled', 'MarkerFaceAlpha', 0.6);


% Histogram Setup
figure(2)
TotalBins = 18;
[Count.Saline, BinEdge.Saline] = histcounts(Data.Saline, TotalBins);
BinCenter.Saline = (BinEdge.Saline(1:end-1) + BinEdge.Saline(2:end))/2;
[Count.Nanoplastic, BinEdge.Nanoplastic] = histcounts(Data.Nanoplastic, TotalBins);
BinCenter.Nanoplastic = (BinEdge.Nanoplastic(1:end-1) + BinEdge.Nanoplastic(2:end))/2;

t = tiledlayout(2,2);
title(t, "Olfactory Assay: Buried Food-Seeking Test");
xlabel(t, 'Food Detection Time [s]');
ylabel(t, 'Total Mice');
nexttile;
bar(BinCenter.Saline, Count.Saline, "FaceColor", 'Red', 'EdgeColor', 'none');
title("Food Detection: Saline Group");
nexttile;
bar(BinCenter.Nanoplastic, Count.Nanoplastic, "FaceColor", 'Blue', 'EdgeColor', 'none');
title("Food Detection: Nanoplastic Group");
nexttile([1,2]);
bar(BinCenter.Saline, Count.Saline, "FaceColor", 'Red', 'EdgeColor', 'none', 'FaceAlpha', 0.5); hold on;
bar(BinCenter.Nanoplastic, Count.Nanoplastic, "FaceColor", 'Blue', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
title("Food Detection: All Mice");
hold off;

% BootStrapping
figure(3)
Sample = 100000;
BootStrap.Saline = bootstrp(Sample, @mean, Data.Saline);
ConfidenceInterval.Saline = bootci(Sample, @mean, Data.Saline);
AverageDetectionTime.Saline = mean(Data.Saline);
[fi.Saline, xi.Saline] = ksdensity(BootStrap.Saline);
BootStrap.Nanoplastic = bootstrp(Sample, @mean, Data.Nanoplastic);
[fi.Nanoplastic, xi.Nanoplastic] = ksdensity(BootStrap.Nanoplastic);
ConfidenceInterval.Nanoplastic = bootci(Sample, @mean, Data.Nanoplastic);
AverageDetectionTime.Nanoplastic = mean(Data.Nanoplastic);

[Peak.Saline, Location.Saline] = findpeaks(fi.Saline);
[Max.Saline, Index.Saline] = max(Peak.Saline);
[Peak.Nanoplastic, Location.Nanoplastic] = findpeaks(fi.Nanoplastic);
[Max.Nanoplastic, Index.Nanoplastic] = max(Peak.Nanoplastic);

Difference.Observed = AverageDetectionTime.Nanoplastic - AverageDetectionTime.Saline;
Difference.BootStrap = BootStrap.Nanoplastic - BootStrap.Saline;
pValue = mean(abs(Difference.BootStrap) >= abs(Difference.Observed));

t = tiledlayout(2,2);
title(t, "Olfactory Assay: Buried Food-Seeking Test");
xlabel(t, 'Food Detection Time [s]');
ylabel(t, 'Probability Density');
nexttile;
plot(xi.Saline, fi.Saline, "Color", 'Blue');
title("Food Detection: Saline Group");
nexttile;
plot(xi.Nanoplastic, fi.Nanoplastic, "Color", 'Red');
title("Food Detection: Nanoplastic Group");
nexttile([1,2]);
plot(xi.Saline, fi.Saline, "Color", 'Blue'); hold on;
plot(xi.Nanoplastic, fi.Nanoplastic, "Color", 'Red');
title("Food Detection: All Mice");
hold off;

%% Results
fprintf("BootStrap Analysis\n");
fprintf("\tSaline Group:\n");
fprintf("\t\tTotal Sample: %g\n", size(Data.Saline,2));
fprintf("\t\tPeak Probability Density = %0.5f\n", Max.Saline)
fprintf("\t\tFood Detection Time at Peak Probability = %0.2fs\n", xi.Saline(Location.Saline));
fprintf("\t\tConfidence Interval = %0.5fs : %0.5fs\n", ConfidenceInterval.Saline(1), ConfidenceInterval.Saline(2))
fprintf("\tNanoplastic Group:\n");
fprintf("\t\tTotal Sample: %g\n", size(Data.Nanoplastic,2));
fprintf("\t\tPeak Probability Density = %0.5f\n", Max.Nanoplastic)
fprintf("\t\tFood Detection Time at Peak Probability = %0.2fs\n", xi.Nanoplastic(Location.Nanoplastic));
fprintf("\t\tConfidence Interval = %0.5fs : %0.5fs\n", ConfidenceInterval.Nanoplastic(1), ConfidenceInterval.Nanoplastic(2))

fprintf("P-Value: %g", pValue)