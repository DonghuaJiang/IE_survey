% The SIPI database
% https://sipi.usc.edu/database/

% The following code performs the correlation analysis of a plaintext image, its
% shuffled version, and its encrypted one. 

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

% Compute Correlations
[R,G,B] = imsplit(plaintext);
[Rshuf,Gshuf,Bshuf] = imsplit(shuffled);
[Renc,Genc,Benc] = imsplit(ciphertext);

% Compute Correlation for each Channel
%RED
%horizontal
c_horz_o = corrcoef(double(R(:, 1:end-1)), double(R(:, 2:end)))
c_horz_s = corrcoef(double(Rshuf(:, 1:end-1)), double(Rshuf(:, 2:end)))
c_horz_e = corrcoef(double(Renc(:, 1:end-1)), double(Renc(:, 2:end)))

%vertical
c_vert_o = corrcoef(double(R(1:end-1, :)), double(R(2:end, :)))
c_vert_s = corrcoef(double(Rshuf(1:end-1, :)), double(Rshuf(2:end, :)))
c_vert_e = corrcoef(double(Renc(1:end-1, :)), double(Renc(2:end, :)))

%diagonal
c_diag_o = corrcoef(double(R(1:end-1, 1:end-1)), double(R(2:end, 2:end)))
c_diag_s = corrcoef(double(Rshuf(1:end-1, 1:end-1)), double(Rshuf(2:end, 2:end)))
c_diag_e = corrcoef(double(Renc(1:end-1, 1:end-1)), double(Renc(2:end, 2:end)))

%Green
%horizontal
c_horz_o = corrcoef(double(G(:, 1:end-1)), double(G(:, 2:end)))
c_horz_s = corrcoef(double(Gshuf(:, 1:end-1)), double(Gshuf(:, 2:end)))
c_horz_e = corrcoef(double(Genc(:, 1:end-1)), double(Genc(:, 2:end)))

%vertical
c_vert_o = corrcoef(double(G(1:end-1, :)), double(G(2:end, :)))
c_vert_s = corrcoef(double(Gshuf(1:end-1, :)), double(Gshuf(2:end, :)))
c_vert_e = corrcoef(double(Genc(1:end-1, :)), double(Genc(2:end, :)))

%diagonal
c_diag_o = corrcoef(double(G(1:end-1, 1:end-1)), double(G(2:end, 2:end)))
c_diag_s = corrcoef(double(Gshuf(1:end-1, 1:end-1)), double(Gshuf(2:end, 2:end)))
c_diag_e = corrcoef(double(Genc(1:end-1, 1:end-1)), double(Genc(2:end, 2:end)))

%Blue
%horizontal
c_horz_o = corrcoef(double(B(:, 1:end-1)), double(B(:, 2:end)))
c_horz_s = corrcoef(double(Bshuf(:, 1:end-1)), double(Bshuf(:, 2:end)))
c_horz_e = corrcoef(double(Benc(:, 1:end-1)), double(Benc(:, 2:end)))

%vertical
c_vert_o = corrcoef(double(B(1:end-1, :)), double(B(2:end, :)))
c_vert_s = corrcoef(double(Bshuf(1:end-1, :)), double(Bshuf(2:end, :)))
c_vert_e = corrcoef(double(Benc(1:end-1, :)), double(Benc(2:end, :)))

%diagonal
c_diag_o = corrcoef(double(B(1:end-1, 1:end-1)), double(B(2:end, 2:end)))
c_diag_s = corrcoef(double(Bshuf(1:end-1, 1:end-1)), double(Bshuf(2:end, 2:end)))
c_diag_e = corrcoef(double(Benc(1:end-1, 1:end-1)), double(Benc(2:end, 2:end)))


% Here, we can also plot the pairs of horizontal, vertical, or diagonal
% pixels. As an example, we plot the diagonal case
% to plot the other two cases, just change appropriately the pixel pairs,
% as well as the labels in the x,y axes.

% note that below, we plot all the pixel pairs.
% if you want to plot less, simply choose a bigger step, like 1:3:end-1 etc
% alternatively, you can use a series of random pairs.

subplot(3,3,1)
scatter(double(R(1:end-1, 1:end-1)), double(R(2:end, 2:end)),'.r')
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Plaintext Image (R)')

subplot(3,3,2)
scatter(double(Rshuf(1:end-1, 1:end-1)), double(Rshuf(2:end, 2:end)),'.r');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Shuffled Image (R)')

subplot(3,3,3)
scatter(double(Renc(1:end-1, 1:end-1)), double(Renc(2:end, 2:end)),'.r');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Encrypted Image (R)')

subplot(3,3,4)
scatter(double(G(1:end-1, 1:end-1)), double(G(2:end, 2:end)),'.g')
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Plaintext Image (G)')

subplot(3,3,5)
scatter(double(Gshuf(1:end-1, 1:end-1)), double(Gshuf(2:end, 2:end)),'.g');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Shuffled Image (G)')

subplot(3,3,6)
scatter(double(Genc(1:end-1, 1:end-1)), double(Genc(2:end, 2:end)),'.g');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Encrypted Image (G)')

subplot(3,3,7)
scatter(double(B(1:end-1, 1:end-1)), double(B(2:end, 2:end)),'.b')
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Plaintext Image (B)')

subplot(3,3,8)
scatter(double(Bshuf(1:end-1, 1:end-1)), double(Bshuf(2:end, 2:end)),'.b');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Shuffled Image (B)')

subplot(3,3,9)
scatter(double(Benc(1:end-1, 1:end-1)), double(Benc(2:end, 2:end)),'.b');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Encrypted Image (B)')