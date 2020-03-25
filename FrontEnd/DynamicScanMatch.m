%% 动态显示前端位姿匹配过程,
%  显示内容当前scan与scan用于匹配的submap，其submap为更新当前scan之前的内容
close all;

path='/home/yaoshw/Downloads';
front_prediction_pose = importdata([path '/initial pose in submap.txt']);
fornt_estimate_pose   = importdata([path '/pose info.txt']);

Len=64;
cb=[[linspace(1,0,Len)]',[linspace(1,0,Len)]',[linspace(1,0,Len)]'];

for i = 270:273
    submap = importdata([path '/front_submap/node' num2str(i+2) '_0.txt']);
    point = importdata([path '/points/pcd_' num2str(i-1) '.txt']);
    
    Tinsub = fornt_estimate_pose(i,8:10);
    Rinsub = quat2rotm(fornt_estimate_pose(i,11:14));
    point = Rinsub*point' + Tinsub';
    point = round(point'./0.02);
    ori = [0,0,0];
    ori = Rinsub*ori' + Tinsub';
    ori = ori'./0.02;
%     layer = -2;
%     submap(submap(:,4)<0.101,:)=[];
%     submap(submap(:,3)~=layer,:)=[];
%     submap(submap(:,3)<0,:)=[];
%     point(point(:,3)~=layer,:)=[];
%     point(point(:,3)<0,:)=[];
    submap(submap(:,4)<0.51,:)=[];
    scatter3(submap(:,1),submap(:,2),submap(:,3),10,'k','filled','MarkerFaceAlpha',1.0);
%     scatter3(submap(:,1),submap(:,2),submap(:,3),20,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
    colorbar;
    set(gcf,'colormap',cb);
    hold on;
    scatter3(point(:,1),point(:,2),point(:,3),10,'r','filled');
    scatter3(ori(1),ori(2),ori(3),50,'g','filled');
    title(i);
    view(0,90);
    pause(1);
    hold off;
end