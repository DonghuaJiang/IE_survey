%由lo求像素组

function group=rank_opposite(r,s)
if s<=127
   beg=0;
else
   zone=254-s+1;
   beg=127-zone+1;%域开始的位置
end
a=r+beg;
b=s-a;
group=[a,b];