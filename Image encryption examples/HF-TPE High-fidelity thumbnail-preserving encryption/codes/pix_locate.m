%位置矩阵

function locate=pix_locate(de_R,zone,sum)
[x,y]=size(zone);%y=图像宽的一半
locate=zeros(x,y);
for i=1:1:x
   for j=1:1:y
       s=sum(i,j);
       pix=de_R(i,j*2-1);
       if s<=127
           locate(i,j)=pix;
       else
           begin=127-zone(i,j)+1;%域开始的位置
           locate(i,j)=pix-begin;
       end
   end
end
