function dx = ouhe(t,x)
    dx(1,1) = -x(4)*x(1)+x(2)*(x(3)+x(5));
    dx(2,1) = -x(4)*x(2)+x(1)*(x(3)-x(5));
    dx(3,1) = x(3)-x(1)*x(2);
    dx(4,1) = 0;
    dx(5,1) = 0;
end