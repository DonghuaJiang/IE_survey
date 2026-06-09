global delt r b; 
delt=10;
b=8/3;
r=28
lya_pu=[];

tic
x0=-8.484;y0=-8.484;z0=-27;
sim('lorenz_sim.mdl',90)

data_x=x(3000:end);
data_y=y(3000:end);
data_z=z(3000:end);

% figure
% plot(t(3000:end),data_x);
% xlabel('t')
% ylabel('x')
% 
% figure
% plot(t(3000:end),data_y);
% xlabel('t')
% ylabel('y')
% 
% figure
% plot(t(3000:end),data_z);
% xlabel('t')
% ylabel('z')
% 
% figure
% plot(data_x,data_y);
% xlabel('x')
% ylabel('y')
% 
% figure
% plot(data_x,data_z);
% xlabel('x')
% ylabel('z')
% 
% figure
% plot(data_z,data_y);
% xlabel('z')
% ylabel('y')

figure
plot3(data_x(5800:6000),data_y(5800:6000),data_z(5800:6000));
xlabel('x')
ylabel('y')
zlabel('z')