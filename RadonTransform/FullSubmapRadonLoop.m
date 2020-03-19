close all;
%% 利用radon变化的方法，计算point_index在submap_index中的最可能的回环结果
submap_index = 10;
submap_radon_index = 361-3;
point_index = 1097;
resolution = 0.02;
path = '/home/yaoshw/Downloads';

% submap_point = importdata([path '/submap/submapcon_index' num2str(submap_index) '.txt']);
submap_point = importdata([path '/precomputationgrid/submap_' num2str(submap_index) '_depth_0.txt']);
submap_point(submap_point(:,4)<0.51,:) = [];

% method 1
% submap_radon = RadonTransform(submap_point(:,1:3)*0.02,1,3);
% method 2
% submap_radon = importdata([path '/radon/node' num2str(submap_radon_index+3) '.txt']);
% method 3
point_s = importdata([path '/points/pcd_' num2str(submap_radon_index) '.txt']);
submap_radon = RadonTransform(point_s,1,3);

submap_pose = importdata([path '/submap/submap_pose' num2str(submap_index) '.txt']);
submap_poseT = submap_pose(2,1:3);
submap_poseR = quat2rotm(submap_pose(2,4:7));

label_pose = importdata([path '/pose info.txt']);
point = importdata([path '/points/pcd_' num2str(point_index) '.txt']);
point_radon = RadonTransform(point,10,3);
point = [point;[0 0 0]];
point_poseT = label_pose(point_index+1,1:3);
point_poseR = quat2rotm(label_pose(point_index+1,4:7));

label_radon_poseT = label_pose(submap_radon_index+1,1:3);
label_radon_poseR = quat2rotm(label_pose(submap_radon_index+1,4:7));
%根据前端计算出的在子图中的位姿
related_poseR = submap_poseR\point_poseR;
related_poseT = submap_poseR\point_poseT' - submap_poseR\submap_poseT';
scan_in_loop = related_poseR*point' + related_poseT;
fliplr(rotm2eul(related_poseR,'ZYX'))

eul_ang = fliplr(rotm2eul(related_poseR,'ZYX'));
label_radon_related_poseT = submap_poseR\label_radon_poseT' - submap_poseR\submap_poseT';
label_radon_related_poseR = submap_poseR\label_radon_poseR;
point_s_submap = label_radon_related_poseR*point_s' + label_radon_related_poseT;
label_eul_ang = fliplr(rotm2eul(label_radon_related_poseR,'ZYX'));
% initial_angle = eul_ang(3)
initial_angle = eul_ang(3)-label_eul_ang(3)

angles = -0.5:0.017:0.5;
scores = RadonMatcher(submap_radon,point_radon,initial_angle,angles);
selected_angle_pos = find(scores==max(scores));
selected_angle = angles(selected_angle_pos(1))

%画出匹配的六组投影线
% deg = round((0.01 + initial_angle)*180/pi);%angles(selected_angle_pos(1))
% figure;
% for i=1:2
%     subplot(2,3,i);
%     row = deg+(i-1)*30;
%     while(row<0)
%         row = row +360;
%     end
%     while(row>359)
%         row = row - 360;
%     end
%     if(row>179)
%         row = row -180;
%         scan_vec = fliplr(submap_radon(row+1,:));
%     else
%         scan_vec = submap_radon(row+1,:);
%     end
%     plot(scan_vec/max(scan_vec));
%     hold on;
%     plot(point_radon(i,:)/max(point_radon(i,:)));
% end
related_ang = (initial_angle + selected_angle)*180/pi
related_poseRradon = submap_poseR\rotz(selected_angle*180/pi)*point_poseR;
scan_in_loop_rotation = related_poseRradon*point' + related_poseT;
disp('旋转后在子图中位姿的欧拉角');
pose = fliplr(rotm2eul(related_poseRradon,'ZYX'))*180/pi
% score = [CalScanScore(scan_in_loop', submap_point, 0.02) CalScanScore(scan_in_loop_rotation', submap_point, 0.02)]
figure;
plot(angles,scores);
figure;
scatter3(submap_point(:,1),submap_point(:,2),submap_point(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
hold on;
scatter3(point_s_submap(1,:)./resolution,point_s_submap(2,:)./resolution,point_s_submap(3,:)./resolution,8,'r','filled');
scatter3(scan_in_loop(1,:)./resolution,scan_in_loop(2,:)./resolution,scan_in_loop(3,:)./resolution,8,'g','filled');
scatter3(scan_in_loop_rotation(1,:)./resolution,scan_in_loop_rotation(2,:)./resolution,scan_in_loop_rotation(3,:)./resolution,8,'k','filled');
legend('submap','submap radon','scan in submap','rotation scan');
view(0,90);

function score = CalScanScore(scan, submap, resolution)
% 根据输入的帧,地图以及子图分辨率,计算该帧的平均得分
score = 0;
for i = 1:length(scan)
    score = score + GetProbability(submap,scan(i,:),resolution);
end
score = score/length(scan);
end