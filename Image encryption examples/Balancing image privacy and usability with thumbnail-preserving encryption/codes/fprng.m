function X = fprng(x,n)%伪随机数生成函数，输入：参数x为double矩阵，序列长度n。输出：1-n不重复的伪随机序列
a = java.security.MessageDigest.getInstance('MD5'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%初始值生成部分
a.update(x);
strMD5 = sprintf('%02X',typecast(a.digest,'uint8'));%MD5算法生成128哈希值，返回16进制表示的字符串（长度为128/4=32）
a = strMD5(1:16);%取前16个字符
b = strMD5(17:32);%取后16个字符
a=hex2dec(a);%转换为十进制double类型
b=hex2dec(b);
x0 = a/b;%%%%%%得到取值为0-1之间的小数
if x0>1
    x0=1/x0;%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%伪随机数生成部分
n = n + 500;
X(1) = x0;
for i=2:n
    x_next = 4*x0*(1-x0);%logistic混沌系统
    X(i) = x_next;
    x0 = x_next;
end
X = X(501:n);%舍弃前500个数
[ignore,X] = sort(X);%对X排序，并输出索引值
end