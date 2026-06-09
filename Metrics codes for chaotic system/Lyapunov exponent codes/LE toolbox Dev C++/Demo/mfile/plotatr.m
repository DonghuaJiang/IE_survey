clc
clear
close all

lyap = dlmread('ly.dat');                                                  % 读入Dev C++产生的数据
cv1 = lyap(:,1);                                                           % 可调参数的取值
le1 = lyap(:,2); le2 = lyap(:,3);                                          % 李雅普诺夫指数 
le3 = lyap(:,4);  le4 = lyap(:,5); le5 = lyap(:,6); 
figure(1); plot(cv1,le1,cv1,le2,cv1,le3,cv1,le4,cv1,le5); 
grid on; axis([2.0,6.0,-0.08,0.08]);                                       % 设置图层的坐标范围
xlabel('\fontname{Times New Roman} Adjustable parameter','fontsize',12); 
ylabel('\fontname{Times New Roman} Lypunov exponent','fontsize',12);
legend('LE_{1}','LE_{2}','LE_{3}','LE_{4}','LE_{5}'); set(gca,'FontSize',12);

attr = dlmread('bif.dat');                                                 % 读入Dev C++产生的数据
cv2 = attr(:,1);
figure(2);
for i = 1:length(cv2)
    plot(cv2(i),attr(i,2:end),'.b','Markersize',1.2);
    hold on;
end
axis([2.0,6.0,-1,1.5]); set(gca,'FontSize',12);                            % 设置图层的坐标范围和字体大小
xlabel('\fontname{Times New Roman} Adjustable parameter','fontsize',12); 
ylabel('\fontname{Times New Roman}\it x','fontsize',12);