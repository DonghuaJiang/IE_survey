%解密

function re_I=Decryption(after_I,dimen,key)
de_R=De_I(after_I,dimen,key);%置乱解密
 [re_lsbs,re_R]=Vancant_room(de_R);%最低有效位，和前七位矩阵
 re_S=pix_sum(re_R);%前七位之和
 re_zone=Zone_num(re_S);%域数量矩阵
 re_cap=pix_Cap(re_zone);%容量矩阵
 re_exp=pix_Exp(re_zone);%表示位数矩阵
 re_locate=Re_locate(re_zone,re_cap,re_exp,re_R,re_lsbs,re_S,key);%恢复位置矩阵
 re_I=en_I(re_R,re_S,re_locate,re_lsbs);