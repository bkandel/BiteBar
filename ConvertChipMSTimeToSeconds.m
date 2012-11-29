function ElapsedChipTimeInSeconds = ...
    ConvertChipMSTimeToSeconds(ChipTimeMS)
% correct elapsed chip ms time for resets to 0
ChipTimeResets = (ChipTimeMS - circshift(ChipTimeMS, 1)) < 0; 
ChipTimeResets(1) = 0; 
ChipTimeIndices = 1:length(ChipTimeMS); 
ChipTimeResetIndices = ChipTimeIndices(ChipTimeResets); 
if ( ~isempty(ChipTimeResetIndices)) 
    for j = 1:length(ChipTimeResetIndices)
        if ( j < length(ChipTimeResetIndices)) %only want to correct to next index
            ChipTimeMS(ChipTimeResetIndices( j ):( ChipTimeResetIndices( j + 1 ) - 1) ) = ...
                ChipTimeMS(ChipTimeResetIndices( j ):( ChipTimeResetIndices( j + 1 ) - 1) ) + ...
                ChipTimeMS(  ChipTimeResetIndices(j) - 1 ) ;
        elseif ( j == length( ChipTimeResetIndices) ) %on last index, correct to end
            ChipTimeMS( ChipTimeResetIndices( j ):end ) = ...
                ChipTimeMS( ChipTimeResetIndices( j ):end ) + ...
                ChipTimeMS( ChipTimeResetIndices(j) - 1 ) ;
        end
    end
end
ChipTimeMS = ChipTimeMS - ChipTimeMS(1); 
% correct for microseconds (not milli)
ElapsedChipTimeInSeconds = double(ChipTimeMS / 1000000); 
