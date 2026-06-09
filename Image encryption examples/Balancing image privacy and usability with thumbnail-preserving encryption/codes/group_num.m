%相同和下像素组的数量
function num=group_num(s)
if s<=255
    num = s+1;
else
    num = 511-s;
end
end

