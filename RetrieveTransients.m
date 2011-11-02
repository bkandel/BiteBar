function [transient_pos, transient_vel, numTransients] = RetrieveTransients(Data_Calib, ...
    Position, Min_Magnitude, Min_Length)
% This function will retrieve the transients that meet the length and
% magnitude criteria defined in the constants. 

for i = 1:length(Data_Calib)
    for j = 1:3
        shifts{i,j} = xor((Data_Calib{i}(:,j) > 0), circshift((Data_Calib{i}(:,j) > 0), 1)); 
        shifts{i,j}(1) = 0; 
        shift_indices{i,j} = find(shifts{i,j} == 1); 
    end
end

% Create matrix that records the change in % position between each time the
% velocity switches direction. 
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

%% Retrieve transients that meet length and magnitude criteria
for i = 1:length(Data_Calib)
    for j = 1:3
        numTransients(i,j) = 1; 
        for k = 1:(length(shift_indices{i,j}) - 1)
            if (trans_mags{i,j}(k) > Min_Magnitude && trans_lengths{i,j}(k) > Min_Length)
                transient_pos{i,j}{numTransients(i,j)} = Position{i}(shift_indices{i,j}(k):shift_indices{i,j}(k+1), j); 
                % Zero all positions so that they start from zero position. 
                % Take absolute value--we don't need negative values. 
                transient_pos{i,j}{numTransients(i,j)}(:) =...
                    abs(transient_pos{i,j}{numTransients(i,j)}(:) - transient_pos{i,j}{numTransients(i,j)}(1)); 
                % Retrieve velocity transients, too. 
                transient_vel{i,j}{numTransients(i,j)} = Data_Calib{i}(shift_indices{i,j}(k):shift_indices{i,j}(k+1), j);
                numTransients(i,j) = numTransients(i,j) + 1; 
            end
        end
    end
end