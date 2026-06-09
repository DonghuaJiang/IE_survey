key=1;
dimen=32;
I=imread('Lena512.png');
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

after_R=Encryption(R,dimen,key);
after_G=Encryption(G,dimen,key);
after_B=Encryption(B,dimen,key);
after_I=cat(3,after_R,after_G,after_B);
% imshow(after_I);
% imwrite(after_I,['Lena_',num2str(dimen),'.png']);%保存

% [lsbs,de_R]=Vancant_room(R);%分割图像：de_R=图像的高7位，lsbs图像的最低有效位
% S=pix_sum(de_R);%和矩阵
% zone=Zone_num(S);%域数量矩阵（高七位的域函数）
% cap=pix_Cap(zone);%容量矩阵
% exp=pix_Exp(zone);%表示位数的矩阵，即一个位置信息需要多少位bit来表示
% locate=pix_locate(de_R,zone,S);%位置矩阵，确定像素组在域中所在的位置
% [en_locate,en_lsbs]=En_locate(cap,exp,zone,locate,lsbs,key);%编码后的位置矩阵
% after_I=en_I(de_R,S,en_locate,en_lsbs);%由矩阵恢复图像

re_R=Decryption(after_R,dimen,key);
re_G=Decryption(after_G,dimen,key);
re_B=Decryption(after_B,dimen,key);
re_I=cat(3,re_R,re_G,re_B);
% imshow(re_I);

subplot(1,3,1);
imshow(I);
subplot(1,3,2);
imshow(after_I);
subplot(1,3,3);
imshow(re_I);
% de_R=after_I;
%  [re_lsbs,re_R]=Vancant_room(de_R);%最低有效位，和前七位矩阵
%  re_S=pix_sum(re_R);%前七位之和
%  re_zone=Zone_num(re_S);%域数量矩阵
%  re_cap=pix_Cap(re_zone);%容量矩阵
%  re_exp=pix_Exp(re_zone);%表示位数矩阵
%  re_locate=Re_locate(re_zone,re_cap,re_exp,re_R,re_lsbs,re_S,key,locate);%恢复位置矩阵
%  re_I=en_I(re_R,S,re_locate,re_lsbs);
% [x,y]=size(cap);%y是图像宽的一半
% diff=exp-cap;%表示矩阵和嵌入矩阵的差值
% en_locate=zeros(x,y);
% for i=1:1:x%选中像素组的行
%     for j=1:1:y%选中像素组的列
%     exp_num=exp(i,j);%该像素组的域需要用多少位表示
%     lo=locate(i,j);%像素组在域中的位置
%     limit=2^(exp_num)-1;%异或的界限
%     rng(key);
%     key_bit=randi([0,limit],1,1);
%     lo_bit=dec2bin(bitxor(key_bit,lo),exp_num);%异或加密
%     if cap(i,j)~=0
%         if diff(i,j)==0 
%             en_locate(i,j)=bin2dec(lo_bit);
%         else
%             z=zone(i,j)-1;%域的表示范围
%             z_bit=dec2bin(z,exp_num);%转化为二进制
%             cap_num=cap(i,j);%嵌入容量
%             lobit=lo_bit(1:cap_num);%第一次嵌入的数据
%             zbit=z_bit(2:exp_num);%域的后n-1位
%             remind_bit= lo_bit(cap_num+1:exp_num);%将位置矩阵的最后一位提取出来
%             if bin2dec(zbit)>=bin2dec(lobit) %能进行第二次嵌入
%                 bit=[remind_bit,lobit];%将余下一位放在最高位
%                 en_locate(i,j)=bin2dec(bit);
%             else%不能进行二次嵌入，lsb被替换
%                 remind_bit=str2double(remind_bit);
%                 lsbs(i,j*2-1)=remind_bit; 
%                 en_locate(i,j)=bin2dec(lobit);
%             end
%         end
%     end
%     end
% end

% emb_I=de_R;
% for i=1:1:x
%    for j=1:1:y
%        s=S(i,j);
%        lo=en_locate(i,j);
%        group=rank_opposite(lo,s);
%        emb_I(i,j*2-1)=group(1);
%        emb_I(i,j*2)=group(2);
%    end
% end
% emb_I=emb_I*2;
% emb_I=emb_I+lsbs;
% emb_I=uint8(emb_I);