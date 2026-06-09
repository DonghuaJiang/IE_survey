%表示矩阵
%exp=表示矩阵，zone=域
function exp=pix_Exp(zone)
[x,y]=size(zone);
exp=zeros(x,y);
for i=1:1:x
   for j=1:1:y
      num=double(zone(i,j));
      t=ceil(log2(num));
      exp(i,j)=t;
   end
end