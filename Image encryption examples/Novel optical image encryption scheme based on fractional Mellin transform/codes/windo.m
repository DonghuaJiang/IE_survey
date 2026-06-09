%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Test of 2Dsinc Performance %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function W = windo(N,alfa);
%% 矩形窗
a=floor(alfa*N);
N = N;
[m,n]=meshgrid(linspace(-N/2,N/2-1,N)); 
b=a;
I=rectpuls(m,a).*rectpuls(n,b);% 矩形孔平面
W=I;
%F=fftshift(fft2(I));
 %% 圆形窗
% r=a;a=0;b=0;
% I=zeros(N,N);
% [m,n]=meshgrid(linspace(-N/2,N/2-1,N));
% D=((m-a).^2+(n-b).^2).^(1/2);
% i=find(D<=r);
% I(i)=1;    %孔半径范围内透射系数为1
% W=fftshift(I);
 %% 高斯窗
% a=0.00005;
% [m,n]=meshgrid(linspace(-N/2,N/2-1,N));
% I=exp(-a*(m).^2).*exp(-a*(n).^2);
% W=fftshift(I);


%  test=max(max(F))
%   figure(8)
%   imagesc(F)%画衍射屏的形状 
a=1;




































