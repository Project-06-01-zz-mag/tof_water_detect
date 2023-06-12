clc;clear;close
setenv('MW_MINGW64_LOC', 'C:\mingw-64')
mex -setup C++
%% 编译源文件，输出文件名为water_detect，扩展名基于平台，windows下为mexw64
mex -R2018a 8mextest\3_water_detect\mex_c_to_m.cpp 8mextest\3_water_detect\water_detect_ffc.cpp -output water_detect
%% 二进制文件调用进行混合编程
a = 3;
b = 1;

%% 原始数据导入
filename = '6python/1scipe/ffc.1.csv';
delimiterIn = ' '; % 看到空格分开
ffc_log_struct = importdata(filename,delimiterIn);
fly_state_now = ffc_log_struct.data(:,2);
dpfs_new = ffc_log_struct.data(:,3);
water_flag_infly = ffc_log_struct.data(:,4);

% 调用编译出的二进制文件来验证C/C++实现的算法
length = size(dpfs_new)

for i = 1:length(1)
    [mean_temp,variance_temp,stdvariance_temp,hpf_dpfs_temp,water_flag_inmatlab_temp] = water_detect(dpfs_new(i),fly_state_now(i));
    mean_arr(i) = mean_temp;
    variance_arr(i) = variance_temp;
    stdvariance_arr(i) = stdvariance_temp;
    hpf_dpfs_arr(i) = hpf_dpfs_temp;
    water_flag_inmatlab_arr(i) = water_flag_inmatlab_temp;
end

figure
subplot(2,1,1)
plot(dpfs_new,'b') 
ylabel('dpfs_new')
subplot(2,1,2)
plot(hpf_dpfs_arr,'b') 
ylabel('hpf_dpfs_arr')

figure
subplot(3,1,1)
plot(mean_arr,'b') 
ylabel('mean_arr')
subplot(3,1,2)
plot(variance_arr,'b') 
ylabel('variance_arr')
subplot(3,1,3)
plot(stdvariance_arr,'b') 
ylabel('stdvariance_arr')

figure
subplot(2,1,1)
plot(water_flag_infly,'b') 
ylabel('water_flag_infly')
subplot(2,1,2)
plot(water_flag_inmatlab_arr,'b') 
ylabel('water_flag_inmatlab_arr')

%% 完全结束后释放内存
clear water_detect