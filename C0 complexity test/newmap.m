function [ov] = newmap(len,Iv,a,b)
% 新构建的三维混沌映射，len：生成混沌序列的长度，Iv：混沌映射的初始状态
    cx = zeros(1,len); cy = zeros(1,len); cz = zeros(1,len); 
    cx(1) = Iv(1); cy(1) = Iv(2); cz(1) = Iv(3);
    for j = 1 : len+100-1
        cx(j+1) = cos(a*cx(j))*sin(1/(cy(j)*(1-cy(j))^2));
        cy(j+1) = cos(cx(j)*cy(j)+b*cz(j));
        cz(j+1) = cx(j);
    end
    ov = [cx(101:end);cy(101:end);cz(101:end)];
end