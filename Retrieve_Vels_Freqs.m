% This mfile will be used to do the basic analysis
% of the raw data. 
clear; clc; close all; 

%% Define Constants
Min_Magnitude = 5; 
% Only analyze transients that generated a 
% changein position of 10 degs. 
Min_Duration = 20; % ms
transLengthPadded = 10; % sec
% We will pad and window the transients so that 
% they have a total length of 10 seconds
padLength = 5; % sec
% We will zero-pad the transients for five seconds
pctCutoff = 0.99; % cutoff for bandwidth is 99%


run(strcat('C:\Users\Ben\Dropbox\BiteBlock\Data\', ...
    'Parkour\Parkour_20120202_G1_def.m')); 

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
run_names{1} = 'Walk'; 
run_names{2} = 'Obstacles'; 
run_names{3} = 'Chase'; 
run_names{4} = 'Run-Jump';


names{1} = 'Pitch'; 
names{2} = 'Roll'; % edit--february 9: changed order of channels, as per Alex
names{3} = 'Yaw'; 


for i = 1:length(Data_Calib)
    fullscreen = get(0,'ScreenSize');
    figure('Position',[0 -50 fullscreen(3) fullscreen(4)])
    for j = 1:3
        subplot(3,1,j); 
        freq_hist{i,j} = histc(trans_pos_pwrCutoff{i,j}, 0:3:30) / ...
            length(trans_pos_pwrCutoff{i,j}); 
        bar(0:3:30, freq_hist{i,j}); axis([0 30 0 0.6]); 
        title(names{j}); xlabel('Frequency'); ylabel('Proportion Transients'); 
    end
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1], 'Box', ...
        'off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,run_names{i},'HorizontalAlignment', ...
        'center','VerticalAlignment', 'top')
    file_name = strcat('C:\Users\Ben\Dropbox\BiteBlock\Figures\Parkour\', ...
        run_names{i}, '_Freqs.png'); 
    saveas(gcf, file_name); 
    close
end


for i = 1:length(Data_Calib)
    fullscreen = get(0,'ScreenSize');
    figure('Position',[0 -50 fullscreen(3) fullscreen(4)])
    for j = 1:3
        subplot(3,1,j); 
        vel_hist{i,j} = histc(max_vels{i,j}, 0:100:800) / ... 
            length(max_vels{i,j}); 
        bar(0:100:800, vel_hist{i,j}); axis([0 800 0 0.9]); 
        title(names{j}); xlabel('Max Velocity'); 
        ylabel('Proportion Transients'); 
    end
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1], 'Box', ...
        'off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,run_names{i},'HorizontalAlignment', ...
        'center','VerticalAlignment', 'top')
     file_name = strcat('C:\Users\Ben\Dropbox\BiteBlock\Figures\Parkour\', ...
        run_names{i}, '_Vels.png'); 
    saveas(gcf, file_name); 
    close
end

        

