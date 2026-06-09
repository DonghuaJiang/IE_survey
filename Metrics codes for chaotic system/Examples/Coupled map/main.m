%% 功率谱
clc
clear 
close all

% x = zeros(1,10001);
% y = zeros(1,10001);
% z = zeros(1,10001);                                                        % 数组置零
% x(1) = 1; y(1) = 1; z(1) = 1;
% h = 0.001; k = 10000; a = 3; u = 2;
% for i = 1:k
%     x(i+1) = x(i)+h*(-u*x(i)+y(i)*(z(i)+a));                               % 欧拉离散化
%     y(i+1) = y(i)+h*(-u*y(i)+x(i)*(z(i)-a));
%     z(i+1) = z(i)+h*(z(i)-x(i)*y(i));
% end
% X1 = fft(z,16384);                                                         % 对x做傅里叶变换，取8192个点
% p = X1.*conj(X1)/16384;                                                    % 求x的模及功率谱密度，单位：dB 同样可求y或z
% c = 100*[0:8191]/16384;                                                    % 取双边，也可取单边c=[0:4095]/0.8192;            
% figure(1);
% plot(c,log10(p(1:8192)),'k');                                              % 画出左半部分
% axis([0 4 -3 6]);                                                          % 限制横、纵坐标范围
% % plot(c,abs(X1(1:4096)))                                                    有时候也可用x的绝对值表示功率大小，没求对数
% xlabel('\itf\rm/HZ','fontsize',18,'fontName','times new Roman','fontweight','bold','color','k');         % 加横坐标,\it表倾斜，\rm表复正
% ylabel('power spectrum/dB','fontsize',18,'fontName','times new Roman','fontweight','bold','color','k');  % 纵坐标标示
% 
% %% 最大李雅谱指数程序
% LE1 = [];
% d0 = 1e-8;
% for a = linspace(0.5,10.5,300)
%     le = 0;
%     lsum = 0;
%     x = 1; y = 1; z = 1;
%     x1 = 1; y1 = 1; z1 = 1+d0;
%     for i=1:150   
%         [T1,Y1] = ode45('ouhe',[0,1],[x;y;z;2;a]);   
%         [T2,Y2] = ode45('ouhe',[0,1],[x1;y1;z1;2;a]);   
%         n1 = length(Y1); n2 = length(Y2);
%         x = Y1(n1,1); y = Y1(n1,2); z = Y1(n1,3);
%         x1 = Y2(n2,1); y1 = Y2(n2,2); z1 = Y2(n2,3);
%         d1 = sqrt((x-x1)^2+(y-y1)^2+(z-z1)^2);
%         x1 = x+(d0/d1)*(x1-x);
%         y1 = y+(d0/d1)*(y1-y);
%         z1 = z+(d0/d1)*(z1-z);
%         if i > 50
%             lsum = lsum+log(d1/d0);   
%         end
%     end
%     le = lsum/(i-50);
%     LE1 = [LE1 le];
% end  
% figure(2);
% a = linspace(0.5,10.5,300);
% plot(a,LE1,'-');
% title('largest Lyapunov exponents of ouhe1');
% xlabel('parameter a'),ylabel('largest Lyapunov exponents');
% grid;   
% 
% %% clear; %可调参数区间和步长
% global u a
% N1 = linspace(0,0,200);
% N2 = linspace(0,0,400);
% for I = 1:200
% 	u = 1.5+I*0.025;
%     d0 = 1e-8;
%     for L = 1:400
%         a = 0.5+L*0.025;
%         le = 0; lsum = 0;
%         x = 1; y = 1; z = 1; 
%         x1 = 1; y1 = 1; z1 = 1+d0;
%         for i=1:150   
%             [T1,Y1] = ode45('ouhe',[0,1],[x;y;z;u;a]);   
%             [T2,Y2] = ode45('ouhe',[0,1],[x1;y1;z1;u;a]);   
%             n1 = length(Y1); n2 = length(Y2);
%             x = Y1(n1,1); y = Y1(n1,2); z = Y1(n1,3);
%             x1 = Y2(n2,1); y1 = Y2(n2,2); z1 = Y2(n2,3);
%             d1 = sqrt((x-x1)^2+(y-y1)^2+(z-z1)^2); 
%             x1 = x+(d0/d1)*(x1-x); y1 = y+(d0/d1)*(y1-y); z1 = z+(d0/d1)*(z1-z);
%             if i > 50
%                 lsum = lsum+log(d1/d0);   
%             end
%         end
%         le = lsum/(i-50);
%         LE1(I,L) = le;
%         N2(L) = a;
%     end
%     N1(I) = u;
% end   
% figure(3);
% [X,Y] = meshgrid(N1,N2);
% Z = LE1;
% pcolor(X,Y,Z);                                                             % 画伪彩图
% colormap jet,shading interp                                                % 连续变化的变异饱和色图，表面画伪彩图
% contourf(X,Y,Z)                                                            % 画等高线
% title('largest Lyapunov exponents of ouhe');
% xlabel('parameter \itu');
% ylabel('parameter \ita');
% zlabel('最大李雅普指数{\delta}','FontSize',12);
% 
% %% 奇异值分解法计算耦合系统的李雅普诺夫指数谱
% Z1 = []; Z2 = []; Z3 = [];
% x = 1; y = 1; z = 1;
% h = 0.002; u = 2; k = 10000;
% for a = linspace(0.5,10.5,1000)
%     V = eye(3);
%     S = V;
%     b1 = 0;
%     lp = 0;
%     for i = 1:k   
%         x1 = x+h*(-u*x+y*(z+a));                                           % 欧拉离散化
%         y1 = y+h*(-u*y+x*(z-a));    
%         z1 = z+h*(z-x*y);
%         x = x1; y = y1; z = z1;   
%         J = [ -u  a+z   y    
%              z-a   -u   x    
%               -y   -x   1];
%         J = eye(3)+h*J;    
%         B = J*V*S;    
%         [V,S,U] = svd(B);
%         a_max = max(diag(S));
%         S = (1/a_max)*S;    
%         b1 = b1+log(a_max);
%     end
%     lp = (log(diag(S))+b1)/(k*h);
%     Z1 = [Z1 lp(1)];
%     Z2 = [Z2 lp(2)];
%     Z3 = [Z3 lp(3)];
% end
% figure(4);
% a = linspace(0.5,10.5,1000);
% plot(a,Z1,'-',a,Z2,'-',a,Z3,'-');
% axis([0.5,10.5,-5,2]);
% title('Lyapunov exponents of ouhe system');
% xlabel('parameter a'),ylabel('lyapunov exponents');
% grid on;

%%
[t,x] = ode45('ouhe1',[0 1000],[1 -1 1]);
figure(5);
subplot(2,2,1); plot(x(:,1),'k','markersize',0.5);
xlabel('t/ms','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
ylabel('x','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
subplot(2,2,2); plot(x(:,2),'k','markersize',0.5);
xlabel('t/ms','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
ylabel('y','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
subplot(2,2,3); plot(x(:,3),'k','markersize',0.5);
xlabel('t/ms','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
ylabel('z','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
subplot(2,2,4); plot3(x(:,1),x(:,2),x(:,3),'k','markersize',0.5);grid on;
xlabel('x','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
ylabel('y','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
zlabel('z','fontsize',12,'fontName','times new Roman','fontweight','bold','color','k');
figure(6);plot3(x(:,1),x(:,2),x(:,3),'k','markersize',0.5);grid on;
xlabel('\itx\rm_1','fontsize',20,'fontName','times new Roman','fontweight','bold','color','k');
ylabel('\itx\rm_2','fontsize',20,'fontName','times new Roman','fontweight','bold','color','k');
zlabel('\itx\rm_3','fontsize',20,'fontName','times new Roman','fontweight','bold','color','k');