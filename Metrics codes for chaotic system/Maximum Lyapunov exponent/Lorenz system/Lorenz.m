function dX = Lorenz(t,X,params) 
    a = params(1);
    b = params(2);
    c = params(3);
    x = X(1); 
    y = X(2); 
    z = X(3);
    dX = zeros(3,1);
    dX(1) = a*(y-x);
    dX(2) = x*(b-z)-y;
    dX(3) = x*y-c*z;
end 