% The SIPI database
% https://sipi.usc.edu/database/


% The following code computes the Number of Pixels Change Rate (NPCR)
% and Unified Average Changing Intensity (UACI) measures between two
% encrypted versions of the same image, different only by one pixel.

clear

ciphertext1=double(imread('ciphertext_rgb.png'));

ciphertext2=double(imread('ciphertext2_rgb.png'));

[Renc1,Genc1,Benc1] = imsplit(ciphertext1);
[Renc2,Genc2,Benc2] = imsplit(ciphertext2);

[rows,cols]=size(Renc1);


NPCR_R=100*sum(sum(Renc1~=Renc2))/(rows*cols)
UACI_R=100*sum(sum(abs(Renc1-Renc2)))/(rows*cols*255)

NPCR_G=100*sum(sum(Genc1~=Genc2))/(rows*cols)
UACI_G=100*sum(sum(abs(Genc1-Genc2)))/(rows*cols*255)

NPCR_B=100*sum(sum(Benc1~=Benc2))/(rows*cols)
UACI_B=100*sum(sum(abs(Benc1-Benc2)))/(rows*cols*255)