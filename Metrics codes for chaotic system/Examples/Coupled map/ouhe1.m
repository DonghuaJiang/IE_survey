function dx = ouhe1(t,x)
    dx = zeros(3,1);
    a = 3; u = 2;
    dx(1) = -u*x(1)+x(2)*(x(3)+a);
    dx(2) = -u*x(2)+x(1)*(x(3)-a);
    dx(3) = x(3)-x(1)*x(2);
end