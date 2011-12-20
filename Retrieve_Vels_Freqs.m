% This mfile will be used to do the basic analysis
% of the raw data. 
clear; clc; close all; 

%% Define Constants
Min_Magnitude = 10; 
% Only analyze transients that generated a 
% changein position of 10 degs. 
Min_Duration = 20; % ms
transLengthPadded = 10; % sec
% We will pad and window the transients so that 
% they have a total length of 10 seconds
padLength = 5; % sec
% We will zero-pad the transients for five seconds
pctCutoff = 0.99; % cutoff for bandwidth is 99%


run('C:\Users\Ben\Dropbox\BiteBlock\Data\Data_Def.m'); 

load(calibration_file); 
correction_amp = amp_fit.^(-1); 
% We need to divide by the slope of the 
% amplitude fit to convert the raw measurements
% to deg / s. 
Min_Length = Min_Duration * sampling_rate / 1000; 
% minimum number of indices in a transient to include

%% Convert to deg/s. 
[Data_Calib, Position] = CalibrateRawData(Data_Raw, DC_fit, ...
    sampling_rate, correction_amp); 


%% Find indices where tracing switches direction

[transient_pos, transient_vel, numTransients] = RetrieveTransients(Data_Calib, ...
    Position, Min_Magnitude, Min_Length);
%% Do frequency analysis
trans_pos_pwrCutoff = retrievePctPwr(Data_Calib, numTransients, ...
    transient_pos, sampling_rate, transLengthPadded, padLength, pctCutoff);

%% Retrieve max velocities
max_vels = retrieveMaxVels(Data_Calib, transient_vel, ...
    numTransients); 

%% Plot results
names{1} = 'Roll'; 
names{2} = 'Pitch'; 
names{3} = 'Yaw'; 

figure(1); 

for i = 1:length(Data_Calib)
    for j = 1:3
        subplot(i,3,j); 
        freq_hist{i,j} = histc(trans_pos_pwrCutoff{i,j}, 0:1.5:20) / ...
            length(trans_pos_pwrCutoff{i,j}); 
        bar(0:1.5:20, freq_hist{i,j}); axis([0 20 0 0.3]); 
        title(names{j}); xlabel('Frequency'); ylabel('Percent Transients'); 
    end
end

figure(2); 

for i = 1:length(Data_Calib)
    for j = 1:3
        subplot(i,3,j); 
        vel_hist{i,j} = histc(max_vels{i,j}, 0:75:600) / ... 
            length(max_vels{i,j}); 
        bar(0:75:600, vel_hist{i,j}); axis([0 650 0 0.5]); 
        title(names{j}); xlabel('Max Velocity'); 
        ylabel('Percent Transients'); 
    end
end

        

