% This will be used for calibrating the rotational 
% ratemeter. 
clear; clc
% Define constants
omega = 202; 
% Number of datapoints in a cycle of the ratemeter. 
% For example, if the ratemeter is set to a 
% frequency of 0.5 Hz and the datalogger logs 
% at 100 Hz, omega will be 200. 

% Load pitch calibration data. 
pitch_all = importdata('~/Dropbox/BiteBlock/Calibrations/PITCH_CALIBRATION_20110915'); 
cal_data{1} = pitch_all(2e4:2.25e4, 2); 
cal_data{2} = pitch_all(1.33e4:1.55e4, 2); 
cal_data{3} = pitch_all(6e3:8e3, 2); 

% Load roll calibration data. 
roll_all =importdata('~/Dropbox/BiteBlock/Calibrations/ROLL_CALIBRATION_20110915'); 
cal_data{4} = roll_all(4500:6500, 1); 
cal_data{5} = roll_all(1.25e4:1.45e4, 1); 
cal_data{6} = roll_all(2.02e4:2.22e4, 1); 

% Load yaw calibration data. 
% Yaw was saved in three separate files. 
yaw = importdata('~/Dropbox/BiteBlock/Calibrations/YAW_CALIBRATION_20110831_30_DEG_S'); 
cal_data{7} = yaw(1500:3700, 3); 
yaw = importdata('~/Dropbox/BiteBlock/Calibrations/YAW_CALIBRATION_20110831_60_DEG_S'); 
cal_data{8} = yaw(2000:4000, 3); 
yaw = importdata('~/Dropbox/BiteBlock/Calibrations/YAW_CALIBRATION_20110831_120_DEG_S'); 
cal_data{9} = yaw(2.03e4:2.2e4, 3); 


% Obtain initial guesses for sine curve fitting
for i = 1:9
    numCycles(i) = floor(length(cal_data{i}) / omega); 
    for j = 1:numCycles(i)
        cycle = cal_data{i}( (1 + (j - 1) * omega):(1 + j * omega)); 
        maxes{i}(j) = max(cycle); 
        mins{i}(j) = min(cycle); 
        amp{i}(j) = (maxes{i}(j) - mins{i}(j)) / 2; 
        DC{i}(j) = (maxes{i}(j) + mins{i}(j)) / 2; 
        phase{i}(j) = find(cycle == maxes{i}(j), 1, 'first') - omega/4; 
        % use the location of the first max to 
        % generate a guess for the phase. 
        % First max should occur 1/4 of the way 
        % through the cycle. 
    end
    amp_avg(i) = mean(amp{i}); 
    DC_avg(i) = mean(DC{i});    
    phase_avg(i) = mean(phase{i}); 
    
    % make one array with the various numbers 
    % for fitting with fminsearch
    constants(i,:) = [amp_avg(i) DC_avg(i) phase_avg(i)];
end

% Do optimization
for i = 1:9
    coeffs = constants(i,:); 
    X = 1:length(cal_data{i}); 
    Y = cal_data{i}; 
    Y = Y'; 
    coeffs_opt(i, 1:3) = fminsearch(@cal_sine, coeffs, [], omega,  X, Y);
    subplot(3,3,i); 
    plot(X,Y,X, coeffs_opt(i,2)+ coeffs_opt(i,1) * sin((coeffs_opt(i,3) + X) * 2 * pi / omega)); 

end





