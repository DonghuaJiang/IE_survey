% 基于定义法的分段Tent映射李雅普诺夫指数计算
clc
clear
close all

u = 0:0.001:1;
len = length(u);
y = zeros(1,len);
for i = 1:len
    y(i) = log(abs(2*u(i)));
end
figure(1); plot(u,y,'r.','markersize',2); hold on;
x = get(gca,'xlim'); y = 0;
plot(x,[y y],'k'); axis([0,1,-5,1]);
set(gca,'Xtick',(0:0.2:1));
set(gca,'Ytick',(-5:1:1));
xlabel('u');
ylabel('Lyapunov Exponent');
