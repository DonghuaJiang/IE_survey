%图像和孔径做卷积
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
p=[0.5 0.5 0.5 0.5 0.5];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置变换阶次
% r=[1 50 85 105 125 145 165 175 181];
%  p=[0.7 0.5 0.4 0.6 0.7 0.5 0.6 0.3];

num1=500;num2=500;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置离散化点的数目
center_x=(size(X,1)+1)/2;
center_y=(size(X,2)+1)/2;
G=zeros(num1,num2,N);
AL=1;
alfa=0.9;
W = windo(num1,alfa);
for i=1:N;
   if i==1; 
       rmin = r(i);
   else
       rmin = r(i)-5;% 弥补内部环域边缘效应带来的质量下降
   end;
   rmax = r(i+1);
   f = frmt(X, rmin,rmax,center_x,center_y,num1,num2,p(i),AL);
   %f=f.*W;
   G(:,:,i) = f;%         
end;
figure(2);
imshow(uint8(abs([G(:,:,1),G(:,:,2);G(:,:,3),G(:,:,4)])));%根据极坐标位置置乱后，已无法分辨图像 WANGMM
%imshow(uint8(abs([G(:,:,1)+G(:,:,2)+G(:,:,3)+G(:,:,4)])));

figure(3);
imshow(uint8(abs(G(:,:,1))));% uint强制把图像转换为255 WANGMM
%% 加密迭代  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A=zeros(num1,num2,N);
% As=zeros(num1,num2,N);
% phi=zeros(num1,num2,N);
for i=1:N;
     As(:,:,i)=abs(G(:,:,i));%取幅度
     A(:,:,i)=2*pi* As(:,:,i)/360;%幅度转化为角度     
     phi(:,:,i)=mod(angle(G(:,:,i))+2*pi,2*pi);
     phi(:,:,i)=phi(:,:,i)*255/(2*pi);
end;
%% 迭代
% for i=1:N;
%       As(:,:,i)=abs(G(:,:,i));%取幅度
%     A(:,:,i)=2*pi* As(:,:,i)/360;%幅度转化为角度     
%     phi(:,:,i)=mod(angle(G(:,:,i))+2*pi,2*pi);
%     phi(:,:,i)=phi(:,:,i)*255/(2*pi);
%     j=sqrt(-1);
%      temp1=frft2(phi(:,:,i).*exp(j*A(:,:,i)),0.5);
%      test=phi(:,:,i).*exp(j*A(:,:,i));
% 
%      temp3=frft2(temp1,-0.5); 
%      A1(:,:,i)=mod(angle(temp3)+2*pi,2*pi);%%%%%%问题出在这句？？？？？？？？？？
%       phi1(:,:,i)=abs(temp3);
%      phi1(:,:,i)=(2*pi)*phi1(:,:,i)/255;
%       As1(:,:,i)=A1(:,:,i)*360/(2*pi);
%       Gs(:,:,i)=As1(:,:,i).*exp(j*phi1(:,:,i));
%        MSE=mse2(Gs(:,:,i),G(:,:,i))
%       PSNR=psnr(Gs(:,:,i),G(:,:,i))
% end
%解密
for  i=1:N;
     phi1(:,:,i)=(2*pi)*phi(:,:,i)/255;
     Gs(:,:,i)=As(:,:,i).*exp(j*phi1(:,:,i));
end

  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
r1=[1 50 85 135 160 181];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%半径密钥

p1=[0.5 0.5 0.5 0.5 0.5];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%阶数密钥
%  r1=[1 50 85 105 125 145 165 175 181];
%  p1=[0.7 0.5 0.4 0.6 0.7 0.5 0.6 0.3];

G1=zeros(2*r(N+1)+1,2*r(N+1)+1);
centerx_G1=r(N+1)+1;
centery_G1=r(N+1)+1;
Gs1=Gs;
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

% figure(10);
% imshow(uint8(X));
%%  矩形窗
% N=255;
% alfa=0.50;
% a=floor(alfa*N);
% 
% N = N;
% [m,n]=meshgrid(linspace(-N/2,N/2-1,N)); 
% b=a;
% %temp=rectpuls(m,2*a);
% %imagesc(temp)
% I=rectpuls(m,a).*rectpuls(n,b);% 矩形孔平面
% W1=fftshift(I);
% F=fftshift(fft2(I));
% figure(9)
% imagesc(I)%画衍射屏的形状 
% 
%  temp1=(fft2(X)); 
%  temp2=(temp1.*W1);
%  outmatrix=(ifft2(temp2)); 
%  figure(10);
%  imshow(uint8(outmatrix));
 %%  圆形窗
% N=255;
% r=30;a=0;b=0;
% I=zeros(N,N);
% [m,n]=meshgrid(linspace(-N/2,N/2-1,N));
% D=((m-a).^2+(n-b).^2).^(1/2);
% i=find(D<=r);
% I(i)=1;    %孔半径范围内透射系数为1
%  F=fftshift(fft2(I));
%  W1=fftshift(I);
%  figure(11)
%  imagesc(I)%画衍射屏的形状

%  temp1=(fft2(X));
%  temp2=(temp1.*W1);
%  outmatrix=(ifft2(temp2)); 
%  figure(12);
%  imshow(uint8(outmatrix));
%%
a=0.00005;
 N=500;
 M=250
 D=10000;
[m,n]=meshgrid(linspace(-N/2,N/2-1,N));
[m1,n1]=meshgrid(linspace(-M/2,M/2-1,M));
t=m(:,1:250);
I=exp(-a*(t).^2).*exp(-a*(m1).^2);
%  for n=1:N
%         for m=1:N    
%             I(n,m)=exp(-(n).^2/D).*exp(-(m).^2/D); 
%         end
%     end
% W1=fftshift(I);
 figure(11)
 imagesc(I)%画衍射屏的形状
 
% 
% [n,m]=meshgrid(linspace(-N/2,N/2-1,N));
% I=exp(-(m).^2/D).*exp(-(n).^2/D);  
%  temp1=(fft2(X));
%  temp2=(temp1.*W1);
%  outmatrix=(ifft2(temp2)); 
%  figure(12);
%  imshow(uint8(outmatrix));
MSE=mse2(G2,X)
PSNR=psnr(G2,X)
 
 
 
 a=1;




