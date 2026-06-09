    
     W=G(:,:,1);
     W1=W(1:10,1:10);%122,146,148
     B=abs(W1);
     B1=2*pi*B/360;
     C=mod(angle(W1)+2*pi,2*pi);
     C1=C*255/(2*pi);
     
     test=C1.*exp(j*B1);
     A2=mod(angle(test)+2*pi,2*pi);%%%%%% 问题出在这句 ？？？？？？？
     angle2=angle(test);
     angle1=atan(imag(test)./real(test));
     A=mod(angle1+2*pi,2*pi);
    AA=100*exp(j*A);
    AA2=100*exp(j*A2);
     MSE=mse2(AA,AA2)
     PSNR=psnr(AA,AA2)
%    x1=sin(A1);
%    x2=sin(B1);
%    MSE=mse2(x2,x1)
%    PSNR=psnr(x2,x1)
%    A=B1;
     A1=360*A/(2*pi);
     
     phi1=abs(test);
     phi1=(2*pi)*phi1/255;
     Gs2=A1.*exp(j*phi1);
     
     MSE=mse2(Gs2,W1)
     PSNR=psnr(Gs2,W1)
     
     a=1;