
clc
clear
close all

win_size = 30;  
step_size = 2 
figure_row = 3  
figure_column =1
time_begin = 5000
time_end = 5500

%滤波器参数
Fs = 33
%四阶的巴特沃斯高通滤波
high_pass = 10
Wc=2*high_pass/Fs;            % 截止频率 10Hz
[b2,a2]=butter(4,Wc,'high');  % 四阶的巴特沃斯高通滤波

scale_value = 10

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dpfs_mat_struct_load = load('1_truesensordata/rawdpfs_grass.mat');  
% dpfs_mat_select_grass = dpfs_mat_struct_load.truedata;

% % length = size(dpfs_mat_select_grass,1)
        

% for i = win_size+time_begin:step_size:time_end-win_size
%     %下面实际上获得的时间窗口内滤波的值，比如长度31，那么滤波后也是31
%     inputdata_filter_ = filter(b2,a2,dpfs_mat_select_grass(i-win_size:i));%inputdata_filter_输出的大小是win_size+1个数据
    
%     %获取时间窗口内的信号峰峰值
%     bsort = sort(dpfs_mat_select_grass(i-win_size:i),"ascend");
%     a =abs(1/ (bsort(1) -(bsort(win_size+1) )))

%     %下面将滤波后的最后一个值变为滤波处理过的值？，同时乘上缩放
%     if (a<0.1)
%         after_filter_data(i) = inputdata_filter_(win_size+1) * a
%         deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
%     else
%         after_filter_data(i) = inputdata_filter_(win_size+1)
%         deviation = std(after_filter_data(i-win_size:i),'omitnan')
%     end 

%     result(i) = deviation * scale_value
% end

% for i = win_size+time_begin:step_size:time_end-win_size
%     deviation = std(result(i-win_size:i),'omitnan')
%     result2(i) = deviation
% end

% subplot(figure_row,figure_column,1)


% plot(dpfs_mat_select_grass)  
% hold on
% plot(result)    
% hold on
% plot(result2,'g')
% hold on

% title('Asphalt pavement')
% xlabel('time(1s/100point)')
% ylabel('lg(amp)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_struct_load = load('1_truesensordata/rawdpfs_water1_origin.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.origindata;

time_begin_hebian = 6647
%time_end_hebian = time_begin_hebian + time_end - time_begin 
time_end_hebian = time_begin_hebian + 2000

% for i = win_size+time_begin:step_size:time_end-win_size
%     deviation = std(dpfs_mat_select_water(i-win_size:i),'omitnan')
%     result(i) = deviation
% end

% for i = win_size+time_begin:step_size:time_end-win_size
%     deviation = std(result(i-win_size:i),'omitnan')
%     result2(i) = deviation
% end

% subplot(figure_row,figure_column,2)

% plot(dpfs_mat_select_water)  
% hold on
% plot(result)    
% hold on
% plot(result2,'g')
% hold on

b = 0
count = 0
count1 = 100
for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
    %下面实际上获得的时间窗口内滤波的值，比如长度是31，那么滤波后也是31
    inputdata_filter_ = filter(b2,a2,dpfs_mat_select_water(i-win_size:i));%inputdata_filter_输出的大小是win_size+1个数据
    
    %获取时间窗口内的信号峰峰值
    bsort = sort(dpfs_mat_select_water(i-win_size:i),"ascend");
    a =abs(1/ (bsort(1) -(bsort(win_size+1) )))

    if (a<0.1)
        count = count + 1
    else
        count = 0
    end

    if(count > 100)
        b = 1;
    end

    if(b == 1)
        a = 1
        count1 = count1 - 1 
    end

    if (count1 == 0)
        b = 0;
        count1 = 100;
    end

    %下面将滤波后的最后一个值变为滤波处理过的值？，同时乘上缩放值
    if (a<0.1)
        after_filter_data(i) = inputdata_filter_(win_size+1) * a
        deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
    else
        after_filter_data(i) = inputdata_filter_(win_size+1)
        deviation = std(after_filter_data(i-win_size:i),'omitnan')
    end 

    result(i) = deviation * scale_value
end

for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
    deviation = std(result(i-win_size:i),'omitnan')
    result2(i) = deviation
end

subplot(figure_row,figure_column,2)

plot(after_filter_data)  
hold on
plot(dpfs_mat_select_water)  
hold on
plot(result)    
hold on
plot(result2,'g')
hold on

title('water1')
xlabel('time(1s/100point)')
ylabel('lg(amp)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dpfs_mat_struct_load = load('origindata/rawdpfs_hebian.mat');   
% dpfs_mat_select_water = dpfs_mat_struct_load.hebian.VarName1;

% time_begin_hebian = 7241
% time_end_hebian = time_begin_hebian + time_end - time_begin 

% % for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
% %     deviation = std(dpfs_mat_select_water(i-win_size:i),'omitnan')
% %     result(i) = deviation
% % end

% % for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
% %     deviation = std(result(i-win_size:i),'omitnan')
% %     result2(i) = deviation
% % end

% for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
%     %下面实际上获得的时间窗口内滤波的值，比如长度31，那么滤波后也是31
%     inputdata_filter_ = filter(b2,a2,dpfs_mat_select_water(i-win_size:i));%inputdata_filter_输出的大小是win_size+1个数据
    
%     %获取时间窗口内的信号峰峰
%     bsort = sort(dpfs_mat_select_water(i-win_size:i),"ascend");
%     a =abs(1/ (bsort(1) -(bsort(win_size+1) )))

%     %下面将滤波后的最后一个值变为滤波处理过的值？，同时乘上缩放
%     if (a<0.1)
%         after_filter_data(i) = inputdata_filter_(win_size+1) * a
%         deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
%     else
%         after_filter_data(i) = inputdata_filter_(win_size+1)
%         deviation = std(after_filter_data(i-win_size:i),'omitnan')
%     end 

%     result(i) = deviation * scale_value
% end

% for i = win_size+time_begin_hebian:step_size:time_end_hebian-win_size
%     deviation = std(result(i-win_size:i),'omitnan')
%     result2(i) = deviation
% end

% subplot(figure_row,figure_column,3)

% plot(dpfs_mat_select_water)  
% hold on
% plot(result)    
% hold on
% plot(result2,'g')
% hold on

% title('water2')
% xlabel('time(1s/100point)')
% ylabel('lg(amp)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %数据处理函数
% function myFun(inputdata,figure_num)
    
%     global win_size step_size figure_row figure_column 
%     global std_limit_value water_cnt_limit water_cnt 
%     global b2 a2 %滤波器传递函数的系数

%     length = size(inputdata,1);
% %     j = 1
% %     for i=1:3:length
% %         origindata(j) = inputdata(i)
% %         j= j+1
% %     end

%     %限幅滤波
%     for i = 2:length
%         if (inputdata(i) < (-70)||inputdata(i)>-13)
%             inputdata(i) = inputdata(i-1);
%         end
%     end 

%     % for i = 2:length
%     %     if (abs(inputdata(i-1) - inputdata(i))> 20)
%     %         inputdata(i) = inputdata(i-1);
%     %     end
%     % end 
%     subplot(figure_row,figure_column,figure_num)
%     for i = win_size+1:step_size:length-win_size
%         inputdata_filter_ = filter(b2,a2,inputdata(i-win_size:i));%经过filter滤波之后得到的数据y则是经过带通滤波后的信号数据
        
%         bsort = sort(inputdata(i-win_size:i),"ascend");
%         a =abs(1/ (bsort(1) -(bsort(31) )))

%         if (a<0.1)
%             after_filter_data(i) = inputdata_filter_(31) * a
%             deviation = std(after_filter_data(i-win_size:i),'omitnan') * a
%         else
%             after_filter_data(i) = inputdata_filter_(31)
%             deviation = std(after_filter_data(i-win_size:i),'omitnan')
%         end 
    
%         result(i) = deviation
%         if(deviation > std_limit_value)
%             water_cnt = water_cnt +1;
%         else
%             water_cnt = 0
%         end

%         if water_cnt>water_cnt_limit            
%             water_flag(i)=1*(-80);                     
%          else
%             water_flag(i)=0;         
%          end        
%     end

%     plot(inputdata)  %滤波前的时域图
%     hold on
%     plot(result)     %对应点的标准差图
%     hold on
%     plot(water_flag) %对应点是否在水面的标志位输出
%     hold on
%     plot(after_filter_data) %滤波后的数据
%     hold on
% end