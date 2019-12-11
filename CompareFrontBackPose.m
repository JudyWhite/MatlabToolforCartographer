clc;clear all;close all;
% 调用前端和后端位姿显示函数，最终将前后端的位姿画在一张图上
path = '/home/yaoshw/Downloads';
addpath('/home/yaoshw/matlabcode/Cartographer/FrontEnd');
addpath('/home/yaoshw/matlabcode/Cartographer/BackEnd');
[R_prediction, T_prediction, R_estimate, T_estimate] = ShowFrontPose(path);
[R_back, T_back] = ShowBackPose(path);
close all;
figure;
subplot 311;
plot(T_estimate(:,1),'r--');
hold on;plot(T_back(:,1),'g');
legend('前端','后端');
subplot 312;
plot(T_estimate(:,2),'r--');
hold on;plot(T_back(:,2),'g');
subplot 313;
plot(R_estimate(:,3),'r--');
hold on;plot(R_back(:,3),'g');
figure;
hold on;
for i = 1:length(T_back)
    plot([T_estimate(i,1) T_back(i,1)],[T_estimate(i,2) T_back(i,2)],'k');
end
plot(T_estimate(:,1),T_estimate(:,2),'r');
plot(T_back(:,1),T_back(:,2),'g');