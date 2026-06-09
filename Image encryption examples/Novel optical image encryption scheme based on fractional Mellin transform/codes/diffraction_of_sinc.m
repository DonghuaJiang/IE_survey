% 所有长度单位为毫米 
clear all
lamda=632.8e-6; 
k=2*pi/lamda; 
z=1000000; %先确定衍射屏
N=300; %圆屏采样点数 
% a=10;
% b=10;
% [m,n]=meshgrid(linspace(-N/2,N/2-1,N)); 
% %I=rect(m/(2*a)).*rect(n/(2*b));
% I=rectpuls(m,2*a).*rectpuls(n,2*b);% 矩形孔平面
%%
% 若为圆孔，方框内替换为以下程序 
r=120;a=1;b=1;
I=zeros(N,N);
[m,n]=meshgrid(linspace(-N/2,N/2-1,N));
D=((m-a).^2+(n-b).^2).^(1/2);
i=find(D<=r);
I(i)=1;    % 孔半径范围内透射系数为1
%%  高斯窗
a=5e-5;
[m,n]=meshgrid(linspace(-N/2,N/2-1,N));
I=exp(-a*(m).^2).*exp(-a*(n).^2);
% m=linspace(-N/2,N/2-1,N);
% test=exp(-a*(m+1).^2);
% plot(test)

%%
q=exp(j*k*(m.^2+n.^2)/2/z);
subplot(2,2,1);% 圆孔图像画在 2 行 2 列的第一个位置 
imagesc(I)% 画衍射屏的形状 
% colormap([0 0 0; 1 1 1])% 颜色以黑白区分
% colormap('hot')
axis image 
title('衍射屏形状') 
L=300; M=300;% 取相同点数用于矩阵运算 
[x,y]=meshgrid(linspace(-L/2,L/2,M)); 
h=exp(j*k*z)*exp((j*k*(x.^2+y.^2))/(2*z))/(j*lamda*z);% 接收屏
H =fftshift(fft2(h)); B=fftshift(fft2(I));% 矩形孔频谱
% test=max(max(B));
G=H.*B; 
% 公式中为卷积，空间域中相卷相当于频域中相乘
U= fftshift(ifft2(G));% 求逆变换，得到复振幅分布矩阵
Br=(U/max(U));% 归一化 
subplot(2,2,2); 
imshow(abs(U)); 
axis image; 
colormap(hot) % figure,imshow(G); 
title('衍射后的图样');
subplot(2,2,3); 
mesh(x,y,abs(U)); 
subplot(2,2,4);
plot(abs(Br)) % 画三维图形