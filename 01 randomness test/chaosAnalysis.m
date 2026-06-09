clc
clear
close all

%% The 0-1 test 
figure() 
i = 0;
N0 = 150; beta1 = 4;
len = 20; beta2 = 0.3306;
x1 = zeros(1,N0); x2 = zeros(1,N0);  
x3 = zeros(1,N0); x4 = zeros(1,N0); x5 = zeros(1,N0);
x1(1) = 0.72345; x2(1) = 0.72345; 
x3(1) = 0.72345; x4(1) = 0.72345; x5(1) = 0.72345;
for u = 0:0.2:len
    for n = 2:10500
        x1(n) = cos((1-u*sum(x1))*asin(1-2*x1(n-1)^2));
        x2(n) = cos(u*(x2(n-1)^3+x2(n-1)));
        x3(n) = cos((u*x3(n-1)+1)^2+1)/(sin((u*x3(n-1)+1)^2+1)+2);
        x4(n) = cos(u/(x4(n-1)^beta1));
        x5(n) = (x5(n-1)*(u+1))^sin(beta2*pi+x5(n-1));
    end
    i = i+1;
    [medianKcreg1(i), medianKcCorr1(i)] = calcuKcreg(x1(501:end)'); 
    [medianKcreg2(i), medianKcCorr2(i)] = calcuKcreg(x2(501:end)'); 
    [medianKcreg3(i), medianKcCorr3(i)] = calcuKcreg(x3(501:end)'); 
    [medianKcreg4(i), medianKcCorr4(i)] = calcuKcreg(x4(501:end)'); 
    [medianKcreg5(i), medianKcCorr5(i)] = calcuKcreg(x5(501:end)'); 
end  
box on;  
hold on; 
plot((0:0.2:len),medianKcCorr1,'s-','linewidth',1.5,'markersize',2);
plot((0:0.2:len),medianKcCorr2,'*-','linewidth',1.5,'markersize',2);
plot((0:0.2:len),medianKcCorr3,'d-','linewidth',1.5,'markersize',2);
plot((0:0.2:len),medianKcCorr4,'o-','linewidth',1.5,'markersize',2);
plot((0:0.2:len),medianKcCorr5,'^-','linewidth',1.5,'markersize',2);
axis([0,len,0,1.5]);    
xlabel('\fontsize{16}\fontname{Times New Roman} Control parameter');
ylabel('\fontsize{16}\fontname{Times New Roman} K');   
set(get(gca,'XLabel'),'FontSize',16);
set(get(gca,'YLabel'),'FontSize',16);
legend('Proposed','1-DCP','1-DFCS','1-DCF','1-DSP');

