%两个像素的域中数量
%s_2=两个像素的和
function r=domain_2(s_2)
if s_2<=255
   r=s_2+1;
else
    r=510-s_2+1;
end

