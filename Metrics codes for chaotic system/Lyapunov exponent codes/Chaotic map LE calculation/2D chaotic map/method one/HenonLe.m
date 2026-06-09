% 计算二维Henon混沌映射的李雅普诺夫指数
clc
clear
close all

N = 1000; 
a = (0:0.001:1.4)'; 
b = 0.3; 
na = length(a); 
LE1 = zeros(na,1); 
LE2 = zeros(na,1); 
x = 0.2; y = 0.3; 
for i = 1:na 
    LCEvector = zeros(2,1); 
    Q = eye(2); 
    for j = 1:N 
        xprev = x; 
        yprev = y; 
        x = 1-a(i)*xprev*xprev+yprev; 
        y = b*xprev; 
        Ji = [-2*a(i)*x,1;b,0];
        B = Ji*Q;
        [Q,R] = qr(B); 
        LCEvector = LCEvector+log(diag(abs(R))); 
    end 
    LE = LCEvector/N; 
    LE1(i) = LE(1); 
    LE2(i) = LE(2); 
end 

figure(1); hold on;
plot(a,LE1,'g','linewidth',1) ;
plot(a,LE2,'b','linewidth',1);  
set(gca,'XLim',[0 1.4]);
set(gca,'YLim',[-2 1]);
legend('\lambda1','\lambda2');
plot([0 1.4],[0 0],'k--','linewidth',1)
xlabel('a');ylabel('LE');
set(gca,'fontsize',10);
