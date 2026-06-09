% The SIPI database
% https://sipi.usc.edu/database/

% The following code displays the histograms of a plaintext image, its
% shuffled version, and its encrypted one. 
% The histogram's variance is also computed


clear
plaintext=imread('plaintext_rgb.png');

shuffled=imread('shuffled_rgb.png');

ciphertext=imread('ciphertext_rgb.png');


% Display Images
figure
subplot(1,3,1)
box on
imshow(plaintext)
title('Plaintext Image')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
subplot(1,3,2)
imshow(shuffled)
title('Shuffled Image')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
box on
subplot(1,3,3)
imshow(ciphertext)
title('Encrypted Image')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
box on


[R,G,B] = imsplit(plaintext);
[Rshuf,Gshuf,Bshuf] = imsplit(shuffled);
[Renc,Genc,Benc] = imsplit(ciphertext);

figure(2)
subplot(3,3,1)
hold all
histogram(R,256,FaceColor="r",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
title('Plaintext Image (R)')
box on
subplot(3,3,2)
hold all
histogram(G,256,FaceColor="g",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
title('Plaintext Image (G)')
box on
subplot(3,3,3)
hold all
histogram(B,256,FaceColor="b",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
box on
title('Plaintext Image (B)')


subplot(3,3,4)
hold all
histogram(Rshuf,256,FaceColor="r",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
title('Shuffled Image (R)')
box on
subplot(3,3,5)
hold all
histogram(Gshuf,256,FaceColor="g",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
title('Shuffled Image (G)')
box on
subplot(3,3,6)
hold all
histogram(Bshuf,256,FaceColor="b",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
box on
title('Shuffled Image (B)')


subplot(3,3,7)
hold all
histogram(Renc,256,FaceColor="r",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
title('Encrypted Image (R)')
box on
subplot(3,3,8)
hold all
histogram(Genc,256,FaceColor="g",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
title('Encrypted Image (G)')
box on
subplot(3,3,9)
hold all
histogram(Benc,256,FaceColor="b",EdgeColor="none")
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
box on
title('Encrypted Image (B)')


% compute variance of histograms
counts = imhist(R);
disp('Variance: Plaintext R')
var(counts)

counts = imhist(G);
disp('Variance: Plaintext G')
var(counts)

counts = imhist(B);
disp('Variance: Plaintext B')
var(counts)

counts = imhist(Rshuf);
disp('Variance: Shuffled R')
var(counts)

counts = imhist(Gshuf);
disp('Variance: Shuffled G')
var(counts)

counts = imhist(Bshuf);
disp('Variance: Shuffled B')
var(counts)

counts = imhist(Renc);
disp('Variance: Encrypted R')
var(counts)

counts = imhist(Genc);
disp('Variance: Encrypted G')
var(counts)

counts = imhist(Benc);
disp('Variance: Encrypted B')
var(counts)