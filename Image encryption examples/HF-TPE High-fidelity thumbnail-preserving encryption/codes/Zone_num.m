%像素组的域数量
%s=和矩阵
function   num=Zone_num(S)
[x,y]=size(S);
num=zeros(x,y);
for i=1:1:x
   for j=1:1:y
       sum=S(i,j);
       if sum<=127
            num(i,j)=sum+1;
       else
            num(i,j)=254-sum+1;
       end
   end
end
