function [R_back, T_back] = ShowBackPose(path)
%% 计算前端初始位姿和优化后的位姿的平移及其旋转的欧拉角
back_pose = importdata([path '/node_pose.txt']);

T_back=[];
R_back=[];

for i=1:length(back_pose)
    pose_estT=back_pose(i,1:3);
    pose_estR=quat2rotm(back_pose(i,4:7));
    
    T_back=[T_back;pose_estT];
    eulerAngles = fliplr(rotm2eul(pose_estR,'ZYX'));
    R_back=[R_back;eulerAngles];
end
% figure;
% subplot 311
% hold on;plot(T_back(:,1),'g')
% title("后端结果每帧位姿在三个轴上的变化")
% subplot 312
% hold on;plot(T_back(:,2),'g')
% subplot 313
% hold on;plot(T_back(:,3),'g')
% 
% figure;
% subplot 311
% hold on;plot(R_back(:,1),'g')
% title("后端结果每帧位姿旋转欧拉角变化")
% subplot 312
% hold on;plot(R_back(:,2),'g')
% subplot 313
% hold on;plot(R_back(:,3),'g')
end