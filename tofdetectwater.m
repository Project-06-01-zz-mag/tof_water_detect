clc
clear
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% 原始信号进行fft的窗口大小
win_size = 30;                        % 原始信号进行fft的窗口大小
frequency_spectrum_x1 = win_size/2 % 信号频率窗口下边界
frequency_spectrum_x2 = win_size      % 信号频率窗口上边界
scale = 100                            % fft信号幅值求和后的缩放
sum_value_limit = 0.15             % 信号求和后认为是水面的信号和限值
water_cnt_limit = 5                    % 连续判断是否在水面上的次数
water_cnt = 0 ;      % 判断可能出现在水面上的次数
step_size = 5       % 步进长度
figure_row = 3       % 绘图的row numble
figure_column = 1    % 绘图的column numble
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_ground1_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat
myFun(dpfs_mat_select',1)
title('辉哥自动上升log')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water1_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat
myFun(dpfs_mat_select',2)
title('辉哥水面log1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_load = load('rawdpfs_water2_origin.mat');   %载入mat数据
dpfs_mat_select=dpfs_mat_load.origindata;  %选择mat
myFun(dpfs_mat_select',3)
title('辉哥水面log2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function myFun(inputdata,figure_num)
    
    global win_size frequency_spectrum_x1 frequency_spectrum_x2 scale sum_value_limit water_cnt step_size water_cnt_limit figure_row figure_column% 原始信号进行fft的窗口大小
    length = size(inputdata);
    
%     j = 1
%     for i=1:3:length
%         origindata(j) = inputdata(i)
%         j= j+1
%     end

    for i = 2:length
        if (inputdata(i) < (-60)||inputdata(i)>-13)
            inputdata(i) = inputdata(i-1);
        end
    end 

    % for i = 2:length
    %     if (abs(inputdata(i-1) - inputdata(i))> 20)
    %         inputdata(i) = inputdata(i-1);
    %     end
    % end 



    for i = win_size+1:step_size:length-win_size
        y= fft(inputdata(i-win_size:i)); %fft计算
        M = abs(y);         %求信号幅度 列向量 ，频率从小到大递增   
        amp_sum = sum(inputdata(i-win_size:i))
        %对选定的频率范围进行求和
        sum_result= sum(M(frequency_spectrum_x1/2:frequency_spectrum_x2/2))/(-amp_sum); %计算单侧频谱的频率阈和
%         for a = i-win_size:i
%             value(a)=sum_result;       
%         end
        value(i) = sum_result;
    
        %判断是否超过水面信号的要求，如果是，就让水面识别次数加1
        if(sum_result > sum_value_limit)
            water_cnt = water_cnt +1;
        else
            water_cnt = 0;
        end
    
    %判断是否超过水面识别的次数，如果超过次数，则认为这一个时刻在水面上
        if water_cnt>water_cnt_limit
           %for a = i:i-win_size
           result(i)=1*(-80);         
           %end
        else
           %for a = i:i+win_size 
           result(i)=0;         
           %end
        end
    end
    
    water_cnt = 0;
    subplot(figure_row,figure_column,figure_num)
    plot(inputdata)
    hold on
    plot(result)
    hold on
    plot(value)
    hold on
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% /*
% *********************************************************************************************************
% *	函 数 名: cfft
% *	功能说明: 对输入的复数组进行快速傅里叶变换（FFT）
% *	形    参: *_ptr 复数结构体组的首地址指针struct型 
% *             FFT_N 表示点数
% *	返 回 值: 无
% *********************************************************************************************************
% */
function cfft(ptr,FFT_N)
    global MAX_FFT_N

    z=FFT_N/2; 
    j = 1
    for i=1:FFT_N-1        
        % /* 
        %     如果i<j,即进行变址 i=j说明是它本身，i>j说明前面已经变换过了，不许再变化，注意这里一般是实数 有虚数部分 设置成结合体 
        % */
        if i<j                    				    
            TempReal1  = ptr(j).real;           	
            ptr(j).real= ptr(i).real;
            ptr(i).real= TempReal1;
        end
            
        k=z;                    				  % 求j的下一个倒位序 
        
        while k<=j               				  % 如果k<=j,表示j的最高位为1                  
            j=j-k;                 				  % 把最高位变成0 */
            k=k/2;                 				  % k/2，比较次高位，依次类推，逐个比较，直到某个位为0，通过下面那句j=j+k使其变为1 */
        end
        
        j=j+k;                   				  % 求下一个反序号，如果是0，则把0改为1 */
    end

    Butterfly_NoPerColumn = FFT_N;						     
	Butterfly_NoPerGroup = 1;	
    M = log2(FFT_N);

    for L = 1:M		     					
    
            Butterfly_NoPerColumn = Butterfly_NoPerColumn /2;		%/* 蝶形组数 假如N=8，则(4,2,1) */
            
            %/* 第L级蝶形 第Butterfly_NoOfGroup组	（0,1，....Butterfly_NoOfGroup-1）*/					
            for Butterfly_NoOfGroup = 1: Butterfly_NoPerColumn            
                for J = 1: Butterfly_NoPerGroup	    %/* 第 Butterfly_NoOfGroup 组中的第J个 */
                					   						    %/* 第 ButterflyIndex1 和第 ButterflyIndex2 个元素作蝶形运算,WNC */
                    ButterflyIndex1 = ( ( Butterfly_NoOfGroup * Butterfly_NoPerGroup ) *2 ) + J;  %/* (0,2,4,6)(0,1,4,5)(0,1,2,3) */
                    ButterflyIndex2 = ButterflyIndex1 + Butterfly_NoPerGroup;                       %/* 两个要做蝶形运算的数相距Butterfly_NoPerGroup (ge=1,2,4) */
                    P = J * Butterfly_NoPerColumn;				                                    %/* 这里相当于P=J*2^(M-L),做了一个换算下标都是N (0,0,0,0)(0,2,0,2)(0,1,2,3) */
                    
                    %/* 计算和转换因子乘积 */
                    TempReal2 = ptr(ButterflyIndex2).real * costab( P ) +  ptr(ButterflyIndex2).imag *  sin( 2 * PI * P / MAX_FFT_N );
                    TempImag2 = ptr(ButterflyIndex2).imag * costab( P )  -  ptr(ButterflyIndex2).real * sin( 2 * PI * P / MAX_FFT_N );
                    TempReal1 = ptr(ButterflyIndex1).real;
                    TempImag1 = ptr(ButterflyIndex1).imag;
                    
                    % 蝶形运算 */
                    ptr(ButterflyIndex1).real = TempReal1 + TempReal2;	
                    ptr(ButterflyIndex1).imag = TempImag1 + TempImag2;
                    ptr(ButterflyIndex2).real = TempReal1 - TempReal2;
                    ptr(ButterflyIndex2).imag = TempImag1 - TempImag2;
                end
            end
            
            Butterfly_NoPerGroup = Butterfly_NoPerGroup *2;							%/* 一组中蝶形的个数(1,2,4) */
    end

end