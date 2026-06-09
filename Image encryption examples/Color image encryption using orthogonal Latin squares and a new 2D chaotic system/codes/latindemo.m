close all;
clear all;
clc;
P = imread('4.1.01.tiff');

%% Image encryption and image decryption
tic
[C,K] = ImageCipher(P, 'encryption');
toc
D = ImageCipher(C,'decryption',K);

P = uint8(P);
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
% % axis([0 256 0 5000]);
% 
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
% axis([0 256 0 2000]);
% 
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
% % axis([0 256 0 5000]);
