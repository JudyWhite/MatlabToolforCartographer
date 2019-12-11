clear all;close all;
%% 逐个显示回环帧与子图的匹配情况
addpath('/home/yaoshw/matlabcode/Cartographer/DBSCAN')
addpath('/home/yaoshw/matlabcode/Cartographer/FrontEnd')
path = '/home/yaoshw/Downloads';
loop = importdata([path '/loop_close.txt']);
loop_bc = importdata([path '/loop_close_bc.txt']);
label_pose = importdata([path '/pose info.txt']);
scan_index = loop(:,1);
submap_index = loop(:,2);
resolution = 0.02;
score = [];
for i = 186%1:length(scan_index)
    scan_ori = importdata([path '/points/pcd_' num2str(scan_index(i)) '.txt']);
    scan_ori = [scan_ori;[0 0 0]];%增加一个原点
    scan_seg = scan_ori;
    % DBSCAN聚类算法
    type = DBSCAN(scan_seg,0.2,80);
    scan_seg(type==0,:)=[];%保留聚类后的点
    
%     submap = importdata([path '/precomputationgrid/submap_' num2str(submap_index(i)) '_depth_0.txt']);
    submap = importdata([path '/submap/submapcon_index' num2str(submap_index(i)) '.txt']);
    submap(submap(:,4)<0.51,:) = [];
    submap = [submap;[0 0 0 1]];
    bc_index = find(loop_bc(:,1)==scan_index(i)&loop_bc(:,2)==submap_index(i));
    R_in_Loop_bc = quat2rotm(loop_bc(bc_index,end-3:end));
    T_in_Loop_bc = loop_bc(bc_index,end-6:end-4);
    R_in_Loop = quat2rotm(loop(i,end-3:end));
    T_in_Loop = loop(i,end-6:end-4);
    %点云变换
    scan_seg_in_loop = R_in_Loop*scan_seg' + T_in_Loop';
    scan_ori_in_loop = R_in_Loop*scan_ori' + T_in_Loop';
    scan_ori_in_loop_bc = R_in_Loop_bc*scan_ori' + T_in_Loop_bc';
    %Label Pose计算
    scan_label_poseT = label_pose(scan_index(i)+1,1:3);
    scan_label_poseR = quat2rotm(label_pose(scan_index(i)+1,4:7));
    submap_pose = importdata([path '/submap/submap_pose' num2str(submap_index(i)) '.txt']);
    submap_poseT = submap_pose(2,1:3);
    submap_poseR = quat2rotm(submap_pose(2,4:7));
    label_R = submap_poseR\scan_label_poseR;
    label_T = submap_poseR\scan_label_poseT' - submap_poseR\submap_poseT';
    scan_label_in_loop = label_R*scan_ori' + label_T;
    %直方图结果
    histogram = importdata([path '/histogram/se_submap_' num2str(submap_index(i)) '_node_' num2str(scan_index(i)) '.txt']);
    hist_pose = find(histogram(:,4)==max(histogram(:,4)));
    hist_pose_T = histogram(hist_pose(1),end-6:end-4);
    hist_pose_R = quat2rotm(histogram(hist_pose(1),end-3:end));
%     hist_pose_R = [1 0 0;0 1 0;0 0 1];
    scan_hist_in_loop = hist_pose_R*scan_ori' + hist_pose_T';
    fliplr(rotm2eul(hist_pose_R,'ZYX'))
    %计算点云匹配得分
    score = [score;[CalScanScore(scan_ori_in_loop', submap, 0.02) CalScanScore(scan_label_in_loop', submap, 0.02)]];
    %可视化
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
    hold on;
    scatter3(scan_label_in_loop(1,:)./resolution,scan_label_in_loop(2,:)./resolution,scan_label_in_loop(3,:)./resolution,8,'g','filled');
    scatter3(scan_hist_in_loop(1,:)./resolution,scan_hist_in_loop(2,:)./resolution,scan_hist_in_loop(3,:)./resolution,8,'k','filled');
    scatter3(scan_ori_in_loop_bc(1,:)./resolution,scan_ori_in_loop_bc(2,:)./resolution,scan_ori_in_loop_bc(3,:)./resolution,8,'b','filled');
    scatter3(scan_ori_in_loop(1,:)./resolution,scan_ori_in_loop(2,:)./resolution,scan_ori_in_loop(3,:)./resolution,8,'r','filled');
    title(['node: ' num2str(scan_index(i)) ' in submap: ' num2str(submap_index(i))]);
    legend('submap','IMU position','histogram position','BAB position','Ceres position');
    view(0,90);
    pause(1);
    hold off;
end

function score = CalScanScore(scan, submap, resolution)
% 根据输入的帧,地图以及子图分辨率,计算该帧的平均得分
score = 0;
for i = 1:length(scan)
    score = score + GetProbability(submap,scan(i,:),resolution);
end
score = score/length(scan);
end