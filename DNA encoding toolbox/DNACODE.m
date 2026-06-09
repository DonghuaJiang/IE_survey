function U=DNACODE(h,k)
re=0;
if (h==0)&&(k==0)
    re='A';
end
 if (h==1)&&(k==0)
    re='G';
end
 if (h==0)&&(k==1)
    re='C';
end
 if (h==1)&&(k==1)
    re='T';
end

U=re;
return;

