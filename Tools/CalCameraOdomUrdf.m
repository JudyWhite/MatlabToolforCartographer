%% 利用CloudCompare选取地面上的点,输出至picking_list.txt文件中
%  根据地面的点计算出法线,然后计算坐标系旋转,最终得到urdf文件使用的rpy
clear all;close all;
% planeData = importdata('/home/yaoshw/picking_list.txt');

planeData = pcread('/home/yaoshw/Downloads/tofpcd02271/1582773608.960696744.pcd');
pcd = planeData;
planeData = double(planeData.Location);
planeData(planeData(:,3)<1.9,:)=[];
planeData(planeData(:,1)<-1.5,:)=[];
planeData(planeData(:,1)>0.4&planeData(:,1)<0.7,:)=[];
planeDataL = sqrt(planeData(:,1).*planeData(:,1)+planeData(:,3).*planeData(:,3));
% planeData(planeDataL>2,:)=[];
% pcshowpair(pcd,pointCloud(planeData));
pcshow(pointCloud(planeData));

xlabel('X')
ylabel('Y')
zlabel('Z')

xyz0 = mean(planeData,1);
centeredPlane = planeData-xyz0;
% centeredPlane=bsxfun(@minus,planeData,xyz0);
% [U,S,V]=svd(cov(centeredPlane))
[U,S,V] = svd(centeredPlane);
a = V(1,3);
b = V(2,3);
c = V(3,3);
d = -dot([a b c],xyz0);
if b<0
    a=-a;
    b=-b;
    c=-c;
end
vec = [a b c]
[R q] = Vector2RandQua([a b c],[a 0 0]);
R
R1 = eul2rotm(fliplr([-pi/2 0 0]),'ZYX');
T = R1*R;
urdf = fliplr(rotm2eul(T,'ZYX'))