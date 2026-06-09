%置乱解密

function after_I=De_I(I,dimen,key)
[x,y]=size(I);
after_I=I;
b_x=x/dimen;
b_y=y/dimen;
pix_num=dimen^2;
step=0;
rng(key);
r=randsample(pix_num,pix_num);

re_locate=zeros(pix_num,1);
i=1;

while i<=pix_num%确定置乱的对应位置
   re_locate(i)=find(r==i);
    i=i+1;
end

for i=1:1:b_x
   x_begin=(i-1)*dimen+1;
   x_end=i*dimen;
   for j=1:1:b_y
       step=step+1;
       y_begin=(j-1)*dimen+1;
       y_end=j*dimen;
       t_matrix=after_I(x_begin:x_end,y_begin:y_end);%取出块中的元素
       after_t=t_matrix(re_locate);%块中元素打乱,为一列
       blo_t=reshape(after_t,dimen,dimen);%将一列元素重新变成一块，以列的顺序进行
       after_I(x_begin:x_end,y_begin:y_end)=blo_t;
   end
end