% The SIPI database
% https://sipi.usc.edu/database/


% The following simple code shows how to perform different levels of
% cropping, tampering, and salt & pepper noise on an encrypted image, in
% order to test its resistance to such attacks.

clear
ciphertext=imread('ciphertext.png'); %read ciphertext image
%you can change the above of course with any image of your choice

%% cropping
crop1=ciphertext;
crop2=ciphertext;
crop3=ciphertext;
crop4=ciphertext;

[rows,cols]=size(ciphertext);
crop1(1:floor(rows/2),1:floor(cols/2))=0; % 25% cropping
crop2(1:floor(rows/2),1:cols)=0; % 50% cropping
crop3(1:rows,1:floor(cols/2))=0; % 50% cropping

crop4(1:floor(rows/2),1:cols)=0; % 75% cropping
crop4(1:rows,1:floor(cols/2))=0; % 75% cropping

figure
subplot(1,4,1)
imshow(crop1)
subplot(1,4,2)
imshow(crop2)
subplot(1,4,3)
imshow(crop3)
subplot(1,4,4)
imshow(crop4)


%% tampering
T=imread('cameraman.tif');  %tampering information
T=imresize(T,[rows,cols]);
% T=rgb2gray(T);
tamp1=ciphertext;
tamp2=ciphertext;
tamp3=ciphertext;
tamp4=ciphertext;

[rows,cols]=size(ciphertext);
tamp1(1:floor(rows/2),1:floor(cols/2))=imresize(T,[floor(rows/2),floor(cols/2)]); % 25% tampering
tamp2(1:floor(rows/2),1:cols)=T(1:floor(rows/2),1:cols); % 50% tampering
tamp3(1:rows,1:floor(cols/2))=T(1:rows,1:floor(cols/2)); % 50% tampering

tamp4(1:floor(rows/2),1:cols)=T(1:floor(rows/2),1:cols); % 75% tampering
tamp4(1:rows,1:floor(cols/2))=T(1:rows,1:floor(cols/2)); % 75% tampering

figure
subplot(1,4,1)
imshow(tamp1)
subplot(1,4,2)
imshow(tamp2)
subplot(1,4,3)
imshow(tamp3)
subplot(1,4,4)
imshow(tamp4)

%% Salt & Pepper noise

noise1=imnoise(ciphertext,'salt & pepper',0.05); % 5% noise
noise2=imnoise(ciphertext,'salt & pepper',0.25); % 25% noise
noise3=imnoise(ciphertext,'salt & pepper',0.5); % 50% noise
noise4=imnoise(ciphertext,'salt & pepper',0.75); % 75% noise

figure
%note, since the image is already encrypted, so it looks like noise, you
%will not observe any visual difference between the noisy images
subplot(1,4,1)
imshow(noise1)
subplot(1,4,2)
imshow(noise2)
subplot(1,4,3)
imshow(noise3)
subplot(1,4,4)
imshow(noise4)