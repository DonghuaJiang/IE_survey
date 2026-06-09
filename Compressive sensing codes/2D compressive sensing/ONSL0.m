function xr = ONSL0(y,A,A_pinv)
% ONSL0稀疏重构算法
% NSL0的优化版
% 输入: y:测量值向量 A:测量矩阵 A_pinv:A的广义逆
% 输出: xr:重构信号

    %%%%%%%%%%%%%%%%% 算法参数初始化 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x = A_pinv*y;                                          %  设定初始点
    beta = 0.8;                                            %  sigma的衰减因子
    sigma = 2*max(abs(x));                                 %  光滑函数的初始参数
    sigma_min = 0.01;                                      %  算法终止的界限
    L_max = 2;                                             %  内部循环最大迭代次数
    e = 7.5e-013;                                          %  内部循环终止的条件
    %%%%%%%%%%%%%%%%% 算法主要步骤 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while sigma > sigma_min
        r0 = 0;
        cn = 0;
        d = -((sigma^2).*x)./((sigma^2)+(x.^2));           %  计算修正牛顿方向
        x = x+d;                                           %  更新x
        x = x-A_pinv*(A*x-y);                              %  梯度投影到解空间
        r = y-A*x;
        while cn < L_max && norm(r-r0) > e
            cn = cn+1;
            r0 = r;
            d = -((sigma^2).*x)./((sigma^2)+(x.^2));       %  计算修正牛顿方向
            x = x+d;                                       %  更新x
            x = x-A_pinv*(A*x-y);                          %  梯度投影到解空间
            r = y-A*x;
        end
        sigma = sigma*beta;
    end
    xr = x;
end   
