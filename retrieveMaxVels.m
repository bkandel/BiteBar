function max_vels = retrieveMaxVels(Data_Calib, transient_vel, ...
    numTransients)

for i = 1:length(Data_Calib)
    for j = 1:3
        for k = 1:(numTransients(i,j) - 1) % as before
            max_vels{i,j}(k) = max(abs(transient_vel{i,j}{k})); 
        end
    end
end