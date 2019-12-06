clc;clear all;close all
%% matlab常用旋转函数
%% 欧拉角转旋转矩阵
deg = [0.1 0.2 0.3] %xrotate,yrotate,zrotate,弧度制
ang = deg*180/pi;
%欧拉角转旋转矩阵
Rx = makehgtform('xrotate',deg(1)); %得到绕x的四维旋转矩阵
Ry = makehgtform('yrotate',deg(2));
Rz = makehgtform('zrotate',deg(3));
rotx(ang(1)) == Rx(1:3,1:3);
roty(ang(2)) == Ry(1:3,1:3);
rotz(ang(3)) == Rz(1:3,1:3);
% R = eul2rotm(deg,'XYZ');
% Rtmp = Rx*Ry*Rz;
% R == Rtmp(1:3,1:3)

R = eul2rotm(fliplr(deg),'ZYX') %注意参数顺序需要与ZYX顺序一致
Rtmp = Rz*Ry*Rx;
R == Rtmp(1:3,1:3);

%% 欧拉角转四元数
q = angle2quat(deg(3),deg(2),deg(1),'ZYX'); %注意参数顺序需要与ZYX顺序一致
%q = [w x y z]

%% 四元数转欧拉角
[deg_z, deg_y, deg_x] = quat2angle(q,'ZYX'); %注意参数顺序需要与ZYX顺序一致

%% 四元数转旋转矩阵
% q = [w x y z]
R = quat2rotm(q);
% w = q(1);
% x = q(2);
% y = q(3);
% z = q(4);
% R = [1-2*y*y-2*z*z, 2*x*y-2*w*z,    2*x*z+2*w*y;
%     2*x*y+2*w*z,    1-2*x*x-2*z*z,  2*y*z-2*w*x;
%     2*x*z-2*w*y,    2*y*z+2*w*x,    1-2*x*x-2*y*y];

%% 旋转矩阵转欧拉角
deg_r = fliplr(rotm2eul(R,'ZYX')); %注意参数顺序需要与ZYX顺序一致
deg_r == deg;
%% 旋转矩阵转四元数
q = rotm2quat(R)
%q = [w x y z]

%在Matlab里，可以用quatmultiply计算四元数乘法，用quatinv来计算四元数的逆，用quatconj来计算四元数的共轭