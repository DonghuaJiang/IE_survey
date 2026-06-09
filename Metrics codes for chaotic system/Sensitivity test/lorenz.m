function dx = lorenz(t,x);

global sigma rho beta
dx=[sigma*(x(2)-x(1));
    x(1)*(rho-x(3))-x(2);
    x(1)*x(2)-beta*x(3)];