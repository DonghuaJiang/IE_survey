clc
clear
close all

global cx; global cy;
img = imread('.\Baboon.bmp');
[M,N] = size(img);

%% 密钥产生阶段
initialKey = ceil(rand(1,240)-0.5);                                        % 随机产生一组密钥
keys = zeros(1,7);                                                         % a0-1,b0-2,x-3,y-4,T-5,c1-6,c2-7
sumk = 0;
for i = 1 : 5
    keys(i) = sum(initialKey(40*i-39 : 40*i) .* 2.^(39:-1:0))/2^(40);
    sumk = 0;
end
for i = 1 : 2
    keys(5+i) =  sum(initialKey(200+20*i-19 : 200+20*i).* 2.^(19:-1:0));
    sumk = 0;
end
a = mod(initialKey(1) + initialKey(5)*initialKey(6),5) + 16;
b = mod(initialKey(2) + initialKey(5)*initialKey(7),5) + 16;
x0 = mod(initialKey(3) + initialKey(5)*initialKey(6),2) + 1;
y0 = mod(initialKey(4) + initialKey(5)*initialKey(7),2) + 1;
%% 加密阶段
img_en = reshape(img,1,M*N);
img_perm = zeros(1,M*N);
img_perm2 = zeros(1,M*N);
img_diff = zeros(1,M*N);
for i = 1 : 2
    %% 置乱阶段
    [cx,cy] = ICM2(x0,y0,a,b,M,N);
    cxy = cx*cy;
    [~,Txy] = sort(reshape(cxy,1,M*N));
    for j = 1 : M*N
        img_perm(j) = img_en(Txy(j));
    end
    
    %% 扩散阶段
    cy1 = reshape(cy,1,M*N);
    [~,Tx] = sort(reshape(cx,1,M*N));
    for j = 1 : M*N
        img_perm2(j) = img_perm(Tx(j));
    end
    img_diff(1) = floor(mod(img_perm2(1)+img_perm2(end)+abs(cy1(1))*(2^(31)-1),256));
    for k = 2 : M*N
        img_diff(k) = floor(mod(img_perm2(k)+img_diff(k-1)+abs(cy1(k))*(2^(31)-1),256));
    end
    img_en = img_diff;
end

%% 收尾处理
subplot(1,2,1); imshow(uint8(img)); title('明文图像');
subplot(1,2,2); imshow(uint8(reshape(img_diff,M,N))); title('密文图像');
imwrite(uint8(reshape(img_diff,M,N)),'.\encrypt.bmp');