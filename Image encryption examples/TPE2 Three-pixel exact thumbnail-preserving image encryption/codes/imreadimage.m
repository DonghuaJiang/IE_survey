file_path =  'G:\paper-ruoyu\HF-TPE\code2\helen_1\';% 图像文件夹路径  
img_path_list = dir(strcat(file_path,'*.png'));%获取该文件夹中所有png格式的图像 
img_num = length(img_path_list);%获取图像总数量 
I=cell(1,img_num);
for i=3:1:6
dimen=2^i;%8,16,32,64
key=dimen;
en_pathname=strcat(file_path,['en_','dimen_',num2str(dimen),'\']);
re_pathname=strcat(file_path,['re_','dimen_',num2str(dimen),'\']);
if img_num > 0 %有满足条件的图像  
        for j = 1:img_num %逐一读取图像  
            image_name = img_path_list(j).name;% 图像名  
            image =  imread(strcat(file_path,image_name));  
            I{j}=image;
            R=I{j}(:,:,1);
            G=I{j}(:,:,2);
            B=I{j}(:,:,3);

            after_R=Encryption(R,dimen,key);
            after_G=Encryption(G,dimen,key);
            after_B=Encryption(B,dimen,key);
            after_I=cat(3,after_R,after_G,after_B);
            en_pathfile=[en_pathname image_name];
            imwrite(pic,en_pathfile,'png');
            
            
            re_R=Decryption(after_R,dimen,key);
            re_G=Decryption(after_G,dimen,key);
            re_B=Decryption(after_B,dimen,key);
            re_I=cat(3,re_R,re_G,re_B);
            re_pathfile=[re_pathname image_name];
            imwrite(pic,re_pathfile,'png');
%            fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));% 显示正在处理的图像名  

            %图像处理过程 省略  

            %这里直接可以访问细胞元数据的方式访问数据
        end  
end  

end