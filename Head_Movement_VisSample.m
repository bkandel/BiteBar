% This mfile will create a movie of a head moving in real time with the
% data recorded from the rotational ratemeter. 

% face = imread('face.png'); 
% face = im2bw(face); 
% face = double(face); %face = double(face == 0); 
%colormap gray; imagesc(face)

clear; clc; close
face = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    ]; 
face = double(face == 0); 
    face = flipud(face); 


[x,y,z] = sphere(19); colormap gray; 


subplot(1,3,1); surface(x,y,z, face);
view([1 1 1])
title('Original Face')

%% Rotate Face
xRow = reshape(x,1,400); 
yRow = reshape(y,1,400); 
zRow = reshape(z,1,400); 
xyzCombined = vertcat(xRow, yRow, zRow); 
% angleYaw = 45; 
% cAngleYaw = cosd(angleYaw); 
% sAngleYaw = sind(angleYaw); 
% anglePitch = -19;
% cAnglePitch = cosd(anglePitch); 
% sAnglePitch = sind(anglePitch); 
% rotationMatrixYaw = [
%     cAngleYaw -sAngleYaw 0; 
%     sAngleYaw cAngleYaw 0; 
%     0 0 1; 
%     ]; 
% rotationMatrixPitch = [
%     cAnglePitch 0 sAnglePitch; 
%     0 1 0; 
%     -sAnglePitch 0 cAnglePitch; 
%     ]; 
rotationMatrixYaw = makeRotationMatrix(45, 'z'); 
rotationMatrixPitch = makeRotationMatrix(-19, 'y'); 
xyzCombinedRotated = rotationMatrixYaw * xyzCombined; 
xyzCombinedRotated = rotationMatrixPitch * xyzCombinedRotated; 

xRotatedRow = xyzCombinedRotated(1,:); 
xRotated = reshape(xRotatedRow, 20, 20); 
yRotatedRow = xyzCombinedRotated(2,:); 
yRotated = reshape(yRotatedRow, 20, 20); 
zRotatedRow = xyzCombinedRotated(3,:); 
zRotated = reshape(zRotatedRow, 20, 20); 

subplot(1,3,2); surface(xRotated, yRotated, zRotated, face); 
colormap gray; 
view ([1 1 1]); 
title('Rotated Face')

%% Now Rotate Back
angleYaw = -45; 
cAngleYaw = cosd(angleYaw); 
sAngleYaw = sind(angleYaw); 
anglePitch = 19; 
cAnglePitch = cosd(anglePitch); 
sAnglePitch = sind(anglePitch); 

rotationMatrixYaw = [
    cAngleYaw -sAngleYaw 0; 
    sAngleYaw cAngleYaw 0; 
    0 0 1; 
    ]; 
rotationMatrixPitch = [
    cAnglePitch 0 sAnglePitch; 
    0 1 0; 
    -sAnglePitch 0 cAnglePitch; 
    ]; 

xyzCombinedRotatedBack = rotationMatrixYaw * xyzCombinedRotated; 
xyzCombinedRotatedBack = rotationMatrixPitch * xyzCombinedRotatedBack; 

xRotatedBackRow = xyzCombinedRotatedBack(1,:); 
xRotatedBack = reshape(xRotatedBackRow, 20, 20); 
yRotatedBackRow = xyzCombinedRotatedBack(2,:); 
yRotatedBack = reshape(yRotatedBackRow, 20, 20); 
zRotatedBackRow = xyzCombinedRotatedBack(3,:); 
zRotatedBack = reshape(zRotatedBackRow, 20, 20); 

subplot(1,3,3); surface(xRotatedBack, yRotatedBack, zRotatedBack, face); 
colormap gray; 
view ([1 1 1]); 
title('Face Rotated Back')

%% Try to rotate face with movement data
Min_Magnitude = 10; 
% Only analyze transients that generated a 
% changein position of 10 degs. 
Min_Duration = 20; % ms
transLengthPadded = 10; % sec
% We will pad and window the transients so that 
% they have a total length of 10 seconds
padLength = 5; % sec
% We will zero-pad the transients for five seconds
pctCutoff = 0.99; % cutoff for bandwidth is 99%


run('C:\Users\Ben\Dropbox\BiteBlock\Data\Data_Def.m'); 

load(calibration_file); 
correction_amp = amp_fit.^(-1); 
% We need to divide by the slope of the 
% amplitude fit to convert the raw measurements
% to deg / s. 
Min_Length = Min_Duration * sampling_rate / 1000; 
% minimum number of indices in a transient to include

% Convert to deg/s. 
[Data_Calib, Position] = CalibrateRawData(Data_Raw, DC_fit, ...
    sampling_rate, correction_amp); 

length = 1000; 
dataUsed = Position{1}(1:length, :); 
dataUsed = dataUsed'; 


