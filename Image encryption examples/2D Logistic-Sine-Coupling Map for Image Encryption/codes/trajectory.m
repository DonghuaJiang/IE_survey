
sl = 12000;
X = zeros(1,sl);
Y = zeros(1,sl);

x = 0.8;
y = 0.9;


% r = 1.19;
% r = 1;
% r = 0.9;
r = 0.99;
% precision = 6;

% plot(x,y,'r*');
% hold on;
for i = 1:5000
    
% 2DLogistic
%         x = round(r*(3*y+1)*x*(1-x),precision);
%         y = round(r*(3*x+1)*y*(1-y),precision);

% 2DSLMM
%         x = round(r*(sin(pi*y)+3)*x*(1-x),precision);
%         y = round(r*(sin(pi*x)+3)*y*(1-y),precision);

% 2DLASM
%         x=round(sin(pi*r*(y+3)*x*(1-x)),precision);
%         y=round(sin(pi*r*(x+3)*y*(1-y)),precision);

% Our        
%         x = round(sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y))),precision);
%         y = round(sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x))),precision);
        x = sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y)));
        y = sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x)));
end
%subplot(1,2,2),


for m = 1:sl
    
% 2DLogistic
%         x = round(r*(3*y+1)*x*(1-x),precision);
%         y = round(r*(3*x+1)*y*(1-y),precision);

% 2DSLMM
%         x = round(r*(sin(pi*y)+3)*x*(1-x),precision);
%         y = round(r*(sin(pi*x)+3)*y*(1-y),precision);

% 2DLASM
%         x=round(sin(pi*r*(y+3)*x*(1-x)),precision);
%         y=round(sin(pi*r*(x+3)*y*(1-y)),precision);

% % Our        
%         x = round(sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y))),precision);
%         y = round(sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x))),precision);
        x = sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y)));
        y = sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x)));

    X(m) = x;
    Y(m) = y;
end

c = linspace(0,1,6);
plot(X,Y,'.','MarkerSize',1,'MarkerEdgeColor',[0.1,0.1,0.8]);
set(gcf,'Position',[0,500,500,500]);
set(gca,'ytick',c);
legend('(x_0,y_0)');
axis equal
axis([0,1,0,1]);
xlabel('x_i');
ylabel('y_i');
set(gca,'FontSize',20);