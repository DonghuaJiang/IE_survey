% The SIPI database
% https://sipi.usc.edu/database/

% The following code displays the entropy and local entropy of a plaintext image, its
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

%% Entropy of whole image
%notice that the plaintext and shuffled images have the same entropy
ent_plaintext=entropy(plaintext)
ent_shuffled=entropy(shuffled)
ent_encrypted=entropy(ciphertext)

%% Local Entropy
clear topx topy
[rows,cols]=size(plaintext);
%define a zero matrix to help define the non-overlapping blocks
Mat=zeros(rows,cols);
%vectors to save the entropy values for plaintext, shuffled and enxrypted
%images
entP=[];
entS=[];
entE=[];
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
        entP=[entP, entropy(plaintext(localx:localx+44,localy:localy+44) )];
        entS=[entS, entropy(shuffled(localx:localx+44,localy:localy+44))];
        entE=[entE, entropy(ciphertext(localx:localx+44,localy:localy+44))];
    end
end
%display the positions of the non-overlapping boxes we defined
figure
imshow(uint8(255*Mat))

% Compute the entropies
local_ent_P=mean(entP)
local_ent_S=mean(entS)
local_ent_E=mean(entE)



