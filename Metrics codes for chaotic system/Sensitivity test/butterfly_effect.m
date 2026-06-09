clear
clear global
global sigma rho beta


sigma=10;
rho=28;
beta=8/3;

dt=0.001; %set time step for saving the time series
% options = odeset('RelTol',1e-4); %tolerance options


for i=1:10
    % choose random initial conditions very close to zero
    x0=10^(-12)*rand(1,3);
    
    [t,x]=ode45(@lorenz,0:dt:50,x0); % or use: ...x0,options)


    % Plot the solution with respect to time, including transient behavior
    figure(3)
    subplot(3,1,1)
    plot(t,x(:,1))
    hold all
    xlabel('t')
    ylabel('x_1')
    set(gca,'fontsize',12)
    set(gca,'fontweight','bold')
    box on

    subplot(3,1,2)
    plot(t,x(:,2))
    hold all
    xlabel('t')
    ylabel('x_2')
    set(gca,'fontsize',12)
    set(gca,'fontweight','bold')
    box on

    subplot(3,1,3)
    plot(t,x(:,3))
    hold all
    xlabel('t')
    ylabel('x_3')
    set(gca,'fontsize',12)
    set(gca,'fontweight','bold')
    box on

    figure(2)
    % the command [1 3 5] joins together the left column of the subplot!
    subplot(3,2,[1 3 5])
    hold all
    plot3(x(:,1),x(:,2),x(:,3))
    plot3(x(end,1),x(end,2),x(end,3),'k*','MarkerSize',8)
    view(3) %default view angles
    grid on
    xlabel('x_1')
    ylabel('x_2')
    zlabel('x_3')
    set(gca,'fontsize',12)
    set(gca,'fontweight','bold')
    box on


    subplot(3,2,2)
    hold all
    plot(x(:,1),x(:,2))
    grid on
    xlabel('x_1')
    ylabel('x_2')
    box on
    set(gca,'fontsize',12)
    set(gca,'fontweight','bold')

    subplot(3,2,4)
    hold all
    plot(x(:,2),x(:,3))
    box on
    grid on
    xlabel('x_2')
    ylabel('x_3')
    set(gca,'fontsize',12)
    set(gca,'fontweight','bold')

    subplot(3,2,6)
    hold all
    plot(x(:,1),x(:,3))
    grid on
    xlabel('x_1')
    ylabel('x_3')
    set(gca,'fontsize',12)
    set(gca,'fontweight','bold')
    box on

end