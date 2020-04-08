close all;
%% 读取BAB结果，显示
submap_index = 1;
submap_radon_index = 166;
point_index = 5760;
resolution = 0.02;
path = '/home/yaoshw/Downloads';

%% 是否达到最低分辨率要求
lowres = importdata([path '/BAB/LowResCan_' num2str(submap_index) '_node_' num2str(point_index) '.txt']);
max_score = lowres(lowres(:,2)==max(lowres(:,2)),2)
if max_score>0.8
    submap_point = importdata([path '/precomputationgrid/submap_' num2str(submap_index) '_depth_1.txt']);
    
    point = importdata([path '/points/pcd_' num2str(point_index) '.txt']);
    BAB = importdata([path '/BAB/submap_' num2str(submap_index) '_node_' num2str(point_index) '.txt']);
    BAB = sortrows(BAB,[4 5 6]);
    
    high_level = find(BAB(:,1)==min(BAB(:,1)));
    candidate_index = high_level(find(BAB(high_level,2)==max(BAB(high_level,2))));
    candidate_index
    pointT = BAB(candidate_index(1),4:6);
    pointR = quat2rotm(BAB(candidate_index(1),7:10));
    transf_point = pointR*point'+pointT';
    % transf_point = transf_point + [0.04 0 0]';
    BAB_result = BAB(candidate_index(1),1:2)
%     [BAB(candidate(1),2) CalScanScore1(transf_point', submap_point, resolution)]
    
    submap_point(submap_point(:,4)<0.51,:) = [];
    
    figure;
    scatter3(submap_point(:,1),submap_point(:,2),submap_point(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
    hold on;
    scatter3(transf_point(1,:)./resolution,transf_point(2,:)./resolution,transf_point(3,:)./resolution,8,'r','filled');
    legend('submap','scan in submap');
    view(0,90);
end

function score = CalScanScore(scan, submap, resolution)
% 根据输入的帧,地图以及子图分辨率,计算该帧的平均得分
score = 0;
for i = 1:length(scan)
    score = score + GetProbability(submap,scan(i,:),resolution);
end
score = score/length(scan);
end

function score = CalScanScore1(scan, submap, resolution)
% 根据输入的帧,地图以及子图分辨率,计算该帧的平均得分
score = 0;
for i = 1:length(scan)
    index = round(scan(i,:)/resolution);
    pos = find(submap(:,1)==index(1)&submap(:,2)==index(2)&submap(:,3)==index(3));
    if(isempty(pos))
        p=0.1;
    else
        p=submap(pos(1),4);
    end
    score = score + p;
end
score = score/length(scan);
end