function [value] = get_gyroscope(gyro, id_num)
%GET_GYROSCOPE reads the selected stored gyroscope value
%   Reads the stored odometer value and formats it in a way that can be
%   interpreted by the control algorithm

value = gyro(gyro(:,1)==id_num,3);

end
