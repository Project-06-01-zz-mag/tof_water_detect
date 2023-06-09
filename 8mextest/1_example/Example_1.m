clc;clear;close
setenv('MW_MINGW64_LOC', 'C:\mingw-64')
mex -setup C++
mex -setup C
%% 编译源文件，输出文件名为Example_1_Test，扩展名基于平台，windows下为mexw64
mex -R2018a Example_1.cpp SimpleMath.cpp -output Example_1_Test
%% 二进制文件调用进行混合编程
a = 3;
b = 4;
% 定义1x2的矩阵
ab = [3,4];
% 调用编译出的二进制文件来验证C/C++实现的算法
[add_result,sub_result,mul_result,div_result,out_matrix] = Example_1_Test(a,b,ab);
disp(add_result);
disp(sub_result);
disp(mul_result);
disp(div_result);
disp(out_matrix);
%% 完全结束后释放内存
clear Example_1_Test