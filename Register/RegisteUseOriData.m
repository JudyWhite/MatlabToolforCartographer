close all;
% 以submap_index所在的scan作为子图，以scan_index作为帧与子图进行配准，手动调整deg角度
path = '/home/yaoshw/Downloads';
submap_index = 1;
scan_index = 30;

deg = [0 0 0]; % 角度制
trans = [0.0 0.0 0];
deg = deg*pi/180;
R = eul2rotm(fliplr(deg),'ZYX');
label_pose = importdata([path '/pose info.txt']);
submap = importdata([path '/points/pcd_' num2str(submap_index) '.txt']);
submap_poseT = label_pose(submap_index+1,1:3);
submap_poseR = quat2rotm(label_pose(submap_index+1,4:7));
submap = [submap;[0 0 0];[0 0.2 0];[0 0.4 0]];
submap = submap + trans;
submap = submap_poseR*R*submap' + submap_poseT';
submap = submap';

scan = importdata([path '/points/pcd_' num2str(scan_index) '.txt']);
scan_poseT = label_pose(scan_index+1,1:3);
% scan_poseT = [0 2.0 0];
scan_poseR = quat2rotm(label_pose(scan_index+1,4:7));
scan = [scan;[0 0 0];[0 0.2 0];[0 0.4 0]];
scan = scan + trans;

degt = [0 0 0];
degt = degt*pi/180;
Rt = eul2rotm(fliplr(degt),'ZYX');
transt = [-0.00 0.0 0];
scan = Rt*scan_poseR*R*scan' + scan_poseT' + transt';

figure;
scatter3(submap(:,1),submap(:,2),submap(:,3),5,'g','filled','MarkerFaceAlpha',1.0);
hold on;
scatter3(scan(1,:),scan(2,:),scan(3,:),8,'r','filled');
view(0,90)