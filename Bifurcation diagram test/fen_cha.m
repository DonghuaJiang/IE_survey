%计算lorenz系统分岔图，采用ode45变步长
%2011年3月26日晨
global delt r b; 
delt=10;
b=8/3;
r_test=[0:1:500];
data_x=[];
data_y=[];
data_z=[];
tau1=[];
tau2=[];
tau3=[];
t0=[0 100];
tic
for i=1:length(r_test)
    r=r_test(i)  %r的变化精度
    [t,y]=ode45(@lorenz_shiyu,t0,[1,1,1]);
    [Xmax]=getmax(y(:,1));
    plot(r,Xmax,'b','markersize',1)
    hold on
    clear Xmax
end
xlabel('r');
ylabel('x');
toc


