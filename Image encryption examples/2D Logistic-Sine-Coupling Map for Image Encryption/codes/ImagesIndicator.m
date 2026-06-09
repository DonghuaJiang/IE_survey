function [np,ua,con,H] = ImagesIndicator( P,key )
% 安全指标

[M,N] = size(P);
S1 = double(P);
S2 = S1;
% load('F:\PaperForJF\key.mat');

C1 = Encryption(S1,M,N,key);
con = 0;
H = 0;

x = unidrnd(M);
y = unidrnd(N);
v = S1(x,y);
b = dec2bin(v);
l = length(b);
if b(l)=='0'
    b(l)='1';
else
    b(l)='0';
end

S2(x,y) = bin2dec(b);
C2 = Encryption(S2,M,N,key);

[ np,ua ] = NPCR_UACI( C1,C2 );
con = Contrast(C1);
H = LocalShannonEntropy( C1 );


end

