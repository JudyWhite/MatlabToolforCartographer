clc;clear all;close all;
path = '/home/yaoshw/Downloads';
offset = 250;
map_img = zeros(2*offset,2*offset);
map_point = [];
for i = 1:15
    submap = importdata([path '/submap/submapcon_index' num2str(i) '.txt']);
    submap(submap(:,4)<0.51,:) = [];
    submap(submap(:,3)>1,:) = [];
    submap(submap(:,3)<-1,:) = [];
    submap_pose = importdata([path '/submap/submap_pose' num2str(i) '.txt']);
    submap_poseT = submap_pose(1,1:3);
    submap_poseR = quat2rotm(submap_pose(1,4:7));
    submap_global = submap_poseR*submap(:,1:3)' + submap_poseT'/0.02;
    submap_global = submap_global';
    for j = 1:length(submap_global)
        x = round(submap_global(j,1))+offset;
        y = round(submap_global(j,2))+offset;
        if(map_img(x,y)<0.05)
            map_img(x,y) = submap(j,4);
        else
            map_img(x,y) = UpdateProbability(map_img(x,y),submap(j,4));
        end
    end
    show_img = map_img;
    show_img(show_img<=0.5)=0;
    show_img(show_img>0.5)=1;
    imshow(show_img)
    title(i)
    pause(1)
%     map_point = [map_point;submap_global];
%     for j=1:length(submap_global)
%         map_img(round(submap_global(j,1))+offset,round(submap_global(j,2))+offset) = 1;
%     end
end


% epsilon=10;
% MinPts=80;
% IDX=DBSCAN(map_point,epsilon,MinPts);
% PlotClusterinResult(map_point, IDX);
% view(0,90)
% title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
% pause(0.1)

% imshow(map_img)
% [map,st] = ImgFilter(map_img,3,8);
% % [map,st] = ImgFilter(map,3,2);
% figure;
% imshow(map)
% figure;
% imshow(st./max(max(st)))
% ptCloud = pointCloud(map);
% pcwrite(ptCloud,'p1_as1.ply','PLYFormat','binary');

function p = UpdateProbability(old,new)
p = old*new/(1-old-new+2*old*new);
if p>0.9
    p=0.9;
end
if p<0.1
    p=0.1;
end
end

function [map,st] = ImgFilter(img, s, thr)
map = img;
st = img;
for i = 1:(size(img,1)-s)
    for j = 1:(size(img,2)-s)
        area = img(i:(i+s-1),j:(j+s-1));
        st(i,j) = sum(sum(area));
        if(st(i,j)<thr)
            map(i,j) = 0;
        end
    end
end
end