function [DNA1,DNA2,DNA3,DNA4]=DNA(image);
Array=cell(1,8);
% 显示8个位平面图像
for i=1:8
     Array{i} =bitget(image,i);
end
[M,N]=size(image);
A1=Array{1};
B1=Array{2};
C1=Array{3};
D1=Array{4};
E1=Array{5};
F1=Array{6};
G1=Array{7};
H1=Array{8};
for i=1:M
    for j=1:N
        DNA1(i,j)=DNACODE(A1(i,j),B1(i,j));
        DNA2(i,j)=DNACODE(C1(i,j),D1(i,j));
        DNA3(i,j)=DNACODE(E1(i,j),F1(i,j));
        DNA4(i,j)=DNACODE(G1(i,j),H1(i,j));
    end
end