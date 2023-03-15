% clc
% clear
% close all

% tofampdpsfload = load('tofdpsf1.mat');
tofampdpsfload = load('huioutrise.mat');
tofampdpsf=tofampdpsfload.huioutorise;
tof_data = tofampdpsf.VarName1;
length = size(tof_data);
win_size = 500;

tof_var=zeros(501,5000)
result=zeros(45505,1)

n = 0:win_size; % ²ÉÑùÐòÁÐ

figure
% subplot(2,1,1)
hold on
plot(tof_data)
hold off
legend("tofampdpsf")

% for i = 1:1000:length-win_size
%     tof_var(win_size,i) = fft(tof_data(i:i+win_size));
% end

for i = 1:win_size:length-win_size
    tof_var(:,i) = fft(tof_data(i:i+win_size));
    M = abs(tof_var(:,i));
    
%     subplot(2,1,2)
%     hold on
%     plot(n,M)
%     hold off
%     legend("tof var")

    if M(499) > 500
       for a = i:i+win_size
        result(a)=1*(-80);         
       end
    else
       for a = i:i+win_size
        result(a)=0;         
       end
    end
    
%     subplot(2,1,2)

    
end

hold on
plot(result)
hold off
legend("tof var")

% figure

% subplot(2,1,1)
% hold on
% plot(tof_data)
% hold off
% legend("tofampdpsf")

% subplot(2,1,2)
% hold on
% plot(tof_var)
% hold off
% legend("tof var")

