clc;close all;
% 调用前端和后端位姿显示函数，最终将前后端的位姿画在一张图上
path = '/home/yaoshw/Downloads';
addpath('/home/yaoshw/matlabcode/Cartographer/FrontEnd');
addpath('/home/yaoshw/matlabcode/Cartographer/BackEnd');
[R_prediction, T_prediction, R_estimate, T_estimate] = ShowFrontPose(path);
[R_back, T_back] = ShowBackPose(path);
close all;
fileList = dir([path '/radon/node*.txt']);
fileNames={fileList.name};
radon_pos = GetSubmapPos(fileNames);
radon_pos = sort(radon_pos);

loop = importdata([path '/loop_close.txt']);
loop_close_tmp = importdata([path '/loop_close_tmp.txt']);
loop_close_tmp = loop_close_tmp(find(loop_close_tmp(:,10)==1),1:2);

keyframe = importdata([path '/can_be_frame.txt']);
keyframe = keyframe(:,4);
key_pos = find(keyframe==1);
no_key_pos = find(keyframe==0);
loop_pos = intersect(key_pos,1:20:length(keyframe));

for i=1:length(radon_pos)
    clf;
    if i==1
        submap_range = 1:radon_pos(i+1);
        submap_radon = radon_pos(i)+1;
    elseif i==length(radon_pos)
        submap_range = radon_pos(i-1):length(T_back);
        submap_radon = radon_pos(i)+1;
    else
        submap_range = radon_pos(i-1):radon_pos(i+1);
        submap_radon = radon_pos(i)+1;
    end
    submap_loop = loop(loop(:,2)==(i-1),1)+1;
%     submap_can = intersect(loop_pos,submap_range);
    submap_can = loop_close_tmp(loop_close_tmp(:,2)==(i-1),1)+1;
    hold on;
    plt = plot(T_estimate(:,1),T_estimate(:,2),'k-');
    plt.Color(4) = 0.2;
%     plot(T_back(:,1),T_back(:,2),'k--');
    plt = plot(T_estimate(loop_pos,1),T_estimate(loop_pos,2),'kx');
    plt.Color(4) = 0.2;
    for j=1:length(loop_pos)
        plt = text(T_estimate(loop_pos(j),1),T_estimate(loop_pos(j),2),num2str(loop_pos(j)-1));
        plt.Color(4) = 0.1;
    end
%     plot(T_back(loop_pos,1),T_back(loop_pos,2),'kx');
    plot(T_estimate(submap_range,1),T_estimate(submap_range,2),'r.');
%     plot(T_back(submap_range,1),T_back(submap_range,2),'g.');
    plot(T_estimate(submap_radon,1),T_estimate(submap_radon,2),'b*','markersize',10);
%     plot(T_back(submap_radon,1),T_back(submap_radon,2),'g*');
    plot(T_estimate(submap_can,1),T_estimate(submap_can,2),'rx');
%     plot(T_back(submap_can,1),T_back(submap_can,2),'gx');
    plot(T_estimate(submap_loop,1),T_estimate(submap_loop,2),'gx');
%     plot(T_back(submap_loop,1),T_back(submap_loop,2),'gx');
    title(['submap ' num2str(i-1)]);
    %打印信息
    submap_index = i-1
    submap_radon_index = submap_radon-1
    no_loop_key_scan = setdiff(submap_can, submap_loop)-1
    pause;
end
function radon_pos = GetSubmapPos(fileNames)
radon_pos=[];
for i=1:length(fileNames)
    str = fileNames{i};
    s = find(fileNames{i}=='e');
    e = find(fileNames{i}=='.');
    radon_pos = [radon_pos;str2num(str(s+1:e-1))];
end
end