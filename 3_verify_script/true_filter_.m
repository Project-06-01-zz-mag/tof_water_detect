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

filename = '6python/1scipe/ffc.1.csv';
delimiterIn = ' '; % 看到空格分开
ffc_log_struct = importdata(filename,delimiterIn);
dspf_raw = ffc_log_struct.data(:,2);
dspf_hpf_dsp = ffc_log_struct.data(:,3);

length_raw = size(dspf_raw,1);
length_end = length_raw;

for i = 1:length_end
    origin(i) = dspf_raw(i);
    dspf_hpf_matlab(i) = filter_hpl(origin(i));
end

for i = 1:length_end
    diff(i) = dspf_hpf_matlab(i) - dspf_hpf_dsp(i) ;
end

timeview = 1:length_end
subplot(4,1,1)
plot(timeview,origin,'r') 
xlabel('time(500point/s)')
ylabel('dpfs')
legend('滤波前原始数据')
hold on

subplot(4,1,2)
plot(timeview,dspf_hpf_dsp,'g') 
xlabel('time(500point/s)')
ylabel('dpfs')
legend('dsp滤波数据')
hold on

subplot(4,1,3)
plot(timeview,dspf_hpf_matlab,'b') 
xlabel('time(500point/s)')
ylabel('dpfs')
legend('matlab滤波数据')
hold on

subplot(4,1,4)
plot(timeview,diff,'r') 
xlabel('time(500point/s)')
ylabel('dpfs')
legend('两种滤波数据的差值')
hold on

function r=filter_hpl(new_data)
    global N
    global a b
    global x y
    global old_new_data
    old_new_data = 0;

    if(new_data<-70||new_data>-5)
        new_data = old_new_data;
    else
        old_new_data = new_data;
    end

    begin = N +1;
    y0= 0;
    for i=begin:-1:2 %从3开始到2，但是N是2
        x(i) = x(i-1);
        y(i) = y(i-1);
        y0 = y0 + b(i) * x(i) - a(i) * y(i) ;
    end
    x(1) = new_data;
    y(1) = y0 + b(1)*x(1);
    r= y(1);
end



