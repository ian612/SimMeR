clear
clear global
close all
clc

%% Initialization
disp('Please wait while the simulation loads...')

% Global Plotting Variables
global ray_plot
global rayend_plot
global ir_pts
global ir_pts_in
global ir_circle

% Loop Variable Initialization & Flags
collision = 0;
bot_trail = [];
randerror = 1;	% Use either a random error generator (1) or consistent error generation (0)
randbias = 0;	% Use a randomized, normally distributed set of drive biases
strength = [0.03, 0.03, 0.03];  % How intense the drive bias is
sim = 1;        % Use the simulator (1) or connect to robot via bluteooth (0)
plot_robot = 1; % Plot the robot as it works its way through the maze
plot_sense = 1; % Plot sensor interactions with maze, if relevant
step_time = 0;  % Pause time between the algorithm executing commands
firstrun = 1;   % Flag indicating if this is the first time through the loop
firstULTRA = 1; % Flag indicating if an ultrasonic sensor has been used yet
firstIR = 1;    % Flag indicating if an IR sensor has been used yet

% Data Import
maze = import_maze;
maze_dim = [min(maze(:,1)), max(maze(:,1)), min(maze(:,2)), max(maze(:,2))];
checker = import_checker;

% Build Robot
bot_center = [9.5,41];
bot_rot = 0;
bot_perim = import_bot;
bot_pos = pos_update(bot_center, bot_rot, bot_perim);
bot_front = [0.75*max(bot_perim(:,1)),0];

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

%% Act on initialization flags

% Shuffle random number generator seed or set it statically
if randerror
    rng('shuffle') % Use shuffled pseudorandom error generation
else
    rng(0) % Use consistent pseudorandom error generation
end

% Randomize drive biases to verify algorithm robustness
if randbias
    drive = bias_randomize(drive, strength);
end

% Create the plot
if plot_robot
    fig = figure(1);
    axis equal
    hold on
    xlim(maze_dim(1:2))
    ylim(maze_dim(3:4))

    % Maze
    checker_plot = plot_checker(checker);
    plot(maze(:,1),maze(:,2), 'k', 'LineWidth', 2)
    xticks(0:12:96)
    yticks(0:12:48)
end

%% Initialize tcp server to read and respond to algorithm commands
clc  % Clear loading message
disp('Simulator initialized... waiting for connection from client')
[s_cmd, s_rply] = tcp_setup('server', 9000, 9001);
fopen(s_cmd);
fopen(s_rply);

clc
disp('Client connected!')

%% Main Loop

while sim
    
    % Clear the Ultrasonic and IR sensor plots
    if plot_sense
        plot_clearsense(~firstULTRA, ~firstIR)
    end
    
    % Receive data from the algorithm over the TCP socket
    tcp_data = 0;
    while ~tcp_data
        if s_cmd.BytesAvailable > 0
            cmd = char(fread(s_cmd, s_cmd.BytesAvailable, 'uint8'))';
            tcp_data = 1;
            disp(cmd)
        end
    end
    
    % Parse command
    [cmd_type, cmd_id, cmd_data, id_num] = parse_cmd(cmd, sensor, drive);
    
    % If command is a sensor data request
    if cmd_type == 1
        sensor_pos = [sensor.x(id_num), sensor.y(id_num), sensor.z(id_num), sensor.rot(id_num)];
        pct_error = sensor.err(id_num); % noise value for sensor (from 0 to 1)
        switch cmd_id
            case 'ultra'
                reply = get_ultrasonic(bot_center, bot_rot, sensor_pos, pct_error, maze, firstULTRA, plot_sense);
                firstULTRA = 0;
            case 'ir'
                reply = get_ir(bot_center, bot_rot, sensor_pos, pct_error, checker, firstIR, plot_sense);
                firstIR = 0;
            case 'comp'
                reply = get_compass(bot_center, bot_rot, sensor_pos, pct_error);
            case 'odom'
                reply = get_odometer(odom, id_num);
            case 'gyro'
                reply = get_gyroscope(gyro, id_num);
            otherwise
                error(strcat('Command ID "', cmd_id,'" not recognized.'))
        end
    
    % If command is a movement request
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
        
        % Use Inf to stand in for "movement complete"
        reply = Inf;
        
    else
        disp(strcat('Unrecognized command issued or sensor "',cmd(1:2),'" not found.'));
        % Use NaN to stand in for "Unrecognized command"
        reply = NaN;
    end
    
    % After executing the requested command, plot the result
    if (plot_robot || collision)
        
        % Robot
        if firstrun
            robot = patch(bot_pos(:,1),bot_pos(:,2), 'g');
            set(robot,'facealpha',.5)
        else
            tmpx = bot_pos(:,1);
            tmpy = bot_pos(:,2);
            robot.XData = tmpx;
            robot.YData = tmpy;
        end
        
        % Robot "nose"
        nose = pos_update(bot_center, bot_rot, bot_front);
        if firstrun
            robot_fwd = plot(nose(1), nose(2), 'k*');
            robot_fwd.XDataSource = 'nose(1)';
            robot_fwd.YDataSource = 'nose(2)';
        end
        
        % Robot Movement
        if ~isempty(bot_trail)
            if ~exist('robot_trail', 'var')
                robot_trail = plot(bot_trail(:,1), bot_trail(:,2), 'r*-');
                robot_trail.XDataSource = 'bot_trail(:,1)';
                robot_trail.YDataSource = 'bot_trail(:,2)';
            end
        end
        refreshdata
    end
    
    % Wait before allowing the algorithm to continue
    pause(step_time)
    
    % Return the reply variable to the user algorithm
    fwrite(s_rply, reply, 'double')
    
    % If there is a collision, throw an error and exit the program
    if collision
        error('The robot has collided with the wall! Simulation ended.')
    end
    
    % If not the first run of the loop, set flag to 0
    firstrun = 0;
    
end

% Bluetooth Loop
if ~sim
    
    while ~sim
        
    end
end
