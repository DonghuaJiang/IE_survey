
function L = cycleLength(precision,r,x,y)


for i=1:8000000
%     x = round(r*(3*y+1)*x*(1-x),precision);
%     y = round(r*(3*x+1)*y*(1-y),precision);

%     x = round(r*(sin(pi*y)+3)*x*(1-x),precision);
%     y = round(r*(sin(pi*x)+3)*y*(1-y),precision);

%     x=round(sin(pi*r*(y+3)*x*(1-x)),precision);
%     y=round(sin(pi*r*(x+3)*y*(1-y)),precision);
    
    x = round(sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y))),precision);
    y = round(sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x))),precision);
end

xt = x;
yt = y;


% x = round(r*(3*y+1)*x*(1-x),precision);
% y = round(r*(3*x+1)*y*(1-y),precision);

% x = round(r*(sin(pi*y)+3)*x*(1-x),precision);
% y = round(r*(sin(pi*x)+3)*y*(1-y),precision);

% x=round(sin(pi*r*(y+3)*x*(1-x)),precision);
% y=round(sin(pi*r*(x+3)*y*(1-y)),precision);

x = round(sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y))),precision);
y = round(sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x))),precision);
L = 1;
while(x~=xt||y~=yt)
%     x = round(r*(3*y+1)*x*(1-x),precision);
%     y = round(r*(3*x+1)*y*(1-y),precision);

%     x = round(r*(sin(pi*y)+3)*x*(1-x),precision);
%     y = round(r*(sin(pi*x)+3)*y*(1-y),precision);

%     x=round(sin(pi*r*(y+3)*x*(1-x)),precision);
%     y=round(sin(pi*r*(x+3)*y*(1-y)),precision);
    
    x = round(sin(pi*(4*r*x*(1-x)+(1-r)*sin(pi*y))),precision);
    y = round(sin(pi*(4*r*y*(1-y)+(1-r)*sin(pi*x))),precision);
    L = L + 1;
    if(L>=10^precision)
        break;
    end
end
end