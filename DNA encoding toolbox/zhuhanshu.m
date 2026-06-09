clc
clear all;
%%假设A、B分别为256*256大小的图像,通过DNA编码进行异或加密
A=imread('image1.jpg'); %读取image1图像
B=imread('image2.jpg'); %读取image2图像
[M,N]=size(A);
A=reshape(A,M,N);
%%DNA编码部分
[DNA11,DNA12,DNA13,DNA14]=DNA(A);
B=reshape(B,M,N);
[DNA21,DNA22,DNA23,DNA24]=DNA(B);
DNA11=reshape(DNA11,1,M*N);
DNA12=reshape(DNA12,1,M*N);
DNA13=reshape(DNA13,1,M*N);
DNA14=reshape(DNA14,1,M*N);
DNA21=reshape(DNA21,1,M*N);
DNA22=reshape(DNA22,1,M*N);
DNA23=reshape(DNA23,1,M*N);
DNA24=reshape(DNA24,1,M*N);
%%DNA异或部分
for i=1:M*N
    DNA31(i)=DNAXOR(DNA11(i),DNA21(i));
    DNA32(i)=DNAXOR(DNA12(i),DNA22(i));
    DNA33(i)=DNAXOR(DNA13(i),DNA23(i));
    DNA34(i)=DNAXOR(DNA14(i),DNA24(i));
end
%%DNA解码合并
 for i=1:M*N
    [A11(i),B11(i)]=DEDNACODE(DNA31(i));
    [C11(i),D11(i)]=DEDNACODE(DNA32(i));
    [E11(i),F11(i)]=DEDNACODE(DNA33(i));
    [G11(i),H11(i)]=DEDNACODE(DNA34(i));
 end
A11=reshape(A11,M,N);
B11=reshape(B11,M,N);
C11=reshape(C11,M,N);
D11=reshape(D11,M,N);
E11=reshape(E11,M,N);
F11=reshape(F11,M,N);
G11=reshape(G11,M,N);
H11=reshape(H11,M,N);
%合并    
Array{1}=A11;
Array{2}=B11;
Array{3}=C11;
Array{4}=D11;
Array{5}=E11;
Array{6}=F11;
Array{7}=G11;
Array{8}=H11;
IMAGE=zeros(M,N,'uint8');
for i=1:8
  IMAGE=bitset(IMAGE,i,Array{i});
end
figure(1)
imshow(uint8(IMAGE));