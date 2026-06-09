%解密

function re_R=Decryption(dimen,after_R,key)
de_R=De_I(after_R,dimen,key);%置乱解密
 re_R=de_R;
 [x,y]=size(de_R);
dimen_x=x/dimen;
dimen_y=y/dimen;
   for i=1:1:dimen_x%对块进行处理
      for j=1:1:dimen_y
            begin_x=dimen*(i-1)+1;
            end_x=dimen*i;
            begin_y=dimen*(j-1)+1;
            end_y=dimen*j;
            block=de_R(begin_x:end_x,begin_y:end_y);%把块截取出
            re_b=decryption_block(dimen,block,key);%对块进行解密
            re_R(begin_x:end_x,begin_y:end_y)=re_b;%加密后的块放入图像中
      end
   end