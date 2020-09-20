function [pct_black] = get_ir(bot_center, bot_rot, sensor_pos, pct_error, checker, plotmap)
%GET_IR Returns the output of a simulated IR sensor
%   Detailed explanation goes here

% Constants
fov = 40; % sensor full-width field of view
num_pts = 121; % number of points in IR sensor view bounding circle

if ~exist('plotmap','var')
    plotmap = 0;
end

% Determine sensor absolute position
origin = pos_update(bot_center, bot_rot, sensor_pos(1:2));

% Determine the sensor view area based on the z-position
r = sensor_pos(3)*tand(fov/2); % Sensor fov radius on the ground

% Generate a grid of points to test the checkerboard pattern with
[x, y] = meshgrid(linspace(-r,r,13), linspace(-r,r,13));
pts = [x(:), y(:)];

th = linspace(0,360,num_pts)';
circle = [r.*cosd(th), r.*sind(th)];

% Trim the grid of points to a circular shape
in = inpolygon(pts(:,1), pts(:,2), circle(:,1), circle(:,2));
pts(~in,:) = [];

% Calculate all the points inside the checkerboard
pts = pts + origin.*ones(size(pts)); % place all points to check in correct absolute position
in = inpolygon(pts(:,1), pts(:,2), checker(:,1), checker(:,2));
pts_in = pts;       % copy the list of points to check
pts_in(~in,:) = []; % remove points that are not within a checkerboard square

% Determine the percentage of points that are located in black squares
pct_black_pure = size(pts_in,1)/size(pts,1);

% Calculate the error and add it to the measurement
pct_black = add_error(pct_black_pure, pct_error, [0,1]);

if plotmap
    figure(1)
    hold on
    plot(pts(:,1), pts(:,2), 'ro')
    plot(origin(1), origin(2), 'b*')
    plot(pts_in(:,1), pts_in(:,2), 'kx')
    circle_plot = circle + origin.*ones(size(circle));
    plot(circle_plot(:,1), circle_plot(:,2), 'b')
end
end

