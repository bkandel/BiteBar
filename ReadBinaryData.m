MeasurementFormats = ...
    {'uint32' 'float' 'float' 'float' 'float' 'float' 'float'}; 
MeasurementLengths = [4 4 4 4 4 4 4 ];
R = cell(1, numel(MeasurementFormats)); 
fid = ...
    fopen('../../Data/Terrain_20120913_YEI006/Figure8_20120913_YEI006.dat', ...
    'rb'); 
fseek(fid,114, 'bof');
for i = 1:numel(MeasurementFormats)
    fseek(fid, sum(MeasurementLengths(1:i-1)), 'cof'); 
    R{i} = fread(fid, Inf, ...
        ['*' MeasurementFormats{i}], ...
        sum(MeasurementLengths) - MeasurementLengths(i)); 
end
fclose(fid); 
    

plot(R{1}(100:200))