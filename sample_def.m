% Sample definition file for calibrations. 

Sampling_Rate = 100; % datalogger sampling rate in Hz
Chair_Freq = 0.1; % frequency of chair
omega_init = Sampling_Rate / Chair_Freq; 
% length of chair cycle in datapoints 

Freqs = [600 450 300 200 100 50 25]; 
% frequencies of chair turns

Roll_File = '~/Dropbox/BiteBlock/Calibrations/Calibration_20111010/Roll600_450_300_200_100_50_25_DegPerS_0point1_Hz_1.txt'; 
Pitch_File =  '~/Dropbox/BiteBlock/Calibrations/Calibration_20111010/Pitch600_450_300_200_100_500_50_25_DegPerS_0point1_Hz_1.txt';
Yaw_File = '~/Dropbox/BiteBlock/Calibrations/Calibration_20111010/Yaw600_450_300_200_100_50_25_DegPerS_0point1_Hz_1.txt';

Roll_Data = importdata(Roll_File); 
Pitch_Data = importdata(Pitch_File); 
Yaw_Data = importdata(Yaw_File); 

% Get roll data
cal_data{1} = Roll_Data(7800:9400, 1); % 600 deg/s
cal_data{2} = Roll_Data(1.64e4:1.78e4, 1); % 450 deg/s
cal_data{3} = Roll_Data(2.48e4:2.62e4, 1); % 300 deg/s
cal_data{4} = Roll_Data(3.34e4:3.48e4, 1); % 200 deg/s
cal_data{5} = Roll_Data(4.2e4:4.36e4, 1); % 100 deg/s
cal_data{6} = Roll_Data(5.06e4:5.22e4, 1); % 50 deg/s
cal_data{7} = Roll_Data(5.9e4:6.05e4, 1); % 25 deg/s

% Get pitch data

cal_data{8} = Pitch_Data(7700:8900, 2); % 600 deg/s
cal_data{9} = Pitch_Data(1.65e4:1.8e4, 2); % 450 deg/s
cal_data{10} = Pitch_Data(2.52e4:2.66e4, 2); % 300 deg/s
cal_data{11} = Pitch_Data(3.38e4:3.5e4, 2); % 200 deg/s
cal_data{12} = Pitch_Data(4.34e4:4.46e4, 2); % 100 deg/s
cal_data{13} = Pitch_Data(6.1e4:6.22e4, 2); % 50 deg/s
cal_data{14} = Pitch_Data(6.94e4:7.12e4, 2); % 25 deg/s

% Get yaw data

cal_data{15} = Yaw_Data(4500:6100, 3); % 600 deg/s
cal_data{16} = Yaw_Data(1.34e4:1.49e4, 3); % 450 deg/s
cal_data{17} = Yaw_Data(2.18e4:2.32e4, 3); % 300 deg/s
cal_data{18} = Yaw_Data(3.2e4:3.34e4, 3); % 200 deg/s
cal_data{19} = Yaw_Data(4.08e4:4.22e4, 3); % 100 deg/s
cal_data{20} = Yaw_Data(4.9e4:5.05e4, 3); % 50 deg/s
cal_data{21} = Yaw_Data(5.74e4:5.86e4, 3); % 25 deg/s
