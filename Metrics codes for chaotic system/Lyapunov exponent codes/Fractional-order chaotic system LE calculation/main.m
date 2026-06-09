clc
clear
close all
global c;

c = 5;
q = 0.99;
h = 0.005; t0 = 0; tfinal = 100;
y0 = [1;1;1];
% 做分数阶混沌系统的吸引子图
[t, y] = fde12(q,@chao_SimpleLorenz,t0,tfinal,y0,h);
figure(1); plot(y(1,1000:8000),y(3,1000:8000),'b');
% 计算已知条件下的LE值
[Texp, Lp] = lya_cu_whyle_FDE12(3,@SimLorenz_ly,@fde12,0,2,500,y0,h,q);
figure(2); plot(Texp, Lp);

% 计算LE图谱
C = -2:0.05:8;
L = length(C);
ly = zeros(3,L);
for i = 1:L
    c = C(i);
    [Texp, Lp] = lya_cu_whyle_FDE12(3,@SimLorenz_ly,@fde12,0,2,500,y0,h,q);
    ly(:,i) = Lp(:,end);
end
figure(3); plot(C,ly);
xlabel('\itc'); ylabel('Lyapunov exponents');

