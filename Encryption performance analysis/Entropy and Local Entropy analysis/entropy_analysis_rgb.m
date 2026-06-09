% The SIPI database
% https://sipi.usc.edu/database/

% The following code displays the entropy and local entropy of a plaintext image, its
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

[R,G,B] = imsplit(plaintext);
[Rshuf,Gshuf,Bshuf] = imsplit(shuffled);
[Renc,Genc,Benc] = imsplit(ciphertext);

%% Entropy of whole image
%notice that the plaintext and shuffled images have the same entropy
%note that in contrast to the grayscale case, here we first combine the 3
%channels and then shuffle them, so the entropies of the plaintext and
%shuffled channels is not the same
ent_plaintext_R=entropy(R)
ent_plaintext_G=entropy(G)
ent_plaintext_B=entropy(B)

ent_shuffled_R=entropy(Rshuf)
ent_shuffled_G=entropy(Gshuf)
ent_shuffled_B=entropy(Bshuf)

ent_encrypted_R=entropy(Renc)
ent_encrypted_G=entropy(Genc)
ent_encrypted_B=entropy(Benc)

%% Local Entropy
clear topx topy
[rows,cols]=size(R);
%define a zero matrix to help define the non-overlapping blocks
Mat=zeros(rows,cols);
%vectors to save the entropy values for plaintext, shuffled and encrypted
%images
entP_R=[];
entP_G=[];
entP_B=[];
entS_R=[];
entS_G=[];
entS_B=[];
entE_R=[];
entE_G=[];
entE_B=[];
%compute 30 random non-overlapping boxes of size 44x44
%see the references above for details
counter=0;
while counter<30
    % we use localx and localy variable to define the bottom left part of a box
    % we want to extract from a figure, to compute its entropy
    localx=randi(rows-44);
    localy=randi(cols-44);
    %check if this box does not overlap with the previous ones
    if sum(sum((Mat(localx:localx+44,localy:localy+44))))==0
        counter=counter+1;
        Mat(localx:localx+44,localy:localy+44)=1;
        entP_R=[entP_R, entropy(R(localx:localx+44,localy:localy+44) )];
        entP_G=[entP_G, entropy(G(localx:localx+44,localy:localy+44) )];
        entP_B=[entP_B, entropy(B(localx:localx+44,localy:localy+44) )];

        entS_R=[entS_R, entropy(Rshuf(localx:localx+44,localy:localy+44) )];
        entS_G=[entS_G, entropy(Gshuf(localx:localx+44,localy:localy+44) )];
        entS_B=[entS_B, entropy(Bshuf(localx:localx+44,localy:localy+44) )];

        entE_R=[entE_R, entropy(Renc(localx:localx+44,localy:localy+44) )];
        entE_G=[entE_G, entropy(Genc(localx:localx+44,localy:localy+44) )];
        entE_B=[entE_B, entropy(Benc(localx:localx+44,localy:localy+44) )];

    end
end
%display the positions of the non-overlapping boxes we defined
figure
imshow(uint8(255*Mat))

% Compute the entropies
local_ent_P_R=mean(entP_R)
local_ent_P_G=mean(entP_G)
local_ent_P_B=mean(entP_B)

local_ent_S_R=mean(entS_R)
local_ent_S_G=mean(entS_G)
local_ent_S_B=mean(entS_B)

local_ent_E_R=mean(entE_R)
local_ent_E_G=mean(entE_G)
local_ent_E_B=mean(entE_B)

