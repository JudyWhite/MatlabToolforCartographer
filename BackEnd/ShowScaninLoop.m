clc; clear all;close all;
%% 逐个显示回环帧与子图的匹配情况

path='/home/yaoshw/Downloads/imurec';
loop = importdata([path '/loop_close.txt']);
scan_index = loop(:,1);
submap_index = loop(:,2);
resolution = 0.02;
for i = 1:length(scan_index)
    scan = importdata([path '/points/pcd_' num2str(scan_index(i)) '.txt']);
    scan_ori = scan;
    % DBSCAN聚类算法
    type = DBSCAN(scan,0.2,80);
    scan(type==0,:)=[];%保留聚类后的点
    
    submap = importdata([path '/precomputationgrid/submap_' num2str(submap_index(i)) '_depth_0.txt']);
%     submap = importdata([path '/submap/submapcon_index' num2str(submap_index(i)) '.txt']);
    submap(submap(:,4)<0.51,:) = [];
    R_in_Loop = quat2rotm(loop(i,end-3:end));
    T_in_Loop = loop(i,end-6:end-4);
    scan_in_loop = R_in_Loop*scan' + T_in_Loop';
    scan_ori_in_loop = R_in_Loop*scan_ori' + T_in_Loop';
    %原点位置
    origi = R_in_Loop*[0;0;0] + T_in_Loop';
    %计算点云匹配得分
%     [CalScanScore(scan_ori_in_loop', submap, 0.02) CalScanScore(scan_in_loop', submap, 0.02)]
    
    %可视化
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
    hold on;
    scatter3(scan_ori_in_loop(1,:)./resolution,scan_ori_in_loop(2,:)./resolution,scan_ori_in_loop(3,:)./resolution,5,'g','filled');
    scatter3(scan_in_loop(1,:)./resolution,scan_in_loop(2,:)./resolution,scan_in_loop(3,:)./resolution,8,'r','filled');
    scatter3(origi(1)./resolution,origi(2)./resolution,origi(3)./resolution,30,'k','filled');
    title(['node: ' num2str(scan_index(i)) ' in submap: ' num2str(submap_index(i))]);
    view(0,90);
    pause(0.1);
    hold off;
end

function [score,p] = CalScanScore(scan, submap, resolution)
% 根据输入的帧,地图以及子图分辨率,计算该帧的平均得分
score = 0;
for i = 1:length(scan)
    score = score + GetProbability(submap,scan(i,:),resolution);
end
score = score/length(scan);
end