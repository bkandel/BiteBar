% make figure demonstrating correlation between roll and yaw as function of
% delay. 

% first, run ReadAndProcessYEIData.m or ReadRotateAndProcessYEIData.m so
% that you have a "FilteredData" struct.
close; clear Correlation; 
j = 241 ; FilteredData(j).Filename
% make sure it's an interesting run in unconstrained conditions.  

MaxOffset = 125; 
for Offset = 1:MaxOffset
tmp = corrcoef(FilteredData(j).XGyro, circshift(FilteredData(j).YGyro', Offset)'); 
Correlation(Offset) = tmp(2, 1); 
end

DelayIndices = 1:MaxOffset; 
TimeStepVector = FilteredData(j).TimeInSeconds - ...
    circshift(FilteredData(j).TimeInSeconds', 1)'; 
MeanTimeStep = mean(TimeStepVector(2:end)); 
DelayInSeconds = DelayIndices .* MeanTimeStep; 

plot(DelayInSeconds, Correlation, 'LineWidth', 2); 
ylim([-0.2 1])
title(strcat('Correlation Between Roll and Pitch as Function of Delay', ...
    FilteredData(j).Filename) ); 
    %'FontSize', 16)
xlabel('Delay (s)', 'FontSize', 14)
ylabel('Correlation', 'FontSize', 14)



