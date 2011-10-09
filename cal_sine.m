function sum_diff_squared = cal_sine(coeffs, X, Y)
% Function used for fitting the sine curves for 
% calibration of the rotational ratemeter using 
% fminsearch.  
% coeffs has the following structure:  Each row 
% is a different run; the three colums are amp, 
% DC, and phase (in that order). 
% omega is the frequency of the rotational 
% ratemeter, which is a constant for each run.
amp = coeffs(1);
DC = coeffs(2);
phase = coeffs(3);
omega = coeffs(4);

Y_calc = DC + amp * sin((phase + X) * 2 * pi / omega); 

diff = Y_calc - Y; 
diff_squared = diff.^2; 
sum_diff_squared = sum(diff_squared); 