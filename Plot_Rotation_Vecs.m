% This mfile will be used to do the basic analysis
% of the raw data. 
clear; clc;% close all; 

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
sigma = 2; % sigma for smoothing pdf
num_bins = 100; % number of bins for histogram


run(strcat('C:\Users\Ben\Dropbox\BiteBlock\Data\', ...
    'CodeTest\Code_Test_def.m')); 

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
roll_data = Data_Calib{8}(:,2); 
pitch_data = Data_Calib{8}(:,1); 
yaw_data = Data_Calib{8}(:,3); 
dataUsed = [roll_data pitch_data yaw_data]; 

dataUsed = dataUsed'; 

rotationMatrixRoll = makeRotationMatrix(-19, 'y'); 
rotationMatrixYaw = makeRotationMatrix(-45, 'z'); 
dataRotated = rotationMatrixYaw * dataUsed;
dataRotated = rotationMatrixRoll * dataRotated; 
% the positions (=rotations) should now be in the Reid x,y,z axes.
% copied from Head_Movement_Vis.m
dataRotated = dataRotated'; 

[theta phi smoothed_pdf angular_pdf normalized_data centers] = ...
    angular_velocity_pdf(dataUsed', sigma, num_bins); 
figure; pcolor(centers{2}, centers{1}, smoothed_pdf); shading interp; 
xlabel('\phi'); 
ylabel('\theta')
title('PDF of angular velocities for tilting right.')
%{
figure(2)
[x,y,z] = sphere(30);
cla reset
axis square off
props.Cdata = smoothed_pdf;
props.AmbientStrength = 0.1;
props.DiffuseStrength = 1;
props.SpecularColorReflectance = .5;
props.SpecularExponent = 20;
props.SpecularStrength = 1;
props.FaceColor= 'texture';
props.EdgeColor = 'none';
%props.FaceLighting = 'phong';
surface(x,y,z,props);
view([1 1 1])
title('PDF of angular velocities for run-jump data, mapped to sphere.')
%}


