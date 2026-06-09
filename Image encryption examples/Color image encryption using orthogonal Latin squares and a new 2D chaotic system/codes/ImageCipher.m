function varargout = ImageCipher(P,para,K)  
%% 获取密钥
if ~exist('K','var') && strcmp(para,'encryption')        
    K = round(rand(1,256));
    OutNum = 2;
elseif ~exist('K','var')  && strcmp(para,'decryption')
    error('Can not dectrypted without a key');
else
    OutNum = 1;
end
tran = @(K,low,high) sum(K(low:high).*2.^(-(1:(high-low+1)))); 
x1_0 = bi2de(K(1));
    if x1_0 == 0
       x1 = tran(K,2,32);   
    else
       x1 = -tran(K,2,32);  
    end
y1_0 = bi2de(K(33));
    if y1_0 == 0
       y1 = tran(K,34,64);
    else
       y1 = -tran(K,34,64); 
    end
a11 = bi2de(K(65:71));
a12 = tran(K,72,96);
a1 = a11+a12+1;
b11 = bi2de(K(97:103));
b12 = tran(K,104,128);
b1 = b11+b12+1;

x2_0 = bi2de(K(129));
    if x2_0 == 0
       x2 = tran(K,130,160); 
    else
       x2 = -tran(K,130,160);  
    end
y2_0 = bi2de(K(161));
    if y2_0 == 0
       y2 = tran(K,162,192);
    else
       y2 = tran(K,162,192);  
    end
a21 = bi2de(K(193:199));
a22 = tran(K,200,224);
a2 = a21+a22+1;
b21 = bi2de(K(225:231));
b22 = tran(K,232,256);
b2 = b21+b22+1;                              

%% 生成混沌序列
[N, ~, ~] = size(P);
[S11,R11,R21,R31,R41] = ChaoticSeq(x1,y1,a1,b1,N);
[S21,R12,R22,R32,R42] = ChaoticSeq(x2,y2,a2,b2,N);
%% 加密解密过程
C = double(P);
switch para
    case 'encryption'
             % round 1
             [L1,L2,L3] = Latin(S11);
             C = Random(C);
             C = LatinChange(C,para,L1,L2,L3);   
             C = Substitution(C,para,R11,R21,R31,R41);
             
             C = Finitefield(C,para);
             % round 2
             [L1,L2,L3] = Latin(S21);
             C = LatinChange(C,para,L1,L2,L3);
             C = Substitution(C,para,R12,R22,R32,R42);

    case 'decryption'
             [L1,L2,L3] = Latin(S21);
             C = Substitution(C,para,R12,R22,R32,R42);
             C = LatinChange(C,para,L1,L2,L3);
             
             C = Finitefield(C,para);
             
             [L1,L2,L3] = Latin(S11);
             C = Substitution(C,para,R11,R21,R31,R41);
             C = LatinChange(C,para,L1,L2,L3);
end
C = uint8(C);
 %% 控制输出
if OutNum == 1
     varargout{1} = C;
else
    varargout{1} = C;
    varargout{2} = K;
end
end % end of the function ImageCipher

 %% 混沌序列生成函数
 function  [S1,R1,R2,R3,R4] = ChaoticSeq(x,y,a,b,N)
 X = zeros(1,N);   
 Y = zeros(1,12*N*N);
 for m = 1:N
       tx = x;ty = y;
       x = cos(4*a*tx*(1-tx)+b*sin(pi*ty)+1);
       y = cos(4*a*ty*(1-ty)+b*sin(pi*tx)+1);
       X(m) = x;
 end
 for m = N+1:3*N*N+N
       tx = x;ty = y;
       x = cos(4*a*tx*(1-tx)+b*sin(pi*ty)+1);
       y = cos(4*a*ty*(1-ty)+b*sin(pi*tx)+1);
       Y(m) = y;
 end
 S1 = X; 
 R1 = cat(3,reshape(Y(1:N*N),[N,N]),reshape(Y(N*N+1:2*N*N),[N,N]), reshape(Y(2*N*N+1:3*N*N),[N,N]));
 R2 = cat(3,reshape(Y(3*N*N+1:4*N*N),[N,N]),reshape(Y(4*N*N+1:5*N*N),[N,N]), reshape(Y(5*N*N+1:6*N*N),[N,N]));
 R3 = cat(3,reshape(Y(6*N*N+1:7*N*N),[N,N]),reshape(Y(7*N*N+1:8*N*N),[N,N]), reshape(Y(8*N*N+1:9*N*N),[N,N]));
 R4 = cat(3,reshape(Y(9*N*N+1:10*N*N),[N,N]),reshape(Y(10*N*N+1:11*N*N),[N,N]), reshape(Y(11*N*N+1:12*N*N),[N,N]));
 end
 
%% 添加伪随机序列
function P1 = Random(P)
P1 = P;
[N,~,~] = size(P);
    for i = 1:N
        r1 = randi([0,1]);
        r2 = randi([0,1]);
        a = P1(i,1,1);
        b = bitset(a,1,r1);
        c = bitset(b,2,r2);
        P1(i,1,1) = c;
    end
end

%% 生成拉丁矩阵
function [L1,L2,L3] = Latin(S)
[~,N] = size(S);
[~,lx] = sort(S);
for i = 1:N
    lx(1,i) = lx(1,i)-1;
end
L1 = zeros(N,N,3);
L2 = zeros(N,N,3);
L3 = zeros(N,N,3);
    for i=1:N
        for j=1:N
            for k=1:3
                L1(i,j,k)=mod(mod(lx(i)+1*lx(j),N)+1*lx(k),N);
                if(L1(i,j,k)==0)
                     L1(i,j,k)=N;
                end
                L2(i,j,k)=mod(mod(lx(i)+mod(2*lx(j),N),N) + mod(4*lx(k),N),N);
                if(L2(i,j,k)==0)
                    L2(i,j,k)=N;
                end
                L3(i,j,k)=mod(mod(lx(i)+mod(3*lx(j),N),N) + mod(9*lx(k),N),N);
                if(L3(i,j,k)==0)
                    L3(i,j,k)=N;
                end
            end
        end
    end 
end

%% 通过拉丁矩阵置乱并压缩
function C = LatinChange(P,para,L1,L2,L3)
[N, ~, ~] = size(L1);
C = zeros(N,N,3);
CC = zeros(N,N,N);
S = zeros(N,N,N);
switch para
    case 'encryption'  % 加密
        for i = 1:N
            for j = 1:N
                for k = 1:3
                    CC(L1(i,j,k),L2(i,j,k),L3(i,j,k)) = P(i,j,k);
                    S(L1(i,j,k),L2(i,j,k),L3(i,j,k)) = 1;
                end
            end
        end  
        for i = 1:N
            for j = 1:N
                temp = 1;
                for k = 1:N
                    if S(i,j,k) == 1
                         C(i,j,temp) = CC(i,j,k);
                         temp = temp+1;
                    end
                end
            end
        end       
    case 'decryption'  %解密
         for i = 1:N
             for j = 1:N
                 for k = 1:3
                     S(L1(i,j,k),L2(i,j,k),L3(i,j,k)) = 1;
                 end
             end
         end
         for i = N:-1:1
             for j = N:-1:1
                 temp = 3;
                 for k = N:-1:1
                      if S(i,j,k) == 1
                          CC(i,j,k) = P(i,j,temp);
                          temp = temp-1;
                      end
                 end
             end
         end
         for i = 1:N
            for j = 1:N
                for k = 1:3
                    C(i,j,k) = CC(L1(i,j,k),L2(i,j,k),L3(i,j,k));
                end
            end
         end
end
end
%% 值改变
function C = Substitution(P,para,R1,R2,R3,R4)
P = double(P); 
[N,~,~] = size(P);
R1 = floor(R1.*2^32); R2 = floor(R2.*2^32); R3 = floor(R3.*2^32); R4 = floor(R4.*2^32); 
R1 = mod(R1(:,:,:), 256);R2 = mod(R2(:,:,:), 256);R3 = mod(R3(:,:,:), 256);R4 = mod(R4(:,:,:), 256);
r1 = R1(1,1,1);r3 = R2(1,1,1);r5 = R3(1,1,1);r7 = R4(1,1,1);
r2 = R1(N,N,3);r4 = R2(N,N,3);r6 = R3(N,N,3);r8 = R4(N,N,3);
C0 = zeros(N,N,3);
C1 = zeros(N,N,3);
C2 = zeros(N,N,3);
C = zeros(N,N,3);
switch para
    case 'encryption' 
        % 
        for k=1:3
            for i=1:N
                for j=1:N
                    if(i==1&&k==1)
                        C0(i,j,k)=mod(P(i,j,k)+R1(i,j,k)+r1+r2,256);
                    elseif(i==1&&k~=1)
                        C0(i,j,k)=mod(P(i,j,k)+R1(i,j,k)+C0(N,j,k-1)+P(N,j,k-1),256);
                    else
                        C0(i,j,k)=mod(P(i,j,k)+R1(i,j,k)+C0(i-1,j,k)+P(i-1,j,k),256);
                    end
                end
            end
        end
        % 
        for k=1:3
            for i=1:N
                for j=1:N
                    if(j==1&&k==1)
                        C1(i,j,k)=mod(C0(i,j,k)+R2(i,j,k)+r3+r4,256);
                    elseif(j==1&&k~=1)
                        C1(i,j,k)=mod(C0(i,j,k)+R2(i,j,k)+C1(i,N,k-1)+C0(i,N,k-1),256);
                    else
                        C1(i,j,k)=mod(C0(i,j,k)+R2(i,j,k)+C1(i,j-1,k)+C0(i,j-1,k),256); 
                    end
                end
            end
        end
        % 反向列
        for k=3:-1:1
            for i=N:-1:1
                for j=N:-1:1
                    if(i==N&&k==3)
                        C2(i,j,k)=mod(C1(i,j,k)+R3(i,j,k)+r5+r6,256);
                    elseif(i==N&&k~=3)
                        C2(i,j,k)=mod(C1(i,j,k)+R3(i,j,k)+C2(1,j,k+1)+C1(1,j,k+1),256);
                    else
                        C2(i,j,k)=mod(C1(i,j,k)+R3(i,j,k)+C2(i+1,j,k)+C1(i+1,j,k),256);
                    end
                end
            end
        end
        % 反向行
        for k=3:-1:1
            for i=N:-1:1
                for j=N:-1:1
                    if(j==N&&k==3)
                        C(i,j,k)=mod(C2(i,j,k)+R4(i,j,k)+r7+r8,256);
                    elseif(j==N&&k~=3)
                        C(i,j,k)=mod(C2(i,j,k)+R4(i,j,k)+C(i,1,k+1)+C2(i,1,k+1),256);
                    else
                        C(i,j,k)=mod(C2(i,j,k)+R4(i,j,k)+C(i,j+1,k)+C2(i,j+1,k),256);
                    end
                end
            end
        end
        
     case 'decryption'
        % 反向行
        for k=3:-1:1
            for i=N:-1:1
                for j=N:-1:1
                    if(j==N&&k==3)
                        C2(i,j,k)=mod(P(i,j,k)-R4(i,j,k)-r7-r8,256);
                    elseif(j==N&&k~=3)
                        C2(i,j,k)=mod(P(i,j,k)-R4(i,j,k)-P(i,1,k+1)-C2(i,1,k+1),256);
                    else
                        C2(i,j,k)=mod(P(i,j,k)-R4(i,j,k)-P(i,j+1,k)-C2(i,j+1,k),256);
                    end
                end
            end
        end
        % 反向列
        for k=3:-1:1
            for i=N:-1:1
                for j=N:-1:1
                    if(i==N&&k==3)
                        C1(i,j,k)=mod(C2(i,j,k)-R3(i,j,k)-r5-r6,256);
                    elseif(i==N&&k~=3)
                        C1(i,j,k)=mod(C2(i,j,k)-R3(i,j,k)-C2(1,j,k+1)-C1(1,j,k+1),256);
                    else
                        C1(i,j,k)=mod(C2(i,j,k)-R3(i,j,k)-C2(i+1,j,k)-C1(i+1,j,k),256);
                    end
                end
            end
        end
        % 
        for k=1:3
            for i=1:N
                for j=1:N
                    if(j==1&&k==1)
                        C0(i,j,k)=mod(C1(i,j,k)-R2(i,j,k)-r3-r4,256);
                    elseif(j==1&&k~=1)
                        C0(i,j,k)=mod(C1(i,j,k)-R2(i,j,k)-C0(i,N,k-1)-C1(i,N,k-1),256);
                    else
                        C0(i,j,k)=mod(C1(i,j,k)-R2(i,j,k)-C0(i,j-1,k)-C1(i,j-1,k),256); 
                    end
                end
            end
        end
        % 
        for k=1:3
            for i=1:N
                for j=1:N
                    if(i==1&&k==1)
                        C(i,j,k)=mod(C0(i,j,k)-R1(i,j,k)-r1-r2,256);
                    elseif(i==1&&k~=1)
                        C(i,j,k)=mod(C0(i,j,k)-R1(i,j,k)-C(N,j,k-1)-C0(N,j,k-1),256);
                    else
                        C(i,j,k)=mod(C0(i,j,k)-R1(i,j,k)-C(i-1,j,k)-C0(i-1,j,k),256);
                    end
                end
            end
        end
end
end

%% 有限域运算
function CC = Finitefield(P,para)
[N,~,~] = size(P);
P1 = zeros(N,3*N);
P1(:,1:N) = P(:,:,1);
P1(:,N+1:2*N) = P(:,:,2);
P1(:,2*N+1:3*N) = P(:,:,3);
if max(P1(:))>1
    S = 4;
else
    S = 32;
end
switch para
    case 'encryption'
        L = gf([4 2 1 3; 1 3 4 2; 2 4 3 1; 3 1 2 4],8);
    case 'decryption'
        L = gf([71 216 173 117; 173 117 71 216; 216 71 117 173; 117 173 216 71],8);
end
C = P1;
mn = floor(size(P1)/S)*S;
fun = @(y) double(y.x);
C(1:mn(1),1:mn(2)) = blkproc(P1(1:mn(1),1:mn(2)),[4,4],@(y) feval(fun,L*y*L));
CC = cat(3,C(:,1:N),C(:,N+1:2*N),C(:,2*N+1:3*N));
end

 