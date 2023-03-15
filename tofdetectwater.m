clc
clear
close all

% tofampdpsfload = load('tofdpsf1.mat');
dpfs_mat_load = load('huioutrise.mat');     %载入mat数据
dpfs_mat_select=dpfs_mat_load.huioutorise;  %选择mat
dpfs_data = dpfs_mat_select.VarName1;       %选择列

length = size(dpfs_data);
win_size = 500;

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft计算
    M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增

    if M(499) > 500
       for a = i:i+win_size
        result(a)=1*(-80);         
       end
    else
       for a = i:i+win_size
        result(a)=0;         
       end
    end
end

figure
plot(dpfs_data)
hold on
plot(result)

% figure

% subplot(2,1,1)
% hold on
% plot(tof_data)
% hold off
% legend("tofampdpsf")

% subplot(2,1,2)
% hold on
% plot(tof_var)
% hold off
% legend("tof var")

