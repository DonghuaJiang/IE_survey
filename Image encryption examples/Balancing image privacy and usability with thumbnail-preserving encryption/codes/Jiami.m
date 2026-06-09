function C = Jiami(P,K,T,key)
Snum = zeros(1,255*2);
for i = 0:255*2
    Snum(i+1) = group_num(i);
end
P = double(P);
[wd,hd] = size(P);
num1 = K;
num2 = K;
sub_wd = wd / num1;
sub_hd = hd / num2;
subr=mat2cell(P,num1*ones(1,sub_wd),num2*ones(1, sub_hd));%分块函数，将P分成sub_wd×sub_hd个子块
for k =1:sub_wd*sub_hd
        bunch = double([key,k]);
        subr{k} = Kjiami(subr{k},T,bunch,Snum);
end
C = cell2mat(subr);
end
function C = Kjiami(P,T,bunch,Snum)
[wd,hd] = size(P);
C = P;
for t = 1:T
    Key = [bunch,t];
    PN2 = fprng([Key,1],wd*hd);
    num1 = 1;
    num2 = 2;
    sub_wd = wd / num1;
    sub_hd = hd / num2;
    subr=mat2cell(C,num1*ones(1,sub_wd),num2*ones(1, sub_hd));%分块函数，将P分成sub_wd×sub_hd个子块
    PN = fprng([Key,2],wd*hd);
    PN = mod(PN,256);
    for i = 1:sub_wd*sub_hd
    subr{i} = S2PE(subr{i},Snum,PN(i));
    end
    C = cell2mat(subr);
    C = reshape(C(PN2),wd,hd);
end
C = uint8(C);
end
function C = S2PE(P,Snum,pn)%二像素保和加密
s = sum(P);
a = P(1);
%%%%%%%%%%%%%%%%%%%%%%%
if s<255
    r = a;
else
    r = 255 - a;
end
%%%%%%%%%%%%%%%%%%%%%%%%
% num = group_num(s);
num = Snum(s+1);
% t_arry=randperm(num);
% en_r=t_arry(r+1)-1;
en_r = mod(r+pn,num);
if s<255
    C = [en_r,s-en_r];
else
    C = [255-en_r,s-255+en_r];
end
end