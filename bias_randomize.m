function [drive] = bias_randomize(drive, strength)
%BIAS_RANDOMIZE generates randomized drive biases
%   This function is NOT optimized, don't use it yet

% Set variables if not set by function call
if ~exist('drive','var')
    load('drive.mat');
end
if ~exist('strength','var')
    strength = [0.02, 0.02, 0.02];
end

% X-axis bias
for ct = 1:length(drive.bias_x)
    drive.bias_x(ct,1) = randn * strength(1);
end

% Y-axis bias
for ct = 1:length(drive.bias_y)
    drive.bias_y(ct,1) = randn * strength(2);
end

% Rotation bias
for ct = 1:length(drive.bias_r)
    drive.bias_r(ct,1) = randn * strength(3);
end

end

