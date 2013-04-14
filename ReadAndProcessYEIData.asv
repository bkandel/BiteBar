clear; clc; close all;
%% Define Constants 
ResampleRate = 500; % Hz
DownsampleFactor = 2; 
NumberOfPointsInMovingAverageFilter = 5; 
MinFrequency = 0.2; 
MaxFrequency = 10;
TimeThreshold = 20; % threshold for transient length in ms
AmplitudeThreshold = 10; % threshold for transient amplitude in deg
OutputFilename = '../../Data/DataStats.csv'; 

%% Read, Calibrate, and Filter Data
YEIDataInformation; 
% returns "data" variable containing data
CalibratedData = ReadAndCalibrateYEIData(data); 
DownsampledData = ...
    InterpolateAndDownsample(CalibratedData, ResampleRate, DownsampleFactor); 
FilteredData = ...
    FilterData(DownsampledData, NumberOfPointsInMovingAverageFilter); 
FilteredData = CalculatePosition(FilteredData); 
FilteredData = CalculateFFT(FilteredData, ResampleRate, DownsampleFactor, ...
    MinFrequency, MaxFrequency); 
FilteredData = FilterFFTData(FilteredData, NumberOfPointsInMovingAverageFilter); 
FilteredData = ...
    CalculateAmplitudes(FilteredData, AmplitudeThreshold, TimeThreshold, ...
    (ResampleRate / DownsampleFactor) ); 

WriteDataStatsToFile(FilteredData, OutputFilename); 