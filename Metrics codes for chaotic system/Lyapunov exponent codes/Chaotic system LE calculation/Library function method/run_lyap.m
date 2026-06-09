clc
clear
close all

% 计算已知条件下的LE值
global c;
c = 2;
[T,Res] = lyapunov(3,@SimLorenz_ly,@ode45,0,0.5,500,[0.1 0 0.1],0);
Ly = Res(end,:);
disp(Ly);
figure(1); plot(T, Res);
title('Dynamics of Lyapunov exponents');
xlabel('Time'); ylabel('Lyapunov exponents');

% 计算LE图谱
C = -2:0.05:8;
L = length(C);
ly = zeros(3,L);
for i = 1:L
    c = C(i);
    [T,Res] = lyapunov(3,@SimLorenz_ly,@ode45,0,0.5,500,[0.1 0 0.1],0);
    ly(:,i) = Res(end,:);
end
figure(2); plot(C,ly);
xlabel('\itc'); ylabel('Lyapunov exponents');



