clc;
clear all;
input1=imread('lena.tiff');
input2=input1(1:2:end,1:2:end); % 提取图像
% input2=imread('woman.tiff');
% X=double(input2(1:255,1:255));
X=double(input2(1:255,1:255));
figure(1);
imshow(uint8(X));
title('the original image');
N=5;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%将图像分为N个环域进行不同阶次的分数梅林变换
r=[1 50 85 135 160 181];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置环域半径 r_max = sqrt（127*127+127*127）=181
% r=[1 50 85 105 125 145 165 175 181];
% p=[0.7 0.5 0.4 0.6 0.7 0.5 0.6 0.3];
p=[0.5 0.5 0.5 0.5 0.5];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置变换阶次
num1=500;num2=500;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置离散化点的数目
center_x=(size(X,1)+1)/2;
center_y=(size(X,2)+1)/2;
G=zeros(num1,num2,N);

AL=1;
for i=1:N;
   if i==1; 
       rmin = r(i);
   else
       rmin = r(i)-5;% 弥补内部环域边缘效应带来的质量下降
   end;
   rmax = r(i+1);
   f = frmt(X, rmin,rmax,center_x,center_y,num1,num2,p(i),AL);
   
   G(:,:,i) = f;%         
end;
figure(2);
imshow(uint8(abs([G(:,:,1),G(:,:,2);G(:,:,3),G(:,:,4)])));%根据极坐标位置置乱后，已无法分辨图像 WANGMM
%imshow(uint8(abs([G(:,:,1)+G(:,:,2)+G(:,:,3)+G(:,:,4)])));
A11=G(:,:,1);
figure(3);
imshow(uint8(abs(G(:,:,1))));% uint强制把图像转换为255 WANGMM
%%%%%%%%%%%%%%%%%%%%%%%%通过迭代，整合为一幅加密图像
A=zeros(num1,num2,N);
As=zeros(num1,num2,N);
phi=zeros(num1,num2,N);
for i=1:N;
    As(:,:,i)=abs(G(:,:,i));%取幅度
    test1=As(:,:,4);%255*255图像最大的幅度为360 WANGMM
    A(:,:,i)=2*pi* As(:,:,i)/360;%幅度转化为角度  这里全是正的数值 
    phi(:,:,i)=angle(G(:,:,i));%取相位；提取G的弧度
     %test1= As(:,:,5).*exp(j*phi(:,:,i));
end;

ks=A(:,:,1); % 密钥

C=mod(phi(:,:,1)+2*pi,2*pi); % 把负的相位转换为正相位，为了把幅值转化为相位用 限制在[0,2pi]范围

CC1=C;
C=C*255/2/pi; % 将相位信息，编码为幅度信息。正好把两者做一个颠倒  密钥
t1=zeros(num1,num2,N);
theta=zeros(num1,num2,N);
psi=zeros(num1,num2,N);
for i=2:N;
   j=sqrt(-1);
   temp1=frft2(C.*exp(j*A(:,:,i)),0.5,AL); 
   B=abs(temp1);
   fai=mod(angle(temp1)+2*pi,2*pi);% 把原角度转换为幅值，原幅值转换为相位；然后在对其做分数傅里叶变换。变换一次 
   
   psi(:,:,i)=ks-A(:,:,i);psi(:,:,i)=mod(psi(:,:,i)+2*pi,2*pi);
   %psi(:,:,i)=A(:,:,i)+ks;  psi(:,:,i)=mod(psi(:,:,i)+2*pi,2*pi);% psi为密钥
   theta(:,:,i)=fai-psi(:,:,i);theta(:,:,i)=mod(theta(:,:,i)+2*pi,2*pi);%theta 为密钥  

   %theta(:,:,i)=psi(:,:,i)+fai;theta(:,:,i)=mod(theta(:,:,i)+2*pi,2*pi);
   t=theta(:,:,i)+phi(:,:,i);t=mod(t+2*pi,2*pi);
   t1(:,:,i)=t;
   temp2=frft2(B.*exp(j*t),0.5,AL);
   test1=B.*exp(j* t1(:,:,2));
   C=abs(temp2);
   ks=mod(angle(temp2)+2*pi,2*pi);
end;
Cipher=temp2;
figure(4);
imshow(uint8(abs(temp2)));
title('the encrypted image');
figure(5);
imshow(uint8(abs(360*ks/2/pi)));
title('the phase information');

%% 逆变换    还原图像
% 这里是对image的相位 幅值解密 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%解密
%theta(:,:,N)=theta(:,:,N)+2*pi*rand(500);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%相位密钥
theta1=theta;
psi1=psi;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%相位密钥
C1=C; %密钥
ks1=ks; %密钥
phi1=zeros(num1,num2,N);
A1=zeros(num1,num2,N);
As1=zeros(num1,num2,N);
n=linspace(N,2,N-2+1);
for i=1:N-1;
    m=n(i);
    temp1=frft2(C1.*exp(j*ks1),-0.5,AL);
    B1=abs(temp1);  
    phi1(:,:,m)=angle(temp1)-theta1(:,:,m);phi1(:,:,m)=mod(phi1(:,:,m)+2*pi,2*pi);%% 这里检测还原没有错误
 
    
%  MSE=mse2( Gs1(:,:,2),G(:,:,2))
%  PSNR=20*log10(255/sqrt(MSE))  
    
  % phi1(:,:,m)=mod(angle(temp1)+2*pi,2*pi)-theta1(:,:,m); phi1(:,:,m)=mod(phi1(:,:,m)+2*pi,2*pi);
    fai1=theta1(:,:,m)+psi1(:,:,m);fai1=mod(fai1+2*pi,2*pi);
  % fai1=theta1(:,:,m)-psi1(:,:,m);fai1=mod(fai1+2*pi,2*pi);  
    temp2=frft2(B1.*exp(j*fai1),-0.5,AL);   
    C1=abs(temp2);
    A1(:,:,m)=mod(angle(temp2)+2*pi,2*pi);
    As1(:,:,m)=360*A1(:,:,m)/(2*pi);%恢复出幅值       

    ks1=psi1(:,:,m)+A1(:,:,m);ks1=mod(ks1+2*pi,2*pi); 
    %ks1=psi1(:,:,m)-A1(:,:,m);ks1=mod(ks1+2*pi,2*pi);
end;
phi1(:,:,1)=C1;   phi1(:,:,1)=2*pi*phi1(:,:,1)/255;   CC2=phi1(:,:,1);
As1(:,:,1)=ks1;    As1(:,:,1)=360*As1(:,:,1)/(2*pi);

Gs1=zeros(num1,num2,N);                                                                                                   
for i=1:N;
    Gs1(:,:,i)=As1(:,:,i).*exp(j*phi1(:,:,i));
end;
%  MSE=mse2( Gs1(:,:,2),G(:,:,2))
%  PSNR=20*log10(255/sqrt(MSE))  
figure(6);
imshow(uint8((abs([Gs1(:,:,1),Gs1(:,:,2);Gs1(:,:,3),Gs1(:,:,4)]))));
figure(7);
imshow(uint8(abs(Gs1(:,:,1))));
A12=Gs1(:,:,1);
%% 这里是对image梅林变换解密
r1=[1 50 85 135 160 181];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%半径密钥

p1=[0.5 0.5 0.5 0.5 0.5];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%阶数密钥
%r1=[1 50 85 105 125 145 165 175 181];
%p1=[0.7 0.5 0.4 0.6 0.7 0.5 0.6 0.3];
G1=zeros(2*r(N+1)+1,2*r(N+1)+1);
centerx_G1=r(N+1)+1;
centery_G1=r(N+1)+1;

for i=1:N;
    if i==1; 
      rmin=r(i);
    else
      rmin=r(i)-5;
    end;
    rmax=r1(i+1);
    f=frmt(Gs1(:,:,i), rmin,rmax,[],[],num1,num2,-1*p1(i),AL);
    
    a=r(N+1)-r(i+1);
    f1=padarray(f,[a a]);%使分数梅林反变换后图像的尺寸相同
    [a1 a2]=size(f1);
    for i1=1:a1;
       for i2=1:a2;
           if (G1(i1,i2)~=0)&&(f1(i1,i2)~=0);
               G1(i1,i2)=G1(i1,i2);
           else
               G1(i1,i2)=f1(i1,i2)+G1(i1,i2);
           end;
           if (round(sqrt((i1-centerx_G1)^2+(i2-centery_G1)^2))>=rmax-2)&&i~=N;
               G1(i1,i2)=0;
           end;
       end;
   end;  
end;
figure(8);
G2=G1(centerx_G1-(255-1)/2:centerx_G1+(255-1)/2,centery_G1-(255-1)/2:centery_G1+(255-1)/2);
G2(128,128)=(G2(127,128)+G2(129,129)+G2(127,127)+G2(127,127)+G2(127,129)+G2(129,127)+G2(128,127)+G2(127,129))/8;
imshow(uint8(G2));
title('the decrypted image');
MSE=mse2(G2,X)
PSNR=20*log10(255/sqrt(MSE))







