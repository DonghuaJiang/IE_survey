%相同和下像素组的数量
function num=group_num(s)

if s<=255 %和为0~255时,
   num=sum(1:s+1);
else
    if s>=256 && s<=383 %和为256~383 递增，但是递增数列从254~0，每次减2
    num_s_255=32896;%sum(1:255+1);
    surplus=s-256;
    num=num_s_255+sum(254:-2:254-surplus*2);
    else
        if s>=384 && s<=511%递减每次减2
            num_s_383=49152;%和为383时像素组的数量
            surplus=s-384;
            num=num_s_383+sum(-2:-2:-2-surplus*2);
        else%和为512~765，递减 每次加1 -255~-2
            num_s_511=32640;
            surplus=s-512;
            num=num_s_511+sum(-255:1:-255+surplus);
        end
    end
end

