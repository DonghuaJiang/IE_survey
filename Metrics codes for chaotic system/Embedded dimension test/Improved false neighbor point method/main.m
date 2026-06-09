% 使用改进的虚假邻点法，求嵌入维数m的主程序
clc
clear

global delt r b; 
delt = 10; b = 8/3; r = 20;
lya_pu = [];

x0 = 1; y0 = 1; z0 = 1;
sim('lorenz_sim.mdl',50);

data_x = x(3000:end);
data_y = y(3000:end);
data_z = z(3000:end);

tau1 = 14; tau2 = 19; tau3 = 1;
em1 = cao(data_x,1,15,tau1);
fprintf('The embedding dimension of the sequence data_x is :\n');                                                                                                           
disp(em1);
em2 = cao(data_y,1,15,tau2);
fprintf('The embedding dimension of the sequence data_y is :\n');                                                                                                           
disp(em2);
em3 = cao(data_z,1,15,tau3);
fprintf('The embedding dimension of the sequence data_z is :\n');                                                                                                           
disp(em3);