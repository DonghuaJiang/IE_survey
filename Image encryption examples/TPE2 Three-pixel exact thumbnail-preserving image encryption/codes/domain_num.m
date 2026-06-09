%ÏñËØ×éÊýÁ¿

function num=domain_num(s)
l1=s+1;
l2=256;
l3=s-255;
l4=2*l2-1;
l5=3*255-s+1;
if s>=0 && s<l2
    num=domain_sum(0,1,l1);
else 
    if l2<=s && s<=l4
        num=domain_num(255)+domain_sum(l2,-2,l3);
    else 
        num=domain_sum(0,1,l5);
    end
    
end