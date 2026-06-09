I=imread('mugshot.png');
% dimen=16;
key=1;
round=1;

R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
for i=1:1:5
    dimen=2^(i+2);
    after_R=Encryption(dimen,R,key);
    after_G=Encryption(dimen,G,key);
    after_B=Encryption(dimen,B,key);
    after_I=cat(3,after_R,after_G,after_B);
    imwrite(after_I,['mugshot_dimen',num2str(dimen),'.png']);
end
% imshow(after_I);
% [x,y]=size(R);
% dimen_x=x/dimen;
% dimen_y=y/dimen;
% after_R=R;
% for i=1:1:dimen_x
%    for j=1:1:dimen_y
%         begin_x=dimen*(i-1)+1;
%         end_x=dimen*i;
%         begin_y=dimen*(j-1)+1;
%         end_y=dimen*j;
%         block=R(begin_x:end_x,begin_y:end_y);%把块截取出 
%         after_b=process_block(dimen,block,key);%对块中像素组置换加密
%         after_R(begin_x:end_x,begin_y:end_y)=after_b;%加密后的块放入图像中
%    end
% end



%%%%%解密
% re_R=Decryption(dimen,after_R,key);
% re_G=Decryption(dimen,after_G,key);
% re_B=Decryption(dimen,after_B,key);
% re_I=cat(3,re_R,re_G,re_B);


%  de_R=De_I(after_R,dimen,key);%置乱解密
%  re_R=de_R;
%    for i=1:1:dimen_x%对块进行处理
%       for j=1:1:dimen_y
%             begin_x=dimen*(i-1)+1;
%             end_x=dimen*i;
%             begin_y=dimen*(j-1)+1;
%             end_y=dimen*j;
%             block=de_R(begin_x:end_x,begin_y:end_y);%把块截取出
%             re_b=decryption_block(dimen,block,key);%对块进行解密
%             re_R(begin_x:end_x,begin_y:end_y)=re_b;%加密后的块放入图像中
%       end
%    end