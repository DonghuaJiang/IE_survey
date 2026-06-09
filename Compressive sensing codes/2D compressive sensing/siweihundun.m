function [X,Y,Z,W] = siweihundun(x0,y0,z0,w0,mm,N,dd) 
    a = 8; b = -1; c = -40; d = 1; e = 2; m = 1; n = -2; k = -13;
    x(1) = x0; y(1) = y0; z(1) = z0; w(1) = w0;
    for i = 1:500+mm*N*dd
        x(i+1) = mod((a*x(i)+b*y(i)*z(i)),1);
        y(i+1) = mod((c*y(i)+d*x(i)*z(i)),1);
        z(i+1) = mod((e*x(i)*y(i)+k*z(i)+m*x(i)*w(i)),1);
        w(i+1) = mod(n*y(i),1);
    end
    for i = 1:500+mm*N*dd
        X(i) = x(i+1);
        Y(i) = y(i+1);
        Z(i) = z(i+1);
        W(i) = w(i+1);
    end
end