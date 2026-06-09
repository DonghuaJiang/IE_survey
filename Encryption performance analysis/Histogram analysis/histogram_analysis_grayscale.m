% The SIPI database
% https://sipi.usc.edu/database/

% The following code displays the histograms of a plaintext image, its
% shuffled version, and its encrypted one. 
% The histogram's variance is also computed

clear
plaintext=imread('plaintext.png');

shuffled=imread('shuffled.png');

ciphertext=imread('ciphertext.png');

% Display Images
figure
subplot(1,3,1)
box on
imshow(plaintext)
title('Plaintext Image')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
subplot(1,3,2)
imshow(shuffled)
title('Shuffled Image')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on
subplot(1,3,3)
imshow(ciphertext)
title('Encrypted Image')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on

figure(2)
subplot(1,3,1)
hold all
imhist(plaintext)
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
title('Plaintext Image')
box on
subplot(1,3,2)
hold all
imhist(shuffled)
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
title('Shuffled Image')
box on
subplot(1,3,3)
hold all
imhist(ciphertext)
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on
title('Encrypted Image')

% compute variance of histograms
counts = imhist(plaintext);
plaintext_var=var(counts)

counts = imhist(shuffled);
plaintext_var=var(counts)

counts = imhist(ciphertext);
ciphertext_var=var(counts)
