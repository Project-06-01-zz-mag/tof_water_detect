clc;clear;close;
setenv('MW_MINGW64_LOC', 'C:\mingw-64')
mex -setup C++
mex -setup C
% 获取头文件路径，并储存在元胞数组中
inc_path = {['-I' fullfile(pwd,'Inc')]
    ['-I' fullfile(pwd,'Dependencies')]
    };
% 获取源文件夹路径
src_path = fullfile(pwd,'Src');
% 递归查找源文件文件下下所有的.cpp文件，并排除文件夹
files_info = dir(fullfile(src_path, '**', '*.cpp'));
files = files_info(~[files_info.isdir]);
% 计算cpp文件个数
files_number = length(files);
% 定义源文件路径元胞数组大小，包括函数入口源文件
src_files = cell(files_number + 1,1);
% 将完整的源文件路径填入元胞数组中
for i = 1:files_number
    full_file_path = fullfile(files(i).folder, files(i).name);
    src_files{i+1,1} = full_file_path;
end
% 将函数入口源文件路径添加到源文件元胞数组中
src_files{1,1} = [pwd '\Example_2.cpp'];
%% 编译源文件，输出文件名为Example_2_Test，扩展名基于平台，windows下为mexw64
mex('-v','-R2018a',inc_path{:},src_files{:},'-output','Example_2_Test')
%% 二进制文件调用
a = 3;
b = 4;
% 定义1x2的矩阵
ab = [3,4];
[add_result,sub_result,mul_result,div_result,out_matrix,eigen_out] = Example_2_Test(a,b,ab);
% 打印结果
disp(add_result);
disp(sub_result);
disp(mul_result);
disp(div_result);
disp(out_matrix);
disp(eigen_out);
%% 释放内存
clear Example_2_Test