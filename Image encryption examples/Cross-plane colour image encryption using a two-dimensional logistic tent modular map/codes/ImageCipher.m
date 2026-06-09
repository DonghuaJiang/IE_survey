function varargout = ImageCipher(P,para,K)  
%% 密钥
if ~exist('K','var') && strcmp(para,'encryption')        
    K = round(rand(1,256));
    OutNum = 2;
elseif ~exist('K','var')  && strcmp(para,'decryption')
    error('Can not dectrypted without a key');
else
    OutNum = 1;
end
tran = @(K,low,high) sum(K(low:high).*2.^(-(1:(high-low+1))));                                                                  
x1 = tran(K,1,32);                                               
y1 = tran(K,33,64);
a11 = bi2de(K(65:71));
a12 = tran(K,72,96);
a1 = a11+a12+1;
b11 = bi2de(K(97:103));
b12 = tran(K,104,128);
b1 = b11+b12+1;

x2 = tran(K,129,160);                                               
y2 = tran(K,161,192);
a21 = bi2de(K(193:199));
a22 = tran(K,200,224);
a2 = a21+a22+1;
b21 = bi2de(K(225:231));
b22 = tran(K,232,256);
b2 = b21+b22+1;                              

%% 生成混沌序列
[r, c, ~] = size(P);
[S11,S12] = ChaoticSeq(x1,y1,a1,b1,r,c);
[S21,S22] = ChaoticSeq(x2,y2,a2,b2,r,c);
 %% 加密解密过程
C = double(P);
switch para
    case 'encryption'
            % round one
             C = SpatialTrans(C,para,S11);
             C = ChaoticMagicTrans(C,para,S12);
             C = Substitution(C,para,S11);
             
             C = SpatialTrans(C,para,S21);
             C = ChaoticMagicTrans(C,para,S22);
             C = Substitution(C,para,S21);
    case 'decryption'
             C = Substitution(C,para,S21);
             C = ChaoticMagicTrans(C,para,S22);  
             C = SpatialTrans(C,para,S21);
             
             C = Substitution(C,para,S11);
             C = ChaoticMagicTrans(C,para,S12);
             C = SpatialTrans(C,para,S11);
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
 function  [S1,S2] = ChaoticSeq(x,y,a,b,r,c)
 X = zeros(1,3*r*c);    
 Y = zeros(1,3*r*c);
 for m = 1:3*r*c
       tx = x;ty = y;
       x = mod(4*a*tx*(1-tx) + (2*b*ty*((ty)<0.5)+2*b*(1-ty)*((ty)>=0.5)) ,1);
       y = mod(4*a*ty*(1-ty) + (2*b*tx*((tx)<0.5)+2*b*(1-tx)*((tx)>=0.5)) ,1);
       X(m) = x;
       Y(m) = y;
 end
 S1 = cat(3,reshape(X(1:r*c),[r,c]),reshape(X(r*c+1:2*r*c),[r,c]), reshape(X(2*r*c+1:3*r*c),[r,c]));  
 S2 = Y(1:3*(r+c));
 end
 %% 空间值排序
function T = SpatialTrans(P,para,S)
[r,c,p] = size(P);
T = zeros(r,c,p);
[~,I] = sort(S,3);
switch para
    case'encryption'
        for k = 1:p
            for i = 1:r
                for j =1:c
                    T(i,j,k) = P(i,j,I(i,j,k));
                end
            end
        end
    case'decryption'
       for k = 1:p
           for i = 1:r
               for j =1:c
                   T(i,j,I(i,j,k)) = P(i,j,k);
               end
           end
       end
end
end

 %% 在单一平面位置改变
function C = ChaoticMagicTrans( P,para,S)
[r,c,p] = size(P);
R1 = S(1:r);   C1 = S(r+1:r+c);
R2 = S(r+c+1:2*r+c);   C2 = S(2*r+c+1:2*r+2*c);
R3 = S(2*r+2*c+1:3*r+2*c);  C3 = S(3*r+2*c+1:3*r+3*c);
[~,I1] = sort(R1); [~,J1] = sort(C1);
[~,I2] = sort(R2); [~,J2] = sort(C2);
[~,I3] = sort(R3); [~,J3] = sort(C3);
S1 = zeros(r,c);                             
     for m = 1:r
         for n = 1:c
             it = mod(n+I1(m)-1,c) + 1;
             S1(m,n) = J1(it);
         end
     end
S2 = zeros(r,c);                             
     for m = 1:r
         for n = 1:c
            it = mod(n+I2(m)-1,c) + 1;
            S2(m,n) = J2(it);
         end
     end
S3 = zeros(r,c);                             
     for m = 1:r
         for n = 1:c
            it = mod(n+I3(m)-1,c) + 1;
            S3(m,n) = J3(it);
         end
     end
S_c = cat(3,S1,S2,S3);
C = P;
switch para
    case 'encryption'
        for k = 1:p
            for j = 1:c
                for i = 1:r
                    tr = i;
                    cc = S_c(i,j,k);
                    m = mod(-S_c(1,j,k)+i-1,r) + 1;
                    n = S_c(mod(-S_c(1,j,k)+i-1,r)+1, j, k);
                    C(m,n,k) = P(tr,cc,k);
                end
            end
        end
    case 'decryption'
        for k = 1:p
            for j = 1:c
                for i = 1:r
                    tr = i;
                    cc = S_c(i,j,k);
                    m = mod(S_c(1,j,k) + i - 1,r) + 1;
                    n = S_c(mod(S_c(1,j,k)+i-1,r)+1, j,k);
                    C(m,n,k) = P(tr,cc,k);
                end
            end
        end

end
end
%% 值改变
function C = Substitution(P,para,S)
P = double(P); 
[r,c,p] = size(P);
F = 256;
S = floor(S.*2^32);      
S = mod(S(:,:,:), F);      
C = zeros(r,c,3);
switch para
    case 'encryption'
        for k = 1:p
            for n = 1:c
                for m = 1:r
                     if m == 1 && n == 1 && k == 1
                         C(m,n,k) = mod(P(m,n,k)+P(r,c,3)+S(m,n,k), F);
                     elseif m == 1 && n == 1 && (k ~= 1)
                         C(m,n,k) = mod(P(m,n,k)+C(r,c,k-1)+S(m,n,k), F);
                     elseif m == 1 && (n ~= 1)
                         C(m,n,k) = mod(P(m,n,k)+C(r,n-1,k)+S(m,n,k), F);
                     else 
                         C(m,n,k) = mod(P(m,n,k)+C(m-1,n,k)+S(m,n,k), F);
                     end
                end
            end
        end
    case 'decryption'
        for k = p:-1:1
            for n = c:-1:1
                for m = r:-1:1
                    if m == 1 && n == 1 && k == 1
                        C(m,n,k) = mod(P(m,n,k)-C(r,c,3)-S(m,n,k),F);
                    elseif m == 1 && n == 1 && (k ~= 1)
                        C(m,n,k) = mod(P(m,n,k)-P(r,c,k-1)-S(m,n,k),F);
                    elseif m == 1 && (n ~= 1)
                        C(m,n,k) = mod(P(m,n,k)-P(r,n-1,k)-S(m,n,k),F);
                    else
                        C(m,n,k) = mod(P(m,n,k)-P(m-1,n,k)-S(m,n,k),F);
                    end
                end
            end
        end
end
end


 
 