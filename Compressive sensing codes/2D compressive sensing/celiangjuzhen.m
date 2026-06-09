function [A1,A2]=celiangjuzhen(X,Y,Z,W,mm,N,dd)
for i=1:500+mm*N*dd;
    U(i)=(X(i)+Y(i))/2;
    R(i)=(Z(i)+W(i))/2;
end
U1=U(500:end);
R1=R(500:end);
count=1;
for i=1:dd:mm*N*dd;
    U2(count)=U1(i);
    R2(count)=R1(i);
    count=count+1;
end
U3=U2(:,1:end);
R3=R2(:,1:end);
fai1=1-2*U3;
fai2=1-2*R3;
fai3=reshape(fai1,mm,N);
fai4=reshape(fai2,mm,N);
A1=sqrt(2/N).*fai3;
A2=sqrt(2/N).*fai4;