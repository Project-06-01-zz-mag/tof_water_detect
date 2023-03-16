clc
clear
close all

win_size = 100; % 原始信号进行fft的窗口大小
frequency_spectrum_x1 = 50 %信号频率窗口下边界
frequency_spectrum_x2 = 99 %信号频率窗口上边界
scale = 100 %fft信号幅值求和后的缩放
sum_value_limit = 10  %信号求和后认为是水面的信号和限值
water_cnt = 0 ; %判断可能出现在水面上的次数
water_cnt_limit = 3
figure_row = 2
figure_column = 1

dpfs_mat_load = load('rawdpfs_ground1.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.rawdpfsground1;  %选择mat
dpfs_data = dpfs_mat_select.VarName1;          %选择列
length = size(dpfs_data);                      %求s原始信号的长度

%对原始信号进行脉冲噪声去噪
for i = 2:length
    if (dpfs_data(i) < (-80)||dpfs_data(i) == 0)
        dpfs_data(i) = dpfs_data(i-1);
    end
end 
%对原始信号进行中值滤波
%dpfs_data_filter = medfilt1(dpfs_data,100);

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft计算
    M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增       

    %对选定的频率范围进行求和
    sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

    if(sum_result > sum_value_limit)
        water_cnt = water_cnt +1;
    else
        water_cnt = 0;
    end


    if water_cnt>water_cnt_limit
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
subplot(figure_row,figure_column,1)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water1.mat');     %载入mat数据
dpfs_mat_select=dpfs_mat_load.rawdpfswater1;  %选择mat
dpfs_data = dpfs_mat_select.VarName1;       %选择列
length = size(dpfs_data);

for i = 2:length
    if (dpfs_data(i) < (-80)||dpfs_data(i) ==0)
        dpfs_data(i) = dpfs_data(i-1);
    end
end 
%对原始信号进行中值滤波
%dpfs_data_filter = medfilt1(dpfs_data,100);

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft计算
    M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增       

    %对选定的频率范围进行求和
    sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

    if(sum_result > sum_value_limit)
        water_cnt = water_cnt +1;
    else
        water_cnt = 0;
    end


    if water_cnt > water_cnt_limit
       for a = i:i+win_size
        result(a)=1*(-80);         
       end
    else
       for a = i:i+win_size
        result(a)=0;         
       end
    end
end

subplot(figure_row,figure_column,2)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)

