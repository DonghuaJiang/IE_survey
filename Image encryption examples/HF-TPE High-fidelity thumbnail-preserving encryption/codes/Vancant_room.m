%提取最低有效位，并且清空最低有效位
%lsbs=最低有效位矩阵，de_I=清空最低有效位的矩阵
function [lsbs,de_I]=Vancant_room(I)
I=double(I);
lsbs=mod(I,2);
de_I=floor(I/2);



% [x,y]=size(I);
% lsbs=zeros(x,y);
% de_I=zeros(x,y);
% 
% 
% 
% for i=1:1:x
%     for j=1:1:y
%        t=double(I(i,j));
%        de_I(i,j)=floor(t/2);
%        if mod(t,2)==0
%           lsbs(i,j)=0;
%        else
%            lsbs(i,j)=1;
%        end
%     end
% end
