clear
clc
close all

maze = import_maze;
xv = maze(:,1);
yv = maze(:,2);

rng default
xq = rand(500,1)*120 - 12;
yq = rand(500,1)*72 - 12;

in = ~inpolygon(xq,yq,xv,yv);

figure

plot(xv,yv,'LineWidth',2) % polygon
axis equal

hold on
plot(xq(in),yq(in),'r+') % points inside
plot(xq(~in),yq(~in),'bo') % points outside
hold off