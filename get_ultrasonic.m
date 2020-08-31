function [range] = get_ultrasonic(bot_center, bot_rot, sensor_pos, pct_error, maze, plotmap)
%GET_ULTRASONIC Generates a simulated ultrasonic sensor reading
%   Detailed explanation goes here

% Constants
ray_length = 108; % length of the ray to draw/check for intersection with walls
fov = 10; % Field of view of the sensor, to be implemented later

if ~exist('plotmap','var')
    plotmap = 0;
end

% Determine sensor absolute position
origin = pos_update(bot_center, bot_rot, sensor_pos(1:2));

% Determine sensor absolute orientation
rot = sensor_pos(4) + bot_rot;

% Draw line between the sensor and an arbitrary point. This should be
% longer than the hypotenuse of the maze, so it's not range limited.
ray = [origin; pos_update(origin, rot, [ray_length,0])];

% Calculate all the intersection points
[x,y] = intersections(ray(:,1), ray(:,2), maze(:,1), maze(:,2));

% Keep only the first value, it should be the one closest to the origin.
% Calculate the range from the sensor to the maze
range_pure = sqrt((origin(1) - x(1))^2 + (origin(2) - y(1))^2);

% Calculate the error and add it to the measurement
range = add_error(range_pure,pct_error);

if plotmap
    figure(1)
    hold on
    plot(ray(:,1), ray(:,2), 'r')
    plot(origin(1), origin(2), 'b*')
    plot(x(1), y(1), 'ko')
end
end

