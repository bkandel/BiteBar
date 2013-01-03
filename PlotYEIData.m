clear all; close; clc;
%% Read Raw Data
DataFile = '../../Data/DataStats.csv'; 
fid = fopen(DataFile);
RawData = textscan( fid, '%s%f%f%f%f%f%f', 'headerlines', 1, 'delimiter', ','); 
fclose( fid ); 

Data.Filename = RawData{1}; 
Data.MaxXGyro = RawData{2}; 
Data.MaxYGyro = RawData{3}; 
Data.MaxZGyro = RawData{4}; 
Data.PrincipalXFrequency = RawData{5}; 
Data.PrincipalYFrequency = RawData{6}; 
Data.PrincipalZFrequency = RawData{7}; 

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
boxplot(RunFrequencyData, GRun, 'colorgroup', GroupByChannelRun)
title('Principal Frequency for Running'); ylabel('Frequency (Hz)');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/BoxplotPeakFreqsRun.png')

figure(2); 
boxplot(RunGyroData, GRun, 'colorgroup', GroupByChannelRun)
title('Maximum Velocities for Running'); ylabel('Velocity (deg/s)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/BoxplotPeakVelocitiesRun.png')

figure(3); 
boxplot(WalkFrequencyData, GWalk, 'colorgroup', GroupByChannelWalk)
title('Principal Frequency for Walking'); ylabel('Frequency (Hz)');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/BoxplotPeakFreqsWalk.png')

figure(4); 
boxplot(WalkGyroData, GWalk, 'colorgroup', GroupByChannelWalk)
title('Maximum Velocities for Walking'); ylabel('Velocity (deg/s)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/BoxplotPeakVelocitiesWalk.png')

figure(5); 
boxplot(ShakeFrequencyData, GShake, 'colorgroup', GroupByChannelShake)
title('Principal Frequency for Shaking'); ylabel('Frequency (Hz)');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/BoxplotPeakFreqsShake.png')

figure(6); 
boxplot(ShakeGyroData, GShake, 'colorgroup', GroupByChannelShake)
title('Maximum Velocities for Shaking'); ylabel('Velocity (deg/s)'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 7])
print(gcf, '-dpng', '-r150', '../../Figures/BoxplotPeakVelocitiesShake.png')


