clc
clear
close all

win_size = 30;        % 原始信号进行fft的窗口大小
step_size = 1         % 步进长度
figure_row = 3        % 绘图的row numble
figure_column = 1     % 绘图的column numble
std_limit_value = 0.09 % 判断是否为水面上的标准差阈值
water_cnt_limit = 30   % 判断是否为水面上的连续次数阈值
water_cnt = 0 ;       % 判断可能出现在水面上的次数

dpfs_mat_struct_load = load('origindata/rawdpfs_grass.mat');  
dpfs_mat_select_grass = dpfs_mat_struct_load.rawdpfsgarss.VarName1;

dpfs_mat_struct_load = load('origindata/rawdpfs_water1.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.rawdpfswater1.VarName1;