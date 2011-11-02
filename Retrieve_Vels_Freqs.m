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
% Pad and cosine window transients
names{1} = 'Roll'; 
names{2} = 'Pitch'; 
names{3} = 'Yaw'; 

figure(1); 
% This stretch of code is very sloppy--needs to 
% be better documented, etc.
for i = 1:length(Data_Calib)
    for j = 1:3
        for k = 1:(numTransients(i,j) - 1) % m-1 is number of significant transients
            trans_pos_pad{i,j}{k} = CosinePad(transient_pos{i,j}{k}, ...
                sampling_rate, transLengthPadded, padLength); 
            [trans_pos_fft{i,j}{k}, freq_indices{i,j}{k}] = positiveFFT(trans_pos_pad{i,j}{k}, sampling_rate);
            trans_pos_fft{i,j}{k} = abs(trans_pos_fft{i,j}{k}); 
            trans_pos_pwr{i,j}{k} = cumtrapz(trans_pos_fft{i,j}{k}); 
            trans_pos_pctpwr{i,j}{k} = trans_pos_pwr{i,j}{k}(:) / trans_pos_pwr{i,j}{k}(end); 
            index = find(trans_pos_pctpwr{i,j}{k} > 0.99); 
            trans_pos_99pctpwr{i,j}(k) = freq_indices{i,j}{k}(index(1)); 
        end
        subplot(i,3,j); 
        freq_hist{i,j} = histc(trans_pos_99pctpwr{i,j}, 0:1.5:20) / length(trans_pos_99pctpwr{i,j}); 
        bar(0:1.5:20, freq_hist{i,j}); axis([0 20 0 0.3]); 
        title(names{j}); xlabel('Frequency'); ylabel('Percent Transients'); 
    end
end

%% Retrieve max velocities
figure(2); 
for i = 1:length(Data_Calib)
    for j = 1:3
        for k = 1:(numTransients(i,j) - 1) % as before
            max_vels{i,j}(k) = max(abs(transient_vel{i,j}{k})); 
        end
        subplot(i,3,j); vel_hist{i,j} = histc(max_vels{i,j}, 0:75:600) / length(max_vels{i,j}); 
        bar(0:75:600, vel_hist{i,j}); axis([0 650 0 0.5]); 
        title(names{j}); xlabel('Max Velocity'); 
        ylabel('Percent Transients'); 
    end
end

        
