function F = frft2(inmatrix , x,AL)
% inmatrix is input matrix
% x is fractional power in axis x
% y is fractional power in axis y
% F is transform output
L=length(inmatrix);
outmatrix=zeros(L);

if x(1)>=0
    
    for number=1:L
       temp=inmatrix(number,:);
        temp1=Disfrft(temp,x);
       outmatrix(number,:)=temp1.';
    end;

   for number=1:L
       temp=outmatrix(:,number);
       temp1=Disfrft(temp,x);
       outmatrix(:,number)=temp1;
   end;
    
else 
    for number=1:L
       temp=inmatrix(number,:);
       temp1=Disfrft(temp,x);
       outmatrix(number,:)=temp1.';
    end;

   for number=1:L
       temp=outmatrix(:,number);
       temp1=Disfrft(temp,x);
       outmatrix(:,number)=temp1;
   end;
    
end

F=outmatrix;
a=1;
    



