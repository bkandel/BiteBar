% This mfile will be used to do the basic analysis
% of the raw data. 
clear; clc; close all; 

%% Define Constants
Min_Magnitude = 10; 
% Only analyze transients that generated a 
% changein position of 10 degs. 
Min_Duration = 20; % ms
transLengthPadded = 10; 
% We will pad and window the transients so that 
% they have a total length of 10 seconds
padLength = 5; 
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
for i = 1:length(Data_Raw)
    % add smoothing
    for  j= 1:3
        Data_Calib{i}(:,j) = ((Data_Raw{i}(:,j) - DC_fit(j))) * correction_amp(j); 
         % Integrate velocity to get position
         Position{i}(:,j) = sampling_rate^(-1) * cumtrapz(Data_Calib{i}(:,j)); 
    end
end

%% Find indices where tracing switches direction
for i = 1:length(Data_Calib)
    for j = 1:3
        shifts{i,j} = xor((Data_Calib{i}(:,j) > 0), circshift((Data_Calib{i}(:,j) > 0), 1)); 
        shifts{i,j}(1) = 0; 
        shift_indices{i,j} = find(shifts{i,j} == 1); 
    end
end

% Create matrix that records the change in 
% position between each time the velocity 
% switches direction. 
for i = 1:length(Data_Calib)
    for j = 1:3
        for k = 1:(length(shift_indices{i,j}) - 1)
            trans_mags{i,j}(k) = abs(Position{i}(shift_indices{i,j}(k+1), j) - ...
                Position{i}(shift_indices{i,j}(k), j)); 
            trans_lengths{i,j}(k) = shift_indices{i,j}(k+1) - ...
                shift_indices{i,j}(k); 
        end
    end
end

%% Retrieve transients
% that meet length and magnitude criteria
for i = 1:length(Data_Calib)
    for j = 1:3
        m(j) = 1; 
        for k = 1:(length(shift_indices{i,j}) - 1)
            if (trans_mags{i,j}(k) > Min_Magnitude && trans_lengths{i,j}(k) > Min_Length)
                transient_pos{i,j}{m(j)} = Position{i}(shift_indices{i,j}(k):shift_indices{i,j}(k+1), j); 
                % Zero all positions so that they start
                % from zero position. 
                % Take absolute value--we don't need
                % negative values. 
                transient_pos{i,j}{m(j)}(:) =...
                    abs(transient_pos{i,j}{m(j)}(:) - transient_pos{i,j}{m(j)}(1)); 
                % Retrieve velocity transients, too. 
                transient_vel{i,j}{m(j)} = Data_Calib{i}(shift_indices{i,j}(k):shift_indices{i,j}(k+1), j);
                m(j) = m(j) + 1; 
            end
        end
    end
end


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
        for k = 1:(m(j) - 1) % m-1 is number of significant transients
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
        for k = 1:(m(j) - 1) % as before
            max_vels{i,j}(k) = max(abs(transient_vel{i,j}{k})); 
        end
        subplot(i,3,j); vel_hist{i,j} = histc(max_vels{i,j}, 0:75:600) / length(max_vels{i,j}); 
        bar(0:75:600, vel_hist{i,j}); axis([0 650 0 0.5]); 
        title(names{j}); xlabel('Max Velocity'); 
        ylabel('Percent Transients'); 
    end
end

        

