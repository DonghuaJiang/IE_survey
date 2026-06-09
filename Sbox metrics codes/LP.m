function maxlp = LP(box)
% Evaluates Linear Approx. probability of given 8x8 SBox
    n=8;  % for 8x8 sbox
    lp=zeros(256,256);
    maxlp=0;
    for xi=1:1:256
        for yi=1:1:256
            w=0;
            for x=1:1:256
                y=box(x);
                tempx=0;
                tempy=0;
                xxi=bitand(x-1,xi-1);
                yyi=bitand(y,yi-1);
                for i=1:1:n
                    tempx=bitxor(bitget(xxi,i),tempx);
                    tempy=bitxor(bitget(yyi,i),tempy);
                end
                if(tempx==tempy)
                    w=w+1;
                end
            end
            lp(xi,yi)=abs((w/256)-0.5);
            if(lp(xi,yi)>maxlp && xi~=1 && yi~=1)
                maxlp=lp(xi,yi);
            end
        end
    end
end