%原r

function re_r=Decry_r(en_r,num,key)
rng(key);
t_arry=randperm(num);%生成的随机序列，是从1到num不重复的序列
for i=1:1:num
    if t_arry(i)==en_r
       re_r=i;
       return;
    end
end
