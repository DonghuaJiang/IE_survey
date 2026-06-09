%% NPCR and UACI
clc;clear;
P = imread('Elaine256.png');
[C,K] = ImageCipher(P,'en');
[row, column] = size(P);

ctime = datestr(now, 30);%取系统时间
tseed = str2num(ctime((end - 5) : end)) ;%将时间字符转换为数字
rand('seed', tseed*100) ;%设置种子，若不设置种子则可取到伪随机数
r = randi(row);
c = randi(column);
P2 = P;
if P2(r,c) == 0
    P2(r,c) = P2(r,c)+1;
else
    P2(r,c) = P2(r,c) -1;
end
C2 = ImageCipher(P2,'en',K);

D = zeros(row,column);
for i = 1:row
    for j = 1:column
        if C2(i,j) ~= C(i,j)
            D(i,j) = 1;
        end
    end
end


A_NPCR = sum(D(:))/(row*column)*100;

C = double(C);
C2 = double(C2);
A = zeros(row,column);
for i = 1:row
    for j = 1:column
        A(i,j)=abs(C(i,j)-C2(i,j));
    end
end
A_UACI = sum(A(:))/(255*row*column)*100;

