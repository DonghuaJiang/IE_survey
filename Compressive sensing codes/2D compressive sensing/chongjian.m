function[R2,G2,B2] = chongjian(R1,G1,B1,KK1,KK2,M,N)
    A_pinv1 = pinv(KK1); A_pinv2 = pinv(KK2);
    Y1 = zeros(M,N); Y2 = zeros(M,N); Y3 = zeros(M,N);
    rec_mat1 = zeros(M,size(R1,2)); 
    for i = 1:size(R1,2)                                                   %  按列恢复-R1重建
        rec = ONSL0(R1(:,i),KK1,A_pinv1);     
        rec_mat1(:,i) = rec;
    end
    rec_mat2 = rec_mat1';                                                  %  按行恢复：转置后按列恢复
    for j = 1:N
        rec = ONSL0(rec_mat2(:,j),KK2,A_pinv2);
        Y1(:,j) = rec;
    end
    rec_mat3 = zeros(M,size(G1,2)); 
    for i = 1:size(G1,2)                                                   %  按列恢复-G1重建
        rec = ONSL0(G1(:,i),KK1,A_pinv1);
        rec_mat3(:,i) = rec;
    end
    rec_mat4 = rec_mat3';                                                  %  按行恢复：转置后按列恢复
    for j = 1:N
        rec = ONSL0(rec_mat4(:,j),KK2,A_pinv2);
        Y2(:,j) = rec;
    end
    rec_mat5 = zeros(M,size(B1,2)); 
    for i = 1:size(B1,2)                                                   %  按列恢复-B1重建
        rec = ONSL0(B1(:,i),KK1,A_pinv1);
        rec_mat5(:,i) = rec;
    end
    rec_mat6 = rec_mat5';                                                  %  按行恢复：转置后按列恢复
    for j = 1:N
        rec = ONSL0(rec_mat6(:,j),KK2,A_pinv2);
        Y3(:,j) = rec;
    end
    R2 = Y1; G2 = Y2; B2 = Y3;
end