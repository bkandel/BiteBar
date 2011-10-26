% Definition file for an analysis run. 

% Constants
sampling_rate = 100; % Hz
Transient_Min_Size = 5; % degs
Transient_Min_Duration = 0.2; % secs

calibration_file = ...
    'C:\Users\Ben\Dropbox\BiteBlock\Calibrations\Calibration_20111010\Calib_20111010_values.mat'; 
Data_Raw{1} = importdata('C:\Users\Ben\Dropbox\BiteBlock\Data\Stairs_20111017_Alex_1.txt'); 