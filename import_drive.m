function [drive] = import_drive(fname)
%IMPORT_DRIVE Imports the drive information from a .csv file
%   This sensor 

if ~exist('fname','var')
    fname = 'drive.csv';
end

% Import the sensor data
drive_raw = readtable(strcat('config\',fname), 'Range', 'A2');
drive_mask = drive_raw{:,3};

% Remove the sensors that aren't enabled in the config file
drive_raw(~drive_mask,:) = [];

% Sort the data into a structure
drive.id = drive_raw{:,1};
drive.char = drive_raw{:,2};
drive.err_onaxis = drive_raw{:,4};
drive.err_offaxis = drive_raw{:,5};
drive.err_rotate = drive_raw{:,6};
drive.bias_onaxis = drive_raw{:,7};
drive.bis_offaxis = drive_raw{:,8};
drive.bis_rotate = drive_raw{:,9};

end

