clear
close all
clc

% Data Import
maze = import_maze;
checker = import_checker;

% Build Robot
bot_center = [0,0];
bot_rot = 0;
bot_perim = import_bot;
bot2 = rotation(bot_perim, 15);

% Import Sensor Loadout and Positions
sensor = import_sensor;

% Testing plots
figure(1)
hold on
% Maze
%plot(checker(:,1),checker(:,2), 'b')
%plot(maze(:,1),maze(:,2), 'k')

% Robot
plot(bot_perim(:,1),bot_perim(:,2))
plot(bot2(:,1),bot2(:,2))

% Sensors
