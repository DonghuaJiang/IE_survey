% 利用庞加莱截面绘制杜芬系统的分岔图

clc
clear
close all

h = 8e-3;                                                                  % 第一步，计算出轨迹
x0 = 0:h:1600;
y0 = [0.1;0.1];                                                            % 最后一项是cos(w*t)，当t=0时必须为1.
d = 0.5:0.002:1.5;
N_c = length(d);
N_P = 250;                                                                 % 假设穿过截面的共有250个点
BF = nan(N_c,N_P);
tP_Ideal = 3*pi/2:(2*pi/1):x0(end);                                        % 第二步，这里直接用频闪法求出截面所在点的索引;这里考虑z=0平面，时间间隔dt=2*pi。
tP_List = zeros(1,length(tP_Ideal));
Ind_List = zeros(1,length(tP_Ideal));
for m = 1:length(tP_Ideal)
    [~,Ind] = min(abs( tP_Ideal(m)-x0 ));
    Ind_List(m) = Ind;
    tP_List(m) = x0(Ind);
end
for k = 1:N_c                                                              % 第三步，开始对每一个d进行循环，计算其庞加莱截面
    d_k = d(k);
    [y1,~] = ODE_RK4_hyh(x0,h,y0,[d_k,1,1]);
    yP_List = y1(:,Ind_List);
    N_P_temp = size(tP_List,2);                                            % 储存
    if N_P_temp > N_P
        BF(k,1:N_P) = yP_List(2,1:N_P);                                    % 取坐标y作为分岔图
    else
        BF(k,1:N_P_temp) = yP_List(2,1:N_P_temp);                          % 取坐标y作为分岔图
    end
end
figure(1); hold on;                                                        % 最后一步，绘图
for k = 1:N_c
    d_k = d(k);
    plot(d_k*ones(1,N_P-30+1),BF(k,30:N_P),...
        'LineStyle','none','Marker','.','MarkerFaceColor','k','MarkerEdgeColor','k',...
        'MarkerSize',1)
end
hold off;

function [F,Output] = Fdydx(x,y,Input)
% 形式为Y'=F(x,Y)的方程，参见数值分析求解常系数微分方程相关知识
% 高次用列向量表示，F=[dy(1);dy(2)];y(1)为函数，y(2)为函数导数
    d = Input(1);
    r = Input(2);
    w = Input(3);
    dy(1) = y(2);
    dy(2) = -y(1)^3+y(1)-d*y(2)+r*cos(w*x);
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
        y(:,ii+1)=yn+h/6*(K1+2*K2+2*K3+K4);
    end
    Output = [];
end