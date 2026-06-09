% 杜芬方程的庞加莱截面
% 截面采用公式Ax+By+Cz+D=0;的形式
 
clc
clear
close all

% 第一步，计算出轨迹
h = 5e-3;
x0 = 0:h:1600;
y0 = [0.1;0.1;1];                                                          % 最后一项是cos(w*t)，当t=0时必须为1.
[y1,Output] = ODE_RK4_hyh(x0,h,y0,[1.15,1,1]);
%[1.5,1,1],[1.35,1,1],[1.15,1,1]
Lx = y1(1,2000:end); Ly = y1(2,2000:end); Lz = y1(3,2000:end);
% 第二步，计算与平面的交点
Plane = [0;0;1;0];                                                         % 一般情况下是个垂直某个轴的平面。这里是Ax+By+Cz+D=0的形式给出的平面。
[tP_List,yP_List] = Solve_Poincare(x0,y1,Plane);                           % 计算Poincare平面

% 第三步，绘制庞加莱截面
% 庞加莱截面，最开始几个点还没有稳定，没有体现出系统特点，所以放弃
figure(1);
plot(yP_List(1,10:end),yP_List(2,10:end),'.')                              % 从第10个点之后开始绘制
xlim([-1,0.6]); ylim([-0.8,0.2]);
% 展示用的示意图，只作为演示
figure(2); hold on;
patch([Lx,nan],[Ly,nan],[Lz,nan],[Lx+Ly,nan],...
      'EdgeColor','interp','Marker','none','MarkerFaceColor','flat','LineWidth',0.8,'FaceAlpha',1);
plot3(yP_List(1,10:end),yP_List(2,10:end),zeros(size(yP_List(2,10:end))),...
      '.','MarkerSize',8,'color','r')
patch([-1.6,0.4,0.4,-1.6],[-0.7,-0.7,0.0,0.6],[0,0,0,0],[1,1,1,1],...
      'FaceAlpha',0.8,'EdgeColor',[0.5,0.5,0.5]) 
view([-17,39]); box on; grid on;
% 绘制投影的相图
set(gcf,'position',[300 200 560 500]);
xlim([-2,2]); zlim([-3,1]);
plot3( Lx,Ly,zeros(size(Ly))-3 ,'color','k');
hold off;

%% 后置函数
function [tP_List,yP_List] = Solve_Poincare(t,y,Plane)
% 截面方程z=0
% Plane=[0;0;1;0];%一般情况下是个垂直某个轴的平面
% 一般只记录从负到正穿越。如果想反向也记录，可以设置Plane=-Plane。
    % 第二步，插值得到线与面的交点
    yP_List = [];
    tP_List = [];
    Dis = DistancePlane(y,Plane);
    N = size(y,2);
    for k = 1:N-1
        if Dis(k) <= 0 && Dis(k+1) > 0
            t0 = t(k); t1 = t(k+1);
            yP0 = y(:,k); yP1 = y(:,k+1);
            Dis0 = Dis(k); Dis1 = Dis(k+1);
            % 一维线性插值，求Dis=0时的t和y
            %（相比较前面积分的4阶RK，这里用线性插值精度有点低，先这么凑合着吧）
            yP = yP0+(yP1-yP0)/(Dis1-Dis0)*(0-Dis0);
            tP = t0+(t1-t0)/(Dis1-Dis0)*(0-Dis0);
            % 储存
            yP_List = [yP_List,yP];
            tP_List = [tP_List,tP];
        end
    end
end

% 点到平面的距离
function Dis = DistancePlane(xk,Plane)
% xk，坐标点，如果是3维坐标，大小就是3*N的矩阵。
% Plane，平面，形如Ax+By+Cz+D=0形式的平面。
    N = size(xk,2);%计算总共多少个点
    xk2 = [xk;ones(1,N)];
    Dis = dot(xk2,Plane*ones(1,N),1)./norm(Plane(1:end-1));
end

%两点线性插值
function y = interp2point_linear(x0,x1,y0,y1,x)
    y = y0+(y1-y0)/(x1-x0)*(x-x0);
end

% 两点3次插值
function y = interp2point_spline(x0,x1,y0,y1,x)
%y0包含y0的值和y0的导数,yy=y0(1),dy=y0(2)
    xx0 = x0; xx1 = x1;
    yy0 = y0(1); dy0 = y0(2);
    yy1 = y1(1); dy1 = y1(2);
    cs = csape([xx0,xx1],[dy0,yy0,yy1,dy1],[1,1]);
    y = ppval(cs,x);
end

function [F,Output] = Fdydx(x,y,Input)
% 形式为Y'=F(x,Y)的方程，参见数值分析求解常系数微分方程相关知识
% 高次用列向量表示，F=[dy(1);dy(2)];y(1)为函数，y(2)为函数导数
% 杜芬方程duffing，参见中国大学MOOC，北京师范大学-计算物理基础-77倒摆与杜芬方程
    d = Input(1); r = Input(2); w = Input(3);
    dy(1) = y(2);
    dy(2) = -y(1)^3+y(1)-d*y(2)+r*y(3);
    dy(3) = -w*sin(w*x);
    F = [dy(1);dy(2);dy(3)];
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