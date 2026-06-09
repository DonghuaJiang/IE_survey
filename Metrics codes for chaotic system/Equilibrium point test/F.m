function  f = F(x,y,z)
    f = [-delt*(x-y); 
         -x*z+r*x-y; 
         x*y-b*z];
end