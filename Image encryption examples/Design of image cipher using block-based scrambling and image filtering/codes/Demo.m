%%================================================================================
%This functionto do image encryption using the reference in
%         [1]. Hua, Zhongyun, et al. "Design of image cipher using block-based scrambling and
%              image filtering.", Information Sciences 396 (2017): 97-113.
%All copyrights are reserved by Zhongyun Hua. E-mial:huazyum@gmail.com
%All following source code is free to distribute, to use, and to modify
%    for research and study purposes, but absolutely NOT for commercial uses.
%If you use any of the following code in your academic publication(s), 
%    please cite the corresponding paper. 
%If you have any questions, please email me and I will try to response you ASAP.
%It worthwhile to note that all following source code is written under MATLAB R2010a
%    and that files may call built-in functions from specific toolbox(es).
%%================================================================================

%%
clear all
close all
clc
%% 1. Load plaintext images
% Image 1
P = imread('cameraman.tif');
%%=========================================================================

%% 2. Encryption
[C,K] = ImageCipher(P,'en');
%%=========================================================================

%% 3. Decryption
D = ImageCipher(C,'de',K);
%%=========================================================================

%% 4. Analaysis
% 4.1 Histogram
figure,subplot(221),imshow(P,[]),subplot(222),imshow(C,[])
subplot(223),imhist(P),subplot(224),imhist(C)
%%=========================================================================

% 4.2 the Local Shannon entropy test
%LSE = LocalEntropy(C);
%%=========================================================================

% 4.3 the NPCR and UACI test
% change one bit of a randomly selected pixel 
% to generate a new plaintext image P2
[row, column] = size(P);
r = randi(row,1);
c = randi(column,1);
P2 = P;
if P2(r,c) == 0
    P2(r,c) = P2(r,c)+1;
else
    P2(r,c) = P2(r,c) -1;
end

% encrypte P2 with the same security key K
C2 = ImageCipher(P2,'en',K);

% compute the NPCR value of C and C2;
D = zeros(row,column);
for i = 1:row
    for j = 1:column
        if C2(i,j) ~= C(i,j)
            D(i,j) = 1;
        end
    end
end
NPCR = sum(D(:))/(row*column)*100;

% compute the UACI value of C and C2;
C = double(C);
C2 = double(C2);
A = zeros(row,column);
for i = 1:row
    for j = 1:column
        A(i,j)=abs(C(i,j)-C2(i,j));
    end
end
UACI = sum(A(:))/(255*row*column)*100;
%%=========================================================================

% 4.4 Key Sensitivity
% Load plaintext images
P = imread('cameraman.tif');

% Generate three similar keys
K = round(rand(1,256));
K2 = K;
K2(200) = 1-K(200);

K3 = K;
K3(240) = 1-K(240);

% Encryption Sensitivity
C = ImageCipher(P,'en',K);
C2 = ImageCipher(P,'en',K2);


% Decryption Sensitivity
D = ImageCipher(C,'de',K);
D2 = ImageCipher(C,'de',K2);
D3 = ImageCipher(C,'de',K3);

figure,
subplot(241),imshow(P,[]),title('P'),subplot(242),imshow(C,[]),title('C_1'),
subplot(243),imshow(C2,[]),title('C_2'),subplot(244),imshow(imabsdiff(C,C2),[]),title('|C_1-C_2|'),
subplot(245),imshow(D,[]),title('D_1'),subplot(246),imshow(D2,[]),title('D_2'),
subplot(247),imshow(D3,[]),title('D_3'),subplot(248),imshow(imabsdiff(D2,D3),[]),title('|D_2-D_3|')




