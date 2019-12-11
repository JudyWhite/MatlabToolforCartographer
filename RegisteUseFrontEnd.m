close all;
% 以submap_index所在的scan作为子图，以scan_index作为帧与子图进行配准，手动调整deg角度
submap_index = 1900;
scan_index = 2100;
resolution = 0.02;
deg = 12;
label_pose = importdata([path '/pose info.txt']);
submap = importdata([path '/points/pcd_' num2str(submap_index) '.txt']);
submap_poseT = label_pose(submap_index+1,1:3);
submap_poseR = quat2rotm(label_pose(submap_index+1,4:7));
submap = submap_poseR*rotz(-deg)*submap' + submap_poseT';
submap = submap';
submap = round(submap./0.02);
% submap = [submap 0.9*ones(size(submap,1),1)];

scan = importdata([path '/points/pcd_' num2str(scan_index) '.txt']);
scan_poseT = label_pose(scan_index+1,1:3);
scan_poseR = quat2rotm(label_pose(scan_index+1,4:7));
scan = scan_poseR*rotz(-deg)*scan' + scan_poseT';
% score = 0;
% p=[];
% for t = -2:2
%     for x = -0.05:0.01:0.05
%         for y = -0.05:0.01:0.05
%             scant=scan+[x y 0.0];
%             scant = rotz(t)*scant';
%             scoret = CalScanScore(scant', submap, 0.02);
%             if scoret > score
%                 score = scoret;
%                 p = [x,y,t];
%             end
%         end
%     end
% end
% score
% p
% scan = rotz(p(3))*scan';
% scan = scan+[p(1);p(2);0.0];
% scan = scan';

% CalScanScore(scan', submap, 0.02)
figure;
scatter3(submap(:,1),submap(:,2),submap(:,3),5,'g','filled','MarkerFaceAlpha',1.0);
hold on;
scatter3(round(scan(1,:)./resolution),round(scan(2,:)./resolution),round(scan(3,:)./resolution),8,'r','filled');
view(0,90)

function score = CalScanScore(scan, submap, resolution)
% 根据输入的帧,地图以及子图分辨率,计算该帧的平均得分
score = 0;
for i = 1:length(scan)
    score = score + GetProbability(submap,scan(i,:),resolution);
end
score = score/length(scan);
end