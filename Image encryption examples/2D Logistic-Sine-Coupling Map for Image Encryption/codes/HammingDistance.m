function [NBCR,Hm] = HammingDistance( C1,  C2)
%    ººÃ÷¾àÀë
[m,n] = size(C1);
Hm = 0;

for i=1:m
    for j=1:n
        v = bitxor(C1(i,j),C2(i,j));
        fs = strfind(dec2bin(v,8),'1');
        [~,num] = size(fs);
        Hm = Hm + num;
    end
end

NBCR = Hm/(m*n*8);
end

