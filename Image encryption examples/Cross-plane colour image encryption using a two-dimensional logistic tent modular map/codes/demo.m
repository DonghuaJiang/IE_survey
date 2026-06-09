clear;
close all;
clc;
 P = imread('peppers.tiff');     
%% 改变周围像素最后两位
[r,c,~] = size(P);
for i = 1:r-1:r
    for j = 1:c
        r1 = randi([0,1]);
        r2 = randi([0,1]);
        a1 = P(i,j,1);
        b1 = bitset(a1,1,r1);
        c1 = bitset(b1,2,r2);
        P(i,j,1) = c1;
    end
end
for i = 2:r-1
    for j = 1:c-1:c
        r1 = randi([0,1]);
        r2 = randi([0,1]);
        a2 = P(i,j,1);
        b2 = bitset(a2,1,r1);
        c2 = bitset(b2,2,r2);
        P(i,j,1) = c2;
    end
end

 %% 加密解密    
 tic
[C,K] = ImageCipher(P, 'encryption');
toc
D = ImageCipher(C,'decryption',K);

figure(1)
tt = imshow(P,'border','tight');
imwrite(tt.CData,'P.png');
figure(2)
tt = imshow(C,'border','tight');
imwrite(tt.CData,'C.png');
figure(3)
tt = imshow(D,'border','tight');
imwrite(tt.CData,'D.png');

% figure(4)
% P1 = P(:,:,1);
% P2 = P(:,:,2);
% P3 = P(:,:,3);
% [pixelCount, ~] = imhist(P1,256);
% bar(pixelCount,'r'); hold on;
% [pixelCount2, ~] = imhist(P2,256);
% bar(pixelCount2,'g'); hold on;
% [pixelCount3, grayLevels] = imhist(P3,256);
% bar(pixelCount3,'b'); hold on;
% xlim([0 grayLevels(end)]); % Scale x axis manually.
% set(gca,'position',[0.17 0.09 0.80 0.81],'FontName','Times New Roman','FontSize',30);
% set(gcf,'Position',[100,100,600,600]);
% % axis([0 256 0 500]);
% %  
% figure(5)
% P1 = C(:,:,1);
% P2 = C(:,:,2);
% P3 = C(:,:,3);
% [pixelCount, ~] = imhist(P1,256);
% bar(pixelCount,'r'); hold on;
% [pixelCount2, ~] = imhist(P2,256);
% bar(pixelCount2,'g'); hold on;
% [pixelCount3, grayLevels] = imhist(P3,256);
% bar(pixelCount3,'b'); hold on;
% xlim([0 grayLevels(end)]); % Scale x axis manually.
% set(gca,'position',[0.17 0.09 0.80 0.81],'FontName','Times New Roman','FontSize',30);
% set(gcf,'Position',[100,100,600,600]);
% axis([0 256 0 8000]);

% figure(6)
% P1 = D(:,:,1);
% P2 = D(:,:,2);
% P3 = D(:,:,3);
% [pixelCount, ~] = imhist(P1,256);
% bar(pixelCount,'r'); hold on;
% [pixelCount2, ~] = imhist(P2,256);
% bar(pixelCount2,'g'); hold on;
% [pixelCount3, grayLevels] = imhist(P3,256);
% bar(pixelCount3,'b'); hold on;
% xlim([0 grayLevels(end)]); % Scale x axis manually.
% set(gca,'position',[0.17 0.09 0.80 0.81],'FontName','Times New Roman','FontSize',30);
% set(gcf,'Position',[100,100,600,600]);
% axis([0 256 0 2000]);
