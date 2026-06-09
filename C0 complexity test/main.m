% 基于C0复杂度的混沌图特性分析程序
% L值越大，参考平面的网格划分就越多，能反映出的细节也就越大，建议至少取L=101。
% 由于C0算法是基于FFT变换，序列需要取长一些，建议至少取N=10^4。
clc
clear
close all

L = 51;
N = 10^(4)+2000;
C0 = zeros(L,L);
A = linspace(0,10,L);
B = linspace(0,2,L);
init_value = [0.1,0.1,0.1];
for i = 1:L
    a = A(i);
    for j = 1:L
        b = B(j);
        y = newmap(N,init_value,a,b);
        temp = y(1,2001:end);
        C0(i,j) = CoFuZadu(temp,15);
    end
end
[X,Y] = meshgrid(A,B);
figure(1);
colormap(flipud(hot));
colorbar('location','SouthOutside');
contourf(X,Y,C0);
xlabel('\alpha');
ylabel('\beta');