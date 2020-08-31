clear
close all
clc

%% Initialization
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

% Send go signal to student algorithm
% -----------------------------------

%% Main Loop
clc

% Initialization & Flags
collision = 0;
bot_trail = [];
lp = 1;
plot_robot = 1;

while lp
    % Listen for command from student algorithm
    % cmd = 'u1-45';
    cmd = input('Please enter a command in the correct format: ', 's');
    
    % Refresh the plot
    figure(1)
    hold off
    plot(0,0,'k')
    hold on
    
    % Parse command
    [cmd_type, cmd_id, cmd_data, id_num] = parse_cmd(cmd, sensor, drive);
    
    if cmd_type == 1
        sensor_pos = [sensor.x(id_num), sensor.y(id_num), sensor.z(id_num), sensor.rot(id_num)];
        pct_error = sensor.err(id_num); % noise value for sensor (from 0 to 1)
        switch cmd_id
            case 'ultra'
                reply = get_ultrasonic(bot_center, bot_rot, sensor_pos, pct_error, maze, 1);
            case 'ir'
                reply = get_ir(bot_center, bot_rot, sensor_pos, pct_error, checker, 1);
            case 'comp'
                reply = get_compass(bot_center, bot_rot, sensor_pos, pct_error);
            case 'odom'
                reply = get_odometer(odom, id_num);
            case 'gyro'
                reply = get_gyroscope(gyro, id_num);
            otherwise
                error(strcat('Command ID "', cmd_id,'" not recognized.'))
        end
        
    elseif cmd_type == 2
        
        % Determine the position and rotation of any odometers
        odom_pos = [sensor.x(odom(:,1)), sensor.y(odom(:,1)), sensor.z(odom(:,1)), sensor.rot(odom(:,1))];
        
        % Plan a path with segments for the robot to follow
        movement = path_plan(cmd_id, cmd_data, drive);
        
        % Move the robot along the path planned out
        bot_trail = [];
        for ct = 1:size(movement,1)
            % Rotate the robot
            [bot_rot, odom, gyro] = rotate_bot(movement(ct,4), bot_rot, odom_pos, odom, gyro);
            
            % Move the robot
            [bot_center, odom] = move_bot(movement(ct,2:3), bot_center, bot_rot, odom_pos, odom);
            
            % Update the robot position
            bot_pos = pos_update(bot_center, bot_rot, bot_perim);
            
            % Create a movement path trail for the program to plot
            bot_trail = [bot_trail; bot_center];
            
            % Check for any collisions with the maze
            collision = check_collision(bot_pos, maze);
            
            % If there is a collision, end the movement loop
            if collision
                break
            end
            
        end
        
    else
        disp(strcat('Unrecognized command issued or sensor "',cmd(1:2),'" not found.'));
    end
    
    
    % Plotting
    if (plot_robot || collision)
        figure(1)
        axis equal
        xlim(maze_dim(1:2))
        ylim(maze_dim(3:4))

        % Robot
        robot = fill(bot_pos(:,1),bot_pos(:,2), 'g');
        %plot(bot_pos(:,1),bot_pos(:,2), 'k')
        set(robot,'facealpha',.5)

        % Maze
        plot(checker(:,1),checker(:,2), 'b--')
        plot(maze(:,1),maze(:,2), 'k', 'LineWidth', 2)
        xticks(0:12:96)
        yticks(0:12:48)

        % Robot Movement
        if ~isempty(bot_trail)
            plot(bot_trail(:,1), bot_trail(:,2), 'r*-')
        end

        % Allow plot to be refreshed
        hold off
    end
    
    % If there is a collision, throw an error and exit the program
    if collision
        error('The robot has collided with the wall! Simulation ended.')
    end
    
%     lp = 0;
    
end



