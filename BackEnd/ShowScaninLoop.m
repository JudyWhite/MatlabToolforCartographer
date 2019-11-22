clc; clear all; close all;
%% 逐个显示回环帧与子图的匹配情况

path='/home/yaoshw/Downloads';
loop = importdata([path '/loop_close.txt']);
scan_index = loop(:,1);
submap_index = loop(:,2);
for i = 1:length(scan_index)
    scan = importdata([path '/points/pcd_' num2str(scan_index(i)) '.txt']);
    submap = import([path '/submap/submap_index' num2str(submap_index(i)) '.txt']);
    RinLoop = quat2rotm(loop(i,end-3:end));
    TinLoop = loop(i,end-6:end-4);
    scaninloop = RinLoop*scan' + TinLoop';
    figure;
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,[0.5 0.5 0.5],'filled');
    hold on;
    plot3(transpcdinloop(1,:)./resolution,transpcdinloop(2,:)./resolution,transpcdinloop(3,:)./resolution,'g.');
    title(['node: ' num2str(scan_index(i)) ' in submap: ' num2str(submap_index(i))]);
    pause(1);
end