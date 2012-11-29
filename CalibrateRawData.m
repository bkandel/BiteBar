function [Data_Calib, Position] = CalibrateRawData(Data_Raw, DC_fit, ...
    sampling_rate, correction_amp)
% This function will convert the raw data to deg/s, and will also convert
% the velocity data to position.  

for i = 1:length(Data_Raw)
    % add smoothing
    for  j= 1:3
        Data_Calib{i}(:,j) = ((Data_Raw{i}(:,j) - DC_fit(j))) * correction_amp(j); 
         % Integrate velocity to get position
         Position{i}(:,j) = sampling_rate^(-1) * cumtrapz(Data_Calib{i}(:,j)); 
    end
end