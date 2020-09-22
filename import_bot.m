function [bot_xy] = import_bot(fname, plotmap)
%IMPORT_BOT Summary of this function goes here
%   Detailed explanation goes here

if ~exist('fname','var')
    fname = 'robot.csv';
end
if ~exist('plotmap','var')
    plotmap = 0;
end

% import robot size definition
bot_params = csvread(strcat('config\',fname),0,1);

% Verify that the robot is smaller than 1 foot by 1 foot
if (bot_params(2) > 12 || bot_params(3) > 12)
    error(strcat('Imported robot is too large, it must be less than 12" x 12". Check',' config\',fname,' to verify dimensions.'));
end
    

if ~bot_params(1)
    d = bot_params(2);
    th = 0:pi/20:2*pi;
    x = d/2 * cos(th);
    y = d/2 * sin(th);
    bot_xy = [x',y'];
else
    x = bot_params(2);
    y = bot_params(3);
    bot_xy = [-x/2, -y/2; ...
              -x/2,  y/2; ...
               x/2,  y/2; ...
               x/2, -y/2; ...
              -x/2, -y/2];
end

% Append a smaller version of the bot to indicate the front (x-direction)
% indicator = 5;
% tiny_xy = (bot_xy + ones(size(bot_xy,1),1) * [(indicator-1)*bot_params(2)/2,0]) / indicator;
% bot_xy = [bot_xy; NaN NaN; flipud(tiny_xy); NaN NaN];

if plotmap
    plot(bot_xy(:,1), bot_xy(:,2))
end

end