%恢复位置矩阵

function re_locate=Re_locate(re_zone,re_cap,re_exp,de_R,lsbs,S,key)
[x,y]=size(re_cap);
diff=re_exp-re_cap;
locate=pix_locate(de_R,re_zone,S);
re_locate=locate;

for i=1:1:x
   for j=1:1:y
       cap_num=re_cap(i,j);
       exp_num=re_exp(i,j);
       lo=locate(i,j);
       
       if cap_num~=0
           if diff(i,j)==0%S1情况
               en_lo=dec2bin(lo,exp_num);
           else 
               z=re_zone(i,j)-1;             
               lo_bit=dec2bin(lo,exp_num);     
               z_bit=dec2bin(z,exp_num);%域中像素组数量转化为二进制
               first_bit=lo_bit(2:exp_num);%第一次嵌入的信息
               zbit=z_bit(2:exp_num);%域的后n-1位
               if bin2dec(zbit)>=bin2dec(first_bit) %能进行第二次嵌入，S2情况
                   remind_bit=lo_bit(1:1);
                   en_lo=[first_bit,remind_bit];
               else
                   remind_bit=num2str(lsbs(i,j*2-1));
                   en_lo=[first_bit,remind_bit];
               end
           end
       limit=2^(exp_num)-1;%异或的界限
       rng(key);
       key_bit=randi([0,limit],1,1);
       lo_bit=bitxor(key_bit,bin2dec(en_lo));%异或解密
       re_locate(i,j)=lo_bit;
       else%嵌入容量为零
           re_locate(i,j)=0;
       end
      
%        if t(i,j)~=re_locate(i,j)
%            error('1');
%        end
   end
end