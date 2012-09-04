clear; clc; close all
%% Define Constants and Read Data
ResampleRate = 500; % Hz
DownsampleFactor = 2; 
Directory = ...
    '../../Data/GrossmanTests/GrossmanTests/RunInPlace_20120814_YEI003_1/'; 
fid = fopen(strcat(Directory, 'data1.txt')); 
data = textscan(fid, ...
     '%d%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f', ...
     'Whitespace', ', :', 'HeaderLines', 1); 
%% Calculate Elapsed Time
Hours = data{1}; 
Minutes = data{2}; 
Seconds = data{3}; 
HoursInSeconds = double(Hours * 3600); 
MinutesInSeconds = double(Minutes * 60); 
TimeInSeconds = HoursInSeconds + MinutesInSeconds + Seconds; 
TimeElapsed = TimeInSeconds - TimeInSeconds(1); 
Deltas = diff(TimeElapsed); 
Deltas(end+1) = Deltas(end); 
%plot(Deltas)

% Correct for entries in which the time between entries is 0
NonUniqueTimes = sum(TimeElapsed == circshift(TimeElapsed, 1)); 
while NonUniqueTimes > 0
    TimeElapsed(TimeElapsed == circshift(TimeElapsed, 1)) = ...
        TimeElapsed(TimeElapsed == circshift(TimeElapsed, 1)) + 1e-5; 
    NonUniqueTimes = sum(TimeElapsed == circshift(TimeElapsed, 1)); 
end

%% Interpolate and Downsample
TimeElapsedResampled = 0:(1 / ResampleRate):TimeElapsed(end); 
ResampledXGyro = interp1(TimeElapsed, data{14}, TimeElapsedResampled, ...
    'linear'); 
ResampledYGyro = interp1(TimeElapsed, data{15}, TimeElapsedResampled, ...
    'linear'); 
ResampledZGyro = interp1(TimeElapsed, data{16}, TimeElapsedResampled, ...
    'linear'); 
DownsampledXGyro = decimate(ResampledXGyro, 2); 
DownsampledYGyro = decimate(ResampledYGyro, 2); 
DownsampledZGyro = decimate(ResampledZGyro, 2); 
DownsampledTimeElapsed = ...
    0:(1 /(ResampleRate / DownsampleFactor)):TimeElapsed(end); 
%plot(TimeElapsed, data{14}, TimeElapsedResampled, InterpolatedXGyro); 
%legend('original', 'resampled')

%% Calibrate and Filter
load('..\..\Calibrations\Calibration_20120826\Fitted_Values.mat'); 
CalibratedXGyro = (DownsampledXGyro - XFit(1)) * XFit(2); 
CalibratedYGyro = (DownsampledYGyro - YFit(1)) * YFit(2); 
CalibratedZGyro = (DownsampledZGyro - ZFit(1)) * ZFit(2);

% filter data with five-point moving average filter
a = 1;
b = [1/5 1/5 1/5 1/5 1/5 1/5 ]; 
CalibratedFilteredXGyro = filter(b, a, CalibratedXGyro); 
CalibratedFilteredYGyro = filter(b, a, CalibratedYGyro); 
CalibratedFilteredZGyro = filter(b, a, CalibratedZGyro); 

%% Calculate Position
 
 PositionX = cumtrapz(DownsampledTimeElapsed, CalibratedFilteredXGyro - ...
     mean(CalibratedFilteredXGyro)); 
 PositionY = cumtrapz(DownsampledTimeElapsed, CalibratedFilteredYGyro - ...
     mean(CalibratedFilteredYGyro)); 
 PositionZ = cumtrapz(DownsampledTimeElapsed, CalibratedFilteredZGyro - ...
     mean(CalibratedFilteredZGyro)); 
 
%% Calculate Fourier Transform
[XFrequencyComponent, XFrequencies] = ...
    positiveFFT(PositionX, (ResampleRate / DownsampleFactor)); 
[YFrequencyComponent, YFrequencies] = ...
    positiveFFT(PositionY, (ResampleRate / DownsampleFactor)); 
[ZFrequencyComponent, ZFrequencies] = ...
    positiveFFT(PositionZ, (ResampleRate / DownsampleFactor));
FrequencySelector = 1:length(XFrequencies); 
FrequencySelector = FrequencySelector((XFrequencies >= 0.2) & (XFrequencies < 10)); 
FrequenciesOfInterest = XFrequencies(FrequencySelector); 
XFrequencyComponentOfInterest = XFrequencyComponent(FrequencySelector); 
YFrequencyComponentOfInterest = YFrequencyComponent(FrequencySelector); 
ZFrequencyComponentOfInterest = ZFrequencyComponent(FrequencySelector); 


%% Plotting
plot(TimeElapsed, data{14}, DownsampledTimeElapsed, DownsampledXGyro); 
legend('raw', 'downsampled')

figure(1); 
plot(DownsampledTimeElapsed, CalibratedFilteredXGyro, ...
     DownsampledTimeElapsed, CalibratedFilteredYGyro, ...
     DownsampledTimeElapsed, CalibratedFilteredZGyro)
 legend('Roll', 'Pitch', 'Yaw')
 title('Calibrated and Filtered Velocity Recordings vs. Time')

 figure(2); 
 plot(DownsampledTimeElapsed, PositionX, ...
     DownsampledTimeElapsed, PositionY, ...
     DownsampledTimeElapsed, PositionZ)
 
 %{
 figure(3); 
 plot(DownsampledTimeElapsed, CalibratedFilteredXGyro, ...
     DownsampledTimeElapsed, CalibratedXGyro); 
 legend('Filtered', 'Unfiltered')
%}
 
 figure(4); 
 plot(FrequenciesOfInterest, abs(XFrequencyComponentOfInterest), ...
      FrequenciesOfInterest, abs(YFrequencyComponentOfInterest), ...
      FrequenciesOfInterest, abs(ZFrequencyComponentOfInterest))
  legend('Roll', 'Pitch', 'Yaw')