% 伪虚假邻点法(cao法）
% 该方法只依赖一个参数，Tau，且用较少的数据量即可
% 作者：张海龙
% 时间：2011年4月5日
function m = cao(data,min_m,max_m,tau)
% data: 混沌时间序列
% min_m: 最小嵌入维
% max_m: 最大嵌入维
% tau: 求出的时间延迟
% m: 得到的嵌入维数
    E_m = zeros(1,15);
    for i = min_m:max_m
        E_m(i) = zui_lin(data,i,tau);
    end
    m = E_m(end);
end