function Data = ...
    CalculateAmplitudes(Data, AmplitudeThreshold, TimeThreshold, SamplingRate)
% CalculateAmplitudes calculates the amplitude of transients from movement
% data.  Transients that are too small (less than AmplitudeThreshold) or
% too short (less than TimeThreshold) are discarded. 
TimeThresholdInTimepoints = TimeThreshold * SamplingRate / 1000; 
for i = 1:length(Data)
   XAmplitude = CalculateAndTrimAmplitudes(Data(i).XPosition, ...
       AmplitudeThreshold, TimeThresholdInTimepoints); 
   YAmplitude = CalculateAndTrimAmplitudes(Data(i).YPosition, ...
       AmplitudeThreshold, TimeThresholdInTimepoints); 
   ZAmplitude = CalculateAndTrimAmplitudes(Data(i).ZPosition, ...
       AmplitudeThreshold, TimeThresholdInTimepoints); 
   
   Data(i).XAmplitude = XAmplitude; 
   Data(i).YAmplitude = YAmplitude; 
   Data(i).ZAmplitude = ZAmplitude; 
end

end
function AmplitudeVector = CalculateAndTrimAmplitudes(PositionVector, ...
        AmplitudeThreshold, TimeThresholdInTimepoints)
   PositionIndices = 1:length( PositionVector ); 
   Reversals = (PositionVector - circshift(PositionVector', 1)') .* ...
       ( PositionVector - circshift(PositionVector', -1)'); 
   ReversalsIndices = PositionIndices(Reversals > 0 ); 
   % discard transients that are too short
   TransientLengthsInTimepoints = ...
       ReversalsIndices - circshift(ReversalsIndices', 1)'; 
   ReversalsIndices( ...
       TransientLengthsInTimepoints < TimeThresholdInTimepoints ) = [];
   for j = 2:length(ReversalsIndices)
       AmplitudeVector(j-1) = abs(PositionVector(ReversalsIndices(j)) - ...
           PositionVector(ReversalsIndices(j - 1) )); 
   end
   %discard transients that are too small
   AmplitudeVector( AmplitudeVector < AmplitudeThreshold ) = []; 
end

