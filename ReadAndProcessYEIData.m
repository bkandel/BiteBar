clear; clc; close all
Directory = ...
    '../../Data/GrossmanTests/GrossmanTests/RunInPlace_20120814_YEI003_1/'; 
fid = fopen(strcat(Directory, 'data1.txt')); 
data = textscan(fid, ...
     '%d%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f', ...
     'Whitespace', ', :', 'HeaderLines', 1); 
 
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


load('..\..\Calibrations\Calibration_20120826\Fitted_Values.mat'); 

% interpolate and downsample
TimeElapsedResampled = 0:(1 / 500):TimeElapsed(end); 
ResampledXGyro = interp1(TimeElapsed, data{14}, TimeElapsedResampled, ...
    'linear'); 
ResampledYGyro = interp1(TimeElapsed, data{15}, TimeElapsedResampled, ...
    'linear'); 
ResampledZGyro = interp1(TimeElapsed, data{16}, TimeElapsedResampled, ...
    'linear'); 
DownsampledXGyro = decimate(ResampledXGyro, 2); 
DownsampledYGyro = decimate(ResampledYGyro, 2); 
DownsampledZGyro = decimate(ResampledZGyro, 2); 
%plot(TimeElapsed, data{14}, TimeElapsedResampled, InterpolatedXGyro); 
%legend('original', 'resampled')

CalibratedXGyro = (DownsampledXGyro - XFit(1)) * XFit(2); 
CalibratedYGyro = (DownsampledYGyro - YFit(1)) * YFit(2); 
CalibratedZGyro = (DownsampledZGyro - ZFit(1)) * ZFit(2); 
DownsampledTimeElapsed = 1:(1 / 200):(length(DownsampledXGyro / 200)); 
% filter data with five-point moving average filter
a = 1;
b = [1/5 1/5 1/5 1/5 1/5]; 
CalibratedFilteredXGyro = filter(b, a, CalibratedXGyro); 
CalibratedFilteredYGyro = filter(b, a, CalibratedYGyro); 
CalibratedFilteredZGyro = filter(b, a, CalibratedZGyro); 
figure(1); 
plot(TimeElapsed, CalibratedFilteredXGyro, ...
     TimeElapsed, CalibratedFilteredYGyro, ...
     TimeElapsed, CalibratedFilteredZGyro)
 legend('Roll', 'Pitch', 'Yaw')
 
 PositionX = cumtrapz(TimeElapsed, CalibratedFilteredXGyro - ...
     mean(CalibratedFilteredXGyro)); 
 PositionY = cumtrapz(TimeElapsed, CalibratedFilteredYGyro - ...
     mean(CalibratedFilteredYGyro)); 
 PositionZ = cumtrapz(TimeElapsed, CalibratedFilteredZGyro - ...
     mean(CalibratedFilteredZGyro)); 
 figure(2); 
 plot(TimeElapsed, PositionX, TimeElapsed, PositionY, TimeElapsed, PositionZ)
 
 figure(3); 
 plot(TimeElapsed, CalibratedFilteredXGyro, TimeElapsed, CalibratedXGyro); 
 legend('Filtered', 'Unfiltered')