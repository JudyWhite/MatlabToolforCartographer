clc;clear all;close all;
path = '/home/yaoshw/Downloads';
map = [];
for i = 0:5
    submap = importdata([path '/submap/submapcon_index' num2str(i) '.txt']);
    submap(submap(:,4)<0.51,:) = [];
    submap = submap(:,1:3);
    submap(submap(:,3)>3,:) = [];
    submap(submap(:,3)<-3,:) = [];
    submap_pose = importdata([path '/submap/submap_pose' num2str(i) '.txt']);
    submap_poseT = submap_pose(1,1:3);
    submap_poseR = quat2rotm(submap_pose(1,4:7));
    submap_global = submap_poseR*submap' + submap_poseT'/0.02;
    submap_global = submap_global';
    map = [map;submap_global];
    scatter3(submap_global(:,1),submap_global(:,2),submap_global(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
    hold on;
end
% ptCloud = pointCloud(map);
% pcwrite(ptCloud,'p1_as1.ply','PLYFormat','binary');