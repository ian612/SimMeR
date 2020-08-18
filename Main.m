clear
close all
clc

%% Initialization
% Data Import
maze = import_maze;
checker = import_checker;

% Build Robot
bot_center = [9.5,40.5];
bot_rot = -30;
bot_perim = import_bot;
bot_pos = pos_update(bot_center, bot_rot, bot_perim);

% Import Sensor Loadout and Positions
sensor = import_sensor; 

% Import Drive information
drive = import_drive;

% Initialize integration-based sensor values
% ------------------------------------------

% Shuffle random number generator seed or set it statically
rng('shuffle') % Use shuffled pseudorandom error generation
% rng(0) % Use consistent pseudorandom error generation

% Send go signal to student algorithm
% -----------------------------------

%% Main Loop
ct = 1;
while ct
    % Listen for command from student algorithm
    cmd = 'i1-1';
    
    % Parse command
    [cmd_type, cmd_id, id_num] = parse_cmd(cmd, sensor, drive);
    
    if cmd_type == 1
        sensor_pos = [sensor.x(id_num), sensor.y(id_num), sensor.z(id_num), sensor.rot(id_num)];
        switch cmd_id
            case 'ultra'
                reply = get_ultrasonic(bot_center, bot_rot, sensor_pos, maze, 1);
            case 'ir'
                reply = get_ir(bot_center, bot_rot, sensor_pos, checker, 1);
            case 'comp'
                reply = get_compass(bot_center, bot_rot, sensor_pos);
            case 'odom'
                reply = get_odometer(bot_center, bot_rot, sensor_pos);
            case 'gyro'
                reply = get_gyroscope(bot_center, bot_rot, sensor_pos);
            otherwise
                error(strcat('Command ID "', cmd_id,'" not recognized.'))
        end
        
    elseif cmd_type == 2
        % Plan the robot's travel path based on the drive command and error
        
        
        % Move the robot along the path, checking for collisions
        
        
        % Make integral sensor measurements
        
        
    else
        disp(strcat('Unrecognized command issued or sensor "',cmd(1:2),'" not found.'));
    end
    
    ct = 0;
end

%% Testing plots
figure(1)
hold on
axis equal

% Maze
plot(checker(:,1),checker(:,2), 'b--')
plot(maze(:,1),maze(:,2), 'k')
xticks(0:12:96)
yticks(0:12:48)

% Robot
%fill(bot_pos(:,1),bot_pos(:,2), 'r')
plot(bot_pos(:,1),bot_pos(:,2), 'k')

% Sensors
