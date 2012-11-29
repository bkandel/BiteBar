clear;clc 
fid = ...
    fopen(...
    '../../Data/Terrain_20120913_YEI006/Figure8_20120913_YEI006.dat', ...
    'r'); 
for j = 1:10
blah(j) = fread(fid, 1, 'int32', 'l');
blah2(j,:) = fread(fid, 6, 'float', 'l');
end
fclose('all');
plot(blah)
blah2(:,2:end)