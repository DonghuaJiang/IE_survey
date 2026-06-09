% The SIPI database
% https://sipi.usc.edu/database/

% The following code performs the correlation analysis of a plaintext image, its
% shuffled version, and its encrypted one. 

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


% Compute Correlation
%horizontal
c_horz_o = corrcoef(double(plaintext(:, 1:end-1)), double(plaintext(:, 2:end)))
c_horz_s = corrcoef(double(shuffled(:, 1:end-1)), double(shuffled(:, 2:end)))
c_horz_e = corrcoef(double(ciphertext(:, 1:end-1)), double(ciphertext(:, 2:end)))

%vertical
c_vert_o = corrcoef(double(plaintext(1:end-1, :)), double(plaintext(2:end, :)))
c_vert_s = corrcoef(double(shuffled(1:end-1, :)), double(shuffled(2:end, :)))
c_vert_e = corrcoef(double(ciphertext(1:end-1, :)), double(ciphertext(2:end, :)))

%diagonal
c_diag_o = corrcoef(double(plaintext(1:end-1, 1:end-1)), double(plaintext(2:end, 2:end)))
c_diag_s = corrcoef(double(shuffled(1:end-1, 1:end-1)), double(shuffled(2:end, 2:end)))
c_diag_e = corrcoef(double(ciphertext(1:end-1, 1:end-1)), double(ciphertext(2:end, 2:end)))


% Here, we can also plot the pairs of horizontal, vertical, or diagonal
% pixels. As an example, we plot the diagonal case
% to plot the other two cases, just change appropriately the pixel pairs,
% as well as the labels in the x,y axes.

% note that below, we plot all the pixel pairs.
% if you want to plot less, simply choose a bigger step, like 1:3:end-1
% alternatively, you can use a series of random pairs.

subplot(1,3,1)
scatter(double(plaintext(1:end-1, 1:end-1)), double(plaintext(2:end, 2:end)),'.k')
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Plaintext Image')

subplot(1,3,2)
scatter(double(shuffled(1:end-1, 1:end-1)), double(shuffled(2:end, 2:end)),'.k');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Shuffled Image')

subplot(1,3,3)
scatter(double(ciphertext(1:end-1, 1:end-1)), double(ciphertext(2:end, 2:end)),'.k');
xlabel('Pixel value at (x,y)')
ylabel('Pixel value at (x+1,y+1)')
set(gca,'fontsize',10)
set(gca,'fontweight','bold')
axis([0,256,0,256])
box
title('Encrypted Image')




