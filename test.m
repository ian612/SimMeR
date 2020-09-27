clear
close all
clc

% Initialize tcp server to read and respond to algorithm commands
[s_cmd, s_rply] = tcp_setup();
fopen(s_cmd);
fopen(s_rply);

% Robot Sensor Measurements
u = [0,0,0,0,0];  % Ultrasonic measurements
pos = [0,0,0];  % Position (x,y,rotation)
speed = 2;
rot_stuck = 90;
stepcount = 0;

while 1
    
    % Take Measurements
    for ct = 1:5
        pollstr = strcat('u',num2str(ct));
        u(ct) = tcpclient_write(pollstr, s_cmd, s_rply);
    end
    disp(u)
    
    ir = tcpclient_write('i1', s_cmd, s_rply);
    
    % Pick random direction, left or right, to try travelling in
    direct_i = randperm(2,2)*2;
    direct = -direct_i*90+270;
    
    for ct = 1:2
        if  (u(1) > 4) && (u(2) > 1.5) && (u(4) > 1.5)
            
            % If the way ahead is clear, go forward
            pollstr = strcat('d1-',num2str(speed));             % Build command string to move bot
            reply = tcpclient_write(pollstr, s_cmd, s_rply);
            break
            
        elseif u(direct_i(ct)) > 4
            
            % If not, pick a random direction that is clear and go that way
            pollstr = strcat('r1-',num2str(direct(ct)));  % Build command string to rotate bot
            reply = tcpclient_write(pollstr, s_cmd, s_rply);
            
            pollstr = strcat('d1-',num2str(speed));             % Build command string to move bot
            reply = tcpclient_write(pollstr, s_cmd, s_rply);
            break
        elseif ct == 2
            
            % If no directions clear, turn to the left
            pollstr = strcat('r1-',num2str(rot_stuck));    % Rotate if stuck
            reply = tcpclient_write(pollstr, s_cmd, s_rply);
            
        end
    end
    stepcount = stepcount+1;
    
end