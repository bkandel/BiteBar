clear; clc; close all; 
%RootDirectory = '../../Data/GrossmanTests/GrossmanTests/'; 
RootDirectory = '../../Data/Grossman_20120913_YEI006/'; 
FileList = dir(strcat(RootDirectory, '*YEI*.txt')); 
FileList(1) = []; 
FileList(1) = []; % clean up file listing


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
    fprintf(FileNameDataFile, '%s,%f, %f, \n', FileName, X1, X2); 
    fclose(FileNameDataFile); 
end
fclose('all')
close all; 

