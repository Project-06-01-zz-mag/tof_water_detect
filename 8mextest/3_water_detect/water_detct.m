clc;clear;close
setenv('MW_MINGW64_LOC', 'C:\mingw-64')
mex -setup C++
mex -setup C
%% 编译源文件，输出文件名为water_detect，扩展名基于平台，windows下为mexw64
mex -R2018a mex_c_to_m.cpp water_detect_ffc.cpp -output water_detect
%% 二进制文件调用进行混合编程
a = 3;
b = 1;

% 调用编译出的二进制文件来验证C/C++实现的算法
[mean,variance,stdvariance,hpf_dpfs] = water_detect(a,b);

disp(mean);
disp(variance);
disp(stdvariance);
disp(hpf_dpfs);

%% 完全结束后释放内存
clear water_detect