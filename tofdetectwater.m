% clc
% clear
% close all


tofampdpsfload = load('tofdpsf1.mat');
tofampdpsf=tofampdpsfload.tofdsps1;
tof_data = tofampdpsf.VarName1;
length = size(tof_data);
win_size = 3000;

for i = 1:length-win_size
    tof_var(i,1) = var(tof_data(i:i+win_size));
end

figure
subplot(2,1,1)
hold on
plot(tof_data)
hold off
legend("tofampdpsf")
subplot(2,1,2)
hold on
plot(tof_var)
hold off
legend("tof var")

