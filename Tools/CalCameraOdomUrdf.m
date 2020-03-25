%% 利用CloudCompare选取地面上的点,输出至picking_list.txt文件中
%  根据地面的点计算出法线,然后计算坐标系旋转,最终得到urdf文件使用的rpy
close all;
% planeData = importdata('/home/yaoshw/picking_list.txt');

% planeData = pcread('/home/yaoshw/Downloads/tofpcdimur/1584945773.625770477.pcd');
planeData = pcread('/home/yaoshw/Downloads/tofpcdimur/1584945767.803459683.pcd');
pcd = planeData;
planeData = double(planeData.Location);
% planeData(planeData(:,3)<1.9,:)=[];
% planeData(planeData(:,1)>1,:)=[];
planeData(planeData(:,1)>1|planeData(:,1)<-2,:)=[];
planeDataL = sqrt(planeData(:,1).*planeData(:,1)+planeData(:,3).*planeData(:,3));
% planeData(planeDataL>2,:)=[];
% pcshowpair(pcd,pointCloud(planeData));
% pcshow(pointCloud(planeData));

xlabel('X')
ylabel('Y')
zlabel('Z')

if 0
    xyz0 = mean(planeData,1);
    centeredPlane = planeData-xyz0;
    % centeredPlane=bsxfun(@minus,planeData,xyz0);
    % [U,S,V]=svd(cov(centeredPlane))
    [U,S,V] = svd(centeredPlane);
    a = V(1,3);
    b = V(2,3);
    c = V(3,3);
    d = -dot([a b c],xyz0);
    if c<0
        a=-a;
        b=-b;
        c=-c;
    end
    vec = [a b c]
    [R q] = Vector2RandQua([a b c],[0 0 c]);
    R
    rota_deg = fliplr(rotm2eul(R,'ZYX'))*180/pi
    planeData = [planeData;[0 0 0];[a b c]];
    planeDataR = R*planeData';
    planeDataR = planeDataR';
    pcshowpair(pointCloud(planeData),pointCloud(planeDataR));
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    R1 = eul2rotm(fliplr([-pi/2 0 0]),'ZYX');
    T = R1*R;
    urdf = fliplr(rotm2eul(T,'ZYX'))
end
if 1
    planeData = pcread('/home/yaoshw/Downloads/tofpcdimur/1584945768.802633598.pcd');
    pcd = planeData;
    planeData = double(planeData.Location);
    planeDataT = T*planeData';
    planeDataT = planeDataT';
    T1=eul2rotm(fliplr([-pi/2 0 0]),'ZYX');
    planeDataT1=T1*planeData';
    planeDataT1=planeDataT1';
    pcshowpair(pointCloud(planeDataT),pointCloud(planeDataT1));
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end