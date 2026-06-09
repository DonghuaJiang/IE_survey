%对块进行解密

function re_b=decryption_block(dimen,block,key)
num=dimen^2;%块中像素的数量
group_num=num/3;%像素组的数量
line=blo2line(block);%把块以行顺序换成一行
after_line=line;
for i=1:1:group_num
    begin_group=(i-1)*3+1;
    end_group=i*3;
    group=line(begin_group:end_group);%像素组 
    re_group=Decry_group(group,key);%原像素组
    after_line(begin_group:end_group)=re_group;
end
t_block=reshape(after_line,dimen,dimen);%将元素重新变成一块，以列的顺序进行
re_b=t_block';%将块转置