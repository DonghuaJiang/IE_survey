function chaoSequence = SequenceGenerator( n,r,x,y )
% 混沌序列生成
% n       序列总长度
% r       混沌系统参数
% x,y     混沌系统初值
format long eng

chaoSequence = zeros(2,n);

chaoSequence(1,1) = x;
chaoSequence(2,1) = y;
for i=2:n
    chaoSequence(1,i) = sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y)));
    chaoSequence(2,i) = sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x)));
    x = chaoSequence(1,i);
    y = chaoSequence(2,i);
end
end

