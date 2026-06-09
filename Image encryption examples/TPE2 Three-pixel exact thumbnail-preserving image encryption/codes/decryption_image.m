%½âÃÜÍ¼Ïñ

function I=decryption_image(after_I,key,dimen)
R=after_I(:,:,1);
G=after_I(:,:,2);
B=after_I(:,:,3);
after_R=Decryption(dimen,R,key);
% after_G=Decryption(dimen,G,key);
% after_B=Decryption(dimen,B,key);
after_G=G;
after_B=B;
I=cat(3,after_R,after_G,after_B);