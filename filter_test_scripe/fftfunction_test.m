clc
clear
close all

Fs = 256; % 采样率
L = 256; % 采样点数
n = 0:L-1; % 采样序列
t = 0:1/Fs:1-1/Fs; % 时间序列

global MAX_FFT_N
MAX_FFT_N = 1024

for i = 1 : MAX_FFT_N
    s(i).real = 1 + cos(2*3.1415926*10*i/MAX_FFT_N + 3.1415926/3);
    s(i).imag = 0 ;
end 

for i = 1 : MAX_FFT_N
    origin(i) = s(i).real 
end 

subplot(2,1,1)
plot(origin)
hold on

cfft(s, MAX_FFT_N);
	
for i=1:MAX_FFT_N
    amp(i) = s(i).real *s(i).real+ s(i).imag*s(i).imag 		
end

subplot(2,1,2)
plot(amp)
hold on

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
        
        j=uint32(j+k);                   				  % 求下一个反序号，如果是0，则把0改为1 */
    end

    Butterfly_NoPerColumn = FFT_N-2;						     
	Butterfly_NoPerGroup = 1;	
    M = uint32(log2(FFT_N))

    for L = 1:M		     					
    
            Butterfly_NoPerColumn = uint32(Butterfly_NoPerColumn /2);		%/* 蝶形组数 假如N=8，则(4,2,1) */            
            %/* 第L级蝶形 第Butterfly_NoOfGroup组	（0,1，....Butterfly_NoOfGroup-1）*/					
            for Butterfly_NoOfGroup = 1: Butterfly_NoPerColumn            
                for J = 1: Butterfly_NoPerGroup	    %/* 第 Butterfly_NoOfGroup 组中的第J个 */
                					   						    %/* 第 ButterflyIndex1 和第 ButterflyIndex2 个元素作蝶形运算,WNC */
                    ButterflyIndex1 = ( ( Butterfly_NoOfGroup * Butterfly_NoPerGroup ) *2 ) + J;  %/* (0,2,4,6)(0,1,4,5)(0,1,2,3) */
                    ButterflyIndex2 = ButterflyIndex1 + Butterfly_NoPerGroup;                       %/* 两个要做蝶形运算的数相距Butterfly_NoPerGroup (ge=1,2,4) */
                    P = J * Butterfly_NoPerColumn;				                                    %/* 这里相当于P=J*2^(M-L),做了一个换算下标都是N (0,0,0,0)(0,2,0,2)(0,1,2,3) */
                    
                    if ButterflyIndex2>1024
                         TempReal2 = ptr(ButterflyIndex2).real * cos(single(2 * pi * P / MAX_FFT_N)  ) +  ptr(ButterflyIndex2).imag *  sin( single(2 * pi * P / MAX_FFT_N ));
                    end
                    %/* 计算和转换因子乘积 */
                    TempReal2 = ptr(ButterflyIndex2).real * cos(single(2 * pi * P / MAX_FFT_N)  ) +  ptr(ButterflyIndex2).imag *  sin( single(2 * pi * P / MAX_FFT_N ));
                    TempImag2 = ptr(ButterflyIndex2).imag * cos( single(2 * pi * P / MAX_FFT_N) )  -  ptr(ButterflyIndex2).real * sin(single( 2 * pi * P / MAX_FFT_N ));
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