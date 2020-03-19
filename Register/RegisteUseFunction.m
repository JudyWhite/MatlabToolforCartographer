close all;
%% 读取txt文件
path = '/home/yaoshw/Downloads';
submap_index = 105;
scan_index = 106;
pcd1 = importdata([path '/points/pcd_' num2str(submap_index) '.txt']);
pcd2 = importdata([path '/points/pcd_' num2str(scan_index) '.txt']);
label_pose = importdata([path '/pose info.txt']);
submap_poseT = label_pose(submap_index+1,1:3);
submap_poseR = quat2rotm(label_pose(submap_index+1,4:7));
scan_poseT = label_pose(scan_index+1,1:3);
scan_poseR = quat2rotm(label_pose(scan_index+1,4:7));
relaR = submap_poseR\scan_poseR;
diffT = scan_poseT-submap_poseT;
relaT = submap_poseR\diffT';
Timu = zeros(4,4);
Timu(1:3,1:3) = relaR;
Timu(1:3,4) = relaT;
Timu(4,4) = 1;
Timu
pcd2t = relaR*pcd2'+relaT;
subplot 121
pcshowpair(pointCloud(pcd1),pointCloud(pcd2t'),'MarkerSize',30); %紫色，绿色
xlabel('X')
ylabel('Y')
zlabel('Z')
title('IMU 配准')
view(0,90)
pcd1 = pointCloud(pcd1);
pcd2 = pointCloud(pcd2);

%%直接读取pcd文件
% pcd1=pcread('/home/yaoshw/Downloads/tofpcd1218/1576634140.111949939.pcd');
% pcd2=pcread('/home/yaoshw/Downloads/tofpcd1218/1576634144.327703799.pcd');
% p1=[2.9999322891 0.020071134 0.0055850535];
% p2=[234.989852905 -1.8394885063	6.2671279907];
% [x,y,t]=RelatedPose(p1(1),p1(2),p1(3),p2(1),p2(2),p2(3));
% s = rotz(90)*[x;y;0]./1000;
% r = rotz(t);
% Timu = zeros(4,4);
% Timu(1:3,1:3) = r;
% Timu(1:3,4) = s;

%% 非刚性变换
% figure;
% tform = pcregistercpd(pcd2,pcd1);
% movingReg = pctransform(pcd2,tform);
% pcshowpair(pcd1,movingReg,'MarkerSize',30);
% view(0,90)
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% title('CPD 配准')

% figure;
% gridStep = 0.1;
% tform = pcregisterndt(pcd2,pcd1,gridStep);
% movingReg = pctransform(pcd2,tform);
% pcshowpair(pcd1,movingReg,'MarkerSize',30);
% view(0,90)
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% title('NDT 配准')

tform = pcregistericp(pcd2,pcd1,'Extrapolate',true);%T = pcregistericp(A,B,'Extrapolate',true); TA=B
ptCloudTformed = pctransform(pcd2,tform);
% pcshowpair(pcd1,ptCloudTformed)
% view(180,0)
pcd2 = pcd2.Location;
Ticp=tform.T;
Ticp=Ticp'
icpR=Ticp(1:3,1:3);
icpT=Ticp(1:3,4);
pcd2t=icpR*pcd2'+icpT;
subplot 122
pcshowpair(pcd1,pointCloud(pcd2t'),'MarkerSize',30);
xlabel('X')
ylabel('Y')
zlabel('Z')
title('ICP 配准')
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