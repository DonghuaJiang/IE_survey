function t = SpeedTest( Image )
% 加密100次的速度均值

% Image = imread('E:\Images\harrier.tiff');
[m,n] = size(Image);
iMat = double(Image);
load('F:\PaperForJF\key.mat');
rKey = randn(1,256)<0.5;
E(100) = 0;
p = m*n;
F = 2;
for ii=1:100
    z1 = clock;
    [x, y, r1, r2, r3, r4] = GenKey( rKey );
    seq1 = SequenceGenerator( p,r1,x,y );
    chaoMP1 = reshape(seq1(1,:),m,n);
    chaoMD1 = reshape(seq1(2,:),m,n);
    cSupMat = mod(floor(chaoMD1.*2^32),F);
    for jj=1:4
        t = zeros(m,n);
        ctemp = zeros(1,n);
        [~,col] = sort(chaoMP1,1);
        for i=1:m
            for j=1:n
                ctemp(1,j) = chaoMP1(col(i,j),j);
            end
            [~,indc] = sort(ctemp,2);
            for k=1:n
                %t(col(i,indc(1,k)),indc(1,k)) = iMat(col(i,k),k);
                t(col(i,k),k) = iMat(col(i,indc(1,k)),indc(1,k));
            end
            
        end
        
        t(1,:) = mod(iMat(1,:)+iMat(m,:)+iMat(m-1,:)+cSupMat(1,:),F);
        t(2,:) = mod(iMat(2,:)+t(1,:)+iMat(m,:)+cSupMat(2,:),F);
        for i=3:m
            t(i,:) = mod(iMat(i,:)+t(i-1,:)+t(i-2,:)+cSupMat(i,:),F);
        end
        cipher(:,1) = mod(t(:,1)+t(:,n)+t(:,n-1)+cSupMat(:,1),F);
        cipher(:,2) = mod(t(:,2)+cipher(:,1)+t(:,n)+cSupMat(:,2),F);
        for i=3:n
            cipher(:,i) = mod(t(:,i)+cipher(:,i-1)+cipher(:,i-2)+cSupMat(:,i),F);
        end
    end
    z2 = clock;
    E(ii) = etime(z2,z1);
end
t = mean(E);
% C = Encryption(iMat,m,n,key);
