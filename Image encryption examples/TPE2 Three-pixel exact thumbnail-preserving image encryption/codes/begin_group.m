%相同和的像素组开始的地方

function be_group=begin_group(group)
s=sum(sum(group(:)));
be_group=zeros(1,3);
if s<=255
   be_group(3)=s;
else
    be_group(3)=255;
    if s<=510
        be_group(3)=255;
        be_group(2)=s-255;
    else 
        be_group(2)=255;
        be_group(1)=s-510;
    end
end