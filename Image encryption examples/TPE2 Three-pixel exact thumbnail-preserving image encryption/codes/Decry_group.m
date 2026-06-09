%像素组解密

function re_group=Decry_group(group,key)
s=sum(sum(group(:)));
num=group_num(s);%具有相同和的像素组数量
r=rank(group);
re_r=Decry_r(r,num,key);
re_group=rank_opposite(re_r,s);