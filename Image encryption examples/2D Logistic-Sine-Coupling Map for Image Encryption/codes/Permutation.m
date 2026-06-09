function t = Permutation( chaoM, iMat, para )
% ÖÃÂÒ²Ù×÷
% chaoM      »ìãç¸¨Öú¾ØÕó
% iMat       Í¼ÏñÏñËØ¾ØÕó
% para       ²ÎÊý


[m,n] = size(iMat);
t = zeros(m,n);
ctemp = zeros(1,n);
[~,col] = sort(chaoM,1);
switch para
    case 'encryption'

        for i=1:m
            for j=1:n
                ctemp(1,j) = chaoM(col(i,j),j);
            end
            [~,indc] = sort(ctemp,2);
            for k=1:n
                %t(col(i,indc(1,k)),indc(1,k)) = iMat(col(i,k),k);
                t(col(i,k),k) = iMat(col(i,indc(1,k)),indc(1,k));
            end

        end
    case 'decryption'

        for i=1:m
            for j=1:n
                ctemp(1,j) = chaoM(col(i,j),j);
            end
            [~,indc] = sort(ctemp,2);
            for k=1:n
                %t(col(i,k),k) = iMat(col(i,indc(1,k)),indc(1,k));
                t(col(i,indc(1,k)),indc(1,k)) = iMat(col(i,k),k);
            end

        end
end

% rtemp = zeros(m,1);
% 
% for i=1:n
%     for j=1:m
%         rtemp(j,1) = chaoM(j,row(j,i));
%     end
%     [~,indr] = sort(rtemp,1);
%     for k=1:m
%         cipher(indr(k,1),row(indr(k,1),i)) = t(k,row(k,i));
%     end
%     
% end





        
end

