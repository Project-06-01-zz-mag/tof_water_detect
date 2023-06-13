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
time_infact = ffc_log_struct.data(:,1);
fly_state_now = ffc_log_struct.data(:,2);
dpfs_new = ffc_log_struct.data(:,3);
water_flag_infly = ffc_log_struct.data(:,4);

% 调用编译出的二进制文件来验证C/C++实现的算法
length = size(dpfs_new);

for i = 1:length(1)
    [mean_temp,variance_temp,stdvariance_temp,hpf_dpfs_temp,water_flag_inmatlab_temp,fly_state_change_temp] = water_detect(fly_state_now(i),dpfs_new(i));
    mean_arr(i) = mean_temp;
    variance_arr(i) = variance_temp;
    stdvariance_arr(i) = stdvariance_temp;
    hpf_dpfs_arr(i) = hpf_dpfs_temp;
    water_flag_inmatlab_arr(i) = water_flag_inmatlab_temp;
    waterdetectflag_output.fly_state_change(i)= fly_state_change_temp;
end

figure
subplot(3,1,1)
plot(time_infact,dpfs_new,'b') 
xlabel('t(s)')
ylabel('dpfs')
hold on
plot(time_infact,hpf_dpfs_arr,'r')
legend('dpfs滤波前','dpfs滤波后')

subplot(3,1,2)
plot(time_infact,stdvariance_arr,'b') 
hold on;
limit = 0.5;
for i= 1:length
    line_arr(i) = limit;
end
plot(time_infact,line_arr,'r') 
xlabel('t(s)')
ylabel('stdvariance')
legend('实时标准差','标准差阈值')

subplot(3,1,3)
plot(time_infact,water_flag_infly,'b') 
hold on
plot(time_infact,water_flag_inmatlab_arr*0.5,'r') 
xlabel('t(s)')
legend('优化前水面标志位','优化后水面标志位')

%% 完全结束后释放内存
clear water_detect