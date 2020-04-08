%% 将point_index1和point_index2按照前端位姿（imu结果）绘制在submap_index中
submap_index = 9;
point_index1 = 904;
point_index2 = 2810;
path = '/home/yaoshw/Downloads';
resolution = 0.02;

label_pose = importdata([path '/pose info.txt']);

submap = importdata([path '/submap/submapcon_index' num2str(submap_index) '.txt']);
submap(submap(:,4)<0.51,:) = [];
submap_pose = importdata([path '/submap/submap_pose' num2str(submap_index) '.txt']);
submap_poseT = submap_pose(2,1:3);
submap_poseR = quat2rotm(submap_pose(2,4:7));

point1 = importdata([path '/points/pcd_' num2str(point_index1) '.txt']);
point1 = [point1;[0 0 0]];
scan_label_poseT1 = label_pose(point_index1+1,1:3);
scan_label_poseR1 = quat2rotm(label_pose(point_index1+1,4:7));
label_R1 = submap_poseR\scan_label_poseR1;
label_T1 = submap_poseR\scan_label_poseT1' - submap_poseR\submap_poseT';
scan_label_in_loop1 = label_R1*point1' + label_T1;

point2 = importdata([path '/points/pcd_' num2str(point_index2) '.txt']);
point2 = [point2;[0 0 0]];
scan_label_poseT2 = label_pose(point_index2+1,1:3);
scan_label_poseR2 = quat2rotm(label_pose(point_index2+1,4:7));
label_R2 = submap_poseR\scan_label_poseR2;
label_T2 = submap_poseR\scan_label_poseT2' - submap_poseR\submap_poseT';
scan_label_in_loop2 = label_R2*point2' + label_T2;

figure;
scatter3(submap(:,1),submap(:,2),submap(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
hold on;
scatter3(scan_label_in_loop1(1,:)./resolution,scan_label_in_loop1(2,:)./resolution,scan_label_in_loop1(3,:)./resolution,8,'r','filled');
scatter3(scan_label_in_loop2(1,:)./resolution,scan_label_in_loop2(2,:)./resolution,scan_label_in_loop2(3,:)./resolution,8,'g','filled');
legend('submap','submap radon','scan radon');
view(0,90);
