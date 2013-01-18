clear; clc; close all; 
RootDirectory = '../../Data/GrossmanTests/GrossmanTests/AllData/'; 
%RootDirectory = '../../Data/YEIJump/'; 
%RootDirectory = '../../Data/YEI_20120820/YEI_Data_20120820/AllData/'; 
FileList = dir(strcat(RootDirectory, '*YEI*.txt')); 

for i = 1:length(FileList)
    FileName = strcat(RootDirectory, FileList(i).name); 
    fid = fopen(FileName); 
    data = textscan(fid, ...
        '%d%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f', ...
        'Whitespace', ', :', 'HeaderLines', 1);
    fclose(fid); 
    Hours = data{1};
    Minutes = data{2};
    Seconds = data{3};
    HoursInSeconds = double(Hours * 3600);
    MinutesInSeconds = double(Minutes * 60);
    TimeInSeconds = HoursInSeconds + MinutesInSeconds + Seconds;
    TimeElapsed = TimeInSeconds - TimeInSeconds(1);
    ChipTimeElapsed = ConvertChipMSTimeToSeconds(data{4}); 
    [X1 X2] = SelectRelevantTimePoints(TimeElapsed, ...
        [data{14} data{15} data{16}], FileName); 
    close; 
    FileNameDataFile = fopen(strcat(RootDirectory, 'FileData.csv'), 'a'); 
    for j = 1:length(X1)        
        fprintf(FileNameDataFile, '%s,%d,%f,%f,\n', FileName, j, X1(j), X2(j));
    end
    fclose(FileNameDataFile);
end
fclose('all')
close all; 

