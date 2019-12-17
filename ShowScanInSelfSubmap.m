%% 根据指定范围的scan合成子图，观察每一帧在子图中的位置，以前端位姿（IMU）为依据
close all;

path='/home/yaoshw/Downloads';
fornt_estimate_pose   = importdata([path '/pose info.txt']);
% 根据指定范围的scan创建submap
submap = [];
for i = 5900:10:6600
    point = importdata([path '/points/pcd_' num2str(i-1) '.txt']);
    Tinsub = fornt_estimate_pose(i,1:3);
    Rinsub = quat2rotm(fornt_estimate_pose(i,4:7));
    fliplr(rotm2eul(Rinsub,'ZYX'));
    point = Rinsub*point' + Tinsub';
    point = round(point'./0.02);
    submap = [submap;point];
end
% 显示scan在submap中的位置
for i = 5900:10:6600
    point = importdata([path '/points/pcd_' num2str(i-1) '.txt']);
    Tinsub = fornt_estimate_pose(i,1:3);
    Rinsub = quat2rotm(fornt_estimate_pose(i,4:7));
    point = Rinsub*point' + Tinsub';
    point = round(point'./0.02);
    size = 5;
    scatter3(submap(:,1),submap(:,2),submap(:,3),size,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',1.0);
    hold on;
    scatter3(point(:,1),point(:,2),point(:,3),10,'r','filled');
    title(i);
    view(0,90);
    pause(0.1);
    hold off;
end