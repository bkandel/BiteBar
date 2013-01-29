clear; clc; close all;
%% Define Constants 
ResampleRate = 500; % Hz
DownsampleFactor = 2; 
NumberOfPointsInMovingAverageFilter = 5; 
MinFrequency = 0.2; 
MaxFrequency = 10; 
OutputFilename = '../../Data/DataStats.csv'; 

%% Read, Calibrate, and Filter Data
YEIDataInformation; 
% returns "data" variable containing data
CalibratedData = ReadAndCalibrateYEIData(data);
RotatedData = RotateYEIData(CalibratedData); 
DownsampledData = ...
    InterpolateAndDownsample(RotatedData, ResampleRate, DownsampleFactor); 
FilteredData = ...
    FilterData(DownsampledData, NumberOfPointsInMovingAverageFilter); 
FilteredData = CalculatePosition(FilteredData); 
FilteredData = CalculateFFT(FilteredData, ResampleRate, DownsampleFactor, ...
    MinFrequency, MaxFrequency); 
FilteredData = FilterFFTData(FilteredData, NumberOfPointsInMovingAverageFilter); 
FilteredData = CalculateAmplitudes(FilteredData); 

%WriteDataStatsToFile(FilteredData, OutputFilename); 