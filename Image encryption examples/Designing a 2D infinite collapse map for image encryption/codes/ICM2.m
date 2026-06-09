function [cx,cy] = ICM2(x0,y0,a,b,m,n)
    cx = zeros(m,n); cy = zeros(m,n);
    cx(1) = x0; cy(1) = y0;
    for i = 1 : m*n-1
        cx(i+1) = sin(a/cy(i))*sin(b/cx(i));
        cy(i+1) = sin(a/cx(i))*sin(b/cy(i));
    end
end

