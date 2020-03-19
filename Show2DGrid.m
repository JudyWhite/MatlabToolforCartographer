close all;
%% 读取ros发布的地图和pose位姿，根据时间按顺序显示地图和相机位置
path = '/home/yaoshw/Downloads';
% fileFolder=fullfile([path '/submap']);
% dirOutput=dir(fullfile(fileFolder,'2DGrid*.txt'));
fileList = dir([path '/submap/2DGrid*.txt']);
poseList = importdata([path '/2Dpose.txt']);
fileNames={fileList.name};
[baseTime,~,~] = GetXY(fileNames{1});
Ang=[];
for i= 1:length(fileList)
    hold off;
    filePath = [path '/submap/' fileNames{i}];
    [time,x,y] = GetXY(fileNames{i});
    t = time - baseTime;
    
    ori_x = round(x/0.02);
    ori_y = round(y/0.02);
    grid_submap = importdata(filePath);
    grid_submap = grid_submap+1;
    grid_submap = grid_submap/max(max(grid_submap));
    if(-ori_y-3>0 && -ori_x-3>0)
        grid_submap(-ori_y,-ori_x-3:-ori_x+3) = 1;%起始点位置
        grid_submap(-ori_y-3:-ori_y+3,-ori_x) = 1;
    end
    
    pos = find(poseList(:,2)>time);
    if(isempty(pos))
        pos = find(poseList(:,2)<time);
        pos=pos(end);
    end
    nodeX = poseList(pos(1),3);
    nodeY = poseList(pos(1),4);
    Ang = [Ang poseList(pos(1),5)];
    gridX = round((nodeX-x)/0.02);
    gridY = round((nodeY-y)/0.02);
    
    if(gridY-2>0 && gridX-2>0)
        grid_submap(gridY,gridX) = 1;%相机位置
        grid_submap(gridY-1,[gridX-1 gridX+1]) = 1;
        grid_submap(gridY+1,[gridX-1 gridX+1]) = 1;
        grid_submap(gridY-2,[gridX-2 gridX+2]) = 1;
        grid_submap(gridY+2,[gridX-2 gridX+2]) = 1;
    end
    
    grid_submap(grid_submap<0.7)=0;
    subplot 121
    imshow(grid_submap);
    title([num2str(t) ' ' num2str(x) ' ' num2str(y)]);
    subplot 122
    plot(Ang)
    pause(0.1);
end


function [time,x,y] = GetXY(filename)
pos_ = find(filename=='_');
post = find(filename=='t');
posd = find(filename=='d');
time = str2double(filename(posd(1)+1:pos_(1)-1));
x = str2double(filename(pos_(1)+1:pos_(2)-1));
y = str2double(filename(pos_(2)+1:post(1)-2));
end