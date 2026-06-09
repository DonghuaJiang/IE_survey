%ºÍ¾ØÕó

function sum=pix_sum(I)
[x,y]=size(I);
sum=zeros(x,y/2);

for i=1:1:x
   for j=1:1:y/2
      s=I(i,j*2-1)+I(i,j*2);
      sum(i,j)=s;
   end
end