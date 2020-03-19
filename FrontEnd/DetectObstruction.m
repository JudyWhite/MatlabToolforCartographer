path = '/home/yaoshw/Downloads';
fornt_estimate_pose   = importdata([path '/pose info.txt']);
for i = 100:10:1000
    point = importdata([path '/points/pcd_' num2str(i-1) '.txt']);
    distance = sqrt(sum(point(:,1:2).*point(:,1:2),2));
    point_obs = point(distance<2,:); % 提取距离相机小于2米的数据点，用于分析
    ang = atan(point_obs(:,1)./point_obs(:,2))*180/pi;
    
    subplot 121
    h = histogram(ang,100);
    hist_num = h.BinCounts;
    edges = h.BinEdges;
    mid = (edges(1:end-1)+edges(2:end))/2;
    obs = find(hist_num>10);  % 判断该角度上数据点个数大于10即存在障碍物
    obs_ang = mid(obs);
    title(i);
    
    subplot 122
    point = [point;[0 0 0];[-0.05 0 0];[0.05 0 0];[0 -0.05 0];[0 0.05 0]];
    plot(point(:,1),point(:,2),'r.');
    r=2;
    if(~isempty(obs_ang))
        hold on;
       for j=1:length(obs_ang)
           plot([0,r*sin(obs_ang(j)*pi/180)],[0,r*cos(obs_ang(j)*pi/180)],'g');
       end
    end
    hold off;
    pause(0.5);
    pose_estT=fornt_estimate_pose(i,1:3);
    pose_estR=quat2rotm(fornt_estimate_pose(i,4:7));
    
end