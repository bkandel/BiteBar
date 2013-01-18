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
subplot(2, 1, 1); 
plot(TimeElapsed, SensorData(:, 1), TimeElapsed, SensorData(:,2), ...
    TimeElapsed, SensorData(:, 3))
title(Title); hold on; 

subplot(2, 1, 2); 
XPosition = cumtrapz(TimeElapsed, SensorData(:,1)); 
YPosition = cumtrapz(TimeElapsed, SensorData(:, 2)); 
ZPosition = cumtrapz(TimeElapsed, SensorData(:, 3)); 
%correct for drift
XPosition = XPosition - mean(XPosition); 
YPosition = YPosition - mean(YPosition); 
ZPosition = ZPosition - mean(ZPosition); 

plot(TimeElapsed, XPosition, ...
    TimeElapsed, YPosition, ...
    TimeElapsed, ZPosition); 
title('Position'); hold on; 

FinalCoordinates = 0; SatisfactorySelection = 0; 

i = 1; 
while(FinalCoordinates == 0) 
    while(SatisfactorySelection == 0)
        display('Click on the plot to indicate where the trial begins.')
        [X1(i) Y1] = ginput(1);
        display('Now click on the plot to indicate where the trial ends.')
        [X2(i) Y2] = ginput(1);
        for j = 1:2
            subplot(2, 1, j);
            plot(X1(i):mean(Deltas):X2(i), ...
                zeros(length(X1(i):mean(Deltas):X2(i)), 1), ...
                'y', 'LineWidth', 5)
        end
        SatisfactorySelection = ...
            input('Is this time period satisfactory?  1 = yes, 0 = no.\n'); 
    end
    i = i + 1; 
    FinalCoordinates = ...
        input('Have you selected all relevant sections? 1 = yes, 0 = no.\n');
    SatisfactorySelection = FinalCoordinates; 
end





  


