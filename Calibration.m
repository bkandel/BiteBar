% This will be used for calibrating the rotational 
% ratemeter. 
clear; clc

%% Load data from definition file
run('~/Dropbox/BiteBlock/Calibrations/Calibration_20111010/Cal_20111010_def.m'); 



%% Calculate amp, DC, phase
for i = 1:length(cal_data) % number of runs
    % Get initial guess for phase, amp, DC
    numCycles(i) = floor(length(cal_data{i}) / omega_init); 
    for j = 1:numCycles(i)
        cycle = cal_data{i}( (1 + (j - 1) * omega_init):(1 + j * omega_init)); 
        maxes{i}(j) = max(cycle); 
        mins{i}(j) = min(cycle); 
        amp{i}(j) = abs((maxes{i}(j) - mins{i}(j)) / 2); 
        DC{i}(j) = (maxes{i}(j) + mins{i}(j)) / 2; 
        phase{i}(j) = find(cycle == maxes{i}(j), 1, 'first') - omega_init/4; 
        % use the location of the first max to 
        % generate a guess for the phase. 
        % First max should occur 1/4 of the way 
        % through the cycle. 
    end
    amp_avg(i) = mean(amp{i}); 
    DC_avg(i) = mean(DC{i});    
    phase_avg(i) = mean(phase{i}); 
    omega(i) = omega_init; 
    
    % make one array with the various numbers 
    % for fitting with fminsearch
    constants(i,:) = [amp_avg(i) DC_avg(i) phase_avg(i) omega(i)];
    
    % Do least-squares optimization
    coeffs = constants(i,:); 
    X = 1:length(cal_data{i}); 
    Y = cal_data{i}; 
    Y = Y'; 
    coeffs_opt(i, 1:4) = fminsearch(@cal_sine, coeffs, [],  X, Y);
    % optional plotting
    subplot(3,7,i); 
    plot(X,Y,X, coeffs_opt(i,2)+ coeffs_opt(i,1) * sin((coeffs_opt(i,3) + X) * 2 * pi / coeffs_opt(i,4))); 
    legend('data', 'fit')
end

% Calculate roll calibrations
x_vec = Freqs; 
fit = polyfit(x_vec, abs(coeffs_opt(1:7, 1))', 1); % take abs value of amplitude
fitted_line = fit(2) + x_vec * fit(1); 
figure; 
plot(x_vec, fitted_line, x_vec, abs(coeffs_opt(1:7, 1))')
legend('data', 'fit')
roll_amp_const = fit(2); 
roll_dc_const = mean(coeffs_opt(1:7, 2));




