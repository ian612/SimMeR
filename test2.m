clear
close all
clc

load('checker.mat')

x = checker(:,1);
y = checker(:,2);
x(isnan(x)) = [];
y(isnan(y)) = [];

%x = checker(2:end,1);
%y = checker(2:end,2);

x = reshape(x,5,[]);
y = reshape(y,5,[]);
%x = x(1:end-1,:);
%y = y(1:end-1,:);

patch(x, y, 'k')