clc; clear all; close all;
%% 逐个显示回环帧与子图的匹配情况

path='/home/yaoshw/Downloads/imurec';
loop = importdata([path '/loop_close.txt']);
scan_index = loop(:,1);
submap_index = loop(:,2);
resolution = 0.02;
for i = 1:length(scan_index)
    scan = importdata([path '/points/pcd_' num2str(scan_index(i)) '.txt']);
    submap = importdata([path '/submap/submapcon_index' num2str(submap_index(i)) '.txt']);
    submap(submap(:,4)<0.51,:) = [];
    RinLoop = quat2rotm(loop(i,end-3:end));
    TinLoop = loop(i,end-6:end-4);
    scaninloop = RinLoop*scan' + TinLoop';
    
    origi = RinLoop*[0;0;0] + TinLoop';
    
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,[0.5 0.5 0.5],'filled');
    hold on;
    plot3(scaninloop(1,:)./resolution,scaninloop(2,:)./resolution,scaninloop(3,:)./resolution,'r.');
    scatter3(origi(1)./resolution,origi(2)./resolution,origi(3)./resolution,30,'g','filled');
    title(['node: ' num2str(scan_index(i)) ' in submap: ' num2str(submap_index(i))]);
    view(0,90);
    pause(1);
    hold off;
end