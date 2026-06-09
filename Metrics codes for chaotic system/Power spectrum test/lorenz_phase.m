% 求解混沌系统功率谱的程序
clc
clear
close all

global delt r b; 
delt = 10; b = 8/3; r = 181;
lya_pu = []; fs = 1/0.01;
x0 = 1; y0 = 1; z0 = 1; ny = 1/2;
sim('lorenz_sim.mdl',100)
data_x = x(3000:end); data_y = y(3000:end); data_z = z(3000:end);
y = fft(data_x);
N = length(y);
y(1) = [];
power_init = log(real(y).^2+imag(y).^2);
power = power_init(1:N/2);
f = (1:N/2)'*fs/N;
index = find(power == max(power));
f_temp = f(index);
T = 1/f_temp;
figure(1);plot(f,power);