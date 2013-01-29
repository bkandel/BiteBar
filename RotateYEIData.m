function RotatedData = RotateYEIData(CalibratedData)
% RotateYEIData takes CalibratedData from ReadAndCalibrateYEIData.m and
% rotates it so that the data is centered in the planes of the SCC's.  This
% corresponds to rotating the data 19 degrees about the pitch axis and 45
% degrees about the yaw axis.  
RotationMatrixPitch = makeRotationMatrix(19, 'y') ; 
RotationMatrixYaw   = makeRotationMatrix(45, 'z'); 

for i = 1:length(CalibratedData)
   RotatedData(i).Filename      = CalibratedData(i).Filename ; 
   RotatedData(i).Run           = CalibratedData(i).Run; 
   RotatedData(i).TimeInSeconds = CalibratedData(i).TimeInSeconds; 
   Data = [
       CalibratedData(i).XGyro'; 
       CalibratedData(i).ZGyro'; 
       CalibratedData(i).YGyro';
       ];
   RotatedDataMatrix = RotationMatrixYaw * Data; 
   RotatedDataMatrix = RotationMatrixPitch * Data; 
   RotatedData(i).XGyro = RotatedDataMatrix(1, :); 
   RotatedData(i).YGyro = RotatedDataMatrix(3, :); 
   RotatedData(i).ZGyro = RotatedDataMatrix(2, :);    
end