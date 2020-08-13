function [vR] = rotation(v, th)
%ROTATION Rotates an input vector about its axis
%   v is the vector, th is the rotation in degrees, vR is
%   the rotated output vector

% 2D rotation matrix
R = [cosd(th), -sind(th); sind(th), cosd(th)];

vR = v*R;

end

