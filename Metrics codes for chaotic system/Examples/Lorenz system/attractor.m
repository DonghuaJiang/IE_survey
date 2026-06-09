% Lorenz系统的吸引子图

clc
clear
close all

% 第一步，计算出轨迹
h = 5e-3;
x0 = 0:h:50;
y0 = [0.1;0.1;1];
alpha = 16; beta = 45.92; gamma = 4;
[y1,Output] = ODE_RK4_hyh(x0,h,y0,[alpha,beta,gamma]);
Lx = y1(1,2000:end); Ly = y1(2,2000:end); Lz = y1(3,2000:end);
figure(1); hold on;
patch([Lx,nan],[Ly,nan],[Lz,nan],[Lx+Ly,nan],...
      'EdgeColor','interp','Marker','none','MarkerFaceColor','flat','LineWidth',0.8,'FaceAlpha',1);
view([-17,39]); box on; 
xlabel('\it x','fontsize',20,'fontname','Times New Roman'); 
ylabel('\it y','fontsize',20,'fontname','Times New Roman'); 
zlabel('\it z','fontsize',20,'fontname','Times New Roman');

%% 后置函数
function [F,Output] = Fdydx(y,Input)
% 形式为Y'=F(x,Y)的方程，参见数值分析求解常系数微分方程相关知识
% 高次用列向量表示，F=[dy(1);dy(2)];y(1)为函数，y(2)为函数导数
    alpha = Input(1); beta = Input(2); gamma = Input(3);
    dy(1) = alpha*(y(2)-y(1));
    dy(2) = beta*y(1)-y(2)-y(1)*y(3);
    dy(3) = y(1)*y(2)-gamma*y(3);
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
        [K1,~] = Fdydx(yn,Input);
        [K2,~] = Fdydx(yn+h/2*K1,Input);
        [K3,~] = Fdydx(yn+h/2*K2,Input);
        [K4,~] = Fdydx(yn+h*K3,Input);
        y(:,ii+1) = yn+h/6*(K1+2*K2+2*K3+K4);
    end
    Output = [];
end