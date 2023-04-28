clc
clear
close all

global win_size result2_value_threshold result2_count_threshold

win_size = 30;  
result2_value_threshold = 5      %二次标准差的阈值
result2_count_threshold = 33     %超过阈值的次数

dpfs_mat_struct_load = load('4_rawdata_fromtime/truedata_fromtime_Asphaltroad.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.new_fpds;
length_raw = size(dpfs_mat_select_water',1)
picture_location_row = 1
picture_location = 1
myFun(dpfs_mat_select_water',picture_location_row,picture_location,2,170)
title(['Asphalt road,win=',num2str(win_size),',value threshold=',num2str(result2_value_threshold),',count threshold=',num2str(result2_count_threshold)])

dpfs_mat_struct_load = load('4_rawdata_fromtime/truedata_fromtime_watertest1.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.new_fpds;
length_raw = size(dpfs_mat_select_water',1)
picture_location_row = 1
picture_location = 2
myFun(dpfs_mat_select_water',picture_location_row,picture_location,2,49)
title(['watet test 1,win=',num2str(win_size),',value threshold=',num2str(result2_value_threshold),',count threshold=',num2str(result2_count_threshold)])

dpfs_mat_struct_load = load('4_rawdata_fromtime/truedata_fromtime_watertest2.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.new_fpds;
length_raw = size(dpfs_mat_select_water',1)
picture_location_row = 1
picture_location = 3
myFun(dpfs_mat_select_water',picture_location_row,picture_location,2,80)
title(['watet test 2,win=',num2str(win_size),',value threshold=',num2str(result2_value_threshold),',count threshold=',num2str(result2_count_threshold)])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%数据处理函数
function myFun(inputdata,figure_row,figure_num,time_begin_s,time_end_s)
    global win_size result2_value_threshold result2_count_threshold

    step_size = 2 
    % figure_row = 1  
    figure_column =1
    scale_value =10 %结果缩放

    %滤波器参数
    Fs = 33
    high_pass = 10
    Wc=2*high_pass/Fs;            % 截止频率 10Hz
    [b2,a2]=butter(4,Wc,'high');  % 四阶的巴特沃斯高通滤波

    b = 0           % 控制极值缩放的开关
    count = 0       % 极值个数阈值
    count1 = 100    % 反极值个数阈值

    % result2_value_threshold = 5      %二次标准差的阈值
    result2_over_threshold_count_now = 0 %二次标准差的超阈值次数
    % result2_count_threshold = 33     %超过阈值的次数

    length = size(inputdata,1); % 获取输入数据的长度
    samplingrate = 33
    time_all = length/samplingrate 
    time=0:1/samplingrate:time_all-1/samplingrate

    
    figure(figure_num)
    % subplot(figure_row,figure_column,figure_num)
    plot(time,inputdata)  %滤波前的时域图
    hold on
    for i = 2:length            % 限幅滤波
        if (inputdata(i) < (-70)||inputdata(i)>-5)
            inputdata(i) = inputdata(i-1);
        end
    end 

    plot(time,inputdata)  %限幅滤波后的时域图
    hold on

    time_begin = time_begin_s / (1/33) - win_size
    time_end = time_end_s/ (1/33) + win_size

    for i = win_size+time_begin:step_size:time_end-win_size
        inputdata_filter_ = filter(b2,a2,inputdata(i-win_size:i));%经过filter滤波之后得到的数据y则是经过带通滤波后的信号数据
        
        bsort = sort(inputdata(i-win_size:i),"ascend");
        a =abs(1/ (bsort(1) -(bsort(win_size+1))))
    
        after_filter_data(i) = inputdata_filter_(win_size+1)
        deviation = std(after_filter_data(i-win_size:i),'omitnan')

        result(i) = deviation * scale_value  
    end

    for i = win_size+time_begin:step_size:time_end-win_size
        deviation = std(result(i-win_size:i),'omitnan')
        result2(i) = deviation

        if (result2(i) > result2_value_threshold)
            result2_over_threshold_count_now = result2_over_threshold_count_now +1
        else
            result2_over_threshold_count_now = 0;
        end

        if (result2_over_threshold_count_now > result2_count_threshold)
            result3(i) = -60;
        else
            result3(i) = 0;
        end
    end

    sizetimeview = size(after_filter_data,2)   %重新计算时间序列
    time_all2 = sizetimeview/samplingrate 
    timeview=0:1/samplingrate:time_all2-1/samplingrate
    plot(timeview,after_filter_data','k') %滤波后的数据
    hold on
    plot(timeview,result,'r:')    
    hold on
    plot(timeview,result2,'g.')
    hold on
    plot(timeview,result3)
    hold on
    grid on
    set(gca, 'XTick', 0:time_all/20:time_all);  %调整网格的大小
    set(gca, 'YTick', -90:110/20:20); 
    xlabel('time(s)')
    ylabel('dpfs(lg(amp))')
    legend('raw-data','Limit-amp-filter','Hps-filter','standard-deviation','Secondary-standard-deviation','water flag')

end