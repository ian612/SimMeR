function [direction] = get_compass(bot_center, bot_rot, sensor_pos)
%GET_COMPASS Returns the output of a simulated compass
%   Detailed explanation goes here

% Determine sensor absolute position
origin = pos_update(bot_center, bot_rot, sensor_pos(1:2));

% Determine sensor absolute orientation
direction_pure = sensor_pos(4) + bot_rot;

% Calculate the error and add it to the measurement
direction = direction_pure;

end

