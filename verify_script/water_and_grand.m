
clc
clear
close all

win_size = 30;  
step_size = 1   
figure_row = 2  
figure_column =1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_struct_load = load('origindata/rawdpfs_grass.mat');  
dpfs_mat_select_grass = dpfs_mat_struct_load.rawdpfsgarss.VarName1;

% length = size(dpfs_mat_select_grass,1)

for i = win_size+13100:step_size:13683-win_size
    deviation = std(dpfs_mat_select_grass(i-win_size:i),'omitnan')
    result(i) = deviation
end

subplot(figure_row,figure_column,1)

plot(dpfs_mat_select_grass)  
hold on
plot(result)    
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dpfs_mat_struct_load = load('origindata/rawdpfs_water1.mat');   
dpfs_mat_select_water = dpfs_mat_struct_load.rawdpfswater1.VarName1;



for i = win_size+13100:step_size:13683-win_size
    deviation = std(dpfs_mat_select_water(i-win_size:i),'omitnan')
    result(i) = deviation
end

subplot(figure_row,figure_column,2)

plot(dpfs_mat_select_water)  
hold on
plot(result)    
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%