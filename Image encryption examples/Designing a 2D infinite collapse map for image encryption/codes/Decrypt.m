clc
close all

img_enc = imread('.\encrypt.bmp');
[M,N] = size(img_enc);
img_diff = zeros(1,M*N);
img_perm = zeros(1,M*N);
img_perm2 = zeros(1,M*N);
img_en = reshape(img_enc,1,M*N);
%% ½âÃÜ¹ı³Ì
for i = 1 : 2
    %% ÄæÀ©É¢½×¶Î
    cy1 = reshape(cy,1,M*N);
    [~,Tx] = sort(reshape(cx,1,M*N));
    for k = M*N : -1 : 2
        img_diff(k) = floor(mod(double(img_en(k))-double(img_en(k-1))-double(abs(cy1(k))*(2^(31)-1)),256));
    end
    img_diff(1) = floor(mod(double(img_en(1))-double(img_diff(end))-double(abs(cy1(1))*(2^(31)-1)),256));
    for j = M*N : -1 :1
        img_perm2(Tx(j)) = img_diff(j);
    end

    %% ÖÃÂÒ½×¶Î
    cxy = cx*cy;
    [~,Txy] = sort(reshape(cxy,1,M*N));
    for j = M*N : -1 : 1
        img_perm(Txy(j)) = img_perm2(j);
    end
    img_en = img_perm;
end

%% ÊÕÎ²´¦Àí
subplot(1,2,1); imshow(uint8(img_enc)); title('ÃÜÎÄÍ¼Ïñ');
subplot(1,2,2); imshow(uint8(reshape(img_perm,M,N))); title('½âÃÜÍ¼Ïñ');
imwrite(uint8(reshape(img_perm,M,N)),'.\decrypt.bmp');
