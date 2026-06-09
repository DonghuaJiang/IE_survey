% 杜芬方程的庞佳莱截面（频闪法）

clc
clear
close all

% 第一步，计算出轨迹
h = 5e-3;
x0 = 0:h:1600;
y0 = [0.1;0.1];                                                            % 这里简化了方程，所以只有两个输入
[y1,Output] = ODE_RK4_hyh(x0,h,y0,[1.15,1,1]);
%[1.5,1,1],[1.35,1,1],[1.15,1,1],[0.1,0.35,1.4]
Lx = y1(1,:);
Ly = y1(2,:);
% Lz=cos(1*x0);

% 采用频闪采样法计算
tP_Ideal = 3*pi/2:(2*pi/1):x0(end);                                        % 这里考虑z=0平面，时间间隔dt=2*pi。
tP_List = zeros(1,length(tP_Ideal));
Ind_List = zeros(1,length(tP_Ideal));
for k = 1:length(tP_Ideal)
    [~,Ind] = min(abs( tP_Ideal(k)-x0 ));                                  % 直接根据索引来找到对应的点
    Ind_List(k) = Ind;
    tP_List(k) = x0(Ind);
end
yP_List=y1(:,Ind_List);
% 注，如果上面时间间隔h为pi/600之类的形式，这里连min函数都可以取消，直接按照索引去寻找就行

% 绘图
% 庞加莱截面
% 最开始几个点还没有稳定，没有体现出系统特点，所以放弃
figure(1)
plot(yP_List(1,10:end),yP_List(2,10:end),'.')
xlim([-1,0.6]);
ylim([-0.8,0.2]);

function [F,Output] = Fdydx(x,y,Input)
% 形式为Y'=F(x,Y)的方程，参见数值分析求解常系数微分方程相关知识
% 高次用列向量表示，F=[dy(1);dy(2)];y(1)为函数，y(2)为函数导数
    d = Input(1);
    r = Input(2);
    w = Input(3);
    dy(1) = y(2);
    dy(2) = -y(1)^3+y(1)-d*y(2)+r*cos(w*x);
    % dy(3)=-w*sin(w*x);%由于无需计算具体的z值，所以这里把z合并到了dy(2)项里，减少计算量
    F = [dy(1);dy(2)];
    Output = [];
end

function [y,Output] = ODE_RK4_hyh(x,h,y0,Input)
% 4阶RK方法
% h间隔为常数的算法
    y = zeros(size(y0,1),size(x,2));
    y(:,1) = y0;
    for ii = 1:length(x)-1
        yn = y(:,ii);
        xn = x(ii);
        [K1,~] = Fdydx(xn    ,yn       ,Input);
        [K2,~] = Fdydx(xn+h/2,yn+h/2*K1,Input);
        [K3,~] = Fdydx(xn+h/2,yn+h/2*K2,Input);
        [K4,~] = Fdydx(xn+h  ,yn+h*K3  ,Input);
        y(:,ii+1) = yn+h/6*(K1+2*K2+2*K3+K4);
    end
    Output = [];
end
