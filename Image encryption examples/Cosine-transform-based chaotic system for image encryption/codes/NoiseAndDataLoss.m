P = imread('Elaine256.png');
P = imresize(P,[256,256]);
[C,K] = ImageCipher(P,'en');
P = C;
N1 = P;
N2 = imnoise(P,'salt & pepper', 0.02);
N4 = P;
N5 = P;
N6 = P;



N4(115:140,115:140) = 0;
N5(110:145,110:145) = 0;
N6(100:155,100:155) = 0;

D1 = ImageCipher(P,'de',K);
D2 = ImageCipher(N2,'de',K);
D4 = ImageCipher(N4,'de',K);
D5 = ImageCipher(N5,'de',K);
D6 = ImageCipher(N6,'de',K);



