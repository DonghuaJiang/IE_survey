% The following code can be used to plot the graph of the mean value of any
% chaotic map, with respect to 2 of its parameters.

% In the example below, we are using the skewed tent map. 
% But it can be replaced by any map of your choice, given that the
% map has at least two parameters.

% Note, the following code plots the mean value for all parameter values in
% the chosen interval, regardless of the behavior of the map, chaotic or
% periodic. If you want to plot the mean value for just the chaotic
% parametric regions, you should first check the LE of the map for each
% parameter pair, and then plot its mean.


% set initial condition
x(1)=rand;

% set stepsize of the iteration for the parameter interval
stepsize=0.0025;

% chose the parameter intervals of interest
b_interval=0:stepsize:1;
a_interval=0:stepsize:1;
%This map has 3 parameters, the 3rd is set to 0
c=0;

%these are index variables for saving the mean value of the map in a
%matrix.
cols=0;
rows=0;
M=[];

for b=b_interval
    b % you can print b just to see the progress of the algorithm
    cols=cols+1;
    rows=0;
    for a=a_interval
        rows=rows+1;
        for i=2:10^5+500 % you can increase the number of iterations if you like
            if x(i-1)<=b
                x(i)=(1-a)/b*x(i-1)+a;
            else
                x(i)=(1-c)/(b-1)*x(i-1)+(b*c-1)/(b-1);
            end
        end
        % save the mean value in a matrix. The first 500 values are discarded as the
        % transient part of the time series.
        M(rows,cols)=mean(x(501:end));
    end
end


figure
hold all
[B,A] = meshgrid(b_interval,a_interval);

surf(B,A,M,'EdgeColor','none')

% the lines below fix the view to vertical, the colorbar, and the axes fonts
% you can also rotate the graph and show it as a surface in 3D
% you can use the caxis(limits) command, to fix the colorbar limits, for
% example caxis([0.2,1]), but use this command only after observing the
% graph in the default settings.
view([0,90])
colo=colorbar;
colo.Label.String = 'Mean Value';

xlabel('$b$','Interpreter','latex')
ylabel('$a$','Interpreter','latex')

set(gca,'fontsize',12)
set(gca,'fontweight','bold')
box on
grid off