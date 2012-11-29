% Calibrate YEI Data with calibration from Tim from August 26.  
close all; clear; clc
CalibrationFile = ...
    strcat('C:\Users\Ben\Dropbox\BiteBlock\Calibrations\Calibration_20120826\', ...
           'RotationCalibration_20120826.xls'); 

       
CalibrationData = xlsread(CalibrationFile);
x = 1:length(CalibrationData); 
plot(x, CalibrationData(:,2), x, CalibrationData(:, 3), x, CalibrationData(:, 4)); 

legend('X', 'Y', 'Z')

XPositive33 = 400:1400; 
XNegative33 = 2100:2900; 
YPositive33 = 3600:4400; 
YNegative33 = 5000:5700; 
ZPositive33 = 7700:8300; 
ZNegative33 = 6600:7300; 

XPositive45 = 1.02e4:1.14e4; 
XNegative45 = 1.18e4:1.28e4; 
YPositive45 = 1.35e4:1.43e4; 
YNegative45 = 1.49e4:1.58e4; 
ZPositive45 = 1.78e4:1.88e4; 
ZNegative45 = 1.63e4:1.71e4; 

DegreesPerSecond = [-270 -200 200 270]';
XValues = [
    mean(CalibrationData(XNegative45, 2)); 
    mean(CalibrationData(XNegative33, 2)); 
    mean(CalibrationData(XPositive33, 2)); 
    mean(CalibrationData(XPositive45, 2)); 
    ]; 
   
YValues = [
    mean(CalibrationData(YNegative45, 3)); 
    mean(CalibrationData(YNegative33, 3)); 
    mean(CalibrationData(YPositive33, 3)); 
    mean(CalibrationData(YPositive45, 3)); 
    ]; 
    
ZValues = [
    mean(CalibrationData(ZNegative45, 4)); 
    mean(CalibrationData(ZNegative33, 4)); 
    mean(CalibrationData(ZPositive33, 4)); 
    mean(CalibrationData(ZPositive45, 4)); 
    ]; 
    
XFit = glmfit(XValues, DegreesPerSecond, 'normal'); 
YFit = glmfit(YValues, DegreesPerSecond, 'normal'); 
ZFit = glmfit(ZValues, DegreesPerSecond, 'normal'); 

save(strcat('C:\Users\Ben\Dropbox\BiteBlock\Calibrations\Calibration_20120826\', ... 
    'Fitted_Values.mat'), 'XFit', 'YFit', 'ZFit')
