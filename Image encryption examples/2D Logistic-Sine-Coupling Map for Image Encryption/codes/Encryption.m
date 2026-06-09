function varargout = Encryption( iMat,m , n, rKey )
%  º”√‹  
%  iMat          ÕºœÒæÿ’Û
%  m,n           ≤Œ ˝
%  rKey          √‹‘ø


if ~exist('rKey','var')
    rKey = randn(1,256)<0.5;
    varOutN = 2;
else
    varOutN = 1;
end

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


t1 = Permutation( chaoMP1, iMat, 'encryption' );

t2 = Diffusion( chaoMD1, t1, 'encryption',F );

t3 = Permutation( chaoMP2, t2, 'encryption' );

t4 = Diffusion( chaoMD2, t3, 'encryption',F );

t5 = Permutation( chaoMP3, t4, 'encryption' );

t6 = Diffusion( chaoMD3, t5, 'encryption',F );

t7 = Permutation( chaoMP4, t6, 'encryption' );

cipher = Diffusion( chaoMD4, t7, 'encryption',F );



switch F
    case 2
        C = logical(cipher);
    case 256
        C = uint8(cipher);
end

switch varOutN
    case 1
        varargout{1} = C;
    case 2
        varargout{1} = C;
        varargout{2} = rKey;
end


end

