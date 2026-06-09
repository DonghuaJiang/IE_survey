clc 
clear
close all
 
imgOrg = double(imread('.\images\Lena.png'));                              % load image
[row,col] = size(imgOrg);
TS = 25;                                                                   % threshold value
r = 4/16;                                                                  % compression rate
M = round(row*r);                                                          % number of row in compressed image 

%% The compression process
a = 2.987; cx0 = 0.678; cy0 = 0.496;                                       % initial values of 2d chaotic map
d = 25;                                                                    % sampling length
catSeq = NewMap((d+1)*M*col,a,cx0,cy0);
catDeqcon = zeros(1,M*col);
for i = 1:M*col
    catDeqcon(i) = 1-2*catSeq(100+d*i);
end
Phi = reshape(catDeqcon,M,col)*sqrt(2/M);
z1 = Lorenz_chaotic(0,2*row*col);                                          % pseudo-random sequence
Psi = dwtmtx(col,'db2',3);                                                 % sparse basis matrix
imgSp = Psi*imgOrg*Psi';                                                   % sparseness operate
imgSp(abs(imgSp) <= TS) = 0;                                               % threshold operate
imgSpcon = enscramble_arnold(imgSp,z1);                                    % Arnold confusion
imgMea = Phi*imgSpcon;                                                     % linearly measure
mmax = max(imgMea(:)); mmin = min(imgMea(:));
img_en = uint8(round(255*(imgMea-mmin)/(mmax-mmin)));                      % linearly quantization

%% The decompression process
imgEnc = double(img_en);                                                                                         
imgIqua = imgEnc*(mmax-mmin)/255+mmin;                                     % inverse quantization
for i = 1:col
    imgIre(:,i) = OMP(imgIqua(:,i),Phi,round(M/4));                        % OMP reconsitution
end
imgIcon = descramble_arnold(imgIre,z1);                                    % inverse confusion
img_de = uint8(Psi'*imgIcon*Psi);

subplot(1,3,1); imshow(uint8(imgOrg)); title('Plain image'); 
subplot(1,3,2); imshow(uint8(img_en)); title('Compressed image');
subplot(1,3,3); imshow(uint8(img_de)); title('Decompressed image'); 