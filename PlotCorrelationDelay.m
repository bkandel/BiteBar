% make figure demonstrating correlation between roll and yaw as function of
% delay. 

% first, run ReadAndProcessYEIData.m or ReadRotateAndProcessYEIData.m so
% that you have a "FilteredData" struct.
close; clear Correlation; 
RunNumber = 407 ; FilteredData(RunNumber).Filename
% make sure it's an interesting run in unconstrained conditions.  

MaxOffset = 125; 
for Offset = 1:MaxOffset
tmp = corrcoef(FilteredData(RunNumber).XGyro, ...
    circshift(FilteredData(RunNumber).YGyro', Offset)'); 
Correlation(Offset) = tmp(2, 1); 
end

DelayIndices = 1:MaxOffset; 
TimeStepVector = FilteredData(RunNumber).TimeInSeconds - ...
    circshift(FilteredData(RunNumber).TimeInSeconds', 1)'; 
MeanTimeStep = mean(TimeStepVector(2:end)); 
DelayInSeconds = DelayIndices .* MeanTimeStep; 

plot(DelayInSeconds, Correlation, 'LineWidth', 2); 
ylim([-0.2 1])
title(strcat('Correlation Between Roll and Pitch as Function of Delay', ...
    FilteredData(RunNumber).Filename) ); 
    %'FontSize', 16)
xlabel('Delay (s)', 'FontSize', 14)
ylabel('Correlation', 'FontSize', 14)



