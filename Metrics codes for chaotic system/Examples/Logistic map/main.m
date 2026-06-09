clc
clear 
close all

%% Logistic系统分岔图
d = 0.002;
x = d:d:1-d;
a = 0:0.002:4;
Nx = length(x);
Na = length(a);
BF = zeros(Na,Nx);
for k = 1:Na
    a_k = a(k);
    x1 = x;
    for m = 1:250                                                          % 在系统中迭代250次
        x1 = Logistic(x1,a_k);
    end
    BF(k,:) = x1;                                                          % 把结果保存
end
BF_C = zeros(size(BF));                                                    % 上颜色
for k = 1:Na
    BF_k = BF(k,:);
    [N,~,bin] = histcounts(BF_k,[0:0.01:1]);                               % 统计每个小区间，点的数量，作为颜色
    BF_C(k,:) = N(bin);                                                    % 记录各个点的颜色
end
BFy = BF;
BFx = a'*ones(1,Nx);
figure(1);
scatter(BFx(:),BFy(:),0.5,BF_C(:),'MarkerEdgeAlpha',0.5)
caxis([0,20]);
colormap(jet);
ylim([0,1]); xlim([2,4]);

%% 后置函数
function x2 = Logistic(x1,a)
% Logistic系统
% x(n+1) = a*(1-x(n))*x(n)
    x2 = a*(1-x1).*x1;
end