clear;
close all;
clc;
P = imread('test.dib');     
%% º”√‹Ω‚√‹
tic
Cout=ImageCipher(P,'encryption');
toc
C=Cout{1};
K=Cout{2};
Dout=ImageCipher(C,'decryption',K);
D=Dout{1};
figure(1)
tt = imshow(P,'border','tight');
imwrite(tt.CData,'P.png');
figure(2)
tt = imshow(C,'border','tight');
imwrite(tt.CData,'C.png');
figure(3)
tt = imshow(D,'border','tight');
imwrite(tt.CData,'D.png');
isequal(P,D)