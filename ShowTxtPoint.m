clc;clear all;close all;

path = '/home/yaoshw/CLionProjects/xunyu/wltof-EPC-V0.9.0-R1-Linux-20191015/data';

c = newline;
for i = 135
    pointcloud = importdata([path '/' num2str(i) '_pointcloud.txt' c]);
    pointlength = sqrt(sum(pointcloud.*pointcloud,2));
    pointlength(pointlength>8)=8;
    pointplain = reshape(pointlength,160,60);
    surfc(pointplain);
    xlabel('X');ylabel('Y');zlabel('Z')
    pause(0.1);
end