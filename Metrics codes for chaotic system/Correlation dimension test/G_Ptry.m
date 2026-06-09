function [ln_r,ln_C] = G_Ptry(data,N,tau,ss)
% 这是计算关联维数的G－P算法
% data: 时间序列
% N: 时间序列长度
% tau: 重构相空间时的时间延迟
% 原本的程序存在最大m与最小m，是为了显示出lnr,lnc的图像随嵌入维数的变化情况，我们这里的嵌入维数是给定的，不需要这个过程。
% ss: 这个数据用于计算r的步长
    m = 2;
    Y = reconstitution(data,N,m,tau);                                      % 给了N，m以及tau可以用来重构相空间
    M = N-(m-1)*tau;                                                       % M代表的是重构的相空间中的向量个数
    for i = 1:M-1                                                          % 计算状态空间中所有点每两点之间的距离，存储在d(i,j)矩阵里
        for j = i+1:M
            d(i,j) = max(abs(Y(:,i)-Y(:,j)));         
        end                                  
    end
    max_d = max(max(d));                                                   % 得到所有点之间的最大距离
    d(1,1) = max_d;
    min_d = min(min(d));                                                   % 得到所有点间的最短距离
    delt = (max_d-min_d)/ss;                                               % 计算得到r的步长
    for k = 1:ss                                                           % 计算lnr和lnC的值
        r = min_d+k*delt;
        C(k) = correlation_integral(Y,M,r);                                % 用来计算相关积分C(r)
        ln_C(1,k) = log(C(k));                                             % 计算lnC(r)
        ln_r(1,k) = log(r);                                                % 计算lnr，他俩都是一行20列的
    end
end
% fid = fopen('lnr.txt','w');                                                % 后面的代码应该是为了生成lnr和lnC的两个TXT文件记录数据
% fprintf(fid,'%6.2f %6.2f\n',ln_r);
% fclose(fid);
% fid = fopen('lnC.txt','w');
% fprintf(fid,'%6.2f %6.2f\n',ln_C);
% fclose(fid);