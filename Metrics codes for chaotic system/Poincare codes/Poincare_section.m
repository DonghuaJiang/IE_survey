% Poincare_section[绘制庞加莱截面图] 
% 画 Poincare截面 
% 在相空间中适当（要有利于观察系统的运动特征和变化，如截面不能与轨线相切，更不能包含轨线）选取一截面，
% 在此截面上某一对共轭变量如x1和x.1取固定值，称此截面为Poincare截面，相空间的连续轨迹与Poincare截
% 面的交点成为截点。通过观察Poincare截面上截点的情况可以判断是否发生混沌：当Poincare截面上有且只有
% 一个不动点或少数离散点时，运动是周期的；当Poincare截面上是一封闭曲线时，运动是准周期的；当Poinca-
% re截面上是一些成片的具有分形结构的密集点时，运动便是混沌。作此截面图时，其本质是当非线性系统进行角
% 动量作用变换后，可以在环面上讨论系统的性质。环面是指类似轮胎内胎的一个东西，而轨线在环面上运动，这种
% 运动是复杂的，包含绕环中心的运动（公转）和绕截面圆心的运动（类似自转）；如果这些有两种频率，分别为a,
% b，当a/b为有理数时，它们最终会首尾结合到一起，从而形成一个圈。因此，截面上只会留下一个点，这个点是轨
% 线穿越截面时留下的；当两种频率之比（旋转数）为无理数时，两轨线永不相交，这时截面上留下一个圆的痕迹，
% 所以所拟周期的Poincare截面图是一个圆。

clc
clear
close all

z0 = 28;  % 选择z0 = 28这个截面 
j = 0;    % 计数器
[t,x] = ode45(@LorenzDifEqn2,(0:0.01:100),[0.1,0.1,10]); 
for k = 1:length(x(:,3))-1
    d1 = x(k,3)-z0;
    d2 = x(k+1,3)-z0;

    if abs(d1) < 1e-8
        j = j+1;
        X1(j) = x(k,1);
        X2(j) = x(k,2);
        continue;
    end

    if sign(d1)*sign(d2) < 0
        j = j+1;
        Q = polyfit([x(k,3),x(k+1,3)],[x(k,1),x(k+1,1)],1); 
        X1(j) = polyval(Q,z0); 
        Q = polyfit([x(k,3),x(k+1,3)],[x(k,2),x(k+1,2)],1); 
        X2(j) = polyval(Q,z0);
    end
end
figure(1);
subplot(2,2,1); plot(X1,X2,'.'); xlabel('dx','fontsize',14); ylabel('dy','fontsize',14);
subplot(2,2,2); plot(x(:,1),x(:,2)); xlabel('x','fontsize',14); ylabel('y','fontsize',14);
subplot(2,2,3); plot(x(:,1),x(:,3)); xlabel('x','fontsize',14); ylabel('z','fontsize',14);
subplot(2,2,4); plot(x(:,2),x(:,3)); xlabel('y','fontsize',14); ylabel('z','fontsize',14);
