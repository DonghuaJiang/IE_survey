function D = three_line(ss,m,CC,rr)
% ss 插入点数
% m重构后空间数值
% CC lnC的值
% rr lnr的值
    m(m == 0) = [];
    p = log(m);
    x = (max(p)-min(p))/ss;
    B1 = 0;
    for b = 1:(ss-1)
       B1 = B1+CC(b)+CC(b+1);
    end
    A1 = abs(0.5*B1*x);
    for n1 = 2:(ss-2)
        for n2 = (n1+1):(ss-1)
            S1(n1,n2) = abs(0.5*(CC(1)+CC(n1))*(rr(1)-rr(n1)));
            S2(n1,n2) = abs(0.5*(CC(n1)+CC(n2))*(rr(n1)-rr(n2)));
            S3(n1,n2) = abs(0.5*(CC(n2)+CC(ss))*(rr(n2)-rr(ss)));
        end
    end
    A2 = S1+S2+S3;
    G1 = A2-A1;
    X = sort(abs(G1(:)),'ascend');
    c = X(X ~= A1);
    mn = c(1);
    [min_n,max_n] = find(G1 == mn);
    LinearZone = [min_n:max_n];
    KK = polyfit(rr(LinearZone),CC(LinearZone),1);
    D = KK(1);
end
  