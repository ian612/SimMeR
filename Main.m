clear
close all
clc

%% Initialization
disp('Please wait while the simulation loads...')

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

gyro = [gyro_num', zeros(size(gyro_num))'];
odom = [odom_num', zeros(size(odom_num))'];

% Shuffle random number generator seed or set it statically
rng('shuffle') % Use shuffled pseudorandom error generation
% rng(0) % Use consistent pseudorandom error generation

% Send go signal to student algorithm
% -----------------------------------

%% Main Loop
clc
ct = 1;
while ct
    % Listen for command from student algorithm
    cmd = 'i1-1';
    
    % Parse command
    [cmd_type, cmd_id, cmd_data, id_num] = parse_cmd(cmd, sensor, drive);
    
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
        
        % Determine the position and rotation of any odometers
        odom_pos = [sensor.x(odom(:,1)), sensor.y(odom(:,1)), sensor.z(odom(:,1)), sensor.rot(odom(:,1))];
        
        % Plan a path with segments for the robot to follow
        movement = path_plan(cmd_id, cmd_data, bot_center, bot_rot, bot_perim, maze, drive);
        
        
        
        % Based on the command, add some error
        switch cmd_id
            case 'fwd'
                w
            case 'back'
                s
            case 'left'
                a
            case 'right'
                d
            case 'rot'
                r
            otherwise
                error(strcat('Command ID "', cmd_id,'" not recognized.'))
        end
        
        % Plan the robot's travel path based on the drive command and error
        
        
        % Move the robot along the path, checking for collisions
        new_center = bot_center;
        new_rot = bot_rot;
        new_perim = bot_perim;
        
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
