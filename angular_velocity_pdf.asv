function [theta phi smoothed_pdf angular_pdf normalized_data centers] = ...
    angular_velocity_pdf(rotation_data, sigma, num_bins)
% This function will take the rotation data and return a plot of the
% directional vectors.

%% Normalize data
velocity_squared = rotation_data.^2;
magnitude        = (sum(velocity_squared, 2)).^0.5; 
% sum over rows (data points) and take square root for magnitude
magnitude        = repmat(magnitude, 1, 3); 
% get 3 x n data matrix for easy matrix computation
normalized_data  = rotation_data ./ magnitude; 

%% Calculate angles
theta = atan(normalized_data(:,1) ./ normalized_data(:,2));
% theta is the angle from the right ear out.  It goes from -pi to pi. 
phi   = acos(normalized_data(:,3));
% phi is azimuthal angle, measured from the top of the head down. 
% phi goes from 0 (top of head) to pi (base of skull).


%% Calculate PDF

edges{1} = linspace(-pi, pi, num_bins); 
edges{2} = linspace(0, pi, num_bins); 

[angular_pdf, centers] = hist3([theta phi], 'Edges', edges); % [num_bins num]); 

size = (ceil((ceil(6 * sigma) / 2) + 0.5) * 2) - 1; 
% size is 6 * sigma, rounded up to next odd integer 
gaussFilter = fspecial('gaussian', size, sigma); 
smoothed_pdf = conv2(angular_pdf, gaussFilter, 'same'); 

