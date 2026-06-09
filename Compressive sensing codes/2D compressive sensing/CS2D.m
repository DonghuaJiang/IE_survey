clc
clear
close all

%% 压缩阶段
P1 = imread('lena512.tif');                                                % 读入图像
[M,N,K] = size(P1);
RP1 = double(P1(:,:,1));
GP1 = double(P1(:,:,2));
BP1 = double(P1(:,:,3));                                                   % 拆分图像的三基色分量
fid = fopen('Lena-256.txt');                                               % 读取明文图像的哈希值并转化为32位数
sha256 = textscan(fid, '%s');
fc = fclose(fid);
KEY = sha256{1,1}{1,1};
k = zeros(1,32);
for i = 1:32
    k(i) = hex2dec(KEY(2*(i-1)+1:2*i));
end
t1 = 0.354564; t2 = 0.154354; t3 = 0.254168; t4 = 0.445635; t5 = 0.562725; % 求连个混沌系统的初始值
x0 = (t1/256)*(bitxor(bitxor(bitxor(bitxor(bitxor(k(1),k(2)),k(3)),k(4)),k(5)),k(6)));
y0 = (t2/256)*(bitxor(bitxor(bitxor(bitxor(bitxor(k(7),k(8)),k(9)),k(10)),k(11)),k(12)));
z0 = (t3/256)*(bitxor(bitxor(bitxor(bitxor(bitxor(k(13),k(14)),k(15)),k(16)),k(17)),k(18)));
w0 = (t4/256)*(bitxor(bitxor(bitxor(bitxor(bitxor(k(19),k(20)),k(21)),k(22)),k(23)),k(24)));
a0 = (t5/256)*(bitxor(bitxor(bitxor(bitxor(bitxor(k(25),k(26)),k(27)),k(28)),k(29)),k(30)));
x6 = mod(((t1*t2*t3*t4*t5)/bitxor(k(14),k(15)))*10^10,1)+2.89;
ww = DWT(M);                                                               % 对图像的RGB分量进行二维稀疏
R1 = ww*RP1*ww';
G1 = ww*GP1*ww';
B1 = ww*BP1*ww';
threshold = 0;                                                             % 设置阈值
for i = 1:M
    for j = 1:N
        if abs(R1(i,j)) < threshold
            R1(i,j) = 0;
        end
        if abs(G1(i,j)) < threshold
            G1(i,j) = 0;
        end
        if abs(B1(i,j)) < threshold
            B1(i,j) = 0;
        end
    end
end
CR = 0.25;                                                                 % 压缩率
mm = ceil(M*CR);
nn = ceil(N*CR);
dd = 25;
[X,Y,Z,W] = siweihundun(x0,y0,z0,w0,mm,N,dd);                              % 迭代四维混沌系统，生成序列X,Y,Z,W
[A1,A2] = celiangjuzhen(X,Y,Z,W,mm,N,dd);                                  % 生成测量矩阵
[KK1,KK2] = celiangjuzhenyouhua(A1,A2,mm,N);                               % 测量矩阵优化  
R2 = full(KK1*R1*KK2');                                                    % 压缩感知测量
G2 = full(KK1*G1*KK2');
B2 = full(KK1*B1*KK2' );
mmax1 = max(R2(:)); mmin1 = min(R2(:));                                    % 量化
img_com1 = uint8(round(255*(R2-mmin1)/(mmax1-mmin1)));  
mmax2 = max(G2(:)); mmin2 = min(G2(:));                                    
img_com2 = uint8(round(255*(G2-mmin2)/(mmax2-mmin2))); 
mmax3 = max(B2(:)); mmin3 = min(B2(:));                                    
img_com3 = uint8(round(255*(B2-mmin3)/(mmax3-mmin3)));
P2 = zeros(mm,nn,3);
P2(:,:,1) = img_com1; P2(:,:,2) = img_com2; P2(:,:,3) = img_com3;

%% 重建阶段
R3 = double(img_com1)*(mmax1-mmin1)/255+mmin1;                             % 逆量化 
G3 = double(img_com2)*(mmax2-mmin2)/255+mmin2;   
B3 = double(img_com3)*(mmax3-mmin3)/255+mmin3;   
[R4,G4,B4] = chongjian(R3,G3,B3,KK1,KK2,M,N);                              % ONSLO算法重建
R5 = uint8(full(ww'*R4'*ww));                                              % 逆稀疏变换
G5 = uint8(full(ww'*G4'*ww));
B5 = uint8(full(ww'*B4'*ww));
P3 = zeros(M,N,3);
P3(:,:,1) = R5; P3(:,:,2) = G5; P3(:,:,3) = B5;
subplot(1,3,1); imshow(uint8(P1));
subplot(1,3,2); imshow(uint8(P2));
subplot(1,3,3); imshow(uint8(P3));

%% 性能测试
[PSNR] = psnr(P1,P3);
fprintf('The PSNR between plain image and decompressed image :\n ');                                                                                                           
disp(PSNR);
[mssim] = mssim(P1,P3);
fprintf('The MSSIM between plain image and decompressed image :\n ');                                                                                                           
disp(mssim);