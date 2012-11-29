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
% Select times of interest
TimeSelector = 1:length(TimeElapsed); 
TimeSelector = TimeSelector((TimeElapsed > 5) & (TimeElapsed < 60)); 
TimeElapsedOfInterest = TimeElapsed(TimeSelector); 
TimeElapsedOfInterest = TimeElapsedOfInterest - TimeElapsedOfInterest(1); 

%% Interpolate and Downsample
TimeElapsedResampledOfInterest = ...
    0:(1 / ResampleRate):TimeElapsedOfInterest(end); 
ResampledXGyro = interp1(TimeElapsedOfInterest, data{14}(TimeSelector), ...
    TimeElapsedResampledOfInterest, 'linear'); 
ResampledYGyro = interp1(TimeElapsedOfInterest, data{15}(TimeSelector), ...
    TimeElapsedResampledOfInterest, 'linear'); 
ResampledZGyro = interp1(TimeElapsedOfInterest, data{16}(TimeSelector), ...
    TimeElapsedResampledOfInterest, 'linear'); 
DownsampledXGyro = decimate(ResampledXGyro, 2); 
DownsampledYGyro = decimate(ResampledYGyro, 2); 
DownsampledZGyro = decimate(ResampledZGyro, 2); 
DownsampledTimeElapsedOfInterest = ...
    0:(1 /(ResampleRate / DownsampleFactor)):TimeElapsedOfInterest(end); 
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
 
 PositionX = cumtrapz(DownsampledTimeElapsedOfInterest, CalibratedFilteredXGyro - ...
     mean(CalibratedFilteredXGyro)); 
 PositionY = cumtrapz(DownsampledTimeElapsedOfInterest, CalibratedFilteredYGyro - ...
     mean(CalibratedFilteredYGyro)); 
 PositionZ = cumtrapz(DownsampledTimeElapsedOfInterest, CalibratedFilteredZGyro - ...
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
%{
plot(TimeElapsedOfInterest, data{14}(TimeSelector), ...
    DownsampledTimeElapsedOfInterest, DownsampledXGyro); 
legend('raw', 'downsampled')
%}
figure(1); 
plot(DownsampledTimeElapsedOfInterest, CalibratedFilteredXGyro, ...
     DownsampledTimeElapsedOfInterest, CalibratedFilteredYGyro, ...
     DownsampledTimeElapsedOfInterest, CalibratedFilteredZGyro)
 legend('Roll', 'Pitch', 'Yaw')
 title('Calibrated and Filtered Velocity Recordings vs. Time')
 xlabel('Elapsed time (s)'); ylabel('Deg/s')
 saveas(gcf, '..\..\Figures\Grossman_Tests\Velocity.png')

 figure(2); 
 plot(DownsampledTimeElapsedOfInterest, PositionX, ...
     DownsampledTimeElapsedOfInterest, PositionY, ...
     DownsampledTimeElapsedOfInterest, PositionZ)
 title('Position vs. Time'); 
 xlabel('Elapsed Time (s)'); ylabel('Change in position (deg)'); 
  saveas(gcf, '..\..\Figures\Grossman_Tests\Position.png')

 
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
  title('Frequency Component'); 
  xlabel('Hz'); ylabel('Magnitude');
   saveas(gcf, '..\..\Figures\Grossman_Tests\Frequency.png')