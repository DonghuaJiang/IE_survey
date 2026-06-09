function varargoput = ImageCipher(P,para,K)
%% 密钥
if ~exist('K','var') && strcmp(para,'encryption')
    %     a=ceil(rand(1,2)*99)+10;
    %     x=rand(1,2)*2-1;
    a=[103,82];
    x=[-0.101325026440898,-0.761517651598448];
    K{1}=a;
    K{2}=x;
    OutNum = 2;
elseif ~exist('K','var')  && strcmp(para,'decryption')
    error('Can not dectrypted without a key');
else
    OutNum=1;
end

a=K{1};
x=K{2};

%% 生成混沌序列
R1=ChaoticSeq(a(1),x(1),65896);
R2=ChaoticSeq(a(2),x(2),65896);

%% 加密解密过程
C=double(P);
switch para
    case 'encryption'
        %round one
        C=permutation(C,para,R1);
        C=confusion(C,para,R1);
        C=diffusion(C,para,R1);
        
%         %mutiply in GF
        C=GFmuti(C,para,R1);
        
%         %round two
        C=permutation(C,para,R2);
        C=confusion(C,para,R2);
        C=diffusion(C,para,R2);
    case 'decryption'
        
        C=diffusion(C,para,R2);
        C=confusion(C,para,R2);
        C=permutation(C,para,R2);
        
        C=GFmuti(C,para,R1);
        
        C=diffusion(C,para,R1);
        C=confusion(C,para,R1);
        C=permutation(C,para,R1);
end

C=uint8(C);
%% 控制输出
if OutNum == 1
    varargoput{1} = C;
else
    varargoput{1} = C;
    varargoput{2} = K;
end
end %end of the function ImageCipher

%% 混沌序列生成函数
function index = ChaoticSeq(a,x0,n)
r(1)=x0;
x=x0;
for i=2:n
    x=sin(pi*x*a*(1-x));
    r(i)=x;
end
[i,j]=unique(r,'first');
r1=r(sort(j));
count=2;
while(size(r1)<n)
    x=r1(end);
    for j=i:2*i
        x=sin(pi*x*a*(1-x));
        r(j)=x;
    end
    count=count+1;
    i=j;
    [a,b]=unique(r,'first');
    r1=r(sort(b));
end
[~,index]=sort(r1);
end

%% 置乱
function P = permutation(C,para,R)
[~,c]=sort(R(1:256));
J=getLatin(c);
s=(1+256)*256/2-1;
a=J(1,:);
t=J(:,1);
[~,b]=sort(t(1:255,1));
b=b+1;


switch para
    case 'encryption'
        P=C;
        P0=C;
        % 首列置乱
        for i=1:256
            P(i,1)=P0(a(i),1);
        end
        % 首行置乱
        for i=1:255
            P(1,i+1)=P0(1,b(i));
        end
        % H矩阵
        for i=2:256
            for j=2:256
                a=P(i,1);
                H(i,j)=mod(a+J(i,j),256)+1;
                if(H(i,j)==1)
                    H(i,j)=0;
                end
            end
            a=s-sum(H(i,:));
            for j=2:256
                if(H(i,j)==0)
                    H(i,j)=a;
                end
            end
        end
        % 根据H每行置乱
        for i=2:256
            for j=2:256
                t=P(i,j);
                P(i,j)=P(i,H(i,j));
                P(i,H(i,j))=t;
            end
        end
        % 列置换
        % HL产生
        for j=2:256
            for i=2:256
%                 a=P0(1,j);
                a=P(1,j);
                HL(i,j)=mod(a+J(i,j),256)+1;
                if(HL(i,j)==1)
                    HL(i,j)=0;
                end
            end
            a=s-sum(HL(:,j));
            for i=2:256
                if(HL(i,j)==0)
                    HL(i,j)=a;
                end
            end
        end
        % 根据HL每列置乱
        for j=2:256
            for i=2:256
                t=P(i,j);
                P(i,j)=P(HL(i,j),j);
                P(HL(i,j),j)=t;
            end
        end
        
    case 'decryption'
        P=C;
        for j=2:256
            for i=2:256
                a=P(1,j);
                H2(i,j)=mod(a+J(i,j),256)+1;
                if(H2(i,j)==1)
                    H2(i,j)=0;
                end
            end
            a=s-sum(H2(:,j));
            for i=2:256
                if(H2(i,j)==0)
                    H2(i,j)=a;
                end
            end
        end
        
        for i=2:256
            for j=2:256
                a=P(i,1);
                H1(i,j)=mod(a+J(i,j),256)+1;
                if(H1(i,j)==1)
                    H1(i,j)=0;
                end
            end
            a=s-sum(H1(i,:));
            for j=2:256
                if(H1(i,j)==0)
                    H1(i,j)=a;
                end
            end
        end
        for j=2:256
            for i=256:-1:2
                t=P(i,j);
                P(i,j)=P(H2(i,j),j);
                P(H2(i,j),j)=t;
            end
        end
        for i=2:256
            for j=256:-1:2
                t=P(i,j);
                P(i,j)=P(i,H1(i,j));
                P(i,H1(i,j))=t;
            end
        end
        a=J(1,:);
        t=J(:,1);
        [~,b]=sort(t(1:255,1));
        b=b+1;
        
        
        for i=1:255
            P00(1,b(i))=P(1,i+1);
        end
        
        for i=1:256
            P00(a(i),1)=P(i,1);
        end
        
        P(:,1)=P00(:,1);
        P(1,:)=P00(1,:);
        
end
end

%% 混淆
function P = confusion(C,para,R)
ran=R(257:352);
[Sbox1,Sbox2]=getSBox(ran,16);
a=C;
switch para
    case 'encryption'
        for i=0:255
            x1=floor(i/16)+1;
            y1=mod(i,16)+1;
            x=Sbox1(x1,y1);
            for j=0:255
                x2=floor(j/16)+1;
                y2=mod(j,16)+1;
                
                y=Sbox2(x2,y2);
                t=a(i+1,j+1);
                a(i+1,j+1)=a(x,y);
                a(x,y)=t;
            end
        end
    case 'decryption'
        for i=255:-1:0
            x1=floor(i/16)+1;
            y1=mod(i,16)+1;
            x=Sbox1(x1,y1);
            for j=255:-1:0
                x2=floor(j/16)+1;
                y2=mod(j,16)+1;
                
                y=Sbox2(x2,y2);
                t=a(i+1,j+1);
                a(i+1,j+1)=a(x,y);
                a(x,y)=t;
            end
        end
end
P=a;
end

%% 扩散
function P = diffusion(C,para,R)
[~,Y]=sort(R(353:65888));
Y=reshape(Y,[256,256])';
r(1)=mod(Y(127),256);
r(2)=mod(Y(1127),256);
A=C;
G=256;
switch para
    case 'encryption'
        % 行混淆
        for k=1:G
            for i=1:G
                if(i<=G-1)
                    j=mod(i+A(k,i+1),G)+1;
                    if(i==1)
                        C(k,1)=mod(A(k,1)+A(k,G)+A(k,G-1)+Y(k,j),G);
                    elseif(i==2)
                        C(k,i)=mod(A(k,i)+Y(k,j)+C(k,i-1)+A(k,G),G);
                    else
                        C(k,i)=mod(A(k,i)+Y(k,j)+C(k,i-1)+C(k,i-2),G);
                    end
                else
                    j=mod(G+r(1)+r(2),G)+1;
                    C(k,G)=mod(A(k,G)+Y(k,j)+C(k,G-1)+C(k,G-2),G);
                end
            end
        end
        % 列混淆
        for k=1:G
            for i=1:G
                if(k<=G-1)
                    j=mod(k+C(k+1,i),G)+1;
                    
                    if(k==1)
                        C1(1,i)=mod(C(1,i)+C(G,i)+C(G-1,i)+Y(j,i),G);
                    elseif(k==2)
                        C1(k,i)=mod(C(k,i)+Y(j,i)+C1(k-1,i)+C(G,i),G);
                    else
                        C1(k,i)=mod(C(k,i)+Y(j,i)+C1(k-1,i)+C1(k-2,i),G);
                    end
                else
                    j=mod(G+r(1)+r(2),G)+1;
                    C1(G,i)=mod(C(G,i)+Y(j,i)+C1(G-1,i)+C1(G-2,i),G);
                end
            end
        end
        P=C1;
    case 'decryption'
        C1=C;
        for k=G:-1:1
            for i=G:-1:1
                if(k==G)
                    j=mod(G+r(1)+r(2),G)+1;
                    CC(G,i)=mod(C1(G,i)-C1(G-2,i)-C1(G-1,i)-Y(j,i),G);
                else
                    j=mod(k+CC(k+1,i),G)+1;
                    if(k==1)
                        CC(1,i)=mod(C1(1,i)-CC(G,i)-CC(G-1,i)-Y(j,i),G);
                    elseif(k==2)
                        CC(k,i)=mod(C1(k,i)-CC(G,i)-C1(k-1,i)-Y(j,i),G);
                    else
                        CC(k,i)=mod(C1(k,i)-Y(j,i)-C1(k-1,i)-C1(k-2,i),G);
                    end
                    
                end
            end
        end
        
        % 行解密
        for k=G:-1:1
            for i=G:-1:1
                if(i==G)
                    j=mod(G+r(1)+r(2),G)+1;
                    AA(k,G)=mod(CC(k,G)-CC(k,G-2)-CC(k,G-1)-Y(k,j),G);
                else
                    j=mod(i+AA(k,i+1),G)+1;
                    if(i==1)
                        AA(k,1)=mod(CC(k,1)-AA(k,G)-AA(k,G-1)-Y(k,j),G);
                    elseif(i==2)
                        AA(k,i)=mod(CC(k,i)-AA(k,G)-CC(k,i-1)-Y(k,j),G);
                    else
                        AA(k,i)=mod(CC(k,i)-Y(k,j)-CC(k,i-1)-CC(k,i-2),G);
                    end
                    
                end
            end
        end
        P=AA;
end

end

%% 有限域乘法
function P =GFmuti(C,para,R)
[~,v]=sort(R(65889:65892));
L=getL(v);
r1=mod(R(65893),255)+1;
r2=mod(R(65894),255)+1;
r3=mod(R(65895),255)+1;
r4=mod(R(65896),255)+1;
for m=1:4
    for n=1:4
        if(L(m,n)==1)
            L(m,n)=r1;
        elseif(L(m,n)==2)
            L(m,n)=r2;
        elseif(L(m,n)==3)
            L(m,n)=r3;
        else
            L(m,n)=r4;
        end
    end
end
Pb=C;
switch para
    case 'encryption'
        Ld=L;
    case 'decryption'
        L1=gf(L,8);
        L2=inv(L1);
        L=L2.x;
        Ld=L;
end
%   灰度图或彩色图像，切分块为4*4
M=64;
N=64;
% 图像切分
count=1;
block={};
for i=1:M
    for j=1:N
        block{count}=Pb((i-1)*256/M+1:256/M*i,(j-1)*256/N+1:j*256/N);
        count=count+1;
    end
end

% block是行优先的
[~,len]=size(block);
L=gf(Ld,8);

for i=1:len
    P=gf(block{i},8);
    C=L*P*L;
    Cd{i}=double(C.x);
end

b=reshape(Cd,[64,64]);
d=b';
Cb=cell2mat(d);
P=Cb;
end
%% 扩散矩阵生成
function L = getLatin(c)
a=c(1);
i=1;
if(mod(a,2)==0)
    a=a-1;
end
r=c(2);
for i=1:256
    for j=1:256
        latin1(i,j)=mod(c(j)*a+a*a*c(i),256);
        if(latin1(i,j)==0)
            latin1(i,j)=256;
        end
    end
end
L=latin1;
end

%% SBox生成
function [Sbox,Sbox1] = getSBox(ran,n)
[~,ran1]=sort(ran(1:n));
[~,ran2]=sort(ran(n+1:2*n));
[~,ran3]=sort(ran(2*n+1:3*n));
x=mod(ran3(n),9)+1;
[latin1,latin2]=LatinSquare(ran1,ran2,ran3,x);
for i=1:n
    for j=1:n
        Sbox(i,j)=(latin1(i,j)-1)*n+latin2(i,j);
    end
end
[~,ran4]=sort(ran(3*n+1:4*n));
[~,ran5]=sort(ran(4*n+1:5*n));
[~,ran6]=sort(ran(5*n+1:6*n));
x=mod(ran6(n),9)+1;
[latin1,latin2]=LatinSquare(ran4,ran5,ran6,x);
for i=1:n
    for j=1:n
        Sbox1(i,j)=(latin1(i,j)-1)*n+latin2(i,j);
    end
end
end

%% 有限域乘法L矩阵生成
function L = getL(c)
a=c(1);
i=1;
while(a==2||a==4)
    a=c(i+1);
    i=i+1;
end
r=c(2);
for i=1:4
    for j=1:4
        latin1(i,j)=mod(c(j)*a+a*a*c(i),4);
        if(latin1(i,j)==0)
            latin1(i,j)=4;
        end
    end
end
L=latin1;
end

%% 拉丁方生成
function [latin1,latin2]=LatinSquare(ran1,ran2,ran3,x)
a=zeros(16,16);
t=primeRoot(x);
for i=1:16
    a(1,:)=t;
end
for i=2:16
    for j=1:16
        a(i,j)=mod(a(i-1,j)+1,16);
    end
end

for i=1:16
    for j=1:16
        if(a(i,j)==0)
            a(i,j)=16;
        end
    end
end
b=a;
for i=2:16
    t=a(1,i);
    for j=2:16
        if(a(j,1)==t)
            b(i,:)=a(j,:);
        end
    end
end
c=zeros(0,0);
for i=1:16
    for j=1:16
        if(j==16)
            c(i,j)=b(i,j);
        else
            c(i,j)=b(i,j+1);
        end
    end
end
for i=1:16
    for j=1:16
        if(b(i,j)==0)
            b(i,j)=16;
        end
        if(c(i,j)==0)
            c(i,j)=16;
        end
    end
end
latin1=b;
latin2=c;

for i=1:16
    for j=1:16
        b(i,j)=latin1(i,ran1(j));
    end
end
for i=1:16
    for j=1:16
        c(i,j)=b(ran2(i),j);
    end
end
for i=1:16
    for j=1:16
        latin1(i,j)=ran3(c(i,j));
    end
end

for i=1:16
    for j=1:16
        b(i,j)=latin2(i,ran1(j));
    end
end
for i=1:16
    for j=1:16
        c(i,j)=b(ran2(i),j);
    end
end
for i=1:16
    for j=1:16
        latin2(i,j)=ran3(c(i,j));
    end
end


end

function firstR=primeRoot(p)

Plist=[3,5,6,7,10,11,12,14];
list=zeros(8,16);
t=[];
t(1)=16;
t(2)=1;
index=zeros(9,16);
for i=3:16
    if(mod(i,2)==0)
        continue;
    end
    t(i)=16-(i-1)/2;
end
for i=1:16
    if(mod(i,2)==0)
        t(i)=i/2;
    end
end

for i=1:8
    for j=1:16
        temp=mod(Plist(i)^j,17);
        list(i,j)=temp;
    end
    [x,y]=sort(list(i,:));
    index(i,:)=y;
end
index(9,:)=t;
for i=1:9
    for j=1:16
        if(index(i,j)==16)
            index(i,j)=0;
        end
    end
end

firstR=index(p,:);
end