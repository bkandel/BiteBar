% Script for selecting which parts of the data are good for a given test. 
function [X1 X2] = SelectRelevantTimePoints(TimeElapsed, SensorData, Title)
%SelectRelevantTimePoints select time points from data to analyze. 
%  Called by SelectRelevantTimePointsMaster.  Takes two arguments: 
%  TimeElapsed, and SensorData.  SensorData is an n-by-3 matrix, where 
%  n is the length of TimeElapsed.  


%% Plotting and selecting
Deltas = diff(TimeElapsed); 
scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*0.07 scrsz(4)/8 scrsz(3)/2 scrsz(4)*0.75])
plot(TimeElapsed, SensorData(:, 1), TimeElapsed, SensorData(:,2), ...
    TimeElapsed, SensorData(:, 3))
title(Title)
hold on; 
FinalCoordinates = 0; 

while(FinalCoordinates == 0) 
    display('Click on the plot to indicate where the trial begins.')
[X1 Y1] = ginput(1);
display('Now click on the plot to indicate where the trial ends.')
[X2 Y2] = ginput(1);
plot(X1:mean(Deltas):X2, ...
    zeros(length(X1:mean(Deltas):X2), 1), ...
    'y', 'LineWidth', 5)
FinalCoordinates = ...
    input('Is this time period satisfactory?  1 = yes, 0 = no.\n'); 
end





  


