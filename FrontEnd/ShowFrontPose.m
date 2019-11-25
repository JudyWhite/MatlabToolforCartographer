function [R_prediction, T_prediction, R_estimate, T_estimate] = ShowFrontPose(path)
%% 计算前端初始位姿和优化后的位姿的平移及其旋转的欧拉角
front_prediction_pose = importdata([path '/initial pose in submap.txt']);
fornt_estimate_pose = importdata([path '/pose info.txt']);

T_prediction=[];
T_estimate=[];
R_prediction=[];
R_estimate=[];

for i=1:length(fornt_estimate_pose)
    pose_preT=front_prediction_pose(i,1:3);
    pose_preR=quat2rotm(front_prediction_pose(i,4:7));
    pose_estT=fornt_estimate_pose(i,1:3);
    pose_estR=quat2rotm(fornt_estimate_pose(i,4:7));
    
    T_prediction=[T_prediction;pose_preT];
    T_estimate=[T_estimate;pose_estT];
    eulerAngles = fliplr(rotm2eul(pose_preR,'ZYX'));
    R_prediction=[R_prediction;eulerAngles];
    eulerAngles = fliplr(rotm2eul(pose_estR,'ZYX'));
    R_estimate=[R_estimate;eulerAngles];
end
figure;
subplot 311
plot(T_prediction(:,1),'r')
hold on;plot(T_estimate(:,1),'g')
title("前端结果每帧位姿在三个轴上的变化")
subplot 312
plot(T_prediction(:,2),'r')
hold on;plot(T_estimate(:,2),'g')
subplot 313
plot(T_prediction(:,3),'r')
hold on;plot(T_estimate(:,3),'g')

figure;
subplot 311
plot(R_prediction(:,1),'r')
hold on;plot(R_estimate(:,1),'g--')
title("前端结果每帧位姿旋转欧拉角变化")
subplot 312
plot(R_prediction(:,2),'r')
hold on;plot(R_estimate(:,2),'g--')
subplot 313
plot(R_prediction(:,3),'r')
hold on;plot(R_estimate(:,3),'g--')
end