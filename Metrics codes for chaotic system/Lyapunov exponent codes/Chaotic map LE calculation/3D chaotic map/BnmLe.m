% 计算新提出的三维BNM混沌映射的李雅普诺夫指数
clc
clear
close all

N = 1000; 
a = linspace(0,10,550)'; 
b = 0.3; 
na = length(a); 
LE1 = zeros(na,1); 
LE2 = zeros(na,1);
LE3 = zeros(na,1); 
x = 0.121; y = 0.231; z = 0.218;
for i = 1:na
    LCEvector = zeros(3,1); 
    Q = eye(3); 
    for j = 1:N 
        xprev = x; 
        yprev = y;
        zprev = z; 
        x = cos(a(i)*xprev)*sin(1/(yprev*(1-yprev)^2)); 
        y = cos(xprev*yprev+b*zprev); 
        z = xprev;
        Ji = [-a(i)*sin(1/(y*(1-y)^2))*sin(a(i)*x), -(cos(a(i)*x)*cos(1/(y*(1-y)^2))*(3*y-1))/(y^2*(y-1)^3), 0;
              -y*sin(y*x+b*z),                      -x*sin(x*y+b*z),                                         -b*sin(b*z+x*y);
              1,                                    0,                                                       0];
        B = Ji*Q;
        [Q,R] = qr(B); 
        LCEvector = LCEvector+log(diag(abs(R))); 
    end 
    LE = LCEvector/N; 
    LE1(i) = LE(1); 
    LE2(i) = LE(2);
    LE3(i) = LE(3); 
end 

figure(1);
plot(a,LE1,'-',a,LE2,'-',a,LE3,'-','linewidth',1.5); 
set(gca,'XLim',[0,10]);
set(gca,'YLim',[-4,6]);
legend('\fontname{Times New Roman} \lambda_{1}','\fontname{Times New Roman} \lambda_{2}', ...
       '\fontname{Times New Roman} \lambda_{3}');
xlabel('\fontname{Times New Roman} Tunable Parameter');
ylabel('\fontname{Times New Roman} Lyapunov Exponents'); 
% set(gca,'fontsize',12);
