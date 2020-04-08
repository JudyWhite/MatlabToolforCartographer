clear all;close all;
%% 逐个显示回环帧与子图的匹配情况
addpath('/home/yaoshw/matlabcode/Cartographer/DBSCAN')
addpath('/home/yaoshw/matlabcode/Cartographer/FrontEnd')
path = '/home/yaoshw/Downloads';
loop = importdata([path '/loop_close.txt']);
label_pose = importdata([path '/pose info.txt']);
scan_index = loop(:,1);
submap_index = loop(:,2);
resolution = 0.02;
score = [];
gap=20;
for i = 1:length(scan_index)
    if(scan_index(i)-gap<0 || scan_index(i)+gap+2>length(label_pose))
        continue;
    end
    %读取回环帧及其前后间隔gap帧的帧
    scan = importdata([path '/points/pcd_' num2str(scan_index(i)) '.txt']);
    scan_left = importdata([path '/points/pcd_' num2str(scan_index(i)-gap) '.txt']);
    scan_right = importdata([path '/points/pcd_' num2str(scan_index(i)+gap) '.txt']);
    scan = [scan;[0 0.2 0];[0 0.4 0];[0 0 0]];
    scan_left = [scan_left;[0 0.2 0];[0 0.4 0];[0 0 0]];
    scan_right = [scan_right;[0 0.2 0];[0 0.4 0];[0 0 0]];
    %读取这三帧的前端位姿
    scan_pose = GetTform(label_pose(scan_index(i)+1,1:7));
    scan_left_pose = GetTform(label_pose(scan_index(i)+1-gap,1:7));
    scan_right_pose = GetTform(label_pose(scan_index(i)+1+gap,1:7));
    %读取子图和其在前端的位姿
    submap = importdata([path '/submap/submapcon_index' num2str(submap_index(i)) '.txt']);
    submap(submap(:,4)<0.51,:) = [];
    submap_pose = importdata([path '/submap/submap_pose' num2str(submap_index(i)) '.txt']);
    submap_pose = GetTform(submap_pose(1,1:7));
    %三帧以前端位姿在子图的变换
    scan_pose_in_submap = submap_pose\scan_pose;
    scan_left_pose_in_submap = submap_pose\scan_left_pose;
    scan_right_pose_in_submap = submap_pose\scan_right_pose;
    
    scan_in_submap = scan_pose_in_submap(1:3,1:3)*scan'+scan_pose_in_submap(1:3,4);
    scan_left_in_submap = scan_left_pose_in_submap(1:3,1:3)*scan_left'+scan_left_pose_in_submap(1:3,4);
    scan_right_in_submap = scan_right_pose_in_submap(1:3,1:3)*scan_right'+scan_right_pose_in_submap(1:3,4);
    
    %读取回环帧在子图中的位姿并计算其他两帧的位姿（As.inv()*Bs = Al.inv()*Bl ----> Bl = Al*As.inv()*Bs）
    scan_pose_in_loop = GetTform(loop(i,end-7:end-1));
    scan_left_pose_in_loop = scan_pose_in_loop/scan_pose_in_submap*scan_left_pose_in_submap;
    scan_right_pose_in_loop = scan_pose_in_loop/scan_pose_in_submap*scan_right_pose_in_submap;
    
    scan_in_loop = scan_pose_in_loop(1:3,1:3)*scan'+scan_pose_in_loop(1:3,4);
    scan_left_in_loop = scan_left_pose_in_loop(1:3,1:3)*scan_left'+scan_left_pose_in_loop(1:3,4);
    scan_right_in_loop = scan_right_pose_in_loop(1:3,1:3)*scan_right'+scan_right_pose_in_loop(1:3,4);
    
    %计算三帧点云在回环地图的得分
    [CalScanScore(scan_left_in_loop', submap, 0.02) CalScanScore(scan_in_loop', submap, 0.02) CalScanScore(scan_right_in_loop', submap, 0.02)]
    
    %可视化
%     subplot 121
    scatter3(submap(:,1),submap(:,2),submap(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
    hold on;
    scatter3(scan_in_loop(1,:)./resolution,scan_in_loop(2,:)./resolution,scan_in_loop(3,:)./resolution,8,'g','filled');
    scatter3(scan_left_in_loop(1,:)./resolution,scan_left_in_loop(2,:)./resolution,scan_left_in_loop(3,:)./resolution,8,'r','filled');
    scatter3(scan_right_in_loop(1,:)./resolution,scan_right_in_loop(2,:)./resolution,scan_right_in_loop(3,:)./resolution,8,'b','filled');

    title(['node: ' num2str(scan_index(i)) ' in submap: ' num2str(submap_index(i))]);
    legend('submap','scan','left scan','right scan');
    view(0,90);
    hold off;
%     subplot 122
%     scatter3(submap(:,1),submap(:,2),submap(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
%     hold on;
%     scatter3(scan_in_submap(1,:)./resolution,scan_in_submap(2,:)./resolution,scan_in_submap(3,:)./resolution,8,'g','filled');
%     scatter3(scan_left_in_submap(1,:)./resolution,scan_left_in_submap(2,:)./resolution,scan_left_in_submap(3,:)./resolution,8,'r','filled');
%     scatter3(scan_right_in_submap(1,:)./resolution,scan_right_in_submap(2,:)./resolution,scan_right_in_submap(3,:)./resolution,8,'b','filled');
% 
%     title(['node: ' num2str(scan_index(i)) ' in submap: ' num2str(submap_index(i))]);
%     legend('submap','scan','left scan','right scan');
%     view(0,90);
%     hold off;
    pause;
    
end

function score = CalScanScore(scan, submap, resolution)
% 根据输入的帧,地图以及子图分辨率,计算该帧的平均得分
score = 0;
for i = 1:length(scan)
    score = score + GetProbability(submap,scan(i,:),resolution);
end
score = score/length(scan);
end

function tform=GetTform(p)
T = p(1:3);
R = quat2rotm(p(4:7));
tform = zeros(4,4);
tform(1:3,1:3)=R;
tform(1:3,4)=T';
tform(4,4)=1;
end