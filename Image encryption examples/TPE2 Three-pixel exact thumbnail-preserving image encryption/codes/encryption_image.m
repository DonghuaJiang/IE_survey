%一张图像的加密

function after_I=encryption_image(I,key,dimen)
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
after_R=Encryption(dimen,R,key);
% after_G=Encryption(dimen,G,key);
% after_B=Encryption(dimen,B,key);
after_G=G;
after_B=B;
after_I=cat(3,after_R,after_G,after_B);