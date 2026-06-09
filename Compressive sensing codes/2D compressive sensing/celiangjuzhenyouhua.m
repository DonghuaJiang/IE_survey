function [KK1,KK2] = celiangjuzhenyouhua(A1,A2,mm,N)
    [~,cc,~] = svd(A1);
    [~,cc1,~] = svd(A2);
    H = ones(512);
    H1 = ones(512);
    a1 = diag(H);
    a2 = diag(cc);
    a3 = diag(cc1);
    ave = mean(a1(:)); 
    I = find(a2>=ave); J = length(I);
    I1 = find(a3>=ave); J1 = length(I1);
    T1 = 5;
    for i = 1:mm
        for j = 1:J
            H(i,j) = H(i,j)*T1;
        end
    end
    for i = 1:mm
        for j = 1:J1
            H1(i,j) = H1(i,j)*T1;
        end
    end
    HH1 = A1*H;
    HH2 = A2*H1;
    [bbb1,ccc1,ddd1] = svd(HH1);
    ccc1(ccc1~=0) = 1;
    AA1 = bbb1*ccc1*(ddd1');
    KK1 = reshape(AA1,mm,N);
    [bbb2,ccc2,ddd2] =svd(HH2);
    ccc2(ccc2~=0) = 1;
    AA2 = bbb2*ccc2*(ddd2');
    KK2 = reshape(AA2,mm,N);
end