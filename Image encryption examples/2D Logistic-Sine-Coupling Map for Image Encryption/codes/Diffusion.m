function cipher = Diffusion( chaoM, iMat, para, F )
%  À©É¢²Ù×÷  
%  chaoM         »ìãç¸¨Öú¾ØÕó
%  iMat          Í¼Ïñ¾ØÕó
%  para          ²ÎÊý
%  F             Í¼ÏñÀà±ð

[m,n] = size(iMat);
cipher = zeros(m,n);
cSupMat = mod(floor(chaoM.*2^32),F);
switch para
    case 'encryption'
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

    case 'decryption'
        for i=n:-1:3
            t(:,i) = mod(iMat(:,i)-iMat(:,i-1)-iMat(:,i-2)-cSupMat(:,i),F);
        end
        t(:,2) = mod(iMat(:,2)-t(:,n)-iMat(:,1)-cSupMat(:,2),F);
        t(:,1) = mod(iMat(:,1)-t(:,n)-t(:,n-1)-cSupMat(:,1),F);
        
        for i=m:-1:3
            cipher(i,:) = mod(t(i,:)-t(i-1,:)-t(i-2,:)-cSupMat(i,:),F);
        end
        cipher(2,:) = mod(t(2,:)-cipher(m,:)-t(1,:)-cSupMat(2,:),F);
        cipher(1,:) = mod(t(1,:)-cipher(m,:)-cipher(m-1,:)-cSupMat(1,:),F);
        
     
        
end


end

