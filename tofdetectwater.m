clc
clear
close all


frequency_spectrum_x1 = 400
frequency_spectrum_x2 = 500

scale = 1000

figure_row = 3
figure_column = 1

dpfs_mat_load = load('rawdpfs_ground1.mat');     %载入mat数据
dpfs_mat_select=dpfs_mat_load.rawdpfsground1;  %选择mat
dpfs_data = dpfs_mat_select.VarName1;       %选择列

length = size(dpfs_data);

win_size = 500;
n = 0:win_size; % 采样序列

figure
subplot(2,1,1)
plot(dpfs_data)
hold on

Fs=1000;
Fs2=Fs/2;
[b,a]=butter(4,50/Fs2,'high');
y=filter(b,a,dpfs_data);%经过filter滤波之后得到的数据y则是经过带通滤波后的信号数据
subplot(2,1,2)
plot(y)
hold on

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft计算
    M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增
    
    for a = 1:i
        select(a) = 0;
    end
    for a = i:i+win_size
        select(a) = -80;
    end
    select(a) = 0
    
    subplot(2,1,1)
    plot(dpfs_data)
    hold on
    plot(select)
    hold off
        
    subplot(2,1,2)
    plot(n,M)
    hold off

    sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

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
subplot(figure_row,figure_column,1)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)
hold on

for i = 2:length
    if (dpfs_data(i) < (-80)||dpfs_data(i) ==0)
        dpfs_data(i) = dpfs_data(i-1);
    end
end 

dpfs_data_filter = medfilt1(dpfs_data,100);

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft计算
    M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增

    sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

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

subplot(figure_row,figure_column,2)
plot(dpfs_data_filter)
hold on
plot(result)
hold on
plot(value)
hold on

dpfs_mat_load = load('rawdpfs_water1.mat');     %载入mat数据
dpfs_mat_select=dpfs_mat_load.rawdpfswater1;  %选择mat
dpfs_data = dpfs_mat_select.VarName1;       %选择列

length = size(dpfs_data);

n = 0:win_size; % 采样序列

for i = 1:win_size:length-win_size
    y= fft(dpfs_data(i:i+win_size)); %fft计算
    M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增

    sum_result= sum(M(frequency_spectrum_x1:frequency_spectrum_x2))/scale;
    for a = i:i+win_size
        value(a)=sum_result;       
    end

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

subplot(figure_row,figure_column,3)
plot(dpfs_data)
hold on
plot(result)
hold on
plot(value)

