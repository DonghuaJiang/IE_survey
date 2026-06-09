% 计算一维Logistic混沌映射的李雅普诺夫指数
clc     
clear   
close all 

figure(1);
axis([0,4,-5,1]);
grid on,hold on;
title('The Lyapunov Exponent Diagram of Logistic Map');
xlabel('\mu'),ylabel('LE');
x = zeros(1,1000);
x(1) = 0.25;
T0 = 1000;
u = 0:0.01:4;
len = length(u);
sum = zeros(1,len);
for j = 1:len
    for n = 2:T0
        x(n) = u(j)*x(n-1)*(1-x(n-1));
    end
    for i = 101:T0
        y = u(j)*(1-2*x(i));
        sum(j) = sum(j) + log(abs(y));
    end
end
lamuda = sum./(T0-100);
plot(u,lamuda);  
