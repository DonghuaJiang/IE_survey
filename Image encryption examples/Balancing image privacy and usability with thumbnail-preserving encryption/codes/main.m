clc
clear
close all
P = imread('boy.png');
% P = imread('tiffany.tif');
R = P(:,:,1);
G = P(:,:,2);
B = P(:,:,3);
R(1)=0;
G(1)=0;
B(1)=0;
K = 128;
keyr = 'r';
keyg = 'g';
keyb = 'b';
% tic
T = 20;
Cr = Jiami(R,K,T,keyr);
Cg = Jiami(G,K,T,keyg);
Cb = Jiami(B,K,T,keyb);
C = cat(3,Cr,Cg,Cb);
imshow(C);
% d = 0.01;
% C=imnoise(C,'gaussian',0,d);%∏ﬂÀπ‘Î…˘
% C=imnoise(C,'salt & pepper',d);%Ω∑—Œ‘Î…˘
% C=imnoise(C,'speckle',d);%∞ﬂµ„‘Î…˘
% C(48:80,48:80,:)=0;
Cr = C(:,:,1);
Cg = C(:,:,2);
Cb = C(:,:,3);
Dr = Jiemi(Cr,K,T,keyr);
Dg = Jiemi(Cg,K,T,keyg);
Db = Jiemi(Cb,K,T,keyb);
D = cat(3,Dr,Dg,Db);
% figure
% imshow(C)
% figure
% imshow(D)
% imwrite(C,'ck8q95.jpg','quality',95)
imwrite(C,'2.png')