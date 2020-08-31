function [value] = get_odometer(odom, id_num)
%GET_ODOMETER reads the selected stored odometer value
%   Reads the stored odometer value and formats it in a way that can be
%   interpreted by the control algorithm

value = odom(odom(:,1)==id_num,3);
 
end

