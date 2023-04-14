# tofdetectwater
通过tof信号强度的变化来判断飞机是否在水面上
上述项目使用matlab进行仿真，验证方案的可行性

#关于如何从csv文件转换时间序列到matlab进行分析
1、使用kst选择一组想要保存的时间序列，比如sensor.tof.dpfs （保存的名称统一为tofdpfs）
2、打开tofdpfs，删除第一行名称
3、使用matlab导入数据，在工作区里面找到导入的数据并进行保存，保存名称为实际场景
4、使用类似下面的语句进行导入，最终得到的时间序列就是data_load_var
data_load = load('origindata/rawdpfs_grass.mat');  
data_load_var = dpfs_mat_struct_load.tofdpfs.VarName1;
