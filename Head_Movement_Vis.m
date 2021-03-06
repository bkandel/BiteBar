% This mfile will create a movie of a head moving in real time with the
% data recorded from the rotational ratemeter. 

clear; clc; close
face = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 1 0 0 1 0 0 0 0 1 0 0 1 0 0 0 0; 
    0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0; 
    0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0; 
    0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0; 
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
[x,y,z] = sphere(19);
xRow = reshape(x,1,400); 
yRow = reshape(y,1,400); 
zRow = reshape(z,1,400); 
xyzCombined = vertcat(xRow, yRow, zRow); 

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


run(strcat('C:\Users\Ben\Dropbox\BiteBlock\Data', ...
    '\StandardizedHeadMovements\StandardizedHeadMovements_20111006_def.m')); 

load(calibration_file); 
correction_amp = amp_fit.^(-1); 
% We need to divide by the slope of the 
% amplitude fit to convert the raw measurements
% to deg / s. 

% Convert to deg/s. 
[Data_Calib, Position] = CalibrateRawData(Data_Raw, DC_fit, ...
    sampling_rate, correction_amp); 

dataUsed = Position{1}(2300:10:5480, :); 
Normalize = repmat(dataUsed(1,:), length(dataUsed), 1); 
dataUsed = dataUsed - Normalize; 
% Normalize data so that we start movements from a position looking
% forward. 
dataUsed = dataUsed'; 

rotationMatrixYaw = makeRotationMatrix(-45, 'z'); 
rotationMatrixPitch = makeRotationMatrix(19, 'y'); 
dataRotated =rotationMatrixYaw * dataUsed; 
dataRotated = rotationMatrixPitch * dataRotated; 
% the positions (=rotations) should now be in the Reid x,y,z axes.


set(gca,'nextplot','replacechildren');
for i = 1:length(dataUsed)
    xMat = makeRotationMatrix(dataRotated(1,i), 'x'); 
    yMat = makeRotationMatrix(dataRotated(2,i),'y'); 
    zMat = makeRotationMatrix(dataRotated(3,i),'z'); 
    faceRotated = xMat * yMat * zMat * xyzCombined; 
    xRotatedRow = faceRotated(1,:); 
    xRotated = reshape(xRotatedRow, 20, 20); 
    yRotatedRow = faceRotated(2,:); 
    yRotated = reshape(yRotatedRow, 20, 20); 
    zRotatedRow = faceRotated(3,:); 
    zRotated = reshape(zRotatedRow, 20, 20);
    surface(xRotated, yRotated, zRotated, face);
    colormap gray; 
    view([1 1 1])
    F(i) = getframe; 
    close
end
movie(F,1,10)
movie2avi(F, 'C:\Users\Ben\Dropbox\BiteBlock\Figures\StandardMovements.avi', ...
    'fps', 10)



    
    