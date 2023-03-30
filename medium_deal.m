clc
clear
close all

dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   
dpfs_mat_select=dpfs_mat_load.origindata; 
length = size(dpfs_mat_select',1);
raw_data = dpfs_mat_select'; %载入原始数据

window_size = 11;
window_data = zeros(window_size,1);
Median_filter = zeros(length,1);

for i = 1:length
    if i <= window_size
        Median_filter(i) = raw_data(i);
        window_data(i) = raw_data(i);
    else
        window_data(1:window_size-1) = window_data(2:window_size);
        window_data(window_size) = raw_data(i);
        Median_filter(i) = GetMedianNum(window_data,window_size);
    end
end

window_size = 11;
window_data = zeros(window_size,1);
Ave_filter = zeros(length,1);

for i = 1:length
    if i <= window_size
        Ave_filter(i) = raw_data(i);
        window_data(i) = raw_data(i);
    else
        window_data(1:window_size-1) = window_data(2:window_size);
        window_data(window_size) = raw_data(i);
        Ave_filter(i) = GetAve(window_data,window_size);
    end
end

figure
subplot(3,1,1)
plot(raw_data)
title('raw_data')

subplot(3,1,2)
plot(Median_filter)
title('Median_filter')

subplot(3,1,3)
plot(Ave_filter)
title('Ave_filter')

%滑动中值滤波
function mid_data = GetMedianNum(bArray,window_size)
bsort = sort(bArray,"ascend");
if mod(window_size , 2) ~= 0
    mid_data = bsort((window_size+1) / 2);
else
    mid_data = (bsort(window_size/2) + bsort(window_size/2+1)) / 2;
end
end

%滑动平均滤波
function ave_data = GetAve(bArray,window_size)
    sum = 0 
    for i = 1:window_size
        sum = sum + bArray(i) 
    end
    ave_data = sum/window_size
end
