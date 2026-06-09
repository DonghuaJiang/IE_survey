function [C0] = CoFuZadu(x,r)
% 函数名称：C0FuZaDu
% 函数功能：计算序列的C0复杂度
% 输入参数：x:为混沌序列，r为容限度
% 输出参数：C0为输出的混沌序列复杂度
    Y = fft(x);
    Gn = mean(abs(Y).^2);
    YY = zeros(1,length(x));
    for i = 1:length(x)
       if abs(Y(i))^2 > r*Gn
           YY(i) = Y(i);
       end
    end
    xx = ifft(YY);
    Ssum = 0;
    for i = 1:length(x)
        Ssum = Ssum+(xx(i)-x(i))^2;
    end
    C0 = Ssum/sum(x.^2);
end

