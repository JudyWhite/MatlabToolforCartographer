close all;
submap_index = 41;
submap_radon_index = 5163;
point_index = 700;
resolution = 0.02;
path = '/home/yaoshw/Downloads/imurec';

submap_point = importdata([path '/submap/submapcon_index' num2str(submap_index) '.txt']);
submap_point(submap_point(:,4)<0.51,:) = [];
% submap_radon = RadonTransform(submap_point(:,1:3)*0.02,1,3);
submap_radon = importdata([path '/radon/node' num2str(submap_radon_index+3) '.txt']);
submap_pose = importdata([path '/submap/submap_pose' num2str(submap_index) '.txt']);
submap_poseT = submap_pose(2,1:3);
submap_poseR = quat2rotm(submap_pose(2,4:7));

label_pose = importdata([path '/pose info.txt']);
point = importdata([path '/points/pcd_' num2str(point_index) '.txt']);
point_radon = RadonTransform(point+[-0 0 0],10,3);
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
% initial_angle = eul_ang(3)
label_radon_related_poseR = submap_poseR\label_radon_poseR;
label_eul_ang = fliplr(rotm2eul(label_radon_related_poseR,'ZYX'));
initial_angle = eul_ang(3)-label_eul_ang(3)

angles = -1.0:0.017:1.0;
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
fliplr(rotm2eul(related_poseRradon,'ZYX'))*180/pi
figure;
plot(angles,scores);
figure;
scatter3(submap_point(:,1),submap_point(:,2),submap_point(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
hold on;
scatter3(scan_in_loop(1,:)./resolution,scan_in_loop(2,:)./resolution,scan_in_loop(3,:)./resolution,8,'g','filled');
scatter3(scan_in_loop_rotation(1,:)./resolution,scan_in_loop_rotation(2,:)./resolution,scan_in_loop_rotation(3,:)./resolution,8,'k','filled');
legend('submap','scan in submap','rotation scan');
view(0,90);