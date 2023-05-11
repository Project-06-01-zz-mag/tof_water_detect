clc
clear all
close all

global N
global a b
global x y
global old_new_data

x = [0 0 0]
y = [0 0 0]

N = 2;
b = [0.20169205911526   -0.40338411823052    0.20169205911526 ]
a = [1                   0.392116929473767   0.198885165934809]

dpfs_mat_struct_load = load('4_rawdata_fromtime/0_filter_data/officewatertetest2.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.new_fpds;
length_raw = size(dpfs_mat_select_water',1)

dpfs_mat_select_filter_load = load('4_rawdata_fromtime/0_filter_data/officewatertetest2_filter.mat');   
dpfs_mat_select_filter = dpfs_mat_select_filter_load.new_fly_filter;

length_end = length_raw

for i = 1:length_end
    origin(i) = dpfs_mat_select_water(i)
    r(i) = filter_hpl(origin(i))
end

timeview = 1:length_end
plot(timeview,r,'r') %滤波后的数据
hold on
plot(timeview,origin,'g') %原始数据
hold on
plot(timeview,dpfs_mat_select_filter,'k') %飞机滤波后的数据
hold on

function r=filter_hpl(new_data)
    global N
    global a b
    global x y
    global old_new_data
    old_new_data = 0;
    if(new_data<-70||new_data>-5)
        new_data = old_new_data
    else
        old_new_data = new_data
    end

    begin = N +1
    y0= 0
    for i=begin:-1:2 %从3开始到2，但是N是2
        x(i) = x(i-1)
        y(i) = y(i-1)
        y0 = y0 + b(i) * x(i) - a(i) * y(i) 
    end
    x(1) = new_data;
    y(1) = y0 + b(1)*x(1);
    r= y(1)
end



