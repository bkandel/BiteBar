Directory = '../../Data/YEIGrossmanTests/'; 
Pattern = '*08_13*.txt'; 
Figure = tight_subplot(6, 6, [0.05 0.05], [0.05 0.05], [0.07 0.07]);

FileList = dir(strcat(Directory, Pattern)); 
for i = 1:length(FileList)
   File = FileList(i).name; 
   fid = fopen(strcat(Directory, File)); 
   data = textscan(fid, ...
       '%d%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f', ...
       'Whitespace', ', :', 'HeaderLines', 1); 
   fclose(fid); 
   TimeInMilliseconds = data{3}; 
   TimeInMillisecondsShifted = circshift(data{3}, 1); 
   Deltas = TimeInMilliseconds - TimeInMillisecondsShifted; 
   TimeInMinutes = data{2}; 
   TimeInMinutesShifted = circshift(TimeInMinutes, 1); 
   ChangeInMinutes = TimeInMinutes - TimeInMinutesShifted; 
   Deltas(ChangeInMinutes ~= 0) = 0; 
   axes(Figure(i)); 
   plot(Deltas(5:end))
    
end


