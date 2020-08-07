function [sensor] = import_sensor(bot_perim, fname, plotmap)
%IMPORT_SENSOR Imports the sensor loadout
%   This sensor 

if ~exist('bot_perim','var')
    bot_perim = [-6, -6; ...
                 -6,  6; ...
                  6,  6; ...
                  6, -6; ...
                 -6, -6];
end
if ~exist('fname','var')
    fname = 'sensors.csv';
end
if ~exist('plotmap','var')
    plotmap = 0;
end

% Import the sensor data
sensor_raw = readtable(strcat('config\',fname), 'Range', 'A2:G19');
sensor_mask = sensor_raw{:,3};

% Remove the sensors that aren't enabled in the config file
sensor_raw(~sensor_mask,:) = [];

% Sort the data into a structure
sensor.id = sensor_raw{:,1};
sensor.char = sensor_raw{:,2};
sensor.x = sensor_raw{:,4};
sensor.y = sensor_raw{:,5};
sensor.z = sensor_raw{:,6};
sensor.rot = sensor_raw{:,7};

% Plot the positions of the sensors on the robot if needed
if plotmap == 1
    figure(1)
    hold on
    plot(bot_perim(:,1), bot_perim(:,2))
    for ct = 1:size(sensor.x,1)
        plot(sensor.x(ct), sensor.y(ct), 'o')
    end
    legend(['Robot outline'; sensor.id])
end

end

