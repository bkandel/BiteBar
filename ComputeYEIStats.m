%% Documentation
% This m-file will generate a CSV table of quantiles of YEI data from
% boxplots and compare to Grossman data.
% Output file has structure: 
% Name   Median  25th-percentile  75th-percentile

%% Grossman Data--estimated from figures in Grossman et al. 1988
GrossmanWalkFreqYaw        = [ 0.9 0.85 0.95 ]; 
GrossmanWalkFreqPitch      = [ 1.8 1.6 2.1 ]; 
GrossmanRunFreqYaw         = [ 1.7 1.6 1.8 ]; 
GrossmanRunFreqPitch       = [ 3.3 2.7 3.5 ]; 
GrossmanHorizontalFreqYaw  = [ 2.7 2.0 3.2 ]; 
GrossmanVerticalFreqPitch  = [ 2.6 1.9 3.3 ]; 

GrossmanWalkVelocityYaw       = [ 38 31 45 ]; 
GrossmanWalkVelocityPitch     = [ 36 27 40 ]; 
GrossmanRunVelocityYaw        = [ 60 47 88 ]; 
GrossmanRunVelocityPitch      = [ 83 70 95 ]; 
GrossmanHorizontalVelocityYaw = [ 780 600 900 ];
GrossmanVerticalVelocityPitch = [ 400 330 430 ];

%% Our data
GetYEIDataForPlotting; 

MyQuants = [ 0.5 0.25 0.75 ]; 
UsWalkFreqRoll   = quantile(Data.PrincipalXFrequency(WalkInPlaceIndices), MyQuants); 
UsWalkFreqPitch = quantile(Data.PrincipalZFrequency(WalkInPlaceIndices), MyQuants); 
UsWalkFreqYaw   = quantile(Data.PrincipalYFrequency(WalkInPlaceIndices), MyQuants); 
UsRunFreqRoll   = quantile(Data.PrincipalXFrequency(RunInPlaceIndices), MyQuants); 
UsRunFreqPitch  = quantile(Data.PrincipalZFrequency(RunInPlaceIndices), MyQuants); 
UsRunFreqYaw    = quantile(Data.PrincipalYFrequency(RunInPlaceIndices), MyQuants); 
UsHorizontalFreqYaw = ...
    quantile(Data.PrincipalYFrequency(HorizontalShakeIndices), MyQuants); 
UsVerticalFreqPitch = ...
    quantile(Data.PrincipalZFrequency(VerticalShakeIndices), MyQuants); 

UsWalkVelocityRoll = quantile(Data.MaxXGyro(WalkInPlaceIndices), MyQuants); 
UsWalkVelocityPitch = quantile(Data.MaxZGyro(WalkInPlaceIndices), MyQuants); 
UsWalkVelocityYaw = quantile(Data.MaxYGyro(WalkInPlaceIndices), MyQuants); 
UsRunVelocityRoll = quantile(Data.MaxXGyro(RunInPlaceIndices), MyQuants); 
UsRunVelocityPitch = quantile(Data.MaxZGyro(RunInPlaceIndices), MyQuants); 
UsRunVelocityYaw = quantile(Data.MaxYGyro(RunInPlaceIndices), MyQuants); 
UsHorizontalVelocityYaw = ...
    quantile(Data.MaxYGyro(HorizontalShakeIndices), MyQuants); 
UsVerticalVelocityPitch = ...
    quantile(Data.MaxZGyro(HorizontalShakeIndices), MyQuants); 

%% Write to file
Name = '../../Data/Quantiles.csv'; 
fid = fopen(Name, 'w'); 
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s\n', ...
    'Name', 'Frequencies: Median', '25th Quantile', '75th Quantile', ...
    'Velocities: Median', '25th Quantile', '75th Quantile'); 
fclose(fid); 
fid = fopen(Name, 'a'); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Grossman Walk Yaw', ...
    [GrossmanWalkFreqYaw GrossmanWalkVelocityYaw]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Us Walk Yaw', ...
    [UsWalkFreqYaw UsWalkVelocityYaw]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Grossman Walk Pitch', ...
    [GrossmanWalkFreqPitch GrossmanWalkVelocityPitch]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Us Walk Pitch', ...
    [UsWalkFreqPitch UsWalkVelocityPitch]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Grossman Run Yaw', ...
    [GrossmanRunFreqYaw GrossmanRunVelocityYaw]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Us Run Yaw', ...
    [UsRunFreqYaw UsRunVelocityYaw]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Grossman Run Pitch', ...
    [GrossmanRunFreqPitch GrossmanRunVelocityPitch]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Us Run Pitch', ...
    [UsRunFreqPitch UsRunVelocityPitch]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Grossman Horizontal Shake Yaw', ...
    [GrossmanHorizontalFreqYaw GrossmanHorizontalVelocityYaw]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Us Horizontal Shake Yaw', ...
    [UsHorizontalFreqYaw UsHorizontalVelocityYaw]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'GrossmanVerticalShakePitch', ...
    [GrossmanVerticalFreqPitch GrossmanVerticalVelocityPitch]); 
fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', 'Us Vertical Shake Pitch', ...
    [UsVerticalFreqPitch UsVerticalVelocityPitch]); 

fclose(fid);
