%% 动态显示前端位姿匹配过程
clc; clear all; close all;

path='/home/yaoshw/Downloads/imurec';
front_prediction_pose = importdata([path '/initial pose in submap.txt']);
fornt_estimate_pose   = importdata([path '/pose info.txt']);

Len=64;
cb=[[linspace(1,0,Len)]',[linspace(1,0,Len)]',[linspace(1,0,Len)]'];

for i = 1:100
    submap = importdata([path '/front_submap/node' num2str(i+3) '_0.txt']);
    point = importdata([path '/front_submap/nodehpd' num2str(i+3) '.txt']);
    
    Tinsub = fornt_estimate_pose(i,8:10);
    Rinsub = quat2rotm(fornt_estimate_pose(i,11:14));
    point = Rinsub*point' + Tinsub';
    point = round(point'./0.02);
    ori = [0,0,0];
    ori = Rinsub*ori' + Tinsub';
    ori = ori'./0.02;
   
%     submap(submap(:,4)<0.101,:)=[];
%     submap(submap(:,3)>-1,:)=[];
%     submap(submap(:,3)<-2,:)=[];
%     point(point(:,3)>-1,:)=[];
%     point(point(:,3)<-2,:)=[];
    submap(submap(:,4)<0.6,:)=[];
    scatter3(submap(:,1),submap(:,2),submap(:,3),20,submap(:,4),'filled');
    colorbar;
    set(gcf,'colormap',cb);
    hold on;
    scatter3(point(:,1),point(:,2),point(:,3),20,'r','filled');
    scatter3(ori(1),ori(2),ori(3),50,'g','filled');
    title(i);
    view(0,90);
    pause(0.01);
    hold off;
end