function ham = HamDis(C1,C2,bitD)
[r,c] = size(C1);
N = 0;
for i = 1:r
    for j = 1:c
        T1 = dec2bin(C1(i,j),bitD);
        T2 = dec2bin(C2(i,j),bitD);
        for k = 1:bitD
            if T1(k) == T2(k)
                N = N + 1;
            end
        end
    end
end

ham = N/(r*c*bitD);