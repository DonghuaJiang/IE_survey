% 计算混沌序列关联维数的MATLAB程序，利用三线法拟合求斜率，可以画出关联维数随参数变化的曲线
clc
clear
close all

XX = [];
for a = 0:0.1:1
    for q = 1:1000                                  % q是计数用的，迭代一次就加一
        xn(1) = 0.1;
        xn(q+1) = 4*a*xn(q)*(1-xn(q));              % 迭代计算下一个值，xn(1)进去就得到xn(2),然后循环到xn(q)=x，记录下数据后接着循环
    end
    data = xn;
    N = length(data);
    [ln_r,ln_C] = G_Ptry(data,N,3,15);
    D = three_line(15,3,ln_C,ln_r);
    XX = [XX;D];
end
XXX = XX';
plot(0:0.1:1,XXX,'-rs');