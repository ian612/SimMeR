function [value] = get_odometer(odom, id_num)
%GET_ODOMETER reads the selected stored odometer number
%   Detailed explanation goes here

value = odom(odom(:,1)==id_num,3);

end

