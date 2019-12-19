close all;
% 以submap_index所在的scan作为子图，以scan_index作为帧与子图进行配准，手动调整deg角度
path = '/home/yaoshw/Downloads';
submap_index = 0;
scan_index = 100;
resolution = 0.02;
% score = 0;
% pose = [0,0,0];
% submap_t=[];
% scan_t=[];
% for i=-10:10
%     i
%     for j=-10:10
%         for m=-10:10
            deg = [0 0 0]; % 角度制
            deg = deg*pi/180;
            R = eul2rotm(fliplr(deg),'ZYX');
            label_pose = importdata([path '/pose info.txt']);
            submap = importdata([path '/points/pcd_' num2str(submap_index) '.txt']);
            submap_poseT = label_pose(submap_index+1,1:3);
            submap_poseR = quat2rotm(label_pose(submap_index+1,4:7));
            submap = submap_poseR*R*submap' + submap_poseT';
            submap = submap';
            submap = round(submap./0.02);
            submap = [submap 0.9*ones(size(submap,1),1)];
            
            scan = importdata([path '/points/pcd_' num2str(scan_index) '.txt']);
            scan_poseT = label_pose(scan_index+1,1:3);
            scan_poseR = quat2rotm(label_pose(scan_index+1,4:7));
            scan = scan_poseR*R*scan' + scan_poseT';
%             s = CalScanScore(scan', submap, 0.02);
%             if(score<s)
%                 score = s;
%                 pose=[i,j,m];
%                 submap_t = submap;
%                 scan_t = scan;
%             end
%         end
%     end
% end
% submap = submap_t;
% scan = scan_t;

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