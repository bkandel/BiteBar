function Padded = CosinePad(X, ...
    sampling_rate, totalLengthInSecs, padLengthInSecs)

% This function is made to perform a cosine 
% windowing and zero-padding to a vector.  

% Not right--need to have smooth ends.  Forgot 
% about that. 
totalLengthInIndices = totalLengthInSecs * sampling_rate; 
padLengthInIndices = padLengthInSecs * sampling_rate; 

zeroPad = zeros(padLengthInIndices, 1);
xPad = vertcat(zeroPad, X);
endPadLength = totalLengthInIndices - length(xPad);
endPad = ones(endPadLength, 1) * X(end);
cosWindowScaled = cos((1:endPadLength) / endPadLength * pi)'; 
cosWindow = (cosWindowScaled + 1) / 2; 
endPadWindowed = endPad .* cosWindow; 
Padded = vertcat(xPad, endPadWindowed); 
