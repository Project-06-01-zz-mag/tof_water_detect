clc
clear
close all

global win_size step_size figure_row figure_column 
global std_limit_value water_cnt_limit water_cnt 
global b2 a2 %滤波器传递函数的系数

% 系统参数
win_size = 30;        % 原始信号进行fft的窗口大小
step_size = 1         % 步进长度
figure_row = 3        % 绘图的row numble
figure_column = 1     % 绘图的column numble
std_limit_value = 0.3 % 判断是否为水面上的标准差阈值
water_cnt_limit = 2   % 判断是否为水面上的连续次数阈值
water_cnt = 0 ;       % 判断可能出现在水面上的次数

%滤波器参数
Fs = 33
fp1=7;fs1=16;
Fs2=Fs/2;
% 这里需要解释一个问题，为何需要将通带和阻带除以采样频率的一半Fs2呢？
% 我们都知道一句话，叫做时域采样，频域延拓。频域的延拓主要是以周期为2 π 2\pi2π进行延拓。
% 也即意味着，经过离散时间傅里叶变换DTFT后，在频域是以2 π 2\pi2π为周期的。
% 具体参考这篇文章时域采样与频域延拓。因此，我们的滤波器实际是这样的
Wp=fp1/Fs2; Ws=fs1/Fs2;
Rp=1; Rs=30;
[n,Wn]=buttord(Wp,Ws,Rp,Rs);
[b2,a2]=butter(n,Wn,'high','s');
%y=filter(b2,a2,dpfs_mat_select');%经过filter滤波之后得到的数据y则是经过带通滤波后的信号数据

%四阶的巴特沃斯高通滤波
high_pass = 10
Wc=2*high_pass/Fs;            % 截止频率 10Hz
[b2,a2]=butter(4,Wc,'high');  % 四阶的巴特沃斯高通滤波

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%数据导入处理
dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat

raw_data = dpfs_mat_select'; %载入原始数据
length = size(dpfs_mat_select',1);

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

myFun(Median_filter,1)
title('辉哥自动上升log')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dpfs_mat_load = load('rawdpfs_water1_origin.mat');   %载入mat数据
% dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat

% raw_data = dpfs_mat_select'; %载入原始数据
% length = size(dpfs_mat_select',1);

% window_size = 11;
% window_data = zeros(window_size,1);
% Median_filter = zeros(length,1);

% for i = 1:length
%     if i <= window_size
%         Median_filter(i) = raw_data(i);
%         window_data(i) = raw_data(i);
%     else
%         window_data(1:window_size-1) = window_data(2:window_size);
%         window_data(window_size) = raw_data(i);
%         Median_filter(i) = GetMedianNum(window_data,window_size);
%     end
% end

% myFun(Median_filter,2)
% title('辉哥水面log1')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water2_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat

raw_data = dpfs_mat_select'; %载入原始数据
length = size(dpfs_mat_select',1);

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

myFun(Median_filter,3)
title('辉哥水面log2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%数据处理函数
function myFun(inputdata,figure_num)
    
    global win_size step_size figure_row figure_column 
    global std_limit_value water_cnt_limit water_cnt 
    global b2 a2 %滤波器传递函数的系数

    length = size(inputdata,1)/2;
%     j = 1
%     for i=1:3:length
%         origindata(j) = inputdata(i)
%         j= j+1
%     end

    %限幅滤波
    for i = 2:length
        if (inputdata(i) < (-80)||inputdata(i)>-13)
            inputdata(i) = inputdata(i-1);
        end
    end 

    % for i = 2:length
    %     if (abs(inputdata(i-1) - inputdata(i))> 20)
    %         inputdata(i) = inputdata(i-1);
    %     end
    % end 
    subplot(figure_row,figure_column,figure_num)
    for i = win_size+1:step_size:length-win_size
        inputdata_filter_ = filter(b2,a2,inputdata(i-win_size:i));%经过filter滤波之后得到的数据y则是经过带通滤波后的信号数据
        
        bsort = sort(inputdata(i-win_size:i),"ascend");
        a =abs(1/ (bsort(1) -(bsort(31) )))

        if (a<0.1)
            after_filter_data(i) = inputdata_filter_(31) * a
            deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
        else
            after_filter_data(i) = inputdata_filter_(31)
            deviation = std(after_filter_data(i-win_size:i),'omitnan')
        end 
    
        result(i) = deviation
        if(deviation > std_limit_value)
            water_cnt = water_cnt +1;
        else
            water_cnt = 0
        end

        if water_cnt>water_cnt_limit            
            water_flag(i)=1*(-80);                     
         else
            water_flag(i)=0;         
         end        
    end

    plot(inputdata)  %滤波前的时域图
    hold on
    plot(result)     %对应点的标准差图
    hold on
    plot(water_flag) %对应点是否在水面的标志位输出
    hold on
    plot(after_filter_data) %滤波后的数据
    hold on
end

%滑动中值滤波
function mid_data = GetMedianNum(bArray,window_size)
    bsort = sort(bArray,"ascend");
    if mod(window_size , 2) ~= 0
        mid_data = bsort((window_size+1) / 2);
    else
        mid_data = (bsort(window_size/2) + bsort(window_size/2+1)) / 2;
    end
    end