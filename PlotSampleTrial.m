% to be run after ReadAndProcessYEIData.m
close; 
i = 140; 
Start = 5; 
End = 10; 

Indices = 1:length(FilteredData(i).TimeInSeconds); 
SelectedIndices = Indices(...
    FilteredData(i).TimeInSeconds > 5 & FilteredData(i).TimeInSeconds < 10 );
SelectedTime = FilteredData(i).TimeInSeconds(SelectedIndices); 
SelectedTime = SelectedTime - SelectedTime(1); 
figure(1); 
plot(SelectedTime, FilteredData(i).XGyro(SelectedIndices), ...
    SelectedTime, FilteredData(i).ZGyro(SelectedIndices), ...
    SelectedTime, FilteredData(i).YGyro(SelectedIndices), ...
    'LineWidth', 2)
xlabel('Time (s)'); ylabel('Velocity (deg/s)'); 
legend('Roll', 'Pitch', 'Yaw')
title('Sample Tracing for Walking')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 11 8])
print(gcf, '-dpng', '-r150', '../../Figures/SampleWalkTracing.png')

figure(2); 
FrequencyIndices = 1:length(FilteredData(i).Frequencies); 
SelectedFrequencyIndices = FrequencyIndices(...
    FilteredData(i).Frequencies < 5 );
SelectedFrequencies = FilteredData(i).Frequencies(SelectedFrequencyIndices); 
plot(SelectedFrequencies, ...
    FilteredData(i).FilteredXFrequency(SelectedFrequencyIndices), ...
    SelectedFrequencies, ...
    FilteredData(i).FilteredZFrequency(SelectedFrequencyIndices), ...
    SelectedFrequencies, ...
    FilteredData(i).FilteredYFrequency(SelectedFrequencyIndices), ...
    'LineWidth', 2); 
xlabel('Frequency (Hz)'); ylabel('Magnitude')
legend('Roll', 'Pitch', 'Yaw'); 
title('Sample Frequency Components for Walking'); 
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 11 8])
print(gcf, '-dpng', '-r150', '../../Figures/SampleWalkFrequencies.png')