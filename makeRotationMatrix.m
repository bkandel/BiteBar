function ROTMATRIX = makeRotationMatrix(angle, axis) 
% makeRotationMatrix creates a rotation matrix given an angle and axis. 
% The angle is given in degrees.  Rotations are counterclockwise through
% the x, y, z axes.  x is the roll axis; y is the pitch axis; and z is the
% yaw axis. 
% angle is a scalar; axis is a string that can be 'x', 'y', or 'z'. 

cAngle = cosd(angle); 
sAngle = sind(angle);

if axis == 'x'
    ROTMATRIX = [
        1 0 0; 
        0 cAngle -sAngle; 
        0 sAngle cAngle; 
        ]; 
elseif axis == 'y'
    ROTMATRIX = [
        cAngle 0 sAngle; 
        0 1 0; 
        -sAngle 0 cAngle; 
        ];
elseif axis == 'z'
    ROTMATRIX = [
        cAngle -sAngle 0; 
        sAngle cAngle 0; 
        0 0 1'
        ];
else 'Error: Invalid Entry'; return 
    
end