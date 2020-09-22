function [maze, maze_dim, checker, bot_center, bot_rot, bot_perim,...
          bot_pos, sensor, drive, gyro_num, odom_num, gyro, odom,...
          collision, bot_trail, plot_robot] = sim_init
%SIM_INIT Initializes the simulator
%   This function initializes the simulator, setting up the maze and
%   loading any constants. This can be called at the beginning of the
%   student algorithm if they want to simulate a robot.

disp('Please wait while the simulation loads...')

% Data Import
maze = import_maze;
maze_dim = [min(maze(:,1)), max(maze(:,1)), min(maze(:,2)), max(maze(:,2))];
checker = import_checker;

% Build Robot
bot_center = [9.5,40.5];
bot_rot = 0;
bot_perim = import_bot;
bot_pos = pos_update(bot_center, bot_rot, bot_perim);

% Import Sensor Loadout and Positions
sensor = import_sensor; 

% Import Drive information
drive = import_drive;

% Initialize integration-based sensor values
gyro_num = [];
odom_num = [];
for ct = 1:size(sensor.id)
    if strcmp('gyro', sensor.id{ct}(1:end-1))
        gyro_num = [gyro_num ct];
    end
    if strcmp('odom', sensor.id{ct}(1:end-1))
        odom_num = [odom_num ct];
    end
end

% Populate the gyroscope and odometer sensor variables
gyro = [gyro_num', sensor.err(gyro_num'), zeros(size(gyro_num))'];
odom = [odom_num', sensor.err(odom_num'), zeros(size(odom_num))'];

% Shuffle random number generator seed or set it statically
rng('shuffle') % Use shuffled pseudorandom error generation
% rng(0) % Use consistent pseudorandom error generation

% Flags
collision = 0;
bot_trail = [];
plot_robot = 1;

end

