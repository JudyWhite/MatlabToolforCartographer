clc;close all;
% 调用前端和后端位姿显示函数，最终将前后端的位姿画在一张图上
path = '/home/yaoshw/Downloads';
addpath('/home/yaoshw/matlabcode/Cartographer/FrontEnd');
addpath('/home/yaoshw/matlabcode/Cartographer/BackEnd');
[R_prediction, T_prediction, R_estimate, T_estimate] = ShowFrontPose(path);
[R_back, T_back] = ShowBackPose(path);
close all;
figure;
subplot 311;
plot(T_estimate(:,1),'r--');
hold on;plot(T_back(:,1),'g');
legend('前端','后端');
subplot 312;
plot(T_estimate(:,2),'r--');
hold on;plot(T_back(:,2),'g');
subplot 313;
plot(R_estimate(:,3),'r');
hold on;plot(R_back(:,3),'g');
% figure;
% hold on;
% for i = 1:length(T_back)
%     plot([T_estimate(i,1) T_back(i,1)],[T_estimate(i,2) T_back(i,2)],'k');
% end
% plot(T_estimate(:,1),T_estimate(:,2),'r*');
% plot(T_back(:,1),T_back(:,2),'g*');
% legend('前端','后端');

fileList = dir([path '/radon/node*.txt']);
fileNames={fileList.name};
radon_pos = GetSubmapPos(fileNames);
radon_pos = sort(radon_pos);


loop = importdata([path '/loop_close.txt']);
keyframe = importdata([path '/can_be_frame.txt']);
keyframe = keyframe(:,4);
figure;
hold on;
%回环帧之间管段位姿和后端位姿关系
% for i = 1:length(loop)
%     drawArrow([T_estimate(loop(i,1)+1,1) T_estimate(loop(i,1)+1,2)],[T_back(loop(i,1)+1,1) T_back(loop(i,1)+1,2)],'b','b',1,1);
% end
%回环帧前端与子图关键帧后端之间的关系
% for i = 1:length(loop)
%     drawArrow([T_estimate(loop(i,1)+1,1) T_estimate(loop(i,1)+1,2)],[T_back(radon_pos(loop(i,2)+1),1) T_back(radon_pos(loop(i,2)+1),2)],'b','b',1,1);
% end
key_pos = find(keyframe==1);
no_key_pos = find(keyframe==0);
loop_pos = intersect(key_pos,1:20:length(keyframe));
hold on;
plot(T_estimate(:,1),T_estimate(:,2),'r');
plot(T_back(:,1),T_back(:,2),'g');
% plot(T_estimate(key_pos,1),T_estimate(key_pos,2),'r.');
% plot(T_back(key_pos,1),T_back(key_pos,2),'g.');
% plot(T_estimate(no_key_pos,1),T_estimate(no_key_pos,2),'k.');
% plot(T_back(no_key_pos,1),T_back(no_key_pos,2),'k.');
%能做回环检测的关键帧
% plot(T_estimate(loop_pos,1),T_estimate(loop_pos,2),'rx');
% plot(T_back(loop_pos,1),T_back(loop_pos,2),'gx');
%子图关键帧
% plot(T_estimate(radon_pos,1),T_estimate(radon_pos,2),'g*');
% plot(T_back(radon_pos,1),T_back(radon_pos,2),'r*');
title('回环情况')

function radon_pos = GetSubmapPos(fileNames)
radon_pos=[];
for i=1:length(fileNames)
    str = fileNames{i};
    s = find(fileNames{i}=='e');
    e = find(fileNames{i}=='.');
    radon_pos = [radon_pos;str2num(str(s+1:e-1))];
end
end