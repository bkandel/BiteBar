% make figure demonstrating correlation between roll and yaw as function of
% delay. 

% first, run ReadAndProcessYEIData.m or ReadRotateAndProcessYEIData.m so
% that you have a "FilteredData" struct.
%{
 %subject 1: 
begin: 55
end: 102
subject 2: 
%}
%{  
for subject 10
Begin1 = 404; 
End1 = 419; 
Begin2 = 398; 
End2 = 398;
%}

%{
%for subject 6 
Begin1 = 207; 
End1 = 221; 
Begin2 = 193; 
End2 = 195;
%}

% for subject 5
Subject5 = 55:102; 
%{
Begin1 = 55; 
End1 = 102; 
Begin2 = 103; 
End2 = 105;
%}
Subject6 = 209:222; 
Subject78 = 236:253; 
Subject9 = 404:419; 
Subject10 = 435:436; 
% WalkRun
Begin1 = 441; 
End1 = 580; 
Begin2 = 581; 
End2 = 582; 


Begin1 = Subject10(1); 
End1 = Subject10(end); 

Begin1 = 420;  %walk--subject 9
End1 = 427; 
Begin1 = 404; % run -- subject 9
End1 = 419; 
% all walks
WalkIndices = [
    118:144 223:230 267:284 349:381 420:427 437:438
    ]; 
% all runs
RunIndices = [
    55:102 207:222 234:266 285:348 404:419 435:436
    ];
RunIndices=234:266;
MaxCorrelationsUnconstrained = zeros(length(Begin1:End1), 1); 
close; clear Correlation; 
j = 1; 
for RunNumber = RunIndices %Begin1:End1
    FilteredData(RunNumber).Filename
    % make sure it's an interesting run in unconstrained conditions.
    
    MaxOffset = 125;
    X = FilteredData(RunNumber).XGyro; 
    Y = FilteredData(RunNumber).YGyro; 
    
    for i = 1:250:(length(X)-250)
        SelectX = X(i:(i+250));
        SelectY = Y(i:(i+250)); 
        
        for Offset = 1:MaxOffset
            tmp = corrcoef(SelectX, circshift(SelectY', Offset)');
            %tmp = corrcoef(FilteredData(RunNumber).XGyro, ...
            %    circshift(FilteredData(RunNumber).YGyro', Offset)');
            Correlation(Offset) = tmp(2, 1);
        end
        %MaxCorrelationsUnconstrained(RunNumber - Begin1 + 1) = max(Correlation);
        MaxCorrelationsUnconstrained(j) = max(Correlation);
        DelayIndices = 1:MaxOffset;
        TimeStepVector = FilteredData(RunNumber).TimeInSeconds - ...
            circshift(FilteredData(RunNumber).TimeInSeconds', 1)';
        MeanTimeStep = mean(TimeStepVector(2:end));
        DelayInSeconds = DelayIndices .* MeanTimeStep;
        OptimalDelay(j) = DelayInSeconds(Correlation == max(Correlation)); 
%         plot(DelayInSeconds, Correlation, 'LineWidth', 2);
%         ylim([-0.2 1])
%         title(...  %strcat('Correlation Between Roll and Pitch as Function of Delay', ...
%             FilteredData(RunNumber).Filename );
%         %'FontSize', 16)
%         xlabel('Delay (s)', 'FontSize', 14)
%         ylabel('Correlation', 'FontSize', 14)
        %pause(0.1);
        j = j + 1;
    end
end

%% Plotting
% run once for WalkIndices and once for RunIndices
WalkCors = MaxCorrelationsUnconstrained;
WalkDelays = OptimalDelay;
RunCors = MaxCorrelationsUnconstrained;
RunDelays = OptimalDelay;
[nWalk, xoutWalk] = hist(WalkCors, linspace(-0.2,1.2,35));
nWalk = nWalk / sum(nWalk);
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor','r','EdgeColor','w','facealpha',0.5)
% hold on;
[nRun, xoutRun] = hist(RunCors, linspace(-0.2, 1.2, 35)); 
nRun = nRun / sum(nRun);
n = [nWalk ; nRun]';
bar(xoutWalk, n);
set(gca, 'xlim', [-0.02 1])
legend('Walking', 'Running')
title('Distribution of Correlation Between Roll and Yaw', 'FontSize', 26)
xlabel('Correlation Between Roll and Yaw', 'FontSize', 22)
ylabel('Proportion of All Runs', 'FontSize', 22)
set(gca, 'FontSize', 22)
% h1 = findobj(gca,'Type','patch');
% set(h1,'facealpha',0.5);

%{
MaxCorrelationsRIP = zeros(length(Begin2:End2), 1);
for RunNumber = Begin2:End2
    MaxOffset = 125;
    for Offset = 1:MaxOffset
        tmp = corrcoef(FilteredData(RunNumber).XGyro, ...
            circshift(FilteredData(RunNumber).YGyro', Offset)');
        Correlation(Offset) = tmp(2, 1);
    end
    MaxCorrelationsRIP(RunNumber - Begin2 + 1) = max(Correlation);
        
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
end
MaxCorrelationsUnconstrained
MaxCorrelationsRIP
[Diff P ] = ttest2(MaxCorrelationsUnconstrained, MaxCorrelationsRIP)


%}