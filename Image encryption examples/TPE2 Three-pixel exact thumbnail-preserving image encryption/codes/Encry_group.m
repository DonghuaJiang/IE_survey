%加密像素组

function  after_group=Encry_group(group,key)
s=sum(sum(group(:)));%像素组之和
num=group_num(s);%具有相同和的像素组数量
r=rank(group);
rng(key);
t_arry=randperm(num);%生成的随机序列，是从1到num不重复的序列
en_r=t_arry(r);%密文r
after_group=rank_opposite(en_r,s);