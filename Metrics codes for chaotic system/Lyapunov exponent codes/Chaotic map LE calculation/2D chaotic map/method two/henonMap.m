% henonMap.m – function defining the Henon map.
function out = henonMap(x,a,b)
    out = zeros(6,1);
    out(1) = 1-a*(x(1))*(x(1))+x(2);
    out(2) = b*x(1);
    out(3:6) = [-2*x(1), b; 1, 0];
end