clc
clear
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% 原始信号进行fft的窗口大小
win_size = 300;  % 原始信号进行fft的窗口大小
frequency_spectrum_x1 = win_size - 200 %信号频率窗口下边界
frequency_spectrum_x2 = win_size - 50 %信号频率窗口上边界
scale = 100         %fft信号幅值求和后的缩放
sum_value_limit = 5  %信号求和后认为是水面的信号和限值
water_cnt_limit = 5  % 连续判断是否在水面上的次数
water_cnt = 0 ;      %判断可能出现在水面上的次数
step_size = 100      % 步进长度
figure_row = 3       % 绘图的row numble
figure_column = 1    % 绘图的column numble
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat
myFun(dpfs_mat_select',1)
title('辉哥自动上升log')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water1_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat
myFun(dpfs_mat_select',2)
title('辉哥水面log1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water2_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat
myFun(dpfs_mat_select',3)
title('辉哥水面log2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function myFun(inputdata,figure_num)
    
    global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% 原始信号进行fft的窗口大小
    length = size(inputdata);
    
%     j = 1
%     for i=1:3:length
%         origindata(j) = inputdata(i)
%         j= j+1
%     end

    for i = 2:length
        if (inputdata(i) < (-60)||inputdata(i)>-13)
            inputdata(i) = inputdata(i-1);
        end
    end 

    % for i = 2:length
    %     if (abs(inputdata(i-1) - inputdata(i))> 20)
    %         inputdata(i) = inputdata(i-1);
    %     end
    % end 



    for i = win_size+1:step_size:length-win_size
        y= fft(inputdata(i-win_size:i)); %fft计算
        M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增       
        %对选定的频率范围进行求和
        sum_result= sum(M(frequency_spectrum_x1/2:frequency_spectrum_x2/2))/scale; %计算单侧频谱的频率阈和
        for a = i-win_size:i
            value(a)=sum_result;       
        end
    
        %判断是否超过水面信号的要求，如果是，就让水面识别次数加1
        if(sum_result > sum_value_limit)
            water_cnt = water_cnt +1;
        else
            water_cnt = 0;
        end
    
    %判断是否超过水面识别的次数，如果超过次数，则认为这一个时刻在水面上
        if water_cnt>water_cnt_limit
           %for a = i:i-win_size
           result(i)=1*(-80);         
           %end
        else
           %for a = i:i+win_size 
           result(i)=0;         
           %end
        end
    end
    
    water_cnt = 0;
    subplot(figure_row,figure_column,figure_num)
    plot(inputdata)
    hold on
    plot(result)
    hold on
    plot(value)
    hold on
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
