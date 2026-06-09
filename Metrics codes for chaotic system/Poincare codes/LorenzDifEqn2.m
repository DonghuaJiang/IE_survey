function dx = LorenzDifEqn2(~,x)
% Lorenz系统的微分方程如下: 
% dx = -σ*(x-y)
% dy = -x*z+r*x-y
% dz = x*y-b*z
    sigma = 10;
    b = 8/3;
    r = 28;
    dx = [-sigma*(x(1)-x(2));-x(1)*x(3)+r*x(1)-x(2);x(1)*x(2)-b*x(3)];