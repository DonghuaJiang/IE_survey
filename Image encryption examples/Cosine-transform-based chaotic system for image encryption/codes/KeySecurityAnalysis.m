K = importdata('K.mat');
P = imread('Elaine256.png');


CH1 = ImageCipher(P,'en',K);
tic;
Values = zeros(2,256);
for m = 1:256
    display(m);
    K2 = K;
    if K2(m) == 1
        K2(m) = 0;
    else
        K2(m) = 1;
    end
    CH2 = ImageCipher(P,'en',K2);
    Values(1,m) = HamDis(CH1,CH2,8);
    
    
    DH1 = ImageCipher(CH1,'de',K);
    DH2 = ImageCipher(CH1,'de',K2);
    Values(2,m) = HamDis(DH1,DH2,8);
    
    
end
NBCRs.En = Values(1,:);
NBCRs.De = Values(2,:);
t = toc;