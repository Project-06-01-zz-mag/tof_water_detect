clear
clc

f1=5;%第一个点频信号分量频率
f2=15;%第二个点频信号分量频率
f3=30;%第三个点频信号分量频率
fs=150;%采样率
T=2;%时宽
B=25;%FIR截止频率
n=round(T*fs);%采样点个数
t=linspace(0,T,n);
y=cos(2*pi*f1*t)+cos(2*pi*f2*t)+cos(2*pi*f3*t);

figure;
subplot(221)
plot(t,y);
title('原始信号时域');
xlabel('t/s');
ylabel('幅度');

fft_y=fftshift(fft(y));
f=linspace(-fs/2,fs/2,n);
subplot(222)
plot(f,abs(fft_y));
title('原始信号频谱');
xlabel('f/Hz');
ylabel('幅度');
axis([ 0 50 0 100]);

b=fir1(80, B/(fs/2),'high'); %高通
y_after_fir=filter(b,1,y);
subplot(223)
plot(t,y_after_fir);
title('滤波后信号时域');
xlabel('t/s');
ylabel('幅度');

fft_y1=fftshift(fft(y_after_fir));
f=linspace(-fs/2,fs/2,n);
subplot(224)
plot(f,abs(fft_y1));
title('滤波后信号频谱');
xlabel('f/Hz');
ylabel('幅度');
axis([ 0 50 0 100]);

figure;
freqz(b);%数字滤波器频率响应
