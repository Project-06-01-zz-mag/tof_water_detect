clc
clear all
close all

setenv('MW_MINGW64_LOC', 'C:\mingw-64')
mex -setup C++
%% 编译源文件，输出文件名为water_detect，扩展名基于平台，windows下为mexw64
mex -R2018a 8mextest\3_water_detect\mex_c_to_m.cpp 8mextest\3_water_detect\water_detect_ffc.cpp -output water_detect
%% 二进制文件调用进行混合编程

%% 原始数据导入
filename = '6python/1scipe/ffc.1.csv';
delimiterIn = ' '; % 看到空格分开
ffc_log_struct = importdata(filename,delimiterIn);
input.time_infact = ffc_log_struct.data(:,1);
input.fly_state_now = ffc_log_struct.data(:,2);
input.dpfs_new = ffc_log_struct.data(:,3);
output_log.water_flag_infly = ffc_log_struct.data(:,4);
input.fly_higt = ffc_log_struct.data(:,5);

% 调用编译出的二进制文件来验证C/C++实现的算法
length = size(input.dpfs_new);

for i = 1:length(1)
    [mean_temp,variance_temp,stdvariance_temp,hpf_dpfs_temp,water_flag_inmatlab_temp,fly_state_change_temp] = water_detect(input.time_infact(i),input.fly_state_now(i),input.dpfs_new(i),input.fly_higt(i));
    output.mean_arr(i) = mean_temp;
    output.variance_arr(i) = variance_temp;
    output.stdvariance_arr(i) = stdvariance_temp;
    output.hpf_dpfs_arr(i) = hpf_dpfs_temp;
    output.water_flag_inmatlab(i) = water_flag_inmatlab_temp;
    output.fly_state_change(i)= fly_state_change_temp;
end

figure_size = 4

figure
subplot(figure_size,1,1)
plot(input.time_infact,input.dpfs_new,'b') 
xlabel('t(s)')
ylabel('dpfs')
hold on
plot(input.time_infact,output.hpf_dpfs_arr,'r')
legend('dpfs滤波前','dpfs滤波后')

subplot(figure_size,1,2)
plot(input.time_infact,output.stdvariance_arr,'b') 
hold on;
limit = 0.3;
for i= 1:length
    line_arr(i) = limit;
end
plot(input.time_infact,line_arr,'r') 
xlabel('t(s)')
ylabel('stdvariance')
legend('实时标准差','标准差阈值')

subplot(figure_size,1,3)
plot(input.time_infact,output_log.water_flag_infly,'b') 
hold on
plot(input.time_infact,output.water_flag_inmatlab*0.5,'r') 
xlabel('t(s)')
legend('优化前水面标志位','优化后水面标志位')

subplot(figure_size,1,4)
plot(input.time_infact,input.fly_higt,'r') 
hold on
xlabel('t(s)')
legend('飞机高度')

%% 完全结束后释放内存
clear water_detect