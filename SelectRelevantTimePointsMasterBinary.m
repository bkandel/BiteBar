clear; clc; close all; 
%RootDirectory = '../../Data/GrossmanTests/GrossmanTests/'; 
%RootDirectory = '../../Data/Grossman_20120913_YEI006/'; 
%RootDirectory = '../../Data/Terrain_20120913_YEI006/'; 
%RootDirectory =  '../../Data/Terrain_20120921_007YEI_008YEI/';
RootDirectory = '../../Data/GrossmanData_20120921_007YEI_008YEI/';
FileList = dir(strcat(RootDirectory, '*YEI*.txt')); 

for i = 1:length(FileList)
    FileName = strcat(RootDirectory, FileList(i).name); 
    fid = fopen(FileName); 
    data = textscan(fid, ...
        '%d%f%f%f%f%f%f', ...
        'Whitespace', ', :', 'HeaderLines', 0);
    fclose(fid); 
    ChipTimeElapsed = ConvertChipMSTimeToSeconds(double(data{1})); 
    [X1 X2] = SelectRelevantTimePoints(ChipTimeElapsed, ...
        [data{2} data{3} data{4}], FileName); 
    close; 
    FileNameDataFile = fopen(strcat(RootDirectory, 'FileData.csv'), 'a'); 
    for j = 1:length(X1)
        fprintf(FileNameDataFile, '%s,%d,%f,%f,\n', FileName, j, X1(j), X2(j));
    end
    fclose(FileNameDataFile); 
end
fclose('all')
close all; 

