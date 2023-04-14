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

# 文档目录说明
0 原始数据，来自replay工具导出的数据，根据脚本可以设置1s/1000point,1s/100point,后面可以修改成1s/33point

1 真实数据，从原始数据抽样而来，也可以是replay脚本直接降采样到33hz
  为什么是33hz,因为tof的数据是33hz的，所以实时仿真的时候，应该还原最初的数据状态

2 工具脚本，一些matlab内置函数的验证，比如fft，filter等，还有降采样的脚本

3 验证脚本，算法的验证脚本，引入真实数据，进行验证

4 picture ,算法验证的图片保存
