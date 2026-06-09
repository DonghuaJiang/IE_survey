% The SIPI database
% https://sipi.usc.edu/database/

% The following code computes the Number of Pixels Change Rate (NPCR)
% and Unified Average Changing Intensity (UACI) measures between two
% encrypted versions of the same image, different only by one pixel.

clear

ciphertext1=double(imread('ciphertext.png'));

ciphertext2=double(imread('ciphertext2.png'));

[rows,cols]=size(ciphertext1);

NPCR=100*sum(sum(ciphertext1~=ciphertext2))/(rows*cols)
UACI=100*sum(sum(abs(ciphertext1-ciphertext2)))/(rows*cols*255)

