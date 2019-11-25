%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML110
% Project Title: Implementation of DBSCAN Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

%% Run DBSCAN Clustering Algorithm
submap_index = 4 ;

list = '/home/yaoshw/Downloads/912slamdata/tofpcdcir/list.txt';
dataname = importdata(list);

for i=200:600
    pcd = importdata(['/home/yaoshw/Downloads/imurec/points/pcd_' num2str(i) '.txt']);
    epsilon=0.2;
    MinPts=80;
    IDX=DBSCAN(pcd(:,1:3),epsilon,MinPts);
    %% Plot Results
    PlotClusterinResult(pcd, IDX);
    view(0,90)
    title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
    pause(0.1)
end