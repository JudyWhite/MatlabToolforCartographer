%% 统计Cartographer算法处理后每帧点云数量，以序号为横坐标，数量为纵坐标，画图
path='/home/yaoshw/Downloads';
fornt_estimate_pose = importdata([path '/pose info.txt']);
num=[];
for i = 1:length(fornt_estimate_pose)
    point = importdata([path '/points/pcd_' num2str(i-1) '.txt']);
    num = [num size(point,1)];
end
plot(num)