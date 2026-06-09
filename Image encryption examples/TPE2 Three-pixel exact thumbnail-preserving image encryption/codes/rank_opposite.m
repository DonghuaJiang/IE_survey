%rank的逆
%r=像素组的秩，s=像素组的和
function group=rank_opposite(r,s)
group=zeros(1,3);%一行三列
account=0;
    for j=0:1:s
       for z=0:1:s-j
          for k=0:1:s-j-z
              if j+z+k==s && j<=255 && z<=255 && k<=255
                 account=account+1;
                 if r==account
                     group(1)=j;
                     group(2)=z;
                     group(3)=k;
                     return;
                 end
              end
          end
       end
    end