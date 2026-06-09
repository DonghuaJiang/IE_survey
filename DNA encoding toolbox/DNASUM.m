function U=DNASUM(h,k)
U=0;
if (h=='A')&&(k=='A')
     U='A';
end
if (h=='A')&&(k=='G')
     U='G';
end
if (h=='A')&&(k=='C')
     U='C';
end
if (h=='A')&&(k=='T')
     U='T';
end
if (h=='G')&&(k=='A')
     U='G';
end
if (h=='G')&&(k=='G')
     U='C';
end
if (h=='G')&&(k=='C')
     U='T';
end
if (h=='G')&&(k=='T')
     U='A';
end
if (h=='C')&&(k=='A')
     U='C';
end
if (h=='C')&&(k=='G')
     U='T';
end
if (h=='C')&&(k=='C')
     U='A';
end
if (h=='C')&&(k=='T')
     U='G';
end
if (h=='T')&&(k=='A')
     U='T';
end
if (h=='T')&&(k=='G')
     U='A';
end
if (h=='T')&&(k=='C')
     U='G';
end
if (h=='T')&&(k=='T')
     U='C';
end
return;