%% Demo of LSCM-IEA
% -------------------------------------------------------------------------
% For more information, please refer to our paper
% 2D Logistic-Sine-coupling map for image encryption
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% The provided code is free to be used, modified and distributed for
% research purposes only. 
% If you use the code in your paper, please cite our paper. 
% -------------------------------------------------------------------------


%%
clear all
close all
clc

%% Load Image
Image = imread('E:\Images\7.1.03.tiff');
[m,n] = size(Image);
if(max(Image(:))>1)
    F = 256;
else
    F = 2;
end
iMat = double(Image);

%% Encryption
[C,rKey] = Encryption(iMat,m,n);

%% Decryption
P = Decryption( C,m,n,rKey );

figure,subplot(1,2,1),imshow(C),subplot(1,2,2),imshow(P);

%% Chaotic System
[x,y,r,~,~,~] = GenKey( rKey );
% 1.Dynamical Degradation
l = cycleLength(7,r,x,y);
% 2. Chaotic trajectory

sl = 12000;
X = zeros(1,sl);
Y = zeros(1,sl);
r = 0.99;
for i = 1:sl
    x = sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y)));
    y = sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x)));
    X(i) = x;
    Y(i) = y;
end
c = linspace(0,1,6);
figure,plot(X,Y,'.','MarkerSize',1,'MarkerEdgeColor',[0.1,0.1,0.8]);
set(gcf,'Position',[0,500,500,500]);
set(gca,'ytick',c);
legend('(x_0,y_0)');
axis equal
axis([0,1,0,1]);
xlabel('x_i');
ylabel('y_i');
set(gca,'FontSize',20);


%% Performance Index

tmp = iMat;
tmp(1,1) = tmp(1,1)+1;
C1 = Encryption(tmp,m,n,rKey);

% 1. Encryption Speed
t = SpeedTest( Image );

% 2. Number of bit change rate(NBCR)
[NBCR,~] = HammingDistance(C,C1);

% 3. NPCR,UACI,contrast,LocalShannonEntropy
[np,ua,con,lse] = ImagesIndicator( iMat,rKey );

% 4.Key Sensitivity
key = randn(1,256)<0.5;
kf = key;
kl = kf;
kl(1,100) = ~kf(1,100);
I = iMat;
C1 = Encryption( I, m, n, kf );
C2 = Encryption( I, m ,n, kl );
C = uint8(abs(double(C1)-double(C2)));
kn = kf;
kn(1,1) = ~kf(1,1);
P1 = Decryption( C1, m, n, kf );
P2 = Decryption( C1, m ,n, kl );
P3 = Decryption( C1, m, n, kn );
P = uint8(abs(double(P2)-double(P3)));
figure,subplot(2,4,2),imshow(C1),subplot(2,4,3),imshow(C2),
subplot(2,4,4),imshow(C),
subplot(2,4,5),imshow(P1),subplot(2,4,6),imshow(P2),
subplot(2,4,7),imshow(P3),subplot(2,4,8),imshow(P),

