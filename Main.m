clear
close all
clc

%% Initialization
% Data Import
maze = import_maze;
checker = import_checker;

% Build Robot
bot_center = [6,42];
bot_rot = 30;
bot_perim = import_bot;
bot_pos = pos_update(bot_center, bot_rot, bot_perim);

% Import Sensor Loadout and Positions
sensor = import_sensor;

% Import Drive information
drive = import_drive;

% Import sensor error profiles
% ----------------------------

% Initialize integration-based sensor values
% ------------------------------------------

% Send go signal to student algorithm
% -----------------------------------

%% Main Loop
ct = 1;
while ct
    % Listen for command from student algorithm
    cmd = 'w2-1';
    
    % Parse command
    [cmd_type, cmd_id, id_num] = parse_cmd(cmd, sensor, drive);
    
    if cmd_type == 1
        
        
        
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
fill(bot_pos(:,1),bot_pos(:,2), 'r')

% Sensors
