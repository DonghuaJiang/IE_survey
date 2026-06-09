% account_max=zeros(766,256);
jie_max=zeros(766,256);
account=0;
for s=0:1:765
     jie_hang=s+1;
     if s<=255
         max=s;
     else
         max=255;
     end
     for j=0:1:max
         jie_lie=j+1;
        for z=0:1:s-j
           for k=0:1:s-j-z
              if j+z+k==s && j<=255 && z<=255 && k<=255 
                 account=account+1; 
              end
           end
        end
     jie_max(jie_hang,jie_lie)=account;
     account=0;
     end
end

%     for j=0:1:s
%        for z=0:1:s-j
%           for k=0:1:s-j-z
%               if j+z+k==s && j<=255 && z<=255 && k<=255
%                   account=account+1;
%                  jie_511(account,1)=j; 
%                  jie_511(account,2)=z; 
%                  jie_511(account,3)=k; 
%               end
%              
%           end
%        end
%     end
%     account_max(1,i+1)=account;

% cha=zeros(1,765);
% 
% for i=2:1:766
%    cha(i-1)=account_max(i)-account_max(i-1); 
% end