clc
clear
close all

win_size = 30;       % 原始信号进行fft的窗口大小
step_size = 5        % 步进长度
figure_row = 3       % 绘图的row numble
figure_column = 1    % 绘图的column numble

dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat
% myFun(dpfs_mat_select',1)


Fs = 33
fp1=7;fs1=16;
Fs2=Fs/2;
% 这里需要解释一个问题，为何需要将通带和阻带除以采样频率的一半Fs2呢？
% 我们都知道一句话，叫做时域采样，频域延拓。频域的延拓主要是以周期为2 π 2\pi2π进行延拓。
% 也即意味着，经过离散时间傅里叶变换DTFT后，在频域是以2 π 2\pi2π为周期的。
% 具体参考这篇文章时域采样与频域延拓。因此，我们的滤波器实际是这样的
Wp=fp1/Fs2; Ws=fs1/Fs2;
Rp=1; Rs=30;
[n,Wn]=buttord(Wp,Ws,Rp,Rs);
[b2,a2]=butter(n,Wn,'high','s');
y=filter(b2,a2,dpfs_mat_select');%经过filter滤波之后得到的数据y则是经过带通滤波后的信号数据

subplot(figure_row,figure_column,1)
plot(dpfs_mat_select')
hold on
subplot(figure_row,figure_column,2)
plot(y)
hold on
title('辉哥自动上升log')

% function myFun(inputdata,figure_num)
%     
%     global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% 原始信号进行fft的窗口大小
%     length = size(inputdata);
%     
% %     j = 1
% %     for i=1:3:length
% %         origindata(j) = inputdata(i)
% %         j= j+1
% %     end
% 
%     for i = 2:length
%         if (inputdata(i) < (-60)||inputdata(i)>-13)
%             inputdata(i) = inputdata(i-1);
%         end
%     end 
% 
%     % for i = 2:length
%     %     if (abs(inputdata(i-1) - inputdata(i))> 20)
%     %         inputdata(i) = inputdata(i-1);
%     %     end
%     % end 
% 
% 
% 
%     for i = win_size+1:step_size:length-win_size
% 
% 
% 
%     end
%     
%     water_cnt = 0;
%     subplot(figure_row,figure_column,figure_num)
%     plot(inputdata)
%     hold on
%     plot(result)
%     hold on
%     plot(value)
%     hold on
% end