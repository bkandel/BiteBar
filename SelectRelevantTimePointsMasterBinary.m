clear; clc; close all; 
RootDirectory{1} = '../../Data/Grossman_20120913_YEI006/'; 
RootDirectory{2} = '../../Data/Terrain_20120913_YEI006/'; 
RootDirectory{3} =  '../../Data/Terrain_20120921_007YEI_008YEI/';
RootDirectory{4} = '../../Data/GrossmanData_20120921_007YEI_008YEI/';
for k = 1:length(RootDirectory)
    movefile(strcat(RootDirectory{k}, 'FileData.csv'), ...
        strcat(RootDirectory{k}, 'FileDataBackup.csv'));
    FileList = dir(strcat(RootDirectory{k}, '*YEI*.txt'));
    for i = 1:length(FileList)
        FileName = strcat(RootDirectory{k}, FileList(i).name);
        fid = fopen(FileName);
        data = textscan(fid, ...
            '%d%f%f%f%f%f%f', ...
            'Whitespace', ', :', 'HeaderLines', 0);
        fclose(fid);
        ChipTimeElapsed = ConvertChipMSTimeToSeconds(double(data{1}));
        [X1 X2] = SelectRelevantTimePoints(ChipTimeElapsed, ...
            [data{2} data{3} data{4}], FileName);
        close;
        FileNameDataFile = fopen(strcat(RootDirectory{k}, 'FileData.csv'), 'a');
        for j = 1:length(X1)
            fprintf(FileNameDataFile, '%s,%d,%f,%f,\n', FileName, j, X1(j), X2(j));
        end
        fclose(FileNameDataFile);
    end
    fclose('all');
    close all;
end

