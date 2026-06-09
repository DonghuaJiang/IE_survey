%% 奇异值分解法计算耦合系统的李雅普诺夫指数谱
Z1 = []; Z2 = []; Z3 = [];
x = 1; y = 1; z = 1;
h = 0.002; u = 2; k = 10000;
for a = linspace(0.5,10.5,1000)
    V = eye(3);
    S = V;
    b1 = 0;
    lp = 0;
    for i = 1:k   
        x1 = x+h*(-u*x+y*(z+a));                                           % 欧拉离散化
        y1 = y+h*(-u*y+x*(z-a));    
        z1 = z+h*(z-x*y);
        x = x1; y = y1; z = z1;   
        J = [ -u  a+z   y    
             z-a   -u   x    
              -y   -x   1];
        J = eye(3)+h*J;    
        B = J*V*S;    
        [V,S,U] = svd(B);
        a_max = max(diag(S));
        S = (1/a_max)*S;    
        b1 = b1+log(a_max);
    end
    lp = (log(diag(S))+b1)/(k*h);
    Z1 = [Z1 lp(1)];
    Z2 = [Z2 lp(2)];
    Z3 = [Z3 lp(3)];
end
figure(4);
a = linspace(0.5,10.5,1000);
plot(a,Z1,'-',a,Z2,'-',a,Z3,'-');
axis([0.5,10.5,-5,2]);
title('Lyapunov exponents of ouhe system');
xlabel('parameter a'),ylabel('lyapunov exponents');
grid on;
