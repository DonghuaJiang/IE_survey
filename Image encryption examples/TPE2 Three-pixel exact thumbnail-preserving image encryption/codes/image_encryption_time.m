%一百张图像的加密时间

en_file_path =  'G:\数据集\helen\helen_2_change\';% 图像文件夹路径 
dimen=32;
% for i=3:1:4
%    thumb=2^(i+5); 
%    eval(['TPE2encrypt_time_',num2str(thumb), '=', 'zeros(1,100)', ';']);
%    eval(['TPE2decrypt_time_',num2str(thumb), '=', 'zeros(1,100)', ';']);
% end
encrypt_time_martix=zeros(1,100);
decrypt_time_martix=zeros(1,100);
for i=3:1:3%缩略图选择
   thumb=2^(i+5); 
   key=thumb;
   en_img_path_list = dir(strcat(en_file_path,'*.png'));%获取密文图像
       for z=16:1:100
          en_image_name=en_img_path_list(z).name;% 密文图像名  
          en_image =  imread(strcat(en_file_path,en_image_name)); %密文图像名+路径
          im_en = imresize(en_image, [thumb thumb]);%密文缩略图
          t1=clock;
          after_I=encryption_image(im_en,key,dimen);
          t2=clock;
          t3=clock;
          de_I=decryption_image(after_I,key,dimen);
          t4=clock;
          encrypt_time_martix(1,z)=etime(t2,t1)
          decrypt_time_martix(1,z)=etime(t4,t3)
          eval(['TPE2decrypt_time_',num2str(thumb), '=', 'decrypt_time_martix', ';']);
          eval(['TPE2encrypt_time_',num2str(thumb), '=', 'encrypt_time_martix', ';']);
          save(['TPE2decrypt_time_',num2str(thumb)],['TPE2decrypt_time_',num2str(thumb)]);
          save(['TPE2encrypt_time_',num2str(thumb)],['TPE2encrypt_time_',num2str(thumb)]);
       end
      
end