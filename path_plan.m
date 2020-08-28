function [movement] = path_plan(cmd_id, cmd_data, bot_center, bot_rot, bot_perim, maze, drive)
%PATH_PLAN Plans a path for a robot to follow
%   This function takes in data about the robot and maze and outputs a set
%   of movements for the robot to follow. An ideal final position is
%   generated (relative to the start position), then that is broken up into
%   segments. Each segment consists of both a movement and rotation. A
%   different function will convert the relative motion segments into
%   the global coordinate system.
%   
%   movement is a matrix indicating how the robot should move on its path
%   to properly simulate the command given to it by the user, including
%   errors. Each row indicated a movement action. Another function reads in
%   this data, using it to move the robot in the simulated maze.
%   
%   [id number, rotation, x distance, y distance]
%   
%   id number - the number of the movement
%   rotation - rotation in degrees (always takes place before x-y movement
%   x distance - the x distance to move in inches
%   y distance - the y distance to move in inches


% Constants
num_segments = 10;

% Preallocation of variables
x = 0;
y = 0;
r = 0;

% Determine the new target position/rotation
switch cmd_id
    case 'fwd'
        y = cmd_data;
        x_error = [drive.bias_x(1) drive.drive.err_x(1)];
        y_error = [drive.bias_y(1) drive.drive.err_y(1)];
        r_error = [drive.bias_r(1) drive.drive.err_r(1)];
    case 'back'
        y = -cmd_data;
        x_error = [drive.bias_x(2) drive.drive.err_x(2)];
        y_error = [drive.bias_y(2) drive.drive.err_y(2)];
        r_error = [drive.bias_r(2) drive.drive.err_r(2)];
    case 'left'
        x = -cmd_data;
        x_error = [drive.bias_x(3) drive.drive.err_x(3)];
        y_error = [drive.bias_y(3) drive.drive.err_y(3)];
        r_error = [drive.bias_r(3) drive.drive.err_r(3)];
    case 'right'
        x = cmd_data;
        x_error = [drive.bias_x(4) drive.drive.err_x(4)];
        y_error = [drive.bias_y(4) drive.drive.err_y(4)];
        r_error = [drive.bias_r(4) drive.drive.err_r(4)];
    case 'rot'
        r = cmd_data;
        x_error = [drive.bias_x(5) drive.drive.err_x(5)];
        y_error = [drive.bias_y(5) drive.drive.err_y(5)];
        r_error = [drive.bias_r(5) drive.drive.err_r(5)];
    otherwise
        error(strcat('Command ID "', cmd_id,'" not recognized.'))
end

% Break up into the number of segments specified
movement = [(1:num_segments)', ones(num_segments,1)*x/num_segments, ones(num_segments,1)*y/num_segments, ones(num_segments,1)*r/num_segments];



end

