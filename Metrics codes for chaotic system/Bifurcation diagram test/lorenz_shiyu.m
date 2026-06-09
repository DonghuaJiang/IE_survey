%2011年3月25日
%三维lorenz系统，时域系统，标准的微分方程形式
function dX=lorenz_shiyu(t,X)
global delt r b;
%
%
%
x=X(1);y=X(2);z=X(3);

%初始化
dX=zeros(3,1);
%lorenz系统方程
dX(1)=-delt*(x-y);
dX(2)=-x*z+r*x-y;
dX(3)=x*y-b*z;
