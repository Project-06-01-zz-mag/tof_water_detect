clc
clear all
close all

global N
global a b
global x y

x = [0 0 0]
y = [0 0 0]

N = 2;
b = [0.20169205911526   -0.40338411823052    0.20169205911526 ]
a = [1                   0.392116929473767   0.198885165934809]

length_end = 100

dpfs_mat_struct_load = load('4_rawdata_fromtime/truedata_fromtime_Asphaltroad3.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.new_fpds;
length_raw = size(dpfs_mat_select_water',1)

for i = 1:length_end
    origin(i) = dpfs_mat_select_water(i)
    r(i) = filter_hpl(origin(i))
end

timeview = 1:length_end
plot(timeview,r,'k') %滤波后的数据
hold on
plot(timeview,origin,'k') %滤波后的数据
hold on

function r=filter_hpl(new_data)
    global N
    global a b
    global x y
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



