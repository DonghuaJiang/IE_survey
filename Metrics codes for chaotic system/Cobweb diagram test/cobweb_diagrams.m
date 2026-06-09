% The following code computes the cobweb diagram of several types of maps
% the code is edited so tha the diagrams can look their best way, so that
% you can use them in research papers

%Be careful on how you define the function plot, the domain of
%interest, and the axes limits.

% The code can be easily adapted for any chaotic map

% you can run each part of the code using ctrl+Enter, or by choosing 'run
% section' from the menu


%% Logistic map
clear
x(1)=0.1;
k=4;

%plot the map's function
interval=0:0.001:1;
func=k.*interval.*(1-interval);
plot(interval,func,'k','LineWidth',1)
hold on

%now plot the cobweb plot
plot([0,1],[0,1],'k--')

plot([x(1),x(1)],[0,x(1)],'b-');

%in each iteration, we plot the transition between consecutive values
%the more iterations you plot, the denser the graph will be come.
% I suggest limit this to 10^2 or 10^3
for i=2:10^2
    x(i)=k*x(i-1)*(1-x(i-1));
    plot([x(i-1),x(i-1)],[x(i-1),x(i)],'b-');
    hold on
     plot([x(i-1),x(i)],[x(i),x(i)],'b-');
    hold on
end

axis([0,1,0,1])
xlabel('x_{i-1}')
ylabel('x_{i}')
grid on
set(gca,'fontsize',12)
set(gca,'fontweight','bold')

%% Sine map
clear
x(1)=0.1;
k=5;

%the sine map has a mapping interval of [-k,k]
% so we plot the graph of the function accordingly
interval=-k:0.001:k;
func=k.*sin(pi*interval);
plot(interval,func,'k','LineWidth',1)
hold on
plot([-k,k],[-k,k],'k--')

plot([x(1),x(1)],[0,x(1)],'b-');
for i=2:10^3
    x(i)=k*sin(pi*x(i-1));
    plot([x(i-1),x(i-1)],[x(i-1),x(i)],'b-');
    hold on
     plot([x(i-1),x(i)],[x(i),x(i)],'b-');
    hold on
end

axis([-k,k,-k,k])
xlabel('x_{i-1}')
ylabel('x_{i}')
grid on
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
