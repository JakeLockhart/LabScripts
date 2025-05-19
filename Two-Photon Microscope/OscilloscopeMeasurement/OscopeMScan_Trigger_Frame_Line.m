clear; clc; format short g; format compact;
addpath('C:\Workspace\LabScripts\Functions')
Lookup = FileLookup('csv', 'all');
Oscope = ReadOscope(Lookup);

PlotNames = ["Frame Trigger & Line Trigger Alignment", "Trigger Pulse", "Gibbs Phenomenon", "rising/Falling Ringing"];
TimeScales = ["Time [2.5ms]", "Time [50\mus]", "Time [2.5\mus]", "Time [500ns]"];

figure()
t = tiledlayout(4,2);
title(t, "MScan Triggers, Gibbs Phenomenon, FOV", "Color", "White");
set(gcf, "Color", [0, 0, 0]);

nexttile(1)
    hold on;
    title("128x512 Pixel FOV", "Color", "White")
    set(gca, "Color", [0, 0, 0])
    set(gca, "XColor", "White", "YColor", "White");
    xlabel(TimeScales(1))
    axis tight;
    plot(Oscope.Time(4,:), Oscope.Voltage(4,:), "Color", "Red")
    plot(Oscope.Time(3,:), Oscope.Voltage(3,:), "Color", "Blue")
nexttile(2)
    hold on;
    title("512x512 Pixel FOV", "Color", "White")
    set(gca, "Color", [0, 0, 0])
    set(gca, "XColor", "White", "YColor", "White");
    xlabel(TimeScales(1))
    axis tight;
    plot(Oscope.Time(18,:), Oscope.Voltage(18,:), "Color", "Red")
    plot(Oscope.Time(17,:), Oscope.Voltage(17,:), "Color", "Blue")
nexttile(3)
    hold on;
    title("Pulses", "Color", "White")
    set(gca, "Color", [0, 0, 0])
    set(gca, "XColor", "White", "YColor", "White");
    xlabel(TimeScales(2))
    axis tight;
    plot(Oscope.Time(8,:), Oscope.Voltage(8,:), "Color", "Red")
    plot(Oscope.Time(7,:), Oscope.Voltage(7,:), "Color", "Blue")
nexttile(4)
    hold on;
    title("Pulses", "Color", "White")
    set(gca, "Color", [0, 0, 0])
    set(gca, "XColor", "White", "YColor", "White");
    xlabel(TimeScales(2))
    axis tight;
    plot(Oscope.Time(22,:), Oscope.Voltage(22,:), "Color", "Red")
    plot(Oscope.Time(21,:), Oscope.Voltage(21,:), "Color", "Blue")
nexttile(5, [1,2])
    hold on;
    title("Gibbs Phenomenon", "Color", "White")
    set(gca, "Color", [0, 0, 0])
    set(gca, "XColor", "White", "YColor", "White");
    xlabel(TimeScales(3))
    axis tight;
    plot(Oscope.Time(28,:), Oscope.Voltage(28,:), "Color", "Green")
nexttile(7, [1,2])
    hold on;
    title("Over/Under Shoot Ringing", "Color", "White")
    set(gca, "Color", [0, 0, 0])
    set(gca, "XColor", "White", "YColor", "White");
    xlabel(TimeScales(4))
    axis tight;
    plot(Oscope.Time(24,:), Oscope.Voltage(24,:), "Color", "Green")
    plot(Oscope.Time(26,:), Oscope.Voltage(26,:), "Color", "Green")
