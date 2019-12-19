close all;
%% 读取两帧pcd文件，或读取txt文件
%  然后根据IMU数据显示配准结果，或手动调整配准参数，显示配准结果
%Method 1 读取pcd文件
UR=rotz(17);
pcd1=pcread('/home/yaoshw/Downloads/tofpcd1218/1576634140.111949939.pcd');
pcd1=pcd1.Location;
pcd2=pcread('/home/yaoshw/Downloads/tofpcd1218/1576634144.327703799.pcd');
pcd2=pcd2.Location;
R=rotx(-90);
pcd1=UR*R*pcd1';
pcd1=pcd1';
pcd1=[pcd1;[0 0 0]];
pcd2=UR*R*pcd2';
pcd2=pcd2';
pcd2=[pcd2;[0 0 0]];
%Method 2 根据index读取txt文件
% submap_index = 0;
% scan_index = 10;
% pcd1 = importdata([path '/points/pcd_' num2str(submap_index) '.txt']);
% pcd2 = importdata([path '/points/pcd_' num2str(scan_index) '.txt']);

%Method 1 根据两帧对应时刻的IMU数据，对pcd2进行变换
p1=[2.9999322891	0.020071134 0.0055850535];
p2=[234.989852905	-1.8394885063	6.2671279907];
[x,y,t]=RelatedPose(p1(1),p1(2),p1(3),p2(1),p2(2),p2(3));
t=rotz(90)*[x;y;0]
pcd2=pcd2+[t(1)/1000 t(2)/1000 0];
pcd2 = rotz(t(3)*180/pi)*pcd2';

%Method 2 手动调整pcd2的变换参数
% pcd2=pcd2+[-0.02 0 0.01];
% pcd2 = roty(0)*pcd2';

% 显示配准结果
pcd2=pcd2';
pcshowpair(pointCloud(pcd1),pointCloud(pcd2),'MarkerSize',30);
xlabel('X')
ylabel('Y')
zlabel('Z')
% view(180,0)
view(0,90)


function [x,y,t] = RelatedPose(x1,y1,t1,x2,y2,t2)
%由平移x，y和z轴旋转角t组成位姿，求inverse（1）*2
%t逆时针为正
t = t2-t1;
dx = x2-x1;
dy = y2-y1;
trans = rotz(t1*180/pi)\[dx;dy;0];
x = trans(1);
y = trans(2);
end