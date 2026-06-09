function varargout = Decryption( iMat,m , n, rKey )
% 解密过程
% iMat      已加密的图像矩阵
% m,n       图像矩阵大小
% rKey      解密密钥

p = m*n;
if(max(iMat(:))>1)
    F = 256;
else
    F = 2;
end

iMat = double(iMat);


[x, y, r1, r2, r3, r4] = GenKey( rKey );
seq1 = SequenceGenerator( p,r1,x,y );
seq2 = SequenceGenerator( p,r2,seq1(1,p),seq1(2,p));
seq3 = SequenceGenerator( p,r3,seq2(1,p),seq1(2,p));
seq4 = SequenceGenerator( p,r4,seq3(1,p),seq1(2,p));

chaoMP1 = reshape(seq1(1,:),m,n);
chaoMD1 = reshape(seq1(2,:),m,n);
chaoMP2 = reshape(seq2(1,:),m,n);
chaoMD2 = reshape(seq2(2,:),m,n);
chaoMP3 = reshape(seq3(1,:),m,n);
chaoMD3 = reshape(seq3(2,:),m,n);
chaoMP4 = reshape(seq4(1,:),m,n);
chaoMD4 = reshape(seq4(2,:),m,n);

u1 = Diffusion( chaoMD4, iMat, 'decryption',F );
u2 = Permutation( chaoMP4, u1, 'decryption' );
u3 = Diffusion( chaoMD3, u2, 'decryption',F );
u4 = Permutation( chaoMP3, u3, 'decryption' );
u5 = Diffusion( chaoMD2, u4, 'decryption',F );
u6 = Permutation( chaoMP2, u5, 'decryption' );
u7 = Diffusion( chaoMD1, u6, 'decryption',F );
plain = Permutation( chaoMP1, u7, 'decryption' );





switch F
    case 2
        P = logical(plain);
    case 256
        P = uint8(plain);
end

varargout{1} = P;



end

