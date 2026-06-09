%加密

function after_I=Encryption(R,dimen,key)
[lsbs,de_R]=Vancant_room(R);%分割图像：de_R=图像的高7位，lsbs图像的最低有效位
S=pix_sum(de_R);%和矩阵
zone=Zone_num(S);%域数量矩阵（高七位的域函数）
cap=pix_Cap(zone);%容量矩阵
exp=pix_Exp(zone);%表示位数的矩阵，即一个位置信息需要多少位bit来表示
locate=pix_locate(de_R,zone,S);%位置矩阵，确定像素组在域中所在的位置
[en_locate,en_lsbs]=En_locate(cap,exp,zone,locate,lsbs,key);%编码后的位置矩阵
after_I=en_I(de_R,S,en_locate,en_lsbs);%由位置矩阵恢复图像
after_I=P_box(after_I,dimen,key);%置乱加密