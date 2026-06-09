function BitStream = ProduceBitStream(key)
l=length(key);
s=sum(key);
mean=s/l;
for i=1:l
    if key(i)>=mean
        BitStream(i)=1;
    else
        BitStream(i)=0;
    end
end
