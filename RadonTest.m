close all;
%% 计算point_index在submap_index中的回环结果,该文件做测试用
addpath('/home/yaoshw/matlabcode/Cartographer/RadonTransform')
submap_index = 1;
submap_radon_index = 34-3; %radon文件夹中从0索引
point_index = 30;
resolution = 0.02;
path = '/home/yaoshw/Downloads';

submap_point = importdata([path '/submap/submapcon_index' num2str(submap_index) '.txt']);
submap_point(submap_point(:,4)<0.51,:) = [];

point_s = importdata([path '/points/pcd_' num2str(submap_radon_index) '.txt']);
submap_radon = RadonTransform(point_s,1,3);

submap_pose = importdata([path '/submap/submap_pose' num2str(submap_index) '.txt']);
submap_poseT = submap_pose(2,1:3);
submap_poseR = quat2rotm(submap_pose(2,4:7));

label_pose = importdata([path '/pose info.txt']);
point = importdata([path '/points/pcd_' num2str(point_index) '.txt']);
point_radon = RadonTransform(point+[0.0 0.0 0],10,3);
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

related_ang = (initial_angle + selected_angle)*180/pi
related_poseRradon = submap_poseR\rotz(selected_angle*180/pi)*point_poseR;
scan_in_loop_rotation = related_poseRradon*point' + related_poseT;
% [x,y] = SolverTranslation(point_s_submap',scan_in_loop_rotation')

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

% function [x,y]=SolverTranslation(submap,scan)
% submap_radon = zeros(3,3*100);
% for i = 0:45:90
%     rotation = rotz(-i);
%     transform_submap = rotation*submap';
%     transform_submap = transform_submap';
%     for j = 1:length(transform_submap)
%         index = floor((transform_submap(j,1)+3)/0.02);
%         if(index<0 || index>(3*100-1))
%             continue;
%         else
%             submap_radon(i/45+1,index+1) = submap_radon(i/45+1,index+1)+1;
%         end
%     end
% end
% scan_radon = zeros(3,3*100);
% for i = 0:45:90
%     rotation = rotz(-i);
%     transform_scan = rotation*scan';
%     transform_scan = transform_scan';
%     for j = 1:length(transform_scan)
%         index = floor((transform_scan(j,1)+3)/0.02);
%         if(index<0 || index>(3*100-1))
%             continue;
%         else
%             scan_radon(i/45+1,index+1) = scan_radon(i/45+1,index+1)+1;
%         end
%     end
% end
% 
% pos1 = SeekSimilar(submap_radon(1,:),scan_radon(1,:))
% pos2 = SeekSimilar(submap_radon(2,:),scan_radon(2,:))
% pos3 = SeekSimilar(submap_radon(3,:),scan_radon(3,:))
% x = pos1*0.02;
% y = pos3*0.02;
% end
% 
% function pos = SeekSimilar(submap,scan)
% score = 0;
% pos = 0;
% len = length(submap);
% figure;
% plot(submap);
% hold on;plot(scan);
% submap = [zeros(1,len),submap,zeros(1,len)];
% index = (len+1):(2*len);
% for i=-len:len
%     subsubmap = submap(index+i);
%     scan_vec_norm = norm(subsubmap);
%     point_vec_norm = norm(scan);
%     normalization = scan_vec_norm*point_vec_norm;
%     if (score < subsubmap*scan'/ normalization)
%         score = subsubmap*scan'/ normalization;
%         pos = i;
%     end
% end
% end