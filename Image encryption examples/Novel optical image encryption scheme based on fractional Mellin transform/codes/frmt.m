function Y=frmt(X,rmin,rmax,center_x,center_y,num1,num2,p,AL)
%X为图像，rmin为环域内半径，rmax为环域外半径，center_x为中心x坐标，center_y为中心y坐标
%num1为距离轴离散化点的数目，num2为角度轴离散化点的数目,p
%若中心坐标为空值或离散化点数目为空值，则进行分数梅林逆变换，否则进行分数梅林正变换

if isempty(center_x)||isempty(center_y)||isempty(num1)||isempty(num2)
    y1=frft2(X,p,AL);%inverse fractional fourial transform
    %y1=X;
    Y=logsampback(y1,rmin,rmax);    %log-polar transform, 
else
   
    y1=logsample(X,rmin,rmax,center_x,center_y,num1,num2);
    Y=frft2(y1,p,AL);
    %Y=y1;
end;




























