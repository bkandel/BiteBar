clear all; close; clc;
%% Read Raw Data
DataFile = '../../Data/DataStats.csv'; 
fid = fopen(DataFile);
RawData = textscan( fid, '%s%d%f%f%f%f%f%f%f%f%f%f%f%f', ...
    'headerlines', 1, 'delimiter', ','); 
fclose( fid ); 

Data.Filename            = RawData{1};
Data.Run                 = RawData{2}; 
Data.MaxXGyro            = RawData{3}; 
Data.MaxYGyro            = RawData{4}; 
Data.MaxZGyro            = RawData{5}; 
Data.PrincipalXFrequency = RawData{6}; 
Data.PrincipalYFrequency = RawData{7}; 
Data.PrincipalZFrequency = RawData{8}; 
Data.MaxXAmplitude       = RawData{9}; 
Data.MaxYAmplitude       = RawData{10}; 
Data.MaxZAmplitude       = RawData{11}; 
Data.MedianXAmplitude    = RawData{12}; 
Data.MedianYAmplitude    = RawData{13};
Data.MedianZAmplitude    = RawData{14}; 

Indices = 1:length(Data.Filename); 
SortDataByTrial; % define where to find data

%% Prepare data for plotting
GetYEIDataForPlotting; 

%% Define grouping variables
RunTrialLengths = [RunConcreteShoesLength RunInPlaceLength RunGrassShoesLength]; 
RunTrialNames = {'RunConcreteShoes', 'RunInPlace', 'RunGrassShoes'}; 
[GroupByTrialRun, GroupByChannelRun] = ...
    GenerateGroupVariables(RunFrequencyData, ...
    RunTrialNames, RunTrialLengths);
GRun           = cell(1:length(GroupByTrialRun), 2); 
GRun{1:end, 2} = GroupByTrialRun; 
GRun{1:end, 1} = GroupByChannelRun; 

WalkTrialLengths = ...
    [WalkConcreteShoesLength WalkInPlaceLength WalkGrassShoesLength]; 
WalkTrialNames = {'WalkConcreteShoes', 'WalkInPlace', 'WalkGrassShoes'}; 
[GroupByTrialWalk, GroupByChannelWalk] = ...
    GenerateGroupVariables(WalkFrequencyData, WalkTrialNames, WalkTrialLengths); 
GWalk       = cell(1:length(GroupByTrialWalk), 2); 
GWalk{1:end, 2} = GroupByTrialWalk; 
GWalk{1:end, 1} = GroupByChannelWalk; 

ShakeTrialLengths = [HorizontalShakeLength VerticalShakeLength]; 
ShakeTrialNames = {'HorizontalShake', 'VerticalShake'}; 
[GroupByTrialShake, GroupByChannelShake] = ...
    GenerateGroupVariables(ShakeFrequencyData, ShakeTrialNames, ...
    ShakeTrialLengths); 
GShake = cell(1:length(GroupByTrialShake), 2); 
GShake{1:end, 2} = GroupByTrialShake; 
GShake{1:end, 1} = GroupByChannelShake; 

%% Plot
screen_size = get(0, 'ScreenSize');
figure(1); 
BoxPlotFigure = boxplot(RunFrequencyData, GRun, 'colorgroup', GroupByChannelRun);
set(BoxPlotFigure(:, :), 'linewidth', 2); 
title('Principal Frequency for Running'); ylabel('Frequency (Hz)');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotPeakFreqsRun.png')

figure(2); 
BoxPlotFigure = boxplot(RunGyroData, GRun, 'colorgroup', GroupByChannelRun); 
set(BoxPlotFigure(:, :), 'LineWidth', 2); 
title('Maximum Velocities for Running'); ylabel('Velocity (deg/s)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotPeakVelocitiesRun.png')

figure(3); 
BoxPlotFigure = ...
    boxplot(RunMaxAmplitudeData, GRun, 'colorgroup', GroupByChannelRun);
set(BoxPlotFigure(:, :), 'linewidth', 2); 
title('Maximum Amplitudes for Running'); ylabel('Amplitude (deg)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotMaxAmplitudeRun.png')

figure(4); 
BoxPlotFigure = ...
    boxplot(RunMedianAmplitudeData, GRun, 'colorgroup', GroupByChannelRun); 
set(BoxPlotFigure(:, :), 'linewidth', 2); 
title('Median Amplitudes for Running'); ylabel('Amplitude (deg)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotMedianAmplitudeRun.png')

figure(5); 
BoxPlotFigure = ...
    boxplot(WalkFrequencyData, GWalk, 'colorgroup', GroupByChannelWalk); 
set(BoxPlotFigure(:, :), 'linewidth', 2); 
title('Principal Frequency for Walking'); ylabel('Frequency (Hz)');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotPeakFreqsWalk.png')

figure(6); 
BoxPlotFigure = boxplot(WalkGyroData, GWalk, 'colorgroup', GroupByChannelWalk); 
set(BoxPlotFigure(:, :), 'linewidth', 2); 
title('Maximum Velocities for Walking'); ylabel('Velocity (deg/s)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotPeakVelocitiesWalk.png')

figure(7); 
BoxPlotFigure = ...
    boxplot(WalkMaxAmplitudeData, GWalk, 'colorgroup', GroupByChannelWalk);
set(BoxPlotFigure(:, :), 'linewidth', 2);
title('Maximum Amplitudes for Walking'); ylabel('Amplitude (deg)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotMaxAmplitudeWalk.png')

figure(8); 
BoxPlotFigure = ...
    boxplot(WalkMedianAmplitudeData, GWalk, 'colorgroup', GroupByChannelWalk); 
set(BoxPlotFigure(:, :), 'linewidth', 2);
title('Median Amplitudes for Walking'); ylabel('Amplitude (deg)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotMedianAmplitudeWalk.png')

figure(9); 
BoxPlotFigure = ...
    boxplot(ShakeFrequencyData, GShake, 'colorgroup', GroupByChannelShake); 
set(BoxPlotFigure(:, :), 'linewidth', 2);
title('Principal Frequency for Shaking'); ylabel('Frequency (Hz)');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotPeakFreqsShake.png')

figure(10); 
BoxPlotFigure = ...
    boxplot(ShakeGyroData, GShake, 'colorgroup', GroupByChannelShake); 
set(BoxPlotFigure(:, :), 'linewidth', 2);
title('Maximum Velocities for Shaking'); ylabel('Velocity (deg/s)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotPeakVelocitiesShake.png')

figure(11); 
BoxPlotFigure = ...
    boxplot(ShakeMaxAmplitudeData, GShake, 'colorgroup', GroupByChannelShake);
set(BoxPlotFigure(:, :), 'linewidth', 2);
title('Maximum Amplitudes for Shaking'); ylabel('Amplitude (deg)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/YEIPlots/BoxplotMaxAmplitudeShake.png')

figure(12); 
BoxPlotFigure = ...
    boxplot(ShakeMedianAmplitudeData, GShake, 'colorgroup', GroupByChannelShake); 
set(BoxPlotFigure(:, :), 'linewidth', 2);
title('Median Amplitudes for Shaking'); ylabel('Amplitude (deg)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', ...
    '../../Figures/YEIPlots/BoxplotMedianAmplitudeShake.png')


