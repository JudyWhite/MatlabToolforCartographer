%% 读取ros发布的地图和pose位姿，根据时间按顺序显示地图和相机位置
path = '/home/yaoshw/Downloads';
% fileFolder=fullfile([path '/submap']);
% dirOutput=dir(fullfile(fileFolder,'2DGrid*.txt'));
fileList = dir([path '/submap/2DGrid*.txt']);
poseList = importdata([path '/2Dpose.txt']);
fileNames={fileList.name};
[baseTime,~,~] = GetXY(fileNames{1});
for i=1:1:length(fileNames)
    hold off;
    filePath = [path '/submap/' fileNames{i}];
    [time,x,y] = GetXY(fileNames{i});
    t = time - baseTime;
    
    ori_x = round(x/0.02);
    ori_y = round(y/0.02);
    grid_submap = importdata(filePath);
    grid_submap = grid_submap+1;
    grid_submap = grid_submap/max(max(grid_submap));
    grid_submap(-ori_y,-ori_x-3:-ori_x+3) = 1;%起始点位置
    grid_submap(-ori_y-3:-ori_y+3,-ori_x) = 1;
    
    pos = find(poseList(:,1)>time);
    if(isempty(pos))
        pos = find(poseList(:,1)<time);
        pos=pos(end);
    end
    nodeX = poseList(pos(1),2);
    nodeY = poseList(pos(1),3);
    gridX = round((nodeX-x)/0.02);
    gridY = round((nodeY-y)/0.02);
    
    grid_submap(gridY,gridX) = 1;%相机位置
    grid_submap(gridY-1,[gridX-1 gridX+1]) = 1;
    grid_submap(gridY+1,[gridX-1 gridX+1]) = 1;
    grid_submap(gridY-2,[gridX-2 gridX+2]) = 1;
    grid_submap(gridY+2,[gridX-2 gridX+2]) = 1;
    
    grid_submap(grid_submap<0.7)=0;
    imshow(flipud(grid_submap));
    title(t);
    pause(0.1);
    hold on;
end


function [time,x,y] = GetXY(filename)
pos_ = find(filename=='_');
post = find(filename=='t');
posd = find(filename=='d');
time = str2double(filename(posd(1)+1:pos_(1)-1));
x = str2double(filename(pos_(1)+1:pos_(2)-1));
y = str2double(filename(pos_(2)+1:post(1)-2));
end