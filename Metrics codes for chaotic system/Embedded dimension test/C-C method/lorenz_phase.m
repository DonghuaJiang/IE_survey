% 时间延迟是指delt_s的第一个极小值所对应的t再乘以你的采样时间
% 嵌入维数是由s_cor的最小值所对应的t乘以采样时间得到的延时时间窗口再除以时间延迟再加1所得
% delt_s的第一个极小值对应的时间t就是延迟时间td
% s_cor的最小值对应的就是时间窗tw,然后利用公式tw=（m-1）*td，这样就求出了嵌入维数m

clc
clear
close all

global delt r b; 
delt = 10; b = 8/3; r = 28;
lya_pu = [];
x0 = 1; y0 = 1; z0 = 1;
sim('lorenz.mdl',50);
data_x = x(3000:end);
data_y = y(3000:end);
data_z = z(3000:end);
[s,delt_s,s_cor] = C_CMethod(data_x);

