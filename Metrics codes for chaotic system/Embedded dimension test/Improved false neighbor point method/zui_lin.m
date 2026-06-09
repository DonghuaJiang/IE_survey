% 寻找最近邻点，并计算，E[m]
% 作者：张海龙
% 时间：2011年4月5日
function  E = zui_lin(data,m,tau)
% data：输入时间序列
% m：嵌入维数
% tau：延迟时间
    N = length(data);
    data_m = reconstitution(data,N,m,tau);
    data_m2 = reconstitution(data,N,m+1,tau);
    guiyi_dianshu = size(data_m2,1);
    data_m1 = data_m(1:guiyi_dianshu,:);
    zuijin_m1 = zuijin(data_m1);
    zuijin_m2 = zuijin(data_m2);
    E_temp = zuijin_m2./zuijin_m1;
    E = mean(E_temp);
end

function  zuiduan_juli=zuijin(data)
    dianshu = size(data,1);
    juli = zeros(dianshu,dianshu);
    for i = 1:1:dianshu
        for j = 1:dianshu
            if i == j
                juli(i,j) = inf;
            else
                juli(i,j) = norm(data(i,:)-data(j,:));
            end
        end
    end
    zuiduan_juli = zeros(dianshu,1);
    for i = 1:dianshu
        zuiduan_juli(i) = min(juli(i,:));
    end
end