clc;clear all;close all;

path = '/home/yaoshw/Downloads';
imu_path = '/home/yaoshw/tofimu.csv';
imu_ext_path = '/home/yaoshw/tofimuext.csv';
addpath('/home/yaoshw/matlabcode/Cartographer/IMUAnalyse')
[imu_time, imu_data, imu_ext_time, imu_ext_data] = ReadImuData(imu_path, imu_ext_path);