function [bot_center, bot_rot, gyro, odom] = rotate_bot(angle, bot_center, bot_rot, odom_pos, odom, gyro, sensor);
%ROTATE_BOT rotates the simulated robot and updates sensor values
%   Detailed explanation goes here

% Update the robot's rotation
new_rot = bot_rot + angle;

for ct = 1:size(odom_pos,1)
    % Determine the r vector
    r = [odom_pos(ct,1:2) 0];
    
    % Determine the unit vector of the direction of the odometer
    th = odom_pos(ct,4);
    v = [cosd(th) sind(th) 0];
    
    % Calculate the movement of the odometer
    crs = cross(r,v);
    distance = 2*pi*crs*angle/360;
    
    % Add Error to the odometer measurement
    dist_error = add_error(distance,odom(ct,2));
    
    % 
    
end

end

