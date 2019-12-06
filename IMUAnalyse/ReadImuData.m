function [imu_time, imu_data, imu_ext_time, imu_ext_data] = ReadImuData(imu_path, imu_ext_path)
%读取imu文件中的时间,角速度和线加速度 以及 imu_ext文件中的时间,位移和角度
%返回对应的时间和数据
imu = csvread(imu_path,1,17);
imu_data=imu(:,[1,2,3,13,14,15]);

imu_time = importdata(imu_path);
imu_time=imu_time.textdata;
imu_time=imu_time(2:end,1);
imu_time=str2num(cell2mat(imu_time));

imu_ext_data = importdata(imu_ext_path);
imu_ext_time=imu_ext_data.textdata;
imu_ext_time=imu_ext_time(2:end,1);
imu_ext_time=str2num(cell2mat(imu_ext_time));
imu_ext_data = imu_ext_data.data;
imu_ext_data = imu_ext_data(:,1:6);

pos = find(imu_ext_data==0);
t_start = imu_ext_time(pos(1));
imu_data(imu_time<t_start,:)=[];
imu_time(imu_time<t_start)=[];
imu_ext_data(imu_ext_time<t_start)=[];
imu_ext_time(imu_ext_time<t_start)=[];

t_start = min(imu_ext_time(1),imu_time(1));
imu_time = (imu_time - t_start)/1000000000;
imu_ext_time = (imu_ext_time - t_start)/1000000000;

subplot 211
plot(imu_ext_time,imu_ext_data(:,1),'g');
hold on;
plot(imu_ext_time,imu_ext_data(:,2),'r');
legend('X','Y')
subplot 212
plot(imu_ext_time,imu_ext_data(:,6));
legend('deg')
end