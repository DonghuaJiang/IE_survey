clc
clear
close all

d0 = 0.035; Z = []; r = 0.5;
for u = linspace(0,10,600)
   lsum = 0;
   x = [r;u];
   x1 = [r+d0;u];
   for k = 1:1000
       x = improve_logistic(x);
       x1 = improve_logistic(x1);
       d1 = sqrt((x(1)-x1(1))^2);     % 1范数
       x1 = x+(d0/d1)*(x1-x);
       if k > 700
           lsum = lsum+log(d1/d0);
       end
       x = [x(1);u];
       x1 = [x1(1);u];
   end
   le = lsum/(k-700);
   Z = [Z,le]; 
end
plot(linspace(0,10,600),Z,'-'); grid on; axis([0,10,-1,6]);
xlabel('u','fontsize',12,'FontAngle','italic');
ylabel('Lyapunov exponent','fontsize',12,'FontAngle','italic');