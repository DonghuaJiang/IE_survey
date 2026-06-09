
clear all

a=0.00005;
N=500;
M=250
D=10000;
[m,n]=meshgrid(linspace(-N/2,N/2-1,N));
[m1,n1]=meshgrid(linspace(-M/2,M/2-1,M));

I=exp(-(m).^2/D).*exp(-(n).^2/D);      
I1=I(:,1:2:500);
 figure(11)
 imagesc(I1)%»­ÑÜÉäÆÁµÄÐÎ×´
 
 a=1;