% This mfile will be used to do the basic analysis
% of the raw data. 

% Constants
sampling_rate = 100; % Hz
transient_min_size = 5; % degs
transient_min_duration = 0.2; % secs

data_raw = data_raw; 
data_calib = (data_raw - DC) * correction_amp; 
% Find places where tracing switches direction
shifts = xor((data_calib > 0), circshift((data_calib > 0), 1)); 
shifts(1) = 0; 
shift_indices = find(shifts == 1); 
% Integrate velocity to get position
position = 0.01 * trapz(data); 
% Find transients 


