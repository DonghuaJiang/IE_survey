function [h,k]=DEDNACODE(P)
h=0;k=0;
if  P=='A'
    h=0;k=0;
end
if  P=='G'
    h=1;k=0;
end
if  P=='C'
    h=0;k=1;
end
 if  P=='T'
     h=1;k=1;
end


return;