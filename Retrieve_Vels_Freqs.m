% This mfile will be used to do the basic analysis
% of the raw data. 
clear; clc; close all; 

%% Define Constants
Min_Magnitude = 10; 
% Only analyze transients that generated a 
% changein position of 5 degs. 
Min_Duration = 20; % ms
transLengthPadded = 10; 
% We will pad and window the transients so that 
% they have a total length of 10 seconds
padLength = 5; 
% We will zero-pad the transients for five seconds


run('~/Dropbox/BiteBlock/Data/Data_Def.m'); 

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
                % from zero position
                transient_pos{i,j}{m(j)}(:) =...
                    transient_pos{i,j}{m(j)}(:) - transient_pos{i,j}{m(j)}(1); 
                % Retrieve velocity transients, too. 
                transient_vel{i,j}{m(j)} = Data_Calib{i}(shift_indices{i,j}(k):shift_indices{i,j}(k+1), j);
                m(j) = m(j) + 1; 
            end
        end
    end
end


%% Do frequency analysis
% Pad and cosine window transients
for i = 1:length(Data_Calib)
    for j = 1:3
        for k = 1:(m(j) - 1) % m-1 is number of significant transients
            trans_pos_pad{i,j}{k} = CosinePad(transient_pos{i,j}{k}, ...
                sampling_rate, transLengthPadded, padLength); 
        end
    end
end





