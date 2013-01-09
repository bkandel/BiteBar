function Data = CalculateAmplitudes(Data)

for i = 1:length(Data)
   PositionIndices = 1:length(Data(i).XPosition); 
   
   XReversals = (Data(i).XPosition - circshift(Data(i).XPosition', 1)') .* ...
       ( Data(i).XPosition - circshift(Data(i).XPosition', -1)'); 
   XReversalsIndices = PositionIndices(XReversals > 0 ); 
   for j = 2:length(XReversalsIndices)
       XAmplitude(j-1) = abs(Data(i).XPosition(XReversalsIndices(j)) - ...
           Data(i).XPosition(XReversalsIndices(j - 1) )); 
   end
   
   YReversals = (Data(i).YPosition - circshift(Data(i).YPosition', 1)') .* ...
       ( Data(i).YPosition - circshift(Data(i).YPosition', -1)');
   YReversalsIndices = PositionIndices(YReversals > 0 );
   for j = 2:length(YReversalsIndices)
       YAmplitude(j-1) = abs(Data(i).YPosition(YReversalsIndices(j)) - ...
           Data(i).YPosition(YReversalsIndices(j - 1) ));
   end
   
   ZReversals = (Data(i).ZPosition - circshift(Data(i).ZPosition', 1)') .* ...
       ( Data(i).ZPosition - circshift(Data(i).ZPosition', -1)');
   ZReversalsIndices = PositionIndices(ZReversals > 0 );
   for j = 2:length(ZReversalsIndices)
       ZAmplitude(j-1) = abs(Data(i).ZPosition(ZReversalsIndices(j)) - ...
           Data(i).ZPosition(ZReversalsIndices(j - 1) ));
   end  
   
   Data(i).XAmplitude = XAmplitude; 
   Data(i).YAmplitude = YAmplitude; 
   Data(i).ZAmplitude = ZAmplitude; 
end

