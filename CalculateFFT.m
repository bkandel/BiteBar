function Data = ...
    CalculateFFT(Data, ResampleRate, DownsampleFactor, ...
    MinFrequency, MaxFrequency)

for i = 1:length(Data)
    [XFrequencyComponent, XFrequencies] = ...
        positiveFFT(Data(i).XGyro, (ResampleRate / DownsampleFactor)); 
    [YFrequencyComponent, YFrequencies] = ...
        positiveFFT(Data(i).YGyro, (ResampleRate / DownsampleFactor)); 
    [ZFrequencyComponent, ZFrequencies] = ...
        positiveFFT(Data(i).ZGyro, (ResampleRate / DownsampleFactor)); 
    FrequencySelectorIndices = 1:length(XFrequencies); 
    FrequencySelector = ...
        FrequencySelectorIndices( (XFrequencies >= MinFrequency) & ...
        (XFrequencies < MaxFrequency) ); 
    FrequenciesOfInterest = XFrequencies(FrequencySelector); 
    
    Data(i).Frequencies = FrequenciesOfInterest; 
    Data(i).XFrequency = abs(XFrequencyComponent(FrequencySelector)); 
    Data(i).YFrequency = abs(YFrequencyComponent(FrequencySelector)); 
    Data(i).ZFrequency = abs(ZFrequencyComponent(FrequencySelector));     
end