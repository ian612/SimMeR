function [drive] = bias_randomize(drive, strength)
%BIAS_RANDOMIZE generates randomized drive biases
%   This function is NOT optimized, don't use it yet

% Set variables if not set by function call
if ~exist('drive','var')
    load('drive.mat');
end
if ~exist('strength','var')
    strength = [0.05, 0.05];
end

% Movement biases
for ct = 1:(length(drive.bias_x)-1)
    drive.bias_x(ct,1) = randn * strength(1);
    drive.bias_y(ct,1) = randn * strength(1);
    drive.bias_r(ct,1) = randn * strength(1) * 10;
end

% Rotation bias
ct = length(drive.bias_x);
drive.bias_x(ct,1) = randn * strength(2) / 360;
drive.bias_y(ct,1) = randn * strength(2) / 360;
drive.bias_r(ct,1) = randn * strength(2) / 360;

end

