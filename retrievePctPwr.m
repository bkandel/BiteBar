function trans_pos_pwrCutoff = retrievePctPwr(Data_Calib, numTransients, ...
    transient_pos, sampling_rate, transLengthPadded, padLength, pctCutoff)

for i = 1:length(Data_Calib)
    for j = 1:3
        for k = 1:(numTransients(i,j) - 1) % m-1 is number of significant transients
            trans_pos_pad{i,j}{k} = CosinePad(transient_pos{i,j}{k}, ...
                sampling_rate, transLengthPadded, padLength); 
            [trans_pos_fft{i,j}{k}, freq_indices{i,j}{k}] = ...
                positiveFFT(trans_pos_pad{i,j}{k}, sampling_rate);
            trans_pos_fft{i,j}{k} = abs(trans_pos_fft{i,j}{k}); 
            trans_pos_pwr{i,j}{k} = cumtrapz(trans_pos_fft{i,j}{k}); 
            trans_pos_pctpwr{i,j}{k} = trans_pos_pwr{i,j}{k}(:) / ...
                trans_pos_pwr{i,j}{k}(end); 
            index = find(trans_pos_pctpwr{i,j}{k} > pctCutoff); 
            trans_pos_pwrCutoff{i,j}(k) = freq_indices{i,j}{k}(index(1)); 
        end
    end
end