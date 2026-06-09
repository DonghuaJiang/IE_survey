%对块进行处理
%dimen=维度，block=处理的块，key=密钥
function after_block=process_block(dimen,block,key)
num=dimen^2;%块中像素的数量
group_num=num/3;%像素组的数量
line=blo2line(block);%把块以行顺序换成一行
after_line=line;
for i=1:1:group_num
   begin_line=(i-1)*3+1;%像素组开始的地方 
   end_line=i*3;
   group=line(begin_line:end_line);%像素组
   after_group=Encry_group(group,key);%加密像素组
   after_line(begin_line:end_line)=after_group;
end
t_block=reshape(after_line,dimen,dimen);%将元素重新变成一块，以列的顺序进行
after_block=t_block';%将块转置