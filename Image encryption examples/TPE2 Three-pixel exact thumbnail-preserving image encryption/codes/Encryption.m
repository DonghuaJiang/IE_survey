%jiami

function after_R=Encryption(dimen,R,key)
[x,y]=size(R);
dimen_x=x/dimen;
dimen_y=y/dimen;
after_R=R;
for i=1:1:dimen_x
   for j=1:1:dimen_y
        begin_x=dimen*(i-1)+1;
        end_x=dimen*i;
        begin_y=dimen*(j-1)+1;
        end_y=dimen*j;
        block=R(begin_x:end_x,begin_y:end_y);%把块截取出 
        after_b=process_block(dimen,block,key);%对块中像素组置换加密
        after_R(begin_x:end_x,begin_y:end_y)=after_b;%加密后的块放入图像中
   end
end
after_R=P_box(after_R,dimen,key);%置乱加密